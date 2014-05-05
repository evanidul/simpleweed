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

end