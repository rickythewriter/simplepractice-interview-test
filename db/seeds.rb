# TODO: Seed the database according to the following requirements:
# - There should be 10 Doctors with unique names
# - Each doctor should have 10 patients with unique names
# - Each patient should have 10 appointments (5 in the past, 5 in the future)
#   - Each appointment should be 50 minutes in duration

require "faker"

Appointment.destroy_all
Patient.destroy_all
Doctor.destroy_all

# Create ten doctors with unique names
10.times do
    Doctor.create(
        :name => Faker::Name.unique.name
    )

    # For each doctor, create ten patients with unique names
    doctor_curr = Doctor.last
    10.times do 
        Patient.create(
            :doctor_id => doctor_curr.id,
            :name => Faker::Name.unique.name
        )

        # For each patient, create ten appointments
        # Five in the past; five in the future
        patient_curr = Patient.last
        5.times do
            Appointment.create(
                :doctor_id => doctor_curr.id,
                :patient_id => patient_curr.id,
                :start_time => Faker::Time.between_dates(from: '2022-01-01', to: '2022-06-30', period: :day),
                :duration_in_minutes => 60
            )
        end
        5.times do
            Appointment.create(
                :doctor_id => doctor_curr.id,
                :patient_id => patient_curr.id,
                :start_time => Faker::Time.between_dates(from: '2022-07-14', to: '2022-12-31', period: :day),
                :duration_in_minutes => 60
            )
        end

    end

end