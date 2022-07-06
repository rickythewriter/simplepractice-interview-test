class Api::DoctorsController < ApplicationController
    def index

        doctors = Doctor.doctors_without_appointments
        
        render json: doctors, status: 200        

    end
end
