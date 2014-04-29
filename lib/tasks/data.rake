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
  #can be run to refresh addresses
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

#assumes dispensaries are created already
  task :importFirsttimepatientdeals => :environment do
    file = File.open("./lib/tasks/firsttimepatientdeals.txt")
    file.each do |line|
      attrs = line.split(":::")         #can't use "<" since this contains html

      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.firsttimepatientdeals = attrs[2];

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task

#assumes dispensaries are created already
  task :importDescriptions => :environment do
    file = File.open("./lib/tasks/descriptions.txt")
    file.each do |line|
      attrs = line.split(":::")         #can't use "<" since this contains html

      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.description = attrs[2];

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task

#assumes dispensaries are created already
  task :importEmails => :environment do
    file = File.open("./lib/tasks/emails.txt")
    file.each do |line|
      attrs = line.split("<")         #can't use "<" since this contains html

      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.email = attrs[2];

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task

#assumes dispensaries are created already
  task :importStorehours => :environment do
    file = File.open("./lib/tasks/storehours.txt")
    file.each do |line|
      attrs = line.split("<")            
      tds = Simpleweed::Timedateutil::Timedateservice.new
      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.storehourssunday = attrs[2]; # attrs[2].split("-") : results[0], 10AM results[1], 12AM (close)      		
      		sunday =  attrs[2].split("-")
      		@store.storehourssundayopen = tds.getSecondsSinceMidnight(sunday[0])
      		@store.storehourssundayclosed = tds.getSecondsSinceMidnight(sunday[1])

      		@store.storehoursmonday = attrs[3];
			monday =  attrs[3].split("-")
			@store.storehoursmondayopen = tds.getSecondsSinceMidnight(monday[0])
			@store.storehoursmondayclosed = tds.getSecondsSinceMidnight(monday[1])

      		@store.storehourstuesday = attrs[4];
			tuesday =  attrs[4].split("-")
			@store.storehourstuesdayopen = tds.getSecondsSinceMidnight(tuesday[0])
			@store.storehourstuesdayclosed = tds.getSecondsSinceMidnight(tuesday[1])

      		@store.storehourswednesday = attrs[5];
			wednesday =  attrs[5].split("-")
			@store.storehourswednesdayopen = tds.getSecondsSinceMidnight(wednesday[0])
			@store.storehourswednesdayclosed = tds.getSecondsSinceMidnight(wednesday[1])

      		@store.storehoursthursday = attrs[6];
			thursday =  attrs[6].split("-")
			@store.storehoursthursdayopen = tds.getSecondsSinceMidnight(thursday[0])
			@store.storehoursthursdayclosed = tds.getSecondsSinceMidnight(thursday[1])     		

      		@store.storehoursfriday = attrs[7];
			friday =  attrs[7].split("-")
			@store.storehoursfridayopen = tds.getSecondsSinceMidnight(friday[0])
			@store.storehoursfridayclosed = tds.getSecondsSinceMidnight(friday[1])     		

      		@store.storehourssaturday = attrs[8];
			saturday =  attrs[8].split("-")
			@store.storehourssaturdayopen = tds.getSecondsSinceMidnight(saturday[0])
			@store.storehourssaturdayclosed = tds.getSecondsSinceMidnight(saturday[1])     		

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task


end