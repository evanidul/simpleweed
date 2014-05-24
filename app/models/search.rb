class Search 
  include  ActiveModel::Model

  attr_accessor :itemsearch, :itemsearch_location, :groupbystore, :filterpriceby, :pricerangeselect, :minprice, :maxprice,
  # strain & attributes
  :indica, :sativa, :hybrid, :og, :kush, :haze, :indoor, :outdoor, :hydroponic, :greenhouse, :organic, :privatereserve, :topshelf, :glutenfree, :sugarfree,
  # item type
  :bud, :shake, :trim, :wax, :hash, :budder_earwax_honeycomb,:bubblehash_fullmelt_icewax, :ISOhash, :kief_drysieve, :shatter_amberglass, :scissor_fingerhash, :oil_cartridge, :baked, 
  :candy_chocolate, :cooking, :drink, :frozen, :other_edibles, :blunt, :joint, :clones, :seeds, :oral, :topical,
  :bong_pipe, :bong_pipe_accessories, :book_magazine, :butane_lighter, :cleaning, :clothes, :grinder, :other_accessories, :paper_wrap, 
  :storage, :vape, :vape_accessories,
  # distance
  :distance,
  # store features
  :delivery_service , :accepts_atm_credit, :atm_access, :dispensing_machines, :first_time_patient_deals, :handicap_access, :lounge_area,
  :pet_friendly, :security_guard, :eighteenplus, :twentyplus, :has_photos, :lab_tested, :onsite_testing,
  # lab
  :filterthc_range, :thc_min, :thc_max,
  :filtercbd_range, :cbd_min, :cbd_max,
  :filtercbn_range, :cbn_min, :cbn_max

  
  def persisted?
    false
  end

end