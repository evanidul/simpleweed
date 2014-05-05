class StorePage < SitePrism::Page
	#set_url "/admin/stores"

	element :name_header, "#name"

	#description (main page)
	element :description, "#description"
	element :description_edit_link, "#edit-description-link"
	#description (modal)
	element :store_description_input, "#store_description_input"
	element :save_store_description_button, "#save_store_description_button"

	#first time patient deals (main page)
	element :first_time_patient_deals_text, "#first-time-patient-deals"
	element :edit_first_time_patient_deals_link, "#edit-first-time-patient-deals-link"
	#first time patient deals (modal)
	element :first_time_patient_deals_input, "#store_first_time_patient_deals_input"
	element :save_first_time_patient_deals_button, "#save_store_first_time_patient_deals_button"

	#daily specials (main page)
	element :dailyspecials_sunday_text, "#dailyspecials_sunday"
	element :dailyspecials_monday_text, "#dailyspecials_monday"
	element :dailyspecials_tuesday_text, "#dailyspecials_tuesday"
	element :dailyspecials_wednesday_text, "#dailyspecials_wednesday"
	element :dailyspecials_thursday_text, "#dailyspecials_thursday"
	element :dailyspecials_friday_text, "#dailyspecials_friday"
	element :dailyspecials_saturday_text, "#dailyspecials_saturday"
	#daily specials (modal)
	element :dailyspecials_sunday_input, "#store_dailyspecialssunday"
	element :dailyspecials_monday_input, "#store_dailyspecialsmonday"
	element :dailyspecials_tuesday_input, "#store_dailyspecialstuesday"
	element :dailyspecials_wednesday_input, "#store_dailyspecialswednesday"
	element :dailyspecials_thursday_input, "#store_dailyspecialsthursday"
	element :dailyspecials_friday_input, "#store_dailyspecialsfriday"
	element :dailyspecials_saturday_input, "#store_dailyspecialssaturday"

	element :edit_daily_specials_link, "#edit-daily-specials-link"
	element :save_store_daily_specials_button ,"#save_store_daily_specials_button"

	#contact (main page)
	element :addressline1, "#addressline1"
	element :addressline2, "#addressline2"
	element :city, "#city"
	element :state, "#state"
	element :zip, "#zip"
	element :phonenumber, "#phonenumber"
	element :email, "#email"
	element :website, "#website"
	element :facebook, "#facebook"
	element :twitter, "#twitter"
	element :instagram, "#instagram"

	element :edit_contact_link, "#edit-contact-link"

	#contact (edit modal)
	element :addressline1_input, "#store_addressline1"
	element :addressline2_input, "#store_addressline2"
	element :city_input, "#store_city"
	element :state_input, "#store_state"
	element :zip_input, "#store_zip"
	element :phonenumber_input, "#store_phonenumber"
	element :email_input, "#store_email"
	element :website_input, "#store_website"
	element :facebook_input, "#store_facebook"
	element :twitter_input, "#store_twitter"
	element :instagram_input, "#store_instagram"

	element :save_store_contact_button, "#save_store_contact_button"

	#features (main page)
	element :acceptscreditcards, "#acceptscreditcards"
	element :atmaccess, "#atmaccess"
	element :automaticdispensingmachines, "#automaticdispensingmachines"
	element :deliveryservice, "#deliveryservice"
	element :firsttimepatientdeals, "#firsttimepatientdeals"
	element :handicapaccess, "#handicapaccess"
	element :loungearea, "#loungearea"
	element :petfriendly, "#petfriendly"
	element :securityguard, "#securityguard"
	element :labtested, "#labtested"
	element :eighteenplus, "#eighteenplus"
	element :twentyoneplus, "#twentyoneplus"
	element :hasphotos, "#hasphotos"
	element :onsitetesting, "#onsitetesting"

	element :edit_features_link, "#edit-features-link"

	#features (edit modal)
	element :acceptscreditcards_input, "#store_acceptscreditcards"
	element :atmaccess_input, "#store_atmaccess"
	element :automaticdispensingmachines_input, "#store_automaticdispensingmachines"
	element :deliveryservice_input, "#store_deliveryservice"
	element :handicapaccess_input, "#store_handicapaccess"
	element :loungearea_input, "#store_loungearea"
	element :petfriendly_input, "#store_petfriendly"
	element :securityguard_input, "#store_securityguard"
	element :labtested_input, "#store_labtested"
	element :eighteenplus_input, "#store_eighteenplus"
	element :twentyoneplus_input, "#store_twentyoneplus"
	element :hasphotos_input, "#store_hasphotos"
	element :onsitetesting_input, "#store_onsitetesting"

	element :save_store_features_button, "#save_store_features_button"



end