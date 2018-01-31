class ChargesController < ApplicationController
  def index
    add_breadcrumbs
    set_params
    @page_link = ChargePageLink.new('Showing UTC (GMT)', 'Switch to clock time', clock_customer_supply_point_charges_path(params[:customer_id], @supply_point_reference, from: @from, to: @to))
    $statsd.time('bureau.charge.index') do
      get_the_charges(false)
      render :index
    end
  end

  def clock
    add_breadcrumbs
    set_params
    @page_link = ChargePageLink.new('Showing clock time', 'Switch to UTC (GMT)', customer_supply_point_charges_path(params[:customer_id], @supply_point_reference, from: @from, to: @to))
    $statsd.time('bureau.charge.clock') do
      get_the_charges(true)
      render :index
    end
  end

  def get_the_charges(clock_time)
    response = ChargeServiceClient.get_charges(params[:customer_id], @supply_point_reference, DateTime.parse(params[:from]), DateTime.parse(params[:to]), clock_time)
    @charges = ChargeSummary.new(JSON.parse(response[:body])['data'].with_indifferent_access)
    @summary = SummaryBuilder.new(@charges).summary
  end

  def set_params
    @supply_point_reference = params[:supply_point_id]
    @from = params[:from]
    @to = params[:to]
  end

  def add_breadcrumbs
    add_breadcrumb "<i class='fa fa-home'> home</i>".html_safe, '/', :title => 'Back to Home'
    add_breadcrumb "<i class='fa fa-group'> customers</i>".html_safe, customers_path, :title => 'Back to the Customer Page'
    add_breadcrumb "<i class='fa fa-building'> #{params[:customer_id]}</i>".html_safe, customer_supply_points_path(params[:customer_id]), :title => 'Back to the Supply Point Page'
  end
end
