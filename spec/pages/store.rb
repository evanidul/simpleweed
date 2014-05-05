class StorePage < SitePrism::Page
  #set_url "/admin/stores"

  element :name_header, "#name"
  element :description, "#description"

end