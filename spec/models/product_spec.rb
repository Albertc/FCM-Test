# frozen_string_literal: true

RSpec.describe Product do
  describe '#new' do
    subject { described_class.new(code: '001', name: 'test_name', price: 1.23) }

    it 'returns an instance of Product with the attributes provided' do
      mask = subject

      expect(mask.code).to eq('001')
      expect(mask.name).to eq('test_name')
      expect(mask.price).to eq(1.23)
    end
  end
end

