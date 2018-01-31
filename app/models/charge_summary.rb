class ChargeSummary
  include ActiveModel::Model
  include ChargeUtilities
  attr_accessor :loss, :duos, :energy, :total, :expected_periods

  def initialize(hash = {
      duos: {bands: [], total: {}},
      loss: {bands: [], total: {}},
      energy: {bands: [], total: {}},
      total: 0})
    self.duos = create_duos hash
    self.loss = create_loss hash
    self.energy = create_energy hash
    self.total = hash.with_indifferent_access[:total_cost]
    self.expected_periods = hash.with_indifferent_access[:expected_periods]
  end

  def create_duos(hash)
    duos_bands = hash[:duos][:bands].map { |params| DuosCharge.new(params.except(:count)) }
    total_hash = hash[:duos][:total]
    BandsAndTotals.new(duos_bands, ConsumptionAndCharge.new(total_hash))
  end

  def create_loss(hash)
    loss_bands = hash[:loss][:bands].map { |params| LossCharge.new(params.except(:count)) }
    BandsAndTotals.new(loss_bands, LossTotal.new(hash[:loss][:total]))
  end

  def create_energy(hash)
    energy_bands = hash[:energy][:bands].map { |params| EnergyCharge.new(params.except(:count)) }
    total_hash = hash[:energy][:total]
    BandsAndTotals.new(energy_bands, ConsumptionAndCharge.new(total_hash))
  end
  #TODO: make this a bit nicer
end

