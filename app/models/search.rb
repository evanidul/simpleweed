class Search 
  include  ActiveModel::Model

  attr_accessor :itemsearch, :itemsearch_location, :groupbystore, :filterpriceby
  
  def persisted?
    false
  end

end