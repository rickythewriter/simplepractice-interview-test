class Api::AppointmentsController < ApplicationController
  def index
    # TODO: return all values
    @appointments = Appointment.all
    # TODO: return filtered values
    head :ok
  end

  def create
    # TODO:
  end

end
