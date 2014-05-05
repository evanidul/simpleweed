class StorePage < SitePrism::Page
  #set_url "/admin/stores"

  element :name_header, "#name"
  element :description, "#description"
  element :description_edit_link, "#edit-description-link"
  element :store_description_input, "#store_description_input"
  element :save_store_description_button, "#save_store_description_button"

end