require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      customer = Customer.new(age: 25)
      expect(customer).not_to be_valid
      expect(customer.errors[:name]).to include("can't be blank")
    end

    it 'validates minimum age' do
      customer = Customer.new(name: "John", age: 17)
      expect(customer).not_to be_valid
      expect(customer.errors[:age]).to include("must be greater than or equal to 18")
    end

    it 'is valid with valid attributes' do
      customer = Customer.new(name: "John", age: 25)
      expect(customer).to be_valid
    end
  end
end
