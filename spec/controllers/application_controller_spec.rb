require 'rails_helper'

describe ApplicationController do
  shared_examples 'redirects and displays alert' do
    it 'redirects to root_path' do
      get :index
      expect(response).to redirect_to root_path
    end

    it 'displays a helpful message to the user' do
      get :index
      expect(flash[:alert]).
        to include('Sorry, we are experiencing issues with search.')
    end
  end

  context 'when Faraday::ConnectionFailed is raised' do
    controller do
      def index
        fail Faraday::ConnectionFailed, nil, nil
      end
    end

    it_behaves_like 'redirects and displays alert'
  end

  context 'when Ohanakapa::ServiceUnavailable is raised' do
    controller do
      def index
        fail Ohanakapa::ServiceUnavailable, nil, nil
      end
    end

    it_behaves_like 'redirects and displays alert'
  end

  context 'when Ohanakapa::InternalServerError is raised' do
    controller do
      def index
        fail Ohanakapa::InternalServerError, nil, nil
      end
    end

    it_behaves_like 'redirects and displays alert'
  end
end
