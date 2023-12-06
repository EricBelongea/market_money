class VendorSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :contact_name, :contact_phone, :credit_accepted
  # def initialize(vendors)
  #   @vendors = vendors
  # end

  # def serialize_json
  #   @vendors.map do |vendor|
  #     {
  #       id: vendor.id,
  #       name: vendor.name,
  #       description: vendor.description,
  #       contact_name: vendor.contact_name,
  #       contact_phone: vendor.contact_phone,
  #       credit_accepted: vendor.credit_accepted
  #     }
  #   end
  # end
end