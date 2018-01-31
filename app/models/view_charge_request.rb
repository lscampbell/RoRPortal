require 'active_model'
class ViewChargeRequest
  include ActiveModel::Model
  attr_accessor :supply_point_id, :from, :to
end