require File.dirname(__FILE__) + '/../spec_helper'

class Spree::DummyCalculator < Spree::Calculator

  def description
    "Dummy Calc"
  end

  def compute
    return unless order.present? && order.line_items.present? && order.user.present?

    order.line_items.map { |item| compute_item(item.variant) }.sum.round(2)
  end

  def compute_item(variant)
    variant.price * 0.75
  end

end

describe Spree::UserGroup do
  let(:calculator) { Spree::DummyCalculator.create! }
  let(:user_group) { Spree::UserGroup.create!(:name => "Test Group", :calculator => calculator) }
  let(:user) { Spree::User.create!(:email => "someone@example.com", :password => "password") }
  let(:product) { Spree::Product.create!(:name => "Product 1", :price => 10) }
  let(:order) { Spree::Order.create }

  context "belonging to a user who belongs to a UserGroup" do

    before do
      user.user_group = user_group
      user.save
      order.user = user
      order.save!
      order.add_variant(product.master)
    end

    it "results in an order with one line item" do
      order.line_items.count.should == 1
    end

    it "has a line_item with the correct price" do
      order.line_items.first.price.to_f.should == 7.5
    end

    it "has the correct order total" do
      order.item_total.to_f.should == 7.5
    end


  end
  # let(:user_group) { Spree::UserGroup.new }

  # context "shoulda validations" do
  #   it { should have_many(:users) }
  # end

  # describe "#save" do
  #   let(:calculator) { Spree::Calculator::AdvancedFlatPercent.new }
  #   let(:user_group_valid) { Spree::UserGroup.new(:name => "Wholesaler",
  #      :calculator => calculator) }

  #   context "when is invalid" do
  #     it { user_group.save.should be_false }
  #   end

  #   context "when is valid" do
  #     it { user_group_valid.save.should be_true }
  #   end
  # end
end
