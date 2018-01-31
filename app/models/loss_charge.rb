class LossCharge
  include ActiveModel::Model
  attr_accessor :band, :pence_per_kwh, :t_loss, :t_loss_kwh, :d_loss, :d_loss_kwh, :t_loss_factor, :d_loss_factor
end