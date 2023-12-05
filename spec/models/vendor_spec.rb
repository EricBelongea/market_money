require "rails_helper"

RSpec.describe Vendor, type: :model do
  before(:each) do

  end

  describe '#relations' do
    it { should have_many :market_vendors }
    it { should have_many :markets }
  end
end