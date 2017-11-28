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
                     'http://smc-ohana-api-test.herokuapp.com/api/locations/' \
                     'redwood-city-free-medical-clinic').
          with(headers: { 'Accept' => 'application/vnd.ohanapi-v1+json',
                          'Accept-Encoding' =>
                          'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                          'User-Agent' => 'Ohanakapa Ruby Gem 1.1.3' }).
          to_return(status: 200, body: '', headers: {})

        stub_request(:get,
                     'http://smc-ohana-api-test.herokuapp.com/api/' \
                     'search?keyword=ymca&kind=Human%20Services&service_area=smc').
          with(headers: { 'Accept' => 'application/vnd.ohanapi-v1+json',
                          'Accept-Encoding' =>
                          'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                          'User-Agent' => 'Ohanakapa Ruby Gem 1.1.3' }).
          to_return(status: 200, body: '', headers: {})

        get 'check_status'
        body = JSON.parse(response.body)
        expect(body['status']).to eq('NOT OK')
      end
    end
  end
end
