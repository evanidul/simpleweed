FactoryGirl.define do 
	factory :store_item do
		sequence(:name) { |n| "item#{n}"} 
		strain "indica"
		maincategory "flower"
		subcategory "bud"		
	end
end