class Api::AppointmentsController < ApplicationController

  # before_action :sanitize_page_params

  def index
    # Initialize @appointment instance
    appointments = Appointment.all

    if (params[:past] != nil) # Initialize only past or only future appointments
      appointments = Appointment.future_or_past_appointments(params[:past])
    end
    
    # Paginate, if applicable
    if (params[:length] != nil && params[:page] != nil)
      length = params[:length].to_i
      page = params[:page].to_i
      appointments = Appointment.paginated_appointments(length, page, appointments)
    end
    
    # render appointments
    # head :ok
    render json: appointments, status: 200

  end

end