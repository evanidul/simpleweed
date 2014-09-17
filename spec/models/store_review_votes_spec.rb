require 'spec_helper'

describe StoreReviewVote do
	before(:each) do
		@admin = create(:admin)
		@bob = create(:user)		  									
		@alice = create(:user)		  									
	end

  	before(:each) do
  		@store = create(:store)
  	end
  	
	before(:each) do
		@bobs_store_review = create(:store_review, :store => @store, :user => @bob)
		@alices_store_review = create(:store_review, :store => @store, :user => @alice)
	end

	it "prevents users from voting on their own review" do
		vote = build(:store_review_vote, :user => @bob, :store_review => @bobs_store_review)		
		expect(vote.user).to eq @bob
		expect(vote).to have(1).errors_on(:base)
		vote.errors[:base].should include "A user can't vote on their own reviews"
		expect(vote).to be_invalid
	end

	it "fails as store owner" do
		@store_owner = create(:user)
		role_service = Simpleweed::Security::Roleservice.new							
		role_service.addStoreOwnerRoleToStore(@store_owner, @store)

		vote = build(:store_review_vote, :user => @store_owner, :store_review => @bobs_store_review)		
		expect(vote).to have(1).errors_on(:base)
		vote.errors[:base].should include "Store owners and managers cannot vote on reviews"
		expect(vote).to be_invalid
	end

	it "allows users to vote on other user's reviews" do
		vote = build(:store_review_vote, :user => @alice, :store_review => @bobs_store_review)		
		expect(vote).to be_valid		
	end

	it "prevents users from voting twice on the same review" do
		# use create to save the record instead of 'build' which just creates in memory object so that vote2 will throw exception
		vote = create(:store_review_vote, :user => @alice, :store_review => @bobs_store_review)		
		expect(vote).to be_valid		

		vote2 = build(:store_review_vote, :user => @alice, :store_review => @bobs_store_review)		
		expect(vote2).to be_invalid				
	end

	it "prevents a vote from being greater than 1" do
		vote = build(:store_review_vote, :user => @alice, :store_review => @bobs_store_review, :vote => 2)		
		expect(vote).to be_invalid
		expect(vote).to have(1).errors_on(:vote)
	end

	it "prevents a vote from being less than -1" do
		vote = build(:store_review_vote, :user => @alice, :store_review => @bobs_store_review, :vote => -2)		
		expect(vote).to be_invalid
		expect(vote).to have(1).errors_on(:vote)
	end

	it "requires a user" do
		vote = build(:store_review_vote, :user => nil, :store_review => @bobs_store_review, :vote => -1)		
		expect(vote).to be_invalid
		expect(vote).to have(1).errors_on(:user)
	end

	it "requires a store review" do
		vote = build(:store_review_vote, :user => @alice, :store_review => nil, :vote => 1)		
		expect(vote).to be_invalid
		expect(vote).to have(1).errors_on(:store_review)
	end

end
