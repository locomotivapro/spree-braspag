require 'spec_helper'
require File.expand_path('../../../../../lib/spree/braspag/utils', __FILE__)


describe Spree::Braspag::Utils do

  describe '#format_amount' do
    it 'raise error if not an Integer' do
      expect { Spree::Braspag::Utils.format_amount(30.0) }.to raise_error(ArgumentError)
    end

    it 'convert 1000 to 10,00' do
      amount = Spree::Braspag::Utils.format_amount(1000)
      expect(amount).to eq '10,00'
    end

    it 'convert 800 to 8,00' do
      amount = Spree::Braspag::Utils.format_amount(800)
      expect(amount).to eq '8,00'
    end

    it 'convert 50 to 0,50' do
      amount = Spree::Braspag::Utils.format_amount(50)
      expect(amount).to eq '0,50'
    end

    it 'convert 3 to 0,03' do
      amount = Spree::Braspag::Utils.format_amount(3)
      expect(amount).to eq '0,03'
    end

    it 'convert 1050 to 10,50' do
      amount = Spree::Braspag::Utils.format_amount(1050)
      expect(amount).to eq '10,50'
    end

    it 'convert 50223 to 502,23' do
      amount = Spree::Braspag::Utils.format_amount(50223)
      expect(amount).to eq '502,23'
    end

  end
end
