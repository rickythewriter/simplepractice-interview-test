class Doctor < ApplicationRecord
  has_many :patients
  has_many :appointments

  scope :without_appointments, -> { where.not(id: Appointment.distinct.pluck(:doctor_id))}

end