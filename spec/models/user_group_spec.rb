require File.dirname(__FILE__) + '/../spec_helper'

describe Spree::UserGroup do
  let(:user_group) { Spree::UserGroup.new }

  context "shoulda validations" do
    it { should have_many(:users) }
  end

  describe "#save" do
    let(:calculator) { Spree::Calculator::AdvancedFlatPercent.new }
    let(:user_group_valid) { Spree::UserGroup.new(:name => "Wholesaler",
       :calculator => calculator) }

    context "when is invalid" do
      it { user_group.save.should be_false }
    end

    context "when is valid" do
      it { user_group_valid.save.should be_true }
    end
  end
end
