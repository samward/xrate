require "xrate"
require "date"

RSpec.describe Xrate::ExchangeRate do
  let!(:existing_entry) do
    Xrate::Rate.create(date: Date.today, currency: "USD", rate: 1.2)
  end

  let(:duplicate_entry) do
    Xrate::Rate.create(date: Date.today, currency: "USD", rate: 1.21)
  end

  it "validates uniquness of currency, scoped to date" do
    expect(duplicate_entry).to be_invalid
  end
end
