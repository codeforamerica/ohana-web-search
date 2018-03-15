require 'rails_helper'

describe AboutController do
  describe "GET 'index'" do
    it 'assigns the request user agent to an instance variable' do
      get :index

      expect(assigns[:user_agent]).to eq controller.request.user_agent
    end
  end
end
