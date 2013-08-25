class OrganizationsController < ApplicationController
  respond_to :html, :json, :xml, :js

  # search results view
  def index
    @terminology = Organization.terminology(params[:keyword])

    query = Organization.search(params)
    
    # provides temporary custom CIP > OE mapping of search terms that don't return results
    if query.content.blank?
      keyword = params[:keyword].downcase
      new_params = params.dup
      
      if keyword == 'animal welfare'
        new_params[:keyword] = 'Animal Council'
      elsif keyword == 'building support networks'
        new_params[:keyword] = 'Peninsula Clergy Network'
      elsif keyword == 'daytime caregiving'
        new_params[:keyword] = 'Bay Area Caregiver Resource Center'
      elsif keyword == 'help navigating the system'
        new_params[:keyword] = 'Each One Reach One'
      elsif keyword == 'residential caregiving'
        new_params[:keyword] = 'Adult Rehabilitation Center'
      elsif keyword == 'help finding school'
        new_params[:keyword] = 'Children and Family Services'
      elsif keyword == 'help paying for school'
        new_params[:keyword] = 'Consumer Credit Counseling Service'
      elsif keyword == 'disaster response'
        new_params[:keyword] = "San Mateo County Sheriff's Office"
      elsif keyword == 'immediate safety needs'
        new_params[:keyword] = 'EMQ Children and Family Services'
      elsif keyword == 'psychiatric emergencies'
        new_params[:keyword] = 'Behavioral Health and Recovery Services'
      elsif keyword == 'food benefits'
        new_params[:keyword] = 'Project Homeless Connect'
      elsif keyword == 'food delivery'
        new_params[:keyword] = "Jewish Family and Children's Services"
      elsif keyword == 'free meals'
        new_params[:keyword] = 'Vincent de Paul'
      elsif keyword == 'help paying for food'
        new_params[:keyword] = 'united way'
      elsif keyword == 'nutrition support'
        new_params[:keyword] = 'Community Solutions for Children, Families and Individuals'
      elsif keyword == 'baby supplies'
        new_params[:keyword] = "UCSF Women's Health Resource Center"
      elsif keyword == 'diapers'
        new_params[:keyword] = "UCSF Women's Health Resource Center"
      elsif keyword == 'toys and gifts'
        new_params[:keyword] = 'Community Services Agency of Mountain View'
      elsif keyword == 'addiction & recovery'
        new_params[:keyword] = 'ARH Recovery Homes'
      elsif keyword == 'help finding services'
        new_params[:keyword] = 'united way'
      elsif keyword == 'help paying for healthcare'
        new_params[:keyword] = 'Ravenswood Family Health Center'
      elsif keyword == 'help finding housing'
        new_params[:keyword] = 'Menlo Park Housing and Redevelopment'
      elsif keyword == 'housing advice'
        new_params[:keyword] = 'Project Homeless Connect'
      elsif keyword == 'paying for housing'
        new_params[:keyword] = 'Consumer Credit Counseling'
      elsif keyword == 'pay for childcare'
        new_params[:keyword] = 'Go Kids'
      elsif keyword == 'pay for food'
        new_params[:keyword] = 'Consumer Credit Counseling'
      elsif keyword == 'pay for housing'
        new_params[:keyword] = 'ARH Recovery Homes'
      elsif keyword == 'pay for school'
        new_params[:keyword] = 'Corporation for National and Community Service'
      elsif keyword == 'health care reform'
        new_params[:keyword] = 'Human Services Agency'
      elsif keyword == 'market match'
        new_params[:keyword] = "Belmont Farmers' Market"
      elsif keyword == "senior farmers' market nutrition program"
        new_params[:keyword] = "Belmont Farmers' Market"
      elsif keyword == "sfmnp"
        new_params[:keyword] = "Belmont Farmers' Market"
      elsif keyword == "bus passes"
        new_params[:keyword] = 'coastside hope'
      elsif keyword == "transportation to appointments"
        new_params[:keyword] = 'Senior Companion Program of San Mateo County'
      elsif keyword == "transportation to healthcare"
        new_params[:keyword] = 'Senior Companion Program of San Mateo County'
      elsif keyword == "transportation to school"
        new_params[:keyword] = 'The Special Need Transportation Program'
      end

      query = Organization.search(new_params)
    end

    @orgs = query.content

    @pagination = query.pagination

    # adds top-level category information to orgs for display on results list
    # this will likely be refactored to use the top-level keywords when those 
    # are organized in the data source.
    top_level_service_terms = []
    Organization.service_terms.each do |term|
      top_level_service_terms.push(term[:name]);
    end

    @orgs.each do |org|
      org.category = []
      if org.keywords.present?
        org.keywords.each do |keyword|
          org.category.push( keyword ) if top_level_service_terms.include? keyword.downcase
        end
        org.category = org.category.uniq
        org.category = org.category.sort
      end
    end
    
    @params = {
      :count => @pagination.items_current,
      :total_count => @pagination.items_total,
      :keyword => params[:keyword],
      :location => params[:location],
      :radius => params[:radius]
    }

     @query_params = {
      :keyword => params[:keyword],
      :location => params[:location],
      :radius => params[:radius]
    }

    respond_to do |format|
      # visit directly
      format.html # index.html.haml

      # visit via ajax
      format.json {
        with_format :html do
          @html_content = render_to_string partial: 'component/organizations/results/body',
           :locals => { :map_present => @map_present }
        end
        render :json => { :content => @html_content , :action => action_name }
      }
    end

  end

  # organization details view
  def show
    # retrieve specific organization's details
    @org = Organization.get(params[:id]).content

    # sometimes nearby returns a 500 error, 
    # this checks to make sure nearby has a value before initializing map data
    if @org.coordinates.present?
      @map_data = generate_map_data(Organization.nearby(params[:id]).content)
    end

    keyword         = params[:keyword] || ''
    location        = params[:location] || ''
    radius          = params[:radius] || ''
    page            = params[:page] || ''

    @search_results_url = '/organizations?keyword='+URI.escape(keyword)+
                          '&location='+URI.escape(location)+
                          '&radius='+radius+
                          '&page='+page

    respond_to do |format|
      # visit directly
      format.html #show.html.haml

      # visit via ajax
      format.json {

        with_format :html do
          @html_content = render_to_string partial: 'component/organizations/detail/body'
        end
        render :json => { :content => @html_content , :action => action_name }
      }
    end

  end

  private

  # will be used for mapping nearby locations on details map view
  def generate_map_data(data)

    # generate json for the maps in the view
    # this will be injected into a <script> element in the view
    # and then consumed by the map-manager javascript.
    # map_data parses the @org hash and retrieves all entries
    # that have coordinates, and returns that as json, otherwise map_data 
    # ends up being nil and can be checked in the view with map_data.present?
    map_data = data.reduce([]) do |result, o| 
      if o.coordinates.present?
        result << {
          'id' => o._id, 
          'name' => o.name, 
          'coordinates' => o.coordinates
        }
      end
      result
    end

    map_data.push({'count'=>map_data.length,'total'=>data.length})
    map_data = map_data.to_json.html_safe unless map_data.nil?
  end

  # from http://stackoverflow.com/questions/4810584/rails-3-how-to-render-a-partial-as-a-json-response
  # execute a block with a different format (ex: an html partial while in an ajax request)
  def with_format(format, &block)
    old_formats = formats
    self.formats = [format]
    block.call
    self.formats = old_formats
    nil
  end
end