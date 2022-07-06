class Api::AppointmentsController < ApplicationController
  def index

    # Initialize @appointment instance
    if defined?(params[:past]) # Initialize only past or only future appointments

      # Declare conditions
      show_only_past_appointments = params[:past] == 1
      show_only_future_appointments = params[:past] == 0

      # Note: appointments are ordered by start_time, from closest to furthest
      if show_only_past_appointments
        @appointments = Appointment.where("start_time < ?", DateTime.now).order(start_time: :asc)
      elsif show_only_future_appointments
        @appointments = Appointment.where("start_time > ?", DateTime.now).order(start_time: :asc)
      end

    else # Initialize all appointments
      @appointments = Appointment.all
    end
    
    # Paginate, if applicable
    if (params[:length] != nil && params[:page] != nil)
      length = params[:length]
      idx_start = (params[:page] - 1) * length #idx_start is the offset from the beginning

      # only include length number of appointments, starting at index of offset
      @appointments = @appointments[idx_start, length]
    end
    
    # render @appointments
    # head :ok
    render json: @appointments, status: 200
  end

  def create

    # Initialize appointment parameters
    appointment_params = params.require(:appointment).permit(:patient, :doctor, :start_time, :duration)
    patient_name = appointment_params[:patient]

    # Validate patient existence
    if !Appointment.patient_exists?(patient_name)
      return head :bad_request
    end

    # Query patient's ID
    patient_id = Appointment.find_patient_id(patient_name)

    # Create appointment
    appointment = Appointment.create(
      :doctor_id => appointment_params[:doctor],
      :patient_id => patient_id,
      :start_time => appointment_params[:start_time],
      :duration_in_minutes => appointment_params[:duration]
    )

    render json: appointment, status: 200

  end

end
