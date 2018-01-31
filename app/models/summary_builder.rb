class SummaryBuilder
  attr_accessor :charges, :summary
  def initialize(charges)
    self.charges = charges
    self.summary = create_summary
  end

  def create_summary
    [
        {
            type: 'DUOS',
            units: charges.duos.total.kwh,
            charge: charges.duos.total.charge,
            percent: charges.duos.total.percentage
        },
        {
            type: 'T Loss',
            units: charges.loss.total.t_loss_kwh,
            charge: charges.loss.total.t_loss_charge,
            percent: charges.loss.total.t_loss_percentage
        },
        {
            type: 'D Loss',
            units: charges.loss.total.d_loss_kwh,
            charge: charges.loss.total.d_loss_charge,
            percent: charges.loss.total.d_loss_percentage
        },
        {
            type: 'Energy',
            units: charges.energy.total.kwh,
            charge: charges.energy.total.charge,
            percent: charges.energy.total.percentage
        }
    ]
  end
end