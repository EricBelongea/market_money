require "rails_helper"

RSpec.describe "Vendor" do
  it "Can return a specifc vendors info" do
    vendor = create(:vendor)

    get "/api/v0/vendors/#{vendor.id}"
    expect(response).to be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)
    expect(vendors.count).to eq(1)
    vendor = vendors[:data]

    expect(vendor).to have_key(:id)
    expect(vendor[:id]).to be_a(String)
    
    expect(vendor).to have_key(:type)
    expect(vendor[:type]).to eq("vendor")

    expect(vendor[:attributes]).to have_key(:name)
    expect(vendor[:attributes][:name]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:description)
    expect(vendor[:attributes][:description]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:contact_name)
    expect(vendor[:attributes][:contact_name]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:contact_phone)
    expect(vendor[:attributes][:contact_phone]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:credit_accepted)
    expect(vendor[:attributes][:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
  end

  describe '#sad-path' do
    it 'returns proper error message and status code' do
      vendor = create(:vendor)

      get "/api/v0/vendors/0"

      expect(response).to_not be_successful
  
      expect(response.status).to eq(404)
      expect(response.status).to be_a(Integer)
  
      data = JSON.parse(response.body, symbolize_names: true)
  
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=0")
    end
  end
end