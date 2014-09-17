require 'spec_helper'

describe Store do  

  it "must have a name" do
  	@store_name = "My new store"
  	@store_addressline1 = "7110 Rock Valley Court"
  	@store_city = "San Diego"
  	@store_ca = "CA"
  	@store_zip = "92122"
    @store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
  	expect(@store).to be_valid

  	@failedStore = Store.new()
  	expect(@failedStore).to be_invalid
  	expect(@failedStore).to have(1).errors_on(:name)
  end


  it "has an address method which will concatenate other fields" do
  	@store_name = "My new store"
  	@store_addressline1 = "7110 Rock Valley Court"
  	@store_city = "San Diego"
  	@store_ca = "CA"
  	@store_zip = "92122"
  	@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
  	expect(@store).to be_valid

  	expect(@store.address).to eq "#{@store_addressline1}, #{@store_city}, #{@store_ca} #{@store_zip}"
  end


end
