require 'rails_helper'

describe StatusController do
  describe 'GET /.well-known/status' do
    context 'when everything is fine', :vcr do
      it 'returns success' do
        get 'check_status'
        body = JSON.parse(response.body)
        expect(body['status']).to eq('OK')
      end
    end

    context 'when API does not return results' do
      before do
        VCR.turn_off!
      end

      after do
        VCR.turn_on!
      end

      it 'returns API failure error' do
        stub_request(:get,
                     'https://api-staging.smc-connect.org/locations/' \
                     'san-mateo-free-medical-clinic').
          to_return(status: 200, body: '', headers: {})

        stub_request(:get,
                     'https://api-staging.smc-connect.org/' \
                     'search?keyword=food').
          to_return(status: 200, body: '', headers: {})

        get 'check_status'
        body = JSON.parse(response.body)
        expect(body['status']).to eq('NOT OK')
      end
    end
  end
end
