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

  #TODO: determine if this should be controller helper function
  def self.filter_by_past_param(past_param)
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

  #TODO: determine if this should be a controller helper function
  def self.pagination_params_valid?(length, page_number)

    # Convert to integer
    length = length.to_i
    page_number = page_number.to_i

    # Check if length and page number are valid
    return length > 0 && page_number > 0
  end

end

