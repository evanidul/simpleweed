FactoryGirl.define do 
	factory :feed do
		sequence(:name) { |n| "feed#{n}"} 		
	end
end