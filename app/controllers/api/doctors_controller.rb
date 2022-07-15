class Api::DoctorsController < ApplicationController
    def index

        doctors = Doctor.without_appointments
        
        render json: doctors, status: 200        

    end
end
