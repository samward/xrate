require "xrate"
require "date"

RSpec.describe Xrate::ExchangeRate do
  describe ".at" do
    let(:subject) { Xrate::ExchangeRate.at(date, from, target) }
    let(:base_currency) { "EUR" }
    let(:date) { Date.today }

    before do
      Xrate::Rate.create(date: Date.today, currency: "USD", rate: 1.17810 )
      Xrate::Rate.create(date: Date.today, currency: "GBP", rate: 0.87325 )
      allow(ENV).to receive(:fetch).with("XRATE_BASE_CURRENCY").and_return(base_currency)
    end

    context "a valid request" do
      let(:date) { Date.today }
      let(:from) { "EUR" }
      let(:target) { "GBP" }

      context "in base currency" do
        it "returns the stored exchange rate" do
          expect(subject).to eql(0.87325)
        end

        it "returns a BigDecimal exchange rate" do
          expect(subject).to be_a BigDecimal
        end
      end

      context "in non-base currency" do
        let(:from) { "USD" }
        let(:target) { "GBP" }

        it "returns the computed exchange rate" do
          expect(subject).to be_within(0.001).of(0.741)
        end
      end

      context "with a date string" do
        let(:date) { Date.today.to_s }

        it "returns the stored exchange rate" do
          expect(subject).to eql(0.87325)
        end
      end


      context "when from and target are the same" do
        let(:from) { "GBP" }
        let(:target) { "GBP" }

        it "returns prescisely 1" do
          expect(subject).to eql(1)
        end
      end

      context "with an invalid date" do
        let(:date) { "Cheese" }

        it "raises an exception" do
          expect { subject }.to raise_error(Xrate::UnconvertableCurrencyException)
        end
      end
    end

    context "when a base currency rate is not available" do
      let(:from) { "EUR" }
      let(:target) { "XXX" }

      it "raises an exception" do
        expect { subject }.to raise_error(Xrate::UnconvertableCurrencyException)
      end
    end

    context "when there are no rates for the given date" do
      let(:from) { "EUR" }
      let(:target) { "GBP" }
      let(:date) { Date.today.prev_day }

      it "raises an exception" do
        expect { subject }.to raise_error(Xrate::UnconvertableCurrencyException)
      end
    end

    context "when a currency is not available" do
      let(:from) { "GBP" }
      let(:target) { "XXX" }

      it "raises an exception" do
        expect { subject }.to raise_error(Xrate::UnconvertableCurrencyException)
      end
    end
  end
end
