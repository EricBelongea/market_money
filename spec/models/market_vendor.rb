require "rails_helper"

RSpec.describe MarketVendor, type: :model do
  before(:each) do

  end

  describe '#relations' do
    it { should belong_to :vendor }
    it { should belong_to :market }
  end
end