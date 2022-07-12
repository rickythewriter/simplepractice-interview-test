class Doctor < ApplicationRecord
  has_many :patients
  has_many :appointments

  def self.doctors_without_appointments

    ids_doctors_with_appointments = Appointment.distinct.pluck(:doctor_id).sort
    doctors_without_appointments = Doctor.where.not(id: ids_doctors_with_appointments);

    return doctors_without_appointments

  end

end
