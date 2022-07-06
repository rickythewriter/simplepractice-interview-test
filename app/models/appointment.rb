class Appointment < ApplicationRecord
  validates :doctor_id, :patient_id, :start_time, :duration_in_minutes, presence: true

  # Type Validations
  validates :doctor_id, :patient_id, :duration_in_minutes, numericality: { only_integer: true }
  # TODO - Validate DateTime data type (iso8604?) for start_time

  # Associations
  belongs_to :doctor
  belongs_to :patient

  def self.patient_exists?(name)
    patient = Patient.find(name: name)
    patient_exists = patient != nil
  end

  def self.find_patient_id(name)
    patient = Patient.find(name: name)
    patient.id
  end

end
