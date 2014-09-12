FactoryGirl.define do 
	factory :feed_post do
		sequence(:title) { |n| "feedpost#{n}"} 		
		post "this is a great post"
	end
end