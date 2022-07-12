# TODO: Seed the database according to the following requirements:
# - There should be 10 Doctors with unique names
# - Each doctor should have 10 patients with unique names
# - Each patient should have 10 appointments (5 in the past, 5 in the future)
#   - Each appointment should be 50 minutes in duration

require "faker"

Appointment.destroy_all
Patient.destroy_all
Doctor.destroy_all

# Create doctors - ten doctors, w/ unique names
10.times do
    Doctor.create(
        :name => Faker::Name.unique.name
    )
end

# Create patients - w/ unique names, ten per doctor
doctor_ids = Doctor.ids;
doctor_ids.each do |doctor_id|
    10.times do 
        Patient.create(
            :doctor_id => doctor_id,
            :name => Faker::Name.unique.name
        )
    end
end

# Create appointments - ten per patient
patients = Patient.pluck(:id, :doctor_id)
patients.each do |patient|
    doctor_id = patient[1]
    patient_id = patient[0]
    # Five in the past
    5.times do
        Appointment.create(
            :doctor_id => doctor_id,
            :patient_id => patient_id,
            :start_time => Faker::Time.backward(days:182, period: :day),
            :duration_in_minutes => 60
        )
    end
    # Five in the future
    5.times do
        Appointment.create(
            :doctor_id => doctor_id,
            :patient_id => patient_id,
            :start_time => Faker::Time.forward(days:182, period: :day),
            :duration_in_minutes => 60
        )
    end
end