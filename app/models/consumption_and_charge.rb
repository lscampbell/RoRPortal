class ConsumptionAndCharge
  attr_accessor :kwh, :charge, :percentage, :integrity_percent, :count

  def initialize(hash = {})
    self.kwh = hash[:kwh]
    self.charge = hash[:charge]
    self.percentage = hash[:percentage]
    self.integrity_percent = hash[:integrity_percent]
    self.count = hash[:count]
  end

  def get_class
    percent = integrity_percent.to_f.round(1)
    return '' if percent > 95
    percent > 90 ? 'warning' : 'error'
  end
end