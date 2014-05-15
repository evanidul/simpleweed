class StoreClaimPage < SitePrism::Page
	#set_url "/admin/stores"

	element :name_header, "#name"

	element :claim_store_button, "#claim-store-button"
	element :cancel_claim_button, "#cancel-claim-button"

	# email doesn't match
	element :logout_and_try_again, "#logout-link-on-claim-form"

end