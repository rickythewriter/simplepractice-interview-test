class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient

  def self.past_appointments
    self.where("start_time < ?", DateTime.now).order(start_time: :desc)
  end

  def self.future_appointments
    self.where("start_time > ?", DateTime.now).order(start_time: :asc)
  end

  def self.future_or_past_appointments(past)
    if past == "1"
      self.past_appointments
    elsif past == "0"
      self.future_appointments
    end
  end

  def self.paginated_appointments(length, page_number, appointments)
    idx_start = (page_number - 1) * length #idx_start is the offset from the beginning
    appointments = appointments[idx_start, length]
  end

end
