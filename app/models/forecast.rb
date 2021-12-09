# == Schema Information
#
# Table name: forecasts
#
#  id          :bigint           not null, primary key
#  postcode    :string
#  temperature :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Forecast < ApplicationRecord
  validates :postcode, presence: true
end
