class CreateForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :forecasts do |t|
      t.string :postcode
      t.string :temperature

      t.timestamps
    end
  end
end
