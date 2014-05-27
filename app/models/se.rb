# dvu: why is this class called 'S' instead of something like "Search"?  It's because Rails will serialize the word search into
# every parameter sent by the search form, resulting in a large URL that google API will reject for maps.  So we compress it by 
# calling it S.
class Se
  include  ActiveModel::Model

  # dvu: this sucks, we have to map these strings to something smaller, otherwise our URLs are too big.
    
  attr_accessor :itemsearch, 
  :isl, #:itemsearch_location, 
  :gbs, #:groupbystore, 

  :fpb,  #:filterpriceby, 
  :prs, #:pricerangeselect, 
  :mp, #:minprice, 
  :xp, #:maxprice,
  
  # strain & attributes
  :o, #:indica
  :p, #:sativa
  :q, #:hybrid
  :r, #:og
  :s, #:kush
  :t, #:haze
  :u, #:indoor
  :v, #:outdoor
  :w, #:hydroponic
  :x, #:greenhouse
  :y, #:organic, 
  :z, #:privatereserve
  :aa, #:topshelf, 
  :bb, #:glutenfree, 
  :cc, #:sugarfree,
  
  # item type

  :i1, #:bud 
  :i2, #:shake 
  :i3, #:trim
  :i4, #:wax 
  :i5, #:hash
  :i6, #:budder_earwax_honeycomb
  :i7, #:bubblehash_fullmelt_icewax, 
  :i8, #:ISOhash
  :i9, #:kief_drysieve, 
  :i10, #:shatter_amberglass, 
  :i11, #:scissor_fingerhash, 
  :i12, #:oil_cartridge, 
  :i13, #:baked, 
  :i14, #:candy_chocolate
  :i15, #:cooking
  :i16, #:drink
  :i17, #:frozen
  :i18, #:other_edibles, 
  :i19, #:blunt, 
  :i20, #:joint
  :i21, #:clones
  :i22, #:seeds
  :i23, #:oral
  :i24,  #:topical,
  :i25, #:bong_pipe
  :i26, #:bong_pipe_accessories
  :i27, #:book_magazine
  :i28, #:butane_lighter
  :i29, #:cleaning
  :i30, #:clothes
  :i31, #:grinder
  :i32, #:other_accessories
  :i33, #:paper_wrap 
  :i34, #:storage
  :i35, #:vape
  :i36, #:vape_accessories,

  # distance
  :distance,

  # store features
  :a, #:delivery_service , 
  :b, #:accepts_atm_credit,
  :c, # :atm_access, 
  :d, #:dispensing_machines, 
  :e, #:first_time_patient_deals, 
  :f, #:handicap_access, 
  :g, #:lounge_area,
  :h, #:pet_friendly, 
  :i, #:security_guard, 
  :j, #:eighteenplus, 
  :k, #:twentyplus, 
  :l, #:has_photos, 
  :m, #:lab_tested, 
  :n, #:onsite_testing,

  # lab
  :filterthc_range, :thc_min, :thc_max,
  :filtercbd_range, :cbd_min, :cbd_max,
  :filtercbn_range, :cbn_min, :cbn_max

  
  def persisted?
    false
  end

end