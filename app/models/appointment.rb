class Appointment < ApplicationRecord

# TODO: Validate data types
# {
#   patient: { name: <string> },
#   doctor: { id: <int> },
#   start_time: <iso8604>,
#   duration_in_minutes: <int>
# }

#Note: Class methods start with self.

  belongs_to :doctor
  belongs_to :patient
end
