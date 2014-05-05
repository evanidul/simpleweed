class StorePage < SitePrism::Page
	#set_url "/admin/stores"

	element :name_header, "#name"

	#description
	element :description, "#description"
	element :description_edit_link, "#edit-description-link"
	element :store_description_input, "#store_description_input"
	element :save_store_description_button, "#save_store_description_button"

	#first time patient deals
	element :first_time_patient_deals_text, "#first-time-patient-deals"
	element :edit_first_time_patient_deals_link, "#edit-first-time-patient-deals-link"
	element :first_time_patient_deals_input, "#store_first_time_patient_deals_input"
	element :save_first_time_patient_deals_button, "#save_store_first_time_patient_deals_button"

	#daily specials
	element :dailyspecials_sunday_text, "#dailyspecials_sunday"
	element :dailyspecials_monday_text, "#dailyspecials_monday"
	element :dailyspecials_tuesday_text, "#dailyspecials_tuesday"
	element :dailyspecials_wednesday_text, "#dailyspecials_wednesday"
	element :dailyspecials_thursday_text, "#dailyspecials_thursday"
	element :dailyspecials_friday_text, "#dailyspecials_friday"
	element :dailyspecials_saturday_text, "#dailyspecials_saturday"

	element :dailyspecials_sunday_input, "#store_dailyspecialssunday"
	element :dailyspecials_monday_input, "#store_dailyspecialsmonday"
	element :dailyspecials_tuesday_input, "#store_dailyspecialstuesday"
	element :dailyspecials_wednesday_input, "#store_dailyspecialswednesday"
	element :dailyspecials_thursday_input, "#store_dailyspecialsthursday"
	element :dailyspecials_friday_input, "#store_dailyspecialsfriday"
	element :dailyspecials_saturday_input, "#store_dailyspecialssaturday"

	element :edit_daily_specials_link, "#edit-daily-specials-link"
	element :save_store_daily_specials_button ,"#save_store_daily_specials_button"

end