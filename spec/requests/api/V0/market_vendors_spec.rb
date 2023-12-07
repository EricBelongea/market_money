require 'rails_helper'

RSpec.describe "MarketVendors" do
  it "can get all vendors that belong to a market" do
    m = create(:market)
    v = create_list(:vendor, 20)
    m.vendors << v

    get "/api/v0/markets/#{m.id}/vendors"
    expect(response).to be_successful
    vendors = JSON.parse(response.body, symbolize_names: true)
    expect(vendors[:data].count).to eq(20)

    vendors[:data].each do |vendor|
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
  end

  it "Can create a Market Vendor" do
    market = create(:market)
    vendor = create(:vendor)

    post "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: vendor.id}

    expect(response).to be_successful
    
    created_market_vendor = JSON.parse(response.body, symbolize_names: true)

    market_vendor = created_market_vendor[:data]
    
    expect(market_vendor).to have_key(:id)
    expect(market_vendor[:id]).to be_a(String)
    
    expect(market_vendor).to have_key(:type)
    expect(market_vendor[:type]).to eq("market_vendor")
    
    expect(market_vendor[:attributes]).to have_key(:market_id)
    expect(market_vendor[:attributes][:market_id]).to be_a(Integer)
    expect(market_vendor[:attributes][:market_id]).to eq(market.id)
    
    expect(market_vendor[:attributes]).to have_key(:vendor_id)
    expect(market_vendor[:attributes][:vendor_id]).to be_a(Integer)
    expect(market_vendor[:attributes][:vendor_id]).to eq(vendor.id)
    
    expect(market.vendors).to eq([vendor])
    
    # vendor2 = create(:vendor)
    # post "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: vendor2.id}
    # require 'pry'; binding.pry

    # expect(market.vendors).to eq([vendor, vendor2])
  end

  it "Can delete a market vendor" do
    market = create(:market)
    vendor = create(:vendor)

    post "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: vendor.id}

    expect(response).to be_successful

    created_market_vendor = JSON.parse(response.body, symbolize_names: true)

    market_vendor = MarketVendor.find(created_market_vendor[:data][:id])

    expect { delete "/api/v0/market_vendors/#{market_vendor.id}" }.to change(MarketVendor, :count).by(-1)

    expect{ MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)

    expect(Market.find(market.id)).to eq(market)
    expect(Vendor.find(vendor.id)).to eq(vendor)

    # delete "/api/v0/vendors/#{vendor.id}"

    #   expect(response).to be_successful

    #   delete "/api/v0/vendors/#{vendor.id}"
    #   expect(response).to_not be_successful
      
    #   deleted_vendor = JSON.parse(response.body, symbolize_names: true)

    #   expect(deleted_vendor[:errors]).to be_a(Array)
    #   expect(deleted_vendor[:errors].first[:status]).to eq("404")
    #   expect(deleted_vendor[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=#{vendor.id}")
  end

  describe '#sad-path' do
    it 'returns proper error message and status code' do
      m = create(:market)
      v = create_list(:vendor, 20)
      m.vendors << v

      get "/api/v0/markets/0/vendors"
      # require 'pry'; binding.pry
      expect(response).to_not be_successful
  
      expect(response.status).to eq(404)
      expect(response.status).to be_a(Integer)
  
      data = JSON.parse(response.body, symbolize_names: true)
  
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=0")
    end

    describe '#create-sad-paths' do
      it 'market id must be valid' do
        vendor = create(:vendor)

        post "/api/v0/market_vendors", params: { market_id: 0, vendor_id: vendor.id}

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        data = JSON.parse(response.body, symbolize_names: true)
        # require 'pry'; binding.pry

        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:status]).to eq("404")
        expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=0")
      end

      it "Vendor must be real" do
        market = create(:market)

        post "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: 0}

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:status]).to eq("404")
        expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=0")
      end

      it "market nor vendor id can be blank" do
        post "/api/v0/market_vendors", params: { market_id: "", vendor_id: ""}

        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:status]).to eq("400")
        expect(data[:errors].first[:title]).to eq("Market ID or Vendor ID cannot be blank")
      end
    end

    it "Can't delete a MarketVendor that's not there" do
      market = create(:market)
      vendor = create(:vendor)

      post "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: vendor.id}

      expect(response).to be_successful
      
      created_market_vendor = JSON.parse(response.body, symbolize_names: true)
      
      market_vendor = MarketVendor.find(created_market_vendor[:data][:id])
      
      delete "/api/v0/market_vendors/#{market_vendor.id}"
      expect(response).to be_successful
      
      delete "/api/v0/market_vendors/#{market_vendor.id}"
      # require 'pry'; binding.pry
      expect(response).to_not be_successful
      
      deleted_mv = JSON.parse(response.body, symbolize_names: true)

      expect(deleted_mv[:errors]).to be_a(Array)
      expect(deleted_mv[:errors].first[:status]).to eq("404")
      expect(deleted_mv[:errors].first[:title]).to eq("Couldn't find MarketVendor with 'id'=#{market_vendor.id}")
    end
  end
end
