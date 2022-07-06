class Api::DoctorsController < ApplicationController
    def index

        # Initialize doctors instance
        @doctors = Doctor.all

        # Delete doctors with appointments
        @doctors.each do |doctor|
            hasAppointment = Appointment.where(doctor_id: doctor.id).length != 0
            if hasAppointment
                @doctors.delete(doctor)
            end
        end

        # Return doctors without appointments
        # head :ok
        render json: @doctors, status: 200
        
    end
end
