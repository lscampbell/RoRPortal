require 'rails_helper'

feature 'display consumption by month' do
  let(:consumption_data) do
    {
        consumption_data: [
          {reference: '1234-321', 'Jan 2017' => 225.5, 'Feb 2017' => 456.1, 'Mar 2017' => 376.1, 'Total' => 1057.7},
          {reference: '999-99', 'Jan 2017' => 361.2, 'Total' => 361.2}
        ],
        keys: ['Jan 2017', 'Feb 2017', 'Mar 2017']
    }
  end

  before :each do
    allow(ChargeServiceClient).to receive(:get_consumption_summary).and_return({status: 200, body:consumption_data.to_json})
  end

  it 'should display the summary correctly' do
    visit customer_consumptions_path 'test-customer', starts: '2017-01-01', ends: '2017-12-31'
    expect(page).to have_text("Monthly Consumptions for 'test-customer' between '2017-01-01' and '2017-12-31'")
    within('.consumptions') do
      actual = find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
      expected = [
          ['Supply Point', 'Jan 2017', 'Feb 2017', 'Mar 2017', 'Total'],
          ['1234-321', '225.5', '456.1', '376.1', '1057.7'],
          ['999-99', '361.2', '', '', '361.2']
      ]
      expect(actual).to eq(expected)
    end
    expect(ChargeServiceClient).to have_received(:get_consumption_summary).with('test-customer', '2017-01-01', '2017-12-31')
  end
end