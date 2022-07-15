class Api::AppointmentsController < ApplicationController

  # before_action :sanitize_page_params

  def index

    # Initialize appointments
    appointments = query_by_past_param(params[:past])
    # appointments = Appointment.filter_by_past_param(params[:past])

    # Handle pagination
    to_be_paginated = (params[:length].present? && params[:page].present?)

    if to_be_paginated

      # Validate pagination - render nil with 400 status if pagination parameters invalid
      # pagination_params_are_valid = appointments.pagination_params_valid?(params[:length], params[:page])
      if !pagination_params_valid?(params[:length], params[:page])
        return render json: nil, status: :bad_request
      end

      # Paginate appointments
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

  #TODO: determine if this should be a model method
  def query_by_past_param(past_param)
    case past_param
    when "1"
      return Appointment.past
    when "0"
      return Appointment.future
    when nil
      return Appointment.all
    else
      return Appointment.none
    end
  end

  #TODO: determine if this should be a model method
  def pagination_params_valid?(length, page_number)
    # Convert to integer
    length = length.to_i
    page_number = page_number.to_i

    # Check if length and page number are valid
    return length > 0 && page_number > 0
  end

end