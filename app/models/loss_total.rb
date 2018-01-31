class LossTotal
  attr_accessor :t_loss_kwh, :t_loss_charge, :t_loss_percentage, :d_loss_kwh,
                :d_loss_charge, :d_loss_percentage, :integrity_percent, :count

  def initialize(hash = {})
    self.t_loss_kwh = hash[:t_loss_kwh]
    self.t_loss_charge = hash[:t_loss_charge]
    self.t_loss_percentage = hash[:t_loss_percentage]
    self.d_loss_kwh = hash[:d_loss_kwh]
    self.d_loss_charge = hash[:d_loss_charge]
    self.d_loss_percentage = hash[:d_loss_percentage]
    self.integrity_percent = hash[:integrity_percent]
    self.count = hash[:count]
  end

  def get_class
    percent = integrity_percent.to_f.round(1)
    return '' if percent == 100.0
    percent > 90 ? 'warning' : 'error'
  end
end