class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def self.find_market(params)
    city = params[:city]
    state = params[:state]
    name = params[:name]
    
    conditions = {}

    conditions[:city] = city.capitalize if city.present?
    conditions[:state] = state.split.map(&:capitalize).join(" ") if state.present?
    conditions[:name] = name if name.present?
    # require 'pry'; binding.pry
    result = Market.where(conditions)
    returned = result.to_a
    returned 
  end
end