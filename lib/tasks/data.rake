# http://stackoverflow.com/questions/3346108/how-to-write-rake-task-to-import-data-to-rails-app

namespace :data do
  desc "import dispensaries from files to database"  
  #dvu: don't need this.  Use importMenuItems to create stores instead
  task :import => :environment do
    file = File.open("/Users/evanidul/Weed/samplestores.txt")
    file.each do |line|
      attrs = line.split(":")      
      # the file hardcodes primary keys
      # p = Store.find_or_initialize_by_id(attrs[0])      
      storeName = attrs[1].strip
      p = Store.find_or_initialize_by_name(storeName)      
      p.name = storeName
      
      p.save!
    end
  end

  # this task will create dispensaries if they don't exist.  Run this first
  task :importMenuItems => :environment do
    file = File.open("./lib/tasks/samplemenuitems.txt")
    file.each do |line|
      attrs = line.split("<")            

      #@store = Store.find_or_create_by(name: attrs[0].strip)
      @store = Store.find_or_create_by(id: attrs[0])
      @store.name = attrs[1];
      @store.save

      @store_item = @store.store_items.build
	  @store_item.name = attrs[2]
	  @store_item.category = attrs[3]
	  @store_item.costonegram = attrs[4]
	  @store_item.costhalfgram = attrs[5]	  
	  @store_item.costeighthoz = attrs[6]
	  @store_item.costquarteroz = attrs[7]
	  @store_item.costhalfoz = attrs[8]
	  @store_item.costoneoz = attrs[9]

	  @store_item.save
    end
  end

  #assumes dispensaries are created already
  task :importAddresses => :environment do
    file = File.open("./lib/tasks/addresses.txt")
    file.each do |line|
      attrs = line.split("<")            

      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.addressline1 = attrs[2];
      		@store.addressline2 = attrs[3];
      		@store.city = attrs[4];
      		@store.state = attrs[5];
      		@store.zip = attrs[6];

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task

#assumes dispensaries are created already
  task :importPhonenumbers => :environment do
    file = File.open("./lib/tasks/phonenumbers.txt")
    file.each do |line|
      attrs = line.split("<")            

      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.phonenumber = attrs[2];

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task



end