class BandsAndTotals
  include ChargeUtilities
  attr_accessor :total, :bands
  def initialize(bands, total = {})
    self.bands = bands
    self.total = total
  end
end