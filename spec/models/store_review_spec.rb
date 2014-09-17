require 'spec_helper'

describe StoreReview do
  	before(:each) do
		@admin = create(:admin)		
	end

  	before(:each) do
  		@store = create(:store)
  		@store2 = create(:store)
  	end
  	
	it "fails as store owner for his own store" do
		@store_owner = create(:user)
		role_service = Simpleweed::Security::Roleservice.new							
		role_service.addStoreOwnerRoleToStore(@store_owner, @store)

		review = build(:store_review, :user => @store_owner, :store => @store)		
		expect(review).to have(1).errors_on(:base)
		review.errors[:base].should include "Store owners and managers cannot write reviews"
		expect(review).to be_invalid
	end

	it "fails as store owner for other store" do
		@store_owner = create(:user)
		role_service = Simpleweed::Security::Roleservice.new							
		role_service.addStoreOwnerRoleToStore(@store_owner, @store)

		review = build(:store_review, :user => @store_owner, :store => @store2)		
		expect(review).to have(1).errors_on(:base)
		review.errors[:base].should include "Store owners and managers cannot write reviews"
		expect(review).to be_invalid
	end
end
