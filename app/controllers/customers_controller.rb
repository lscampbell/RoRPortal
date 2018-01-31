class CustomersController < ApplicationController
  def index
    add_breadcrumb "<i class='fa fa-home'> home</i>".html_safe, '/', :title => 'Back to Home'
    response = ProfileRepositoryClient.get('/customers')
    throw 'Error retreiving customers' unless response[:status] == 200
    hash = JSON.parse(response[:body])
    @customers = hash['data']
    date = DateTime.now.beginning_of_day
    @date_ranges = [
        {name: 'Year to date', starts: date.beginning_of_year.strftime('%F'), ends: date.at_beginning_of_day.strftime('%F')},
        {name: 'Last year', starts: date.beginning_of_year.prev_year.strftime('%F'), ends: date.beginning_of_year.prev_day.strftime('%F')}
    ]
  end
end