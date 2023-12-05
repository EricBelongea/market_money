require "rails_helper"

describe "Markets API" do
  it 'sends a list of markets' do
    create_list(:market, 3)
    # require 'pry'; binding.pry
    get '/api/v0/markets'
    # require 'pry'; binding.pry
    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry

    expect(markets[:data].count).to eq(3)

    markets[:data].each do |market|
      # require 'pry'; binding.pry
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)

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
end