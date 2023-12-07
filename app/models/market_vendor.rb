class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  # validates :market_id
  # validates :vendor_id
end