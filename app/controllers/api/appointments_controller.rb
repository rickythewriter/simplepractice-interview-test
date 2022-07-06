class Api::AppointmentsController < ApplicationController
  def index

    # Initialize @appointment instance
    if defined?(params[:past]) # Initialize only past or only future appointments

      # Declare conditions
      showOnlyPastAppointments = params[:past] == 1
      showOnlyFutureAppointments = params[:past] == 0

      # Note: appointments are ordered by start_time, from closest to furthest
      if showOnlyPastAppointments
        @appointments = Appointment.where("start_time < ?", DateTime.now).order(start_time: :asc)
      elsif showOnlyFutureAppointments
        @appointments = Appointment.where("start_time > ?", DateTime.now).order(start_time: :asc)
      end

    else # Initialize all appointments
      @appointments = Appointment.all
    end
    
    # Paginate, if applicable
    if defined?(params[:length] && params[:page])
      length = params[:length]
      idx_start = (params[:page] - 0) * length #idx_start is the offset from the beginning

      # only include length number of appointments, starting at index of offset
      @appointments = @appointments[idx_start, length]
    end
    
    @appointments

    head :ok
  end

  def create

    # Initialize appointment parameters
    appointment_params = params.require(:appointment).permit(:patient, :doctor, :start_time, :duration)

    # TODO: Validate data types
    # {
    #   patient: { name: <string> },
    #   doctor: { id: <int> },
    #   start_time: <iso8604>,
    #   duration_in_minutes: <int>
    # }

    # Initialize patient variable
    patient_name = appointment_params[:patient]
    patient = Patient.find(name: patient_name)

    # Validate for existence of patient
    patientExists = patient != nil
    if !patientExists
      return head :bad_request
    end

    # Query patient's ID
    patient_id = patient.id

    # Create appointment
    Appointment.create(
      :doctor_id => appointment_params[:doctor]
      :patient_id => patient_id
      :start_time => appointment_params[:start_time]
      :duration_in_minutes => appointment_params[:duration]
    )

    # Redirect to appointments page
    redirect_to @appointments

  end

end
