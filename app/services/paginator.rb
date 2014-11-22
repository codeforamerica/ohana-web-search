class Paginator
  delegate :headers, to: :response

  def initialize(response, params)
    @response = response
    @params = params
  end

  def total_count
    headers['X-Total-Count'].to_i
  end

  def results
    Kaminari.paginate_array([], total_count: total_count).
      page(params[:page]).
      per(params[:per_page])
  end

  private

  attr_reader :response, :params
end
