class Api::AppointmentsController < ApplicationController

  # before_action :sanitize_page_params

  def index
    # Initialize @appointment instance
    appointments = Appointment.all

    # Return past or future appointments only, if applicable
    if (params[:past] != nil)
      appointments = Appointment.future_or_past_appointments(params[:past])
    end
    
    # Paginate, if applicable
    if (params[:length] != nil && params[:page] != nil)
      length = params[:length].to_i
      page = params[:page].to_i
      appointments = Appointment.paginated_appointments(length, page, appointments)
    end
    
    render json: appointments, status: 200

  end

  def create

    # Initialize appointment parameters
    appointment_params = params.permit(:patient, :doctor, :start_time, :duration)
    patient_name = appointment_params[:patient]
    doctor_id = appointment_params[:doctor]

    # Validate patient and doctor existence
    if !Appointment.patient_exists?(patient_name) || !Appointment.doctor_exists?(doctor_id)
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
