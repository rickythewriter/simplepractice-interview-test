RSpec.describe Api::DoctorsController do

  describe "#index" do
    it "returns json data" do
      get :index
      expect(response.status).to eq(200)
    end
  end
end
