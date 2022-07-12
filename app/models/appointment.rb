class Appointment < ApplicationRecord

  validates :doctor_id, :patient_id, :start_time, :duration_in_minutes, presence: true

  # Type Validations
  validates :doctor_id, :patient_id, :duration_in_minutes, numericality: { only_integer: true }
  # TODO - Validate DateTime data type (iso8604?) for start_time

  # Associations
  belongs_to :doctor
  belongs_to :patient

  def self.future_or_past_appointments(past)
    if past == "1"
      self.past_appointments
    elsif past == "0"
      self.future_appointments
    end
  end

  def self.paginated_appointments(length, page_number, appointments)
    
    idx_start = (page_number - 1) * length #idx_start is the offset from the beginning

    range_special_case = idx_start == appointments.length
    range_wraps = page_number < 1 

    if range_special_case || range_wraps
      return nil
    end

    appointments = appointments[idx_start, length] #appointments[1000, 5]
  end

  # Assumption: Each patient has a unique name
  def self.find_patient_id(name)
    patient_id = Patient.where(name: name).last.id
  end

  private

  def self.past_appointments
    self.where("start_time < ?", DateTime.now).order(start_time: :desc)
  end

  def self.future_appointments
    self.where("start_time > ?", DateTime.now).order(start_time: :asc)
  end

end
