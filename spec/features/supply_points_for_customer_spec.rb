require 'rails_helper'
feature 'list supply points for customer' do
  let(:supply_points) do
    [
        {reference: '123451'},
        {reference: '123452'},
        {reference: '123453'},
        {reference: '123454'}
    ]
  end

  before :each do
    allow(ProfileRepositoryClient).to receive(:get).and_return({status: 200, body: {data: supply_points}.to_json})
  end

  scenario 'list supply points for customer' do
    visit customer_supply_points_path('nandos')

    expect(ProfileRepositoryClient).to have_received(:get).with('/customers/nandos/supply-points?page=1')
    within '#sp_123451' do
      ['Month to date', 'Last month', 'Previous month', 'Year to date', 'Last year'].each do |txt|
        expect(page).to have_text txt
      end
      click_on 'Custom'
    end
    expect(page).to have_text('View Charges')
    expect(find('#view_charge_request_supply_point_id').value).to eq('123451')
  end

end