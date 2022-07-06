class Doctor < ApplicationRecord
  has_many :patients
  has_many :appointments

  def self.doctors_without_appointments

    # Initialize doctors variable
    doctors = []

    # Delete doctors with appointments
    Doctor.all.each do |doctor|
        hasAppointment = Appointment.where(doctor_id: doctor.id).length != 0
        if !hasAppointment
            doctors.push(doctor)
        end
    end

    return doctors

  end

end
