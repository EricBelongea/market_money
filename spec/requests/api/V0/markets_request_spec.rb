require "rails_helper"

describe "Markets API" do
  it 'sends a list of all markets' do
    create_list(:market, 3)

    get '/api/v0/markets'

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets[:data].count).to eq(3)

    markets[:data].each do |market|

      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)

      expect(market).to have_key(:type)
      expect(market[:type]).to eq("market")

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)

      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)

      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)
      
      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)

      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_a(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_a(String)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_a(String)

      expect(market[:attributes]).to have_key(:vendor_count)
      expect(market[:attributes][:vendor_count]).to be_a(Integer)
    end
  end

  it "Can get one market" do
    market = create(:market)

    get "/api/v0/markets/#{market.id}"

    expect(response).to be_successful

    market_data = JSON.parse(response.body, symbolize_names: true)

    market = market_data[:data]

    expect(market).to have_key(:id)
    expect(market[:id]).to be_an(String)

    expect(market).to have_key(:type)
    expect(market[:type]).to eq("market")

    expect(market[:attributes]).to have_key(:name)
    expect(market[:attributes][:name]).to be_a(String)

    expect(market[:attributes]).to have_key(:street)
    expect(market[:attributes][:street]).to be_a(String)

    expect(market[:attributes]).to have_key(:city)
    expect(market[:attributes][:city]).to be_a(String)

    expect(market[:attributes]).to have_key(:county)
    expect(market[:attributes][:county]).to be_a(String)
    
    expect(market[:attributes]).to have_key(:state)
    expect(market[:attributes][:state]).to be_a(String)

    expect(market[:attributes]).to have_key(:zip)
    expect(market[:attributes][:zip]).to be_a(String)

    expect(market[:attributes]).to have_key(:lat)
    expect(market[:attributes][:lat]).to be_a(String)

    expect(market[:attributes]).to have_key(:lon)
    expect(market[:attributes][:lon]).to be_a(String)

    expect(market[:attributes]).to have_key(:vendor_count)
    expect(market[:attributes][:vendor_count]).to be_a(Integer)
  end

  it "Can find markets based on search" do
    market = create(:market)
    market3 = create(:market)
    market4 = create(:market)
    
    # require 'pry'; binding.pry
    get "/api/v0/markets/search", params: { city: "#{market[:city]}" }
    expect(response).to be_successful

    market_data = JSON.parse(response.body, symbolize_names: true)
    
    expect(market_data[:data].count).to eq(1)
    
    market2 = create(:market, city: market[:city])
    
    get "/api/v0/markets/search", params: { city: "#{market[:city]}" }
    market_data = JSON.parse(response.body, symbolize_names: true)
    
    expect(market_data[:data].count).to eq(2)
  end

  it "Can search by state" do
    market = create(:market, city: "Gassaway", state: "West Virginia", name: "county")
    market3 = create(:market, state: "West Virginia")
    market4 = create(:market, state: "West Virginia")
    
    # require 'pry'; binding.pry
    get "/api/v0/markets/search", params: { city: "Gassaway", state: "West Virginia", name: "county"}
    expect(response).to be_successful

    market_data = JSON.parse(response.body, symbolize_names: true)
    
    expect(market_data[:data].count).to eq(1)

  end

  describe '#sad-path' do
    it "no merchant with provided id" do
      markets = create_list(:market, 5)

      get "/api/v0/markets/0"

      expect(response).to_not be_successful

      expect(response.status).to eq(404)
      expect(response.status).to be_a(Integer)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=0")
    end
  end
end