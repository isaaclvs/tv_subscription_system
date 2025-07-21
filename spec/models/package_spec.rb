require 'rails_helper'

RSpec.describe Package, type: :model do
  let(:plan) { create(:plan, price: 50.00) }
  let(:service1) { create(:additional_service, price: 10.00) }
  let(:service2) { create(:additional_service, price: 15.00) }

  describe 'validations' do
    it 'requires a name' do
      package = Package.new(plan: plan)
      expect(package).not_to be_valid
      expect(package.errors[:name]).to include("can't be blank")
    end

    it 'validates price when present' do
      package = Package.new(name: "Basic Package", plan: plan, price: -1)
      package.additional_services << service1
      expect(package).not_to be_valid
      expect(package.errors[:price]).to include("must be greater than 0")
    end
  end

  describe 'basic functionality' do
    it 'belongs to a plan' do
      package = create(:package, plan: plan)
      expect(package.plan).to eq plan
    end

    it 'can have additional services' do
      package = create(:package, plan: plan)
      expect(package.additional_services).to respond_to(:<<)
    end
  end
end
