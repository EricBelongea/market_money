require "rails_helper"

RSpec.describe "ErrorMessage Poro" do
  before(:each) do

  end

  it "exisits" do
    error_message = ErrorMessage.new("Message", 404)
    # require 'pry'; binding.pry
    expect(error_message).to be_a ErrorMessage
    expect(error_message.message).to eq("Message")
    expect(error_message.message).to be_a(String)

    expect(error_message.status_code).to eq(404)
    expect(error_message.status_code).to be_a(Integer)
  end
end