FactoryGirl.define do 
	factory :store do
		sequence(:name) { |n| "store#{n}"} 
		addressline1 "7110 Rock Valley Court"
		city "San Diego"
		state "CA"
		zip "92122"
	end
end