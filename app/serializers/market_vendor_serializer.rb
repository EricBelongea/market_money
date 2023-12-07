class MarketVendorSerializer
  include JSONAPI::Serializer
  attributes :market_id, :vendor_id
  # require 'pry'; binding.pry

end