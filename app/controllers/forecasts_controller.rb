class ForecastsController < ApplicationController
  def new
    @forecast = Forecast.new
  end

  def create
    temperature = ForecastService.new(forecast_params[:postcode])
    redirect_to new_forecast_path, notice: temperature.forecast_message
  end

  private

  def forecast_params
    params.require(:forecast).permit(:postcode)
  end
end
