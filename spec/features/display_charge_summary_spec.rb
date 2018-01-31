require 'rails_helper'

feature 'display charge summary' do
  context 'when selecting supply point and dates' do
    let(:charges) do
      {
          duos: {bands: [{
                             band: 'Green', units: 234, unit_charge: 0.74000001, charge: 2.3400001,
                             count: 1, uom: 'p/kwh'
                         }],
                 total: {
                     kwh: 122.366,
                     charge: 456.78763,
                     percentage: 15.6,
                     integrity_percent: 25,
                     count: 12
                 }},
          loss: {bands: [{
                             band: 'Single', pence_per_kwh: 32, t_loss: 574, t_loss_kwh: 63574, d_loss: 7283, d_loss_kwh: 634, t_loss_factor: 1.01,
                             count: 6
                         }],
                 total: {
                     t_loss_kwh: 2332.1,
                     t_loss_charge: 255.00,
                     d_loss_kwh: 543.212,
                     d_loss_charge: 433.20,
                     t_loss_percentage: 0.9,
                     d_loss_percentage: 7.4,
                     integrity_percent: 12.5,
                     count: 6
                 }
          },
          energy: {bands: [
              {
                  band: 'Single', pence_per_kwh: 0.43, kwh: 543, energy_cost: 646,
                  count: 1
              }],
                   total: {
                       kwh: 98.7, charge: 123, percentage: 76.1,
                       integrity_percent: 22.5,
                       count: 16
                   }},
          total_cost: 631.783,
          expected_periods: 48
      }
    end
    let(:customer){'the-customer'}

    background do
      allow(ChargeServiceClient).to receive(:get_charges).and_return({status: 200, body: {data: charges}.to_json})
    end

    scenario 'renders the charges retrieved from charge repo' do
      visit customer_supply_point_charges_path customer, '1234-321', from: '2016-01-01', to: '2016-01-31'
      expect(ChargeServiceClient).to have_received(:get_charges).with(customer, '1234-321', DateTime.parse('2016-01-01'), DateTime.parse('2016-01-31'), false)
      expect(page).to have_text("Charges for supply point '1234-321' between '2016-01-01' and '2016-01-31'")
      within('.duos-charges') do
        expect(page).to have_text 'DUOS Charges'
        expect(page).to have_text 'Data integrity 25% (12/48)'
        expected = [
            ['Band', 'Units', 'Unit of Measure', 'Unit Charge', 'Charge £'],
            %w(Green 234 p/kwh 0.74 2.34),
            ['Total',  '122.366', '','', '456.79']
        ]
        actual = find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
        expect(actual).to eq(expected)
      end
      within('.tloss-charges') do
        expect(page).to have_text 'Transmission Losses'
        expect(page).to have_text 'Data integrity 12.5% (6/48)'
        expected = [
            ['Band', 'Units (kWh)', 'Charge p/kWh', 'Charge £'],
            %w(Single 63574 32.0 574.00 ),
            ['Total', '2332.1', '', '255.00']
        ]
        actual = find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
        expect(actual).to eq(expected)
      end
      within('.dloss-charges') do
        expect(page).to have_text 'Distribution Losses'
        expect(page).to have_text 'Data integrity 12.5% (6/48)'
        expected = [
            ['Band', 'Units (kWh)', 'Charge p/kWh', 'Charge £'],
            %w(Single 634 32.0 7283.00),
            ['Total', '543.212', '', '433.20']
        ]
        actual = find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
        expect(actual).to eq(expected)
      end
      within('.energy-charges') do
        expect(page).to have_text 'Energy Charges'
        expect(page).to have_text 'Data integrity 22.5% (16/48)'
        expected = [
            ['Band', 'Units (kWh)', 'Charge p/kWh', 'Charge £'],
            %w(Single 543 0.43 646.00),
            ['Total', '98.7', '', '123.00']
        ]
        actual = find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
        expect(actual).to eq(expected)
      end
      within('.cost-summary') do
        expect(page).to have_text 'Cost Summary'
        expected = [
            ['Charge Type', 'Units (kWh)', 'Percentage &percnt;', 'Total Charge £'],
            %w(DUOS 122.366 456.79 15),
            ['T Loss', '2332.1', '255.00', '0.9'],
            ['D Loss', '543.212', '433.20', '7.4'],
            %w(Energy 98.7 123.00 76.1),
            ['Total', '', '100', '631.78']
        ].first
        actual = find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }.first
        expect(actual).to eq(expected)
      end
    end

    scenario 'retrieves the data fro /clock' do
      visit clock_customer_supply_point_charges_path 'the-customer', '1234-321', from: '2016-01-01', to: '2016-01-31'
      expect(ChargeServiceClient).to have_received(:get_charges).with('the-customer', '1234-321', DateTime.parse('2016-01-01'), DateTime.parse('2016-01-31'), true)
    end
  end
end
