require 'rails_helper'
feature 'list customers' do
  let(:customers) do
    [
        {name: 'customer1'},
        {name: 'customer2'},
        {name: 'customer3'},
        {name: 'customer4'}
    ]
  end
  let(:supply_points) do
    [
        {reference: '1234567'}
    ]
  end
  background  do
    allow(ProfileRepositoryClient).to receive(:get).with('/customers').and_return({status: 200, body: {data: customers}.to_json})
    allow(ProfileRepositoryClient).to receive(:get).with("/customers/customer2/supply-points?page=1").and_return({status: 200, body: {data: supply_points}.to_json})
  end

  scenario 'renders the customers retrieved from profile repo' do
    visit root_path
    click_on 'Customers'
    expect(page).to have_text('Customers')
    within '.customers' do
      expected = [
          ['Name', 'Supply Points', 'Monthly Consumption', 'Monthly Consumption'],
          ['customer1', 'View supply points', 'Year to date', 'Last year'],
          ['customer2', 'View supply points', 'Year to date', 'Last year'],
          ['customer3', 'View supply points', 'Year to date', 'Last year'],
          ['customer4', 'View supply points', 'Year to date', 'Last year']
      ]
      actual = find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
      expect(actual).to eq(expected)
    end
    click_link 'customer2'
    expect(page).to have_text("Supply Points for 'customer2'")
    expect(ProfileRepositoryClient).to have_received(:get).with('/customers')
  end
end