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

  it "Create a new Vendor" do
    vendor_params = ({
      name: "Turing",
      description: "School of Software and Design",
      contact_name: "Hello my name is yeff", 
      contact_phone: "1-800-123-4567",
      credit_accepted: true
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

    created_vendor = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry
    expect(response).to be_successful

    expect(created_vendor[:data][:attributes]).to have_key(:name)
    expect(created_vendor[:data][:attributes][:name]).to be_a(String)
    expect(created_vendor[:data][:attributes][:name]).to eq(vendor_params[:name])

    expect(created_vendor[:data][:attributes]).to have_key(:description)
    expect(created_vendor[:data][:attributes][:description]).to be_a(String)
    expect(created_vendor[:data][:attributes][:description]).to eq(vendor_params[:description])

    expect(created_vendor[:data][:attributes]).to have_key(:contact_name)
    expect(created_vendor[:data][:attributes][:contact_name]).to be_a(String)
    expect(created_vendor[:data][:attributes][:contact_name]).to eq(vendor_params[:contact_name])

    expect(created_vendor[:data][:attributes]).to have_key(:contact_phone)
    expect(created_vendor[:data][:attributes][:contact_phone]).to be_a(String)
    expect(created_vendor[:data][:attributes][:contact_phone]).to eq(vendor_params[:contact_phone])

    expect(created_vendor[:data][:attributes]).to have_key(:credit_accepted)
    expect(created_vendor[:data][:attributes][:credit_accepted]).to be_a(TrueClass).or(FalseClass)
    expect(created_vendor[:data][:attributes][:credit_accepted]).to eq(vendor_params[:credit_accepted])
  end

  it "Delete a vendor" do
    v1 = create(:vendor)
    v2 = create(:vendor)
    v3 = create(:vendor)
    v4 = create(:vendor)

    expect { delete "/api/v0/vendors/#{v4.id}" }.to change(Vendor, :count).by(-1)

    expect{ Vendor.find(v4.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "Can update a vendor" do
    vendor = create(:vendor)
    
    vendor_id = vendor.id

    vendor_params = ({
      name: "Eric",
      description: "Once upon a time...",
      contact_name: "Still eric",
      contact_phone: "buy me dinner first",
      credit_accepted: false
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: vendor_params)

    updated_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful    

    expect(vendor_id.to_s).to eq(updated_vendor[:data][:id])
    expect(updated_vendor[:data][:type]).to eq("vendor")

    expect(updated_vendor[:data][:attributes]).to have_key(:name)
    expect(updated_vendor[:data][:attributes][:name]).to be_a(String)
    expect(updated_vendor[:data][:attributes][:name]).to eq(vendor_params[:name])

    expect(updated_vendor[:data][:attributes]).to have_key(:description)
    expect(updated_vendor[:data][:attributes][:description]).to be_a(String)
    expect(updated_vendor[:data][:attributes][:description]).to eq(vendor_params[:description])

    expect(updated_vendor[:data][:attributes]).to have_key(:contact_name)
    expect(updated_vendor[:data][:attributes][:contact_name]).to be_a(String)
    expect(updated_vendor[:data][:attributes][:contact_name]).to eq(vendor_params[:contact_name])

    expect(updated_vendor[:data][:attributes]).to have_key(:contact_phone)
    expect(updated_vendor[:data][:attributes][:contact_phone]).to be_a(String)
    expect(updated_vendor[:data][:attributes][:contact_phone]).to eq(vendor_params[:contact_phone])

    expect(updated_vendor[:data][:attributes]).to have_key(:credit_accepted)
    expect(updated_vendor[:data][:attributes][:credit_accepted]).to be_a(FalseClass)
    expect(updated_vendor[:data][:attributes][:credit_accepted]).to eq(vendor_params[:credit_accepted])
  end

  describe '#sad-path' do
    it 'show page action - nonexistant vendor id' do
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

    it "create function sad-path" do
      vendor_params = ({
      name: "",
      description: "School of Software and Design",
      contact_name: "Hello my name is yeff", 
      contact_phone: "1-800-123-4567",
      credit_accepted: true
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    created_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(created_vendor[:errors]).to be_a(Array)
    expect(created_vendor[:errors].first[:status]).to eq("400")
    expect(created_vendor[:errors].first[:title]).to eq("Validation failed: Name can't be blank")
    end

    it "delete action sad-path" do
      vendor = create(:vendor)

      delete "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful

      delete "/api/v0/vendors/#{vendor.id}"
      expect(response).to_not be_successful
      
      deleted_vendor = JSON.parse(response.body, symbolize_names: true)

      expect(deleted_vendor[:errors]).to be_a(Array)
      expect(deleted_vendor[:errors].first[:status]).to eq("404")
      expect(deleted_vendor[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=#{vendor.id}")
    end

    it "update action sad-path" do
      vendor = create(:vendor)
    
      vendor_id = vendor.id

      vendor_params = ({
        name: "",
        description: "Once upon a time...",
        contact_name: "Still eric",
        contact_phone: "buy me dinner first",
        credit_accepted: false
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: vendor_params)

      updated_vendor = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful 

      expect(updated_vendor[:errors]).to be_a(Array)
      expect(updated_vendor[:errors].first[:status]).to eq("400")
      expect(updated_vendor[:errors].first[:title]).to eq("Validation failed: Name can't be blank")
    end
  end
end