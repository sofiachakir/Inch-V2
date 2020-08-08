require 'rails_helper'

RSpec.describe "Buildings", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/buildings/index"
      expect(response).to have_http_status(:success)
    end
  end

end
