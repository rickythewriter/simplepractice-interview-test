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

end