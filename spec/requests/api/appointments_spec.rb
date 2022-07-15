require 'rails_helper'
require 'faker'

RSpec.describe "/api/appointments", type: :request do
    
    before do
        doctor = Doctor.create(
            :name => Faker::Name.unique.name
        )

        patient = Patient.create(
            :doctor_id => doctor.id,
            :name => Faker::Name.unique.name
        )

        # 5 appointments in the past
        5.times do
            Appointment.create(
                :doctor_id => patient.doctor_id,
                :patient_id => patient.id,
                :start_time => Faker::Time.backward(days:182, period: :day),
                :duration_in_minutes => 60
            )
        end

        # 5 appointments in the future
        5.times do
            Appointment.create(
                :doctor_id => patient.doctor_id,
                :patient_id => patient.id,
                :start_time => Faker::Time.forward(days:182, period: :day),
                :duration_in_minutes => 60
            )
        end
    end

    describe "GET /api/appointments" do
        it "is structured with the proper data" do

            get "/api/appointments"
            appointment = JSON.parse(response.body).last

            # pp appointment

            # These key-value pairs are returned
            expect(appointment["id"]).not_to be_nil
            expect(appointment["patient"]).not_to be_nil
            expect(appointment["doctor"]).not_to be_nil
            expect(appointment["created_at"]).not_to be_nil
            expect(appointment["start_time"]).not_to be_nil
            expect(appointment["duration_in_minutes"]).not_to be_nil

            # These key-value pairs should not be returned
            expect(appointment["doctor_id"]).to be_nil
            expect(appointment["patient_id"]).to be_nil
            expect(appointment["updated_at"]).to be_nil
        end
    end

    describe "GET /api/appointments?past=1" do
        it "returns only appointments in the past" do
            get "/api/appointments", params:{
                past: 1
            }
            json = JSON.parse(response.body)
            # puts "Right now, the time is: " + Time.now.to_s
            # puts json.length.to_s + " appointments in the past"
            json.each do |appointment|
                # pp appointment["start_time"]
                expect(appointment["start_time"]).to be < Time.now
            end
            expect(json.length).to be 5
        end
    end

    describe "GET /api/appointments?past=0" do
        it "returns only appointments in the future" do
            get "/api/appointments", params:{
                past: 0
            }
            json = JSON.parse(response.body)
            # puts "Right now, the time is: " + Time.now.to_s
            # puts json.length.to_s + " appointments in the future"
            json.each do |appointment|
                # pp appointment["start_time"]
                expect(appointment["start_time"]).to be > Time.now
            end
            expect(json.length).to be 5
        end
    end

    describe "GET /api/appointments" do
        it "returns paginated appointments, starting at `page`; use page size of `length`" do

            # Parameter to be tested
            num_of_entries = 8

            get "/api/appointments", params:{
                length: num_of_entries,
                page: 1
            }

            appointments_on_page = JSON.parse(response.body)
            # puts "There are " + appointments_on_page.length.to_s + " appointments on the page."
            expect(appointments_on_page.length).to eql num_of_entries
        end

        it "returns remaining paginated appointments, on the last page" do

            get "/api/appointments", params:{
                length: 4,
                page: 3
            }
            appointments_on_page = JSON.parse(response.body) #appointments 9 and 10 of 10
            expect(appointments_on_page.length).to eql 2
        end

        it "returns paginated appointments, in the correct order" do

            # Parameters to be tested
            length = 4
            page = 2 # must be before final page, if final page not full-length

            get "/api/appointments", params:{
                length: length,
                page: page
            }

            appointments_on_page = JSON.parse(response.body)

            # Initialize all appointments for comparison with appointments on page
            appointments_comprehensive = Appointment.all

            # Initialize offset for index
            offset_for_comprehensive_idx = length * (page - 1)

            # Check if sequence of appointments in correct order
            for idx in 0...length do

                id_appointment_on_page = appointments_on_page[idx]["id"]
                id_appointment_comprehensive = appointments_comprehensive[idx + offset_for_comprehensive_idx]["id"]

                # puts id_appointment_on_page.to_s + " == " + id_appointment_comprehensive.to_s + ": " + (id_appointment_on_page == id_appointment_comprehensive).to_s

                expect(id_appointment_on_page).to eql (id_appointment_comprehensive)
            end

            # Check if correct number of entries returned on page
            expect(appointments_on_page.length).to eql length
        end

        it "returns no appointments, when `page` is 0" do
            get "/api/appointments", params:{
                length: 4,
                page: 0
            }
            appointments_on_page = JSON.parse(response.body)
            expect(appointments_on_page).to eql nil
        end

        it "returns no appointments, when `page` is less than 0" do
            get "/api/appointments", params:{
                length: 4,
                page: -1
            }
            appointments_on_page = JSON.parse(response.body)
            expect(appointments_on_page).to eql nil
        end

        it "returns no appointments, when `page` is out of bounds" do
            get "/api/appointments", params:{
                length: 5,
                page: 3
            }
            appointments_on_page = JSON.parse(response.body)
            expect(appointments_on_page).to eql nil
        end

    end

end