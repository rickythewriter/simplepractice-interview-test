require 'rails_helper'
require 'faker'

RSpec.describe "/api/doctors", type: :request do

    before do
        dr_w_appt = Doctor.create(
            :name => Faker::Name.unique.name
        )

        patient = Patient.create(
            :doctor_id => dr_w_appt.id,
            :name => Faker::Name.unique.name
        )

        Appointment.create(
            :doctor_id => patient.doctor_id,
            :patient_id => patient.id,
            :start_time => Faker::Time.backward(days:182, period: :day),
            :duration_in_minutes => 60
        )

        dr_wout_appt1 = Doctor.create(
            :name => Faker::Name.unique.name
        )

        dr_wout_appt2 = Doctor.create(
            :name => Faker::Name.unique.name
        )
    end

    describe "GET /api/doctors" do
        it "returns doctors without appointments" do
            get "/api/doctors"
            doctors = JSON.parse(response.body)
            expect(doctors.length).to eql 2
        end
    end

end