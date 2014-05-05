class AdminStoresPage < SitePrism::Page
  set_url "/admin/stores"
  element :newstore_button, "#new_store"
  
  # new store modal
  element :modal_store_name_input, "#store_name"
  element :modal_save_button, "#save_store"
end