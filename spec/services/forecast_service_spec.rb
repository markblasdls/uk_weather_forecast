require 'rails_helper'

RSpec.describe ForecastService, type: :service do
  subject(:valid_forcast) { described_class.new('ip130sr') }
  subject(:invalid_forcast) { described_class.new('6000') }
  subject(:not_uk_forcast) { described_class.new('33030') }
  subject(:empty_forcast) { described_class.new(nil) }

  context '#country' do
    it 'should return UK' do
      expect(valid_forcast.country).to eq('UK')
    end

    it 'should return Florida' do
      expect(not_uk_forcast.country).to eq('USA')
    end

    it 'should raise Error' do
      expect { invalid_forcast.country }
        .to raise_exception(StandardError)
    end
  end

  context '#day_forecast' do
    it 'should not equal to nil' do
      expect(valid_forcast.day_forecast).to_not eq(nil)
    end

    it 'should raise Error' do
      expect { invalid_forcast.empty_forcast }
        .to raise_exception(StandardError)
    end
  end

  context '#country_uk?' do
    it 'should return true' do
      expect(valid_forcast.country_uk?).to eq(true)
    end

    it 'should return false' do
      expect(not_uk_forcast.country_uk?).to eq(false)
    end

    it 'should raise Error' do
      expect { invalid_forcast.country_uk? }
        .to raise_exception(StandardError)
    end
  end

  context '#max_temp_c' do
    it 'should return nil' do
      expect(not_uk_forcast.max_temp_c).to eq(nil)
    end

    it 'should return No matching location found' do
      expect(invalid_forcast.forecast_message).to eq('No matching location found.')
    end
  end

  context '#forecast' do
    it 'should return Postcode is Empty' do
      expect(empty_forcast.forecast).to eq('Postcode is Empty')
    end

    it 'should return Temperature' do
      expect(valid_forcast.forecast).to eq('Cold').or eq('Warm').or eq('Hot')
    end

    it 'should return Temperature' do
      expect(valid_forcast.forecast).to eq('Cold').or eq('Warm').or eq('Hot')
    end
  end
end
