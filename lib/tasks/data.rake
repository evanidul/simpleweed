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
	  @store_item.costperunit = attrs[10]
    @store_item.description = attrs[11]

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
  task :importWebsites => :environment do
    file = File.open("./lib/tasks/websites.txt")
    file.each do |line|
      attrs = line.split("<")            

      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.website = attrs[2];

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task

#assumes dispensaries are created already
  task :importDeliveryareas => :environment do
    file = File.open("./lib/tasks/deliveryareas.txt")
    file.each do |line|
      attrs = line.split("<")            

      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.deliveryarea = attrs[2];

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task

#assumes dispensaries are created already
  task :importFilepath => :environment do
    file = File.open("./lib/tasks/filepath.txt")
    file.each do |line|
      attrs = line.split("<")            

      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.filepath = attrs[2];

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task


#assumes dispensaries are created already
  task :importStoreFeatures => :environment do
    file = File.open("./lib/tasks/storefeatures.txt")
    file.each do |line|
      attrs = line.split("<")            

      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.handicapaccess = attrs[2];
      		@store.securityguard = attrs[3];
      		@store.acceptscreditcards = attrs[4];
      		@store.deliveryservice = attrs[5];

      		@store.labtested = attrs[6];
      		@store.eighteenplus = attrs[7];
      		@store.twentyoneplus = attrs[8];
      		@store.hasphotos = attrs[9];

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task

#assumes dispensaries are created already
  task :importAnnouncements => :environment do
    file = File.open("./lib/tasks/announcements.txt")
    file.each do |line|
      attrs = line.split(":::")            

      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.announcement = attrs[2];

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task  

#assumes dispensaries are created already
  task :importSocial => :environment do
    file = File.open("./lib/tasks/social.txt")
    file.each do |line|
      attrs = line.split("<")            

      @store = Store.find_or_initialize_by_id(attrs[0])
      if (@store)
      	if( attrs.last != "ERROR: check fields")      		
      		@store.facebook = attrs[2];
      		@store.twitter = attrs[3];
      		@store.instagram = attrs[4];      		

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
      		sunday =  attrs[2].split("-")
          sundayOpen = tds.getMilitaryTimeFromAMPMString(sunday[0])
          if sundayOpen != "Closed"
            sundayClosed = tds.getMilitaryTimeFromAMPMString(sunday[1])
            @store.storehourssundayopenhour = sundayOpen[0]
            @store.storehourssundayopenminute = sundayOpen[1]
            @store.storehourssundayclosehour = sundayClosed[0]
            @store.storehourssundaycloseminute = sundayClosed[1]
          else
            @store.sundayclosed = true;
          end
      		
    			monday =  attrs[3].split("-")
          mondayOpen = tds.getMilitaryTimeFromAMPMString(monday[0])
          if mondayOpen != "Closed"
            mondayClosed = tds.getMilitaryTimeFromAMPMString(monday[1])
            @store.storehoursmondayopenhour = mondayOpen[0]
            @store.storehoursmondayopenminute = mondayOpen[1]
            @store.storehoursmondayclosehour = mondayClosed[0]
            @store.storehoursmondaycloseminute = mondayClosed[1]
          else
            @store.mondayclosed = true;
          end

    			tuesday =  attrs[4].split("-")
          tuesdayOpen = tds.getMilitaryTimeFromAMPMString(tuesday[0])
          if tuesdayOpen != "Closed"
            tuesdayClosed = tds.getMilitaryTimeFromAMPMString(tuesday[1])
            @store.storehourstuesdayopenhour = tuesdayOpen[0]
            @store.storehourstuesdayopenminute = tuesdayOpen[1]
            @store.storehourstuesdayclosehour = tuesdayClosed[0]
            @store.storehourstuesdaycloseminute = tuesdayClosed[1]
          else
            @store.tuesdayclosed = true;
          end

    			wednesday =  attrs[5].split("-")
          wednesdayOpen = tds.getMilitaryTimeFromAMPMString(wednesday[0])
          if wednesdayOpen != "Closed"
            wednesdayClosed = tds.getMilitaryTimeFromAMPMString(wednesday[1])
            @store.storehourswednesdayopenhour = wednesdayOpen[0]
            @store.storehourswednesdayopenminute = wednesdayOpen[1]
            @store.storehourswednesdayclosehour = wednesdayClosed[0]
            @store.storehourswednesdaycloseminute = wednesdayClosed[1]
          else
            @store.wednesdayclosed = true;
          end

    			thursday =  attrs[6].split("-")
          thursdayOpen = tds.getMilitaryTimeFromAMPMString(thursday[0])
          if thursdayOpen != "Closed"
            thursdayClosed = tds.getMilitaryTimeFromAMPMString(thursday[1])
            @store.storehoursthursdayopenhour = thursdayOpen[0]
            @store.storehoursthursdayopenminute = thursdayOpen[1]
            @store.storehoursthursdayclosehour = thursdayClosed[0]
            @store.storehoursthursdaycloseminute = thursdayClosed[1]
          else
            @store.thursdayclosed = true;
          end

    			friday =  attrs[7].split("-")
          fridayOpen = tds.getMilitaryTimeFromAMPMString(friday[0])
          if fridayOpen != "Closed"
            fridayClosed = tds.getMilitaryTimeFromAMPMString(friday[1])
            @store.storehoursfridayopenhour = fridayOpen[0]
            @store.storehoursfridayopenminute = fridayOpen[1]
            @store.storehoursfridayclosehour = fridayClosed[0]
            @store.storehoursfridaycloseminute = fridayClosed[1]
          else
            @store.fridayclosed = true;
          end

    			saturday =  attrs[8].split("-")
          saturdayOpen = tds.getMilitaryTimeFromAMPMString(saturday[0])
          if saturdayOpen != "Closed"
            saturdayClosed = tds.getMilitaryTimeFromAMPMString(saturday[1])
            @store.storehourssaturdayopenhour = saturdayOpen[0]
            @store.storehourssaturdayopenminute = saturdayOpen[1]
            @store.storehourssaturdayclosehour = saturdayClosed[0]
            @store.storehourssaturdaycloseminute = saturdayClosed[1]
          else
            @store.saturdayclosed = true;
          end

      		@store.save
      	end	
	  end #if

    end # file.each do
  end # task


end