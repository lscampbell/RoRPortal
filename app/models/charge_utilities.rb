module ChargeUtilities

  def display_charge_table
    bands.any?
  end

  def has_data
    bands.any? ? 'has-data' : ''
  end

  def display_total_grid
    total.nil? || total != 0
  end
end