class ViewChargeRequestsController < ApplicationController
  def new
    add_breadcrumb "<i class='fa fa-home'> home</i>".html_safe, '/', :title => 'Back to Home'
    add_breadcrumb "<i class='fa fa-group'> customers</i>".html_safe, customers_path, :title => 'Back to the Customer Page'
    add_breadcrumb "<i class='fa fa-building'> #{params[:customer_id]}</i>".html_safe, customer_supply_points_path(params[:customer_id]), :title => 'Back to the Supply Point Page'
    $statsd.time('bureau.charge_req.new') do
      @view_charge_request = ViewChargeRequest.new(supply_point_id: params[:supply_point_id])
    end
    @customer = params[:customer_id]
    @supply_point = params[:supply_point_id]
  end

  def create
    @customer = params[:customer_id]
    @view_charge_request = ViewChargeRequest.new(charge_request_params)
    redirect_to customer_supply_point_charges_path @customer, @view_charge_request.supply_point_id, from: @view_charge_request.from, to: @view_charge_request.to
  end

  def charge_request_params
    params.require(:view_charge_request).permit(:supply_point_id, :from, :to)
  end
end