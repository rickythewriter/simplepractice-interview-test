class Appointment < ApplicationRecord

  # Associations
  belongs_to :doctor
  belongs_to :patient

  # Validations
  validates :doctor_id, :patient_id, :start_time, :duration_in_minutes, presence: true
  validates :doctor_id, :patient_id, :duration_in_minutes, numericality: { only_integer: true }
  # TODO - Validate DateTime data type (iso8604?) for start_time

  # Scopes
  scope :past, -> { where("start_time < ?", DateTime.now).order(start_time: :desc) }
  scope :future, -> { where("start_time > ?", DateTime.now).order(start_time: :asc) }
  scope :paginated, -> (length, page_number) { limit(length.to_i).offset((page_number.to_i - 1) * length.to_i)}

  def self.query_with_past_param(past_param)
    case past_param
    when "1"
      self.past
    when "0"
      self.future
    when nil
      self.all
    else
      self.none
    end
  end

  def self.format_for_index

    return self.includes(:doctor, :patient).map do |appointment|

      appointment = {
        "id": appointment.id,
        "patient": appointment.patient.name,
        "doctor": appointment.doctor.name,
        "created_at": appointment.created_at,
        "start_time": appointment.start_time,
        "duration_in_minutes": appointment.duration_in_minutes
      }
    
    end

  end


end

