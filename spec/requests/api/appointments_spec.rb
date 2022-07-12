require 'rails_helper'
require 'faker'

RSpec.describe "Api::AppointmentsController", type: :request do
    
    before do
        doctor = Doctor.create(
            :name => Faker::Name.unique.name
        )

        patient = Patient.create(
            :doctor_id => doctor.id,
            :name => Faker::Name.unique.name
        )

        10.times do
            Appointment.create(
                :doctor_id => patient.doctor_id,
                :patient_id => patient.id,
                :start_time => Faker::Time.between_dates(from: Date.today - 182, to: Date.today + 182, period: :day),
                :duration_in_minutes => 60
            )
        end
    end

    describe "GET /api/appointments?past=1" do
        it "returns only appointments in the past" do
            get "/api/appointments?past=1"
            json = JSON.parse(response.body)
            # puts json.length.to_s + " appointments in the past"
            json.each do |appointment|
                # pp appointment["start_time"]
                expect(appointment["start_time"]).to be < Time.now
            end
        end
    end

    describe "GET /api/appointments?past=0" do
        it "returns only appointments in the future" do
            get "/api/appointments?past=0"
            json = JSON.parse(response.body)
            # puts json.length.to_s + " appointments in the future"
            json.each do |appointment|
                # pp appointment["start_time"]
                expect(appointment["start_time"]).to be > Time.now
            end
        end
    end

end