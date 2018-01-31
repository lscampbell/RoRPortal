class SupplyPointsController < ApplicationController
  def index
    add_breadcrumb "<i class='fa fa-home'> home</i>".html_safe, '/', :title => 'Back to Home'
    add_breadcrumb "<i class='fa fa-group'> customers</i>".html_safe, customers_path, :title => 'Back to the Customer Page'
    @customer_name = params[:customer_id]
    page = params[:page] || 1
    response = ProfileRepositoryClient.get("/customers/#{@customer_name}/supply-points?page=#{page}")
    throw 'Error retreiving supply points' unless response[:status] == 200
    hash = JSON.parse(response[:body])
    @supply_points = PagedData.new(hash['data'], hash['total_pages'].to_i, hash['current_page'].to_i, hash['limit_value'].to_i)
    set_date_ranges
  end

  def set_date_ranges
    date = DateTime.now
    @date_ranges = [
        {name: 'Month to date', from: date.beginning_of_month.strftime('%F'), to: date.at_beginning_of_day.strftime('%F')},
        {name: 'Last month', from: date.beginning_of_month.prev_month.strftime('%F'), to: date.beginning_of_month.strftime('%F')},
        {name: 'Previous month', from: date.beginning_of_month.prev_month.prev_month.strftime('%F'), to: date.beginning_of_month.prev_month.strftime('%F')},
        {name: 'Year to date', from: date.beginning_of_year.strftime('%F'), to: date.at_beginning_of_day.strftime('%F')},
        {name: 'Last year', from: date.beginning_of_year.prev_year.strftime('%F'), to: date.beginning_of_year.prev_day.strftime('%F')}
    ]
  end

end