class OrganizationsController < ApplicationController
  include CurrentLanguage

  before_action :check_location_id, only: :show

  include ActionView::Helpers::TextHelper
  include ResultSummaryHelper

  # search results view
  def index
    translator = KeywordTranslator.new(
      params[:keyword], current_language, 'en', 'text')
    params[:keyword] = translator.translated_keyword

    # initialize query. Content may be blank if no results were found.
    begin
      @orgs = Ohanakapa.search('search', params)
    rescue Ohanakapa::ServiceUnavailable
      redirect_to "#{root_url}",
                  alert: 'Sorry, we are experiencing issues with search.
                         Please try again later.' && return
    rescue Ohanakapa::BadRequest => e
      if e.to_s.include?('missing')
        @orgs = Ohanakapa.locations(params)
      else
        @orgs = Ohanakapa.search('search', keyword: 'asdfasg')
      end
    end

    # Populate the keyword search field with the original term
    # as typed by the user, not the translated word.
    params[:keyword] = translator.original_keyword

    @locations_array = Paginator.new(Ohanakapa.last_response, params).results

    # The parameters to use to provide a link to the location
    @search_params = request.params.except(:action, :id, :_, :controller)
    @page_params = request.params.include?(:page) ? request.params.except(:page) : request.params

    array_for_maps = @orgs.map do |org|
      next unless org.coordinates.present?
      {
        latitude: org.latitude,
        longitude: org.longitude,
        name: org.name,
        org_name: org.organization.name,
        slug: org.slug,
        street_address: org.address.street,
        city: org.address.city
      }
    end
    @array_for_maps = array_for_maps.compact

    # construct html and plain results summaries for use in display in the view (html)
    # and for display in the page title (plain)
    @map_search_summary_html = format_map_summary

    expires_in 30.minutes, public: true
    if stale?(etag: @orgs, public: true)
      respond_to do |format|
        format.html # index.html.haml
      end
    end
  end

  # organization details view
  def show
    # retrieve specific organization's details
    id = params[:id].split('/')[-1]
    @org = Organization.get(id)

    # The parameters to use to provide a link back to search results
    @search_params = request.params.except(:action, :id, :_, :controller)

    if @org[:services].present?
      @categories = @org.services.map { |s| s[:categories] }.flatten.compact
    end

    # To disable or remove the Result list button on details page
    # when visiting location directly
    # @referer = request.env['HTTP_REFERER']

    # respond to direct and ajax requests
    expires_in 30.minutes, public: true
    if stale?(etag: @org, public: true)
      respond_to do |format|
        format.html # show.html.haml
      end
    end
  end

  private

  # If the location id is invalid, redirect to home page
  # and display an alert (TODO), or do something else.
  def check_location_id
    id = params[:id].split('/')[-1]
    redirect_to root_path unless Organization.get(id)
  end
end
