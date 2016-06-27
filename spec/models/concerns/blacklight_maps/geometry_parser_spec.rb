require 'spec_helper'

describe BlacklightMaps::GeometryParser do
  describe '.parse' do
    context 'when parsing a CQL ENVELOPE' do
      it 'returns a BlacklightMaps::BoundingBox' do
        expect(described_class.parse('ENVELOPE(1,2,4,3)'))
          .to be_an BlacklightMaps::BoundingBox
      end
    end
    context 'when parsing an X Y coordinate' do
      it 'returns a BlacklightMaps::Point' do
        expect(described_class.parse('-180 90')).to be_an BlacklightMaps::Point
      end
    end
    context 'when parsing an unknown type' do
      it 'raises an exception' do
        expect do
          described_class.parse('123,23 32,123')
        end.to raise_error(BlacklightMaps::Exceptions::UnknownSpatialDataType)
      end
    end
  end
end
