class StatusController < ApplicationController
  respond_to :json

  def get_status
    # API checks
    test_location = Ohanakapa.location("downtown-palo-alto-food-closet")
    test_search = Ohanakapa.search("search", :keyword => "food")

    if test_location.blank? || test_search.blank?
      status = "API did not respond"
    else
      status = "ok"
    end

    render json:
      {
        "status" => status,
        "updated" => Time.now.to_i,
        "dependencies" => ["Ohanakapa","Ohana API","Mandrill","MemCachier"]
      }
  end
end