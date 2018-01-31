class EnergyCharge
  include ActiveModel::Model
  attr_accessor :band, :pence_per_kwh, :kwh, :energy_cost
end