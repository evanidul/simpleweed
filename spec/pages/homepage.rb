class HomePageComponent < SitePrism::Page
  # set_url "http://www.google.com"
  element :searchcontainer, "#home-page-search-container"

  element :search_input, "#search"  
  element :search_button, "#submit-search"

  element :flash_warning, "#flash_warning"

end