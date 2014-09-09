FactoryGirl.define do 
	factory :user do
		sequence(:username) { |n| "user#{n}"} 
		password "password"
		sequence(:email) { |n| "user#{n}@simpleweed.org"} 
		confirmed_at Time.now

		after(:create) { |user| 
			user.skip_confirmation!			
		}

		factory :admin do
        	after(:create) {|user| user.add_role(:admin)}
    	end
		
		

	end
end