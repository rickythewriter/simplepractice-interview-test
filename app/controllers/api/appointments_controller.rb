class Api::AppointmentsController < ApplicationController

  rescue_from ActiveRecord::StatementInvalid, with: :pagination_out_of_bounds

  def index

    # Initialize appointments with `past` param
    appointments = Appointment.query_with_past_param(params[:past])

    # Handle pagination
    if (params[:length].present? && params[:page].present?)
      appointments = appointments.paginated(params[:length], params[:page])
    end

    # Format to meet Requirement 2
    appointments = format_for_index(appointments)

    render json: appointments, status: 200

  end

  def create

    # Initialize appointment parameters
    appointment_params = params.permit(:patient, :doctor, :start_time, :duration)
    
    # Query patient's ID
    patient_name = appointment_params[:patient]
    patient_id = Patient.where(name: patient_name).last.id # Assumption: Each patient has a unique name

    # Create appointment
    appointment = Appointment.create(
      :doctor_id => appointment_params[:doctor],
      :patient_id => patient_id,
      :start_time => appointment_params[:start_time],
      :duration_in_minutes => appointment_params[:duration]
    )

    if !appointment.valid?
      return head :bad_request
    end

    render json: appointment, status: 200

  end


  private

  # TODO:
    # determine if this is appropriate for controller
    # determine if this is the proper way to format JSON data.
    # Am I supposed to get this result via a query in a model scope?
  def format_for_index(appointments)
    formatted_appointments = appointments.to_a.map do |appointment|

      patient_name = Patient.find(appointment.patient_id).name
      doctor_name = Doctor.find(appointment.doctor_id).name

      appointment = {
        "id": appointment.id,
        "patient": patient_name,
        "doctor": doctor_name,
        "created_at": appointment.created_at,
        "start_time": appointment.start_time,
        "duration_in_minutes": appointment.duration_in_minutes
      }
    end

    return formatted_appointments
  end

  def pagination_out_of_bounds
    render json: nil, status: :bad_request
  end

end