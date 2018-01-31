class ConsumptionsController < ApplicationController
  def index
    @customer = params[:customer_id]
    @starts = params[:starts]
    @ends = params[:ends]
    consumption_data = JSON.parse(ChargeServiceClient.get_consumption_summary(@customer, @starts, @ends)[:body])
    @keys = consumption_data['keys']
    @data = consumption_data['consumption_data']
  end
end
