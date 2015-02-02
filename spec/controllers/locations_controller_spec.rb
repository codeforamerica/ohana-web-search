require 'rails_helper'

describe LocationsController do
  describe "GET 'index'" do
    it 'returns 200 status code' do
      VCR.use_cassette('all_results') do
        get :index
        expect(response.code).to eq('200')
      end
    end
  end
end
