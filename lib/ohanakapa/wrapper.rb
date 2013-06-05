module Ohanakapa
  class Wrapper

  	include HTTParty
 
    base_uri 'http://ohanapi.herokuapp.com/api'

    def organizations
    	self.class.get('/organizations')
    end

    def search(keyword)
    	uri = '/search?keyword='+keyword
    	self.class.get(uri)
    end

  end
end