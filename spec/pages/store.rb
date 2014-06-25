class StorePage < SitePrism::Page
	#set_url "/admin/stores"

	element :name_header, "#name"

	# buttons
	element :follow_store_button, '#follow-store-button'
	element :claim_store_button, "#claim-store-button"
	element :write_review_button, '#write-review-button'
	element :write_review_button_blocked, '#write-review-button-blocked'
	element :write_review_button_blocked_tooltip, '#write-review-blocked-tip'
	element :first_write_review_tooltip, '#write-review-first-tip'
	element :flash_notice, '#flash_notice'

	# review modal (write new review)
	element :review_text, '#store_review_review'  #review input
	element :save_review_button, '#save_store_item'
	element :cancel_write_review_button, '#close-button'
	element :onestar_button, '#rank_store_stars_1'
	element :twostar_button, '#rank_store_stars_2'
	element :threestar_button, '#rank_store_stars_3'
	element :fourstar_button, '#rank_store_stars_4'
	element :fivestar_button, '#rank_store_stars_5'

	# main tabs
	element :tabs_reviews, '#tabs-reviews'

	# reviews (on review tab)
	elements :review_content, '.review-content'
	elements :star_ranking, '.store-star-rank'
	elements :review_vote_sum, '.review-votes'
	elements :upvotebutton, '.upvotebutton'
	elements :downvotebutton, '.downvotebutton'
	elements :new_comment_inputs, '.new-comment-input'
	elements :save_new_comment_button, '.save-new-store-review-comment'
	elements :store_review_comments, '.store-review-comment'
	elements :log_in_to_comment_links, '.log-in-to-comment'
	# store owner comments
	elements :owner_badges, '.owner-badge'
	elements :owner_comments, '.owner-store-review-comment'

	# menu (main page)
	element :edit_store_items, "#edit_store_items"

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

	#announcement (main page)
	element :announcement, "#announcement"
	element :edit_announcement_link, "#edit-announcement-link"

	#announcement (edit modal)
	element :announcement_input, "#store_announcement_input"
	element :save_announcement_button, "#save_store_announcement_button"

	#delivery area (main page)
	element :deliveryarea, "#delivery-area"
	element :edit_deliveryarea_link, "#edit-deliveryarea-link"

	#delivery area (edit modal)
	element :deliveryarea_input, "#store_deliveryarea_input"
	element :save_store_deliveryarea_button, "#save_store_deliveryarea_button"

	#store hours (main page)
	element :sunday_hours, "#sunday-hours"
	element :monday_hours, "#monday-hours"
	element :tuesday_hours, "#tuesday-hours"
	element :wednesday_hours, "#wednesday-hours"
	element :thursday_hours, "#thursday-hours"
	element :friday_hours, "#friday-hours"
	element :saturday_hours, "#saturday-hours"

	element :edit_hours_link, "#edit-hours-link"

	#store hours (edit modal)
	# hours take 00-23
	# minutes take 00,15,30,45
	element :date_storehourssundayopenhour, "#date_storehourssundayopenhour"
	element :date_storehourssundayopenminute, "#date_storehourssundayopenminute"
	element :date_storehourssundayclosehour, "#date_storehourssundayclosehour"
	element :date_storehourssundaycloseminute, "#date_storehourssundaycloseminute"
	element :store_sundayclosed, "#store_sundayclosed"

	element :date_storehoursmondayopenhour, "#date_storehoursmondayopenhour"
	element :date_storehoursmondayopenminute, "#date_storehoursmondayopenminute"
	element :date_storehoursmondayclosehour, "#date_storehoursmondayclosehour"
	element :date_storehoursmondaycloseminute, "#date_storehoursmondaycloseminute"
	element :store_mondayclosed, "#store_mondayclosed"

	element :date_storehourstuesdayopenhour, "#date_storehourstuesdayopenhour"
	element :date_storehourstuesdayopenminute, "#date_storehourstuesdayopenminute"
	element :date_storehourstuesdayclosehour, "#date_storehourstuesdayclosehour"
	element :date_storehourstuesdaycloseminute, "#date_storehourstuesdaycloseminute"
	element :store_tuesdayclosed, "#store_tuesdayclosed"
	element :save_store_hours_button, "#save_store_hours_button"

	element :date_storehourswednesdayopenhour, "#date_storehourswednesdayopenhour"
	element :date_storehourswednesdayopenminute, "#date_storehourswednesdayopenminute"
	element :date_storehourswednesdayclosehour, "#date_storehourswednesdayclosehour"
	element :date_storehourswednesdaycloseminute, "#date_storehourswednesdaycloseminute"
	element :store_wednesdayclosed, "#store_wednesdayclosed"

	element :date_storehoursthursdayopenhour, "#date_storehoursthursdayopenhour"
	element :date_storehoursthursdayopenminute, "#date_storehoursthursdayopenminute"
	element :date_storehoursthursdayclosehour, "#date_storehoursthursdayclosehour"
	element :date_storehoursthursdaycloseminute, "#date_storehoursthursdaycloseminute"
	element :store_thursdayclosed, "#store_thursdayclosed"

	element :date_storehoursfridayopenhour, "#date_storehoursfridayopenhour"
	element :date_storehoursfridayopenminute, "#date_storehoursfridayopenminute"
	element :date_storehoursfridayclosehour, "#date_storehoursfridayclosehour"
	element :date_storehoursfridaycloseminute, "#date_storehoursfridaycloseminute"
	element :store_fridayclosed, "#store_fridayclosed"

	element :date_storehourssaturdayopenhour, "#date_storehourssaturdayopenhour"
	element :date_storehourssaturdayopenminute, "#date_storehourssaturdayopenminute"
	element :date_storehourssaturdayclosehour, "#date_storehourssaturdayclosehour"
	element :date_storehourssaturdaycloseminute, "#date_storehourssaturdaycloseminute"
	element :store_saturdayclosed, "#store_saturdayclosed"

	# tooltip
	element :edit_links_tip, "#edit-links-tip"
end