class Search 
  # http://stackoverflow.com/questions/14389105/rails-model-without-a-table.  Model for storing search attributes, but not saved to 
  # db, therefore doesn't extend active record base.
  # include ActiveModel::Validations
  # include ActiveModel::Conversion
  # extend ActiveModel::Naming
  include  ActiveModel::Model

  # def initialize(attributes = {})
  #   attributes.each do |name, value|
  #     send("#{name}=", value)
  #   end
  # end

  attr_accessor :itemsearch, :itemsearch_location
  
  def persisted?
    false
  end

  

  # def itemsearch
  # end

  # def itemsearch_location
  # end

end