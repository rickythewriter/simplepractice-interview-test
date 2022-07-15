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
    appointments = appointments.format_for_index

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

  def pagination_out_of_bounds
    render json: nil, status: :bad_request
  end

end