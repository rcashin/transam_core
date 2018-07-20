require 'rails_helper'

RSpec.describe Uom, :type => :model do

  describe '#valid?' do
    it 'validates correctly' do
      expect(Uom.valid? Uom::MILE).to eq(true)
    end
    it 'validates correctly' do
      expect(Uom.valid? Uom::MILE).to eq(true)
      expect(Uom.send(:valid?, Uom::METER)).to eq(true)
    end
    it 'validates correctly' do
      expect(Uom.valid? 'cubits').to eq(false)
    end
    it 'validates correctly' do
      expect(Uom.valid? 'monkeys').to eq(false)
    end

  end

  describe '#convert?' do
    it 'converts correctly' do
      expect(Uom.convert(1, Uom::MILE, Uom::METER)).to be_within(0.001).of(1609.344)
    end
    it 'converts correctly' do
      expect(Uom.convert(0.25, Uom::MILE, Uom::METER)).to be_within(0.001).of(402.336)
    end
    it 'converts correctly' do
      expect(Uom.convert(1, Uom::METER, Uom::MILE)).to be_within(0.000000001).of(0.000621371)
    end
    it 'fails to convert' do
      expect { Uom.convert(1, Uom::METER, 'monkeys')}.to raise_error(ArgumentError)
    end

  end

end
