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
    # TODO:
  end

end
