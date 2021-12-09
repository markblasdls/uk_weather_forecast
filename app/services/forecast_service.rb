class ForecastService
  attr_reader :postcode, :has_error, :forecast_message

  def initialize(postcode)
    @postcode = postcode
    @has_error = false
    @forecast_message = ''
    forecast
  end

  def request
    JSON.parse(RestClient.get(ENV['API_URL'],
                              { params: { key: ENV['API_KEY'], days: ENV['API_DAYS'], q: @postcode } }))
  rescue RestClient::ExceptionWithResponse => e
    @has_error = true
    @forecast_message = 'Server Error.'
    error_code = JSON.parse(e.response).dig('error', 'code')
    error_message = JSON.parse(e.response).dig('error', 'message')
    @forecast_message = error_message if !error_message.nil? && error_code.to_i == 1006
  end

  def max_temp_c
    max_temp = nil
    return max_temp if request_validated? || !country_uk?

    @has_error = true
    @forecast_message = 'Max Temperature not found'

    unless day_forecast.nil?
      max_temp = day_forecast.first.dig('day', 'maxtemp_c')
      unless max_temp.nil?
        @has_error = false
        @forecast_message = ''
      end
    end
    max_temp
  end

  def day_forecast
    request.dig('forecast', 'forecastday')
  end

  def country
    request.dig('location', 'country')
  end

  def country_uk?
    if country.nil? || country != 'UK'
      @has_error = true
      @forecast_message = 'Location is not in UK'
      return false
    end
    true
  end

  def forecast
    return @forecast_message = 'Postcode is Empty' if @postcode.nil? || @postcode.empty?

    @forecast_message = compute_temperature(max_temp_c.to_f) unless max_temp_c.nil?
  rescue StandardError => e
    Rails.logger.info(e.message)
    Rails.logger.info(e.backtrace)
    @forecast_message = 'No matching location found. or Server Error.'
  end

  private

  def compute_temperature(max_temp_c)
    case max_temp_c
    when max_temp_c..19
      'Cold'
    when 20..25
      'Warm'
    else
      'Hot'
    end
  end

  def request_error?
    return true unless request['error'].nil?

    false
  end

  def request_validated?
    request.nil? || request_error? || @has_error
  end
end
