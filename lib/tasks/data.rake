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
    #file = File.open("./lib/tasks/menuitems_daniel.txt")
    file = File.open("./lib/tasks/FULLmenuitems.txt")
    logger = Logger.new('logfile.log')
    logger.info "Start importing items"

    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|      
      attrs = line.split("<")                  
      totalitemsread = totalitemsread + 1
      #WM Store ID[0]<Store Name[1]<WM Item ID[2]<Item Name[3]<Category[4]<1g[5]<1/2g[6]<1/8oz[7]<1/4oz[8]<1/2oz[9]<1oz[10]<each[11]
      #<Weird Import[12]<item id[13]<Parent Category[14]<Sub-Category[15]<Strain Type[16]<Strain/Item Name[17]<Promo Field[18]
      #<Cultivation[19]<Private Reserve[20]<Top Shelf[21]<DOGO[22]<Organic[23]<Specials (Supersize)[24]<Lab Tested[25]<Gluten-Free[26]
      #<Sugar-Free[27]<High CBD[28]<Dose (mg)[29]<OG[30]<Kush[31]<Haze[32]

      @store = Store.find_or_create_by(syncid: attrs[0])      
      @store.name = attrs[1]
      @store.save

      @store_item = StoreItem.where(:syncid => attrs[2], :store_id => @store.id).first_or_create
      #@store_item = StoreItem.find_or_create_by(:syncid => attrs[2], :store_id => @store.id)
      
      # use daniel's scrubbed name
      @store_item.name = attrs[17]  
      # no longer using WM category, but I guess we'll just sync it.
      @store_item.category = attrs[4]           
      @store_item.costonegram = attrs[5]
      @store_item.costhalfgram = attrs[6]         
      @store_item.costeighthoz = attrs[7]
      @store_item.costquarteroz = attrs[8]
      @store_item.costhalfoz = attrs[9]
      @store_item.costoneoz = attrs[10]
      @store_item.costperunit = attrs[11]
      

      @store_item.maincategory = attrs[14].downcase
      @store_item.subcategory = attrs[15].downcase
      @store_item.strain = attrs[16].downcase
      
      @store_item.promo = attrs[18]
      @store_item.cultivation = attrs[19].downcase
      @store_item.privatereserve = attrs[20]
      @store_item.topshelf = attrs[21]
      @store_item.dogo = attrs[22]
      @store_item.organic = attrs[23]
      @store_item.supersize = attrs[24]
      @store_item.glutenfree = attrs[26]
      @store_item.sugarfree = attrs[27]
      @store_item.dose = attrs[29]
      @store_item.og = attrs[30]
      @store_item.kush = attrs[31]
      @store_item.haze = attrs[32]
      
      if @store_item.save
        totalitemssaved = totalitemssaved + 1
      else         
        logger.info "item skipped : syncid : " + @store_item.syncid.to_s
        logger.info @store_item.errors.full_messages
        logger.info "item subcategory and cultivation values"
        logger.info attrs[15].downcase
        logger.info attrs[19].downcase
        totalitemsskipped = totalitemsskipped + 1
      end
    end

    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
    

  end

  # this works with the schema from the crawler, but chon usually scrubs that file and we use the 'modified' address task
  # below to crawl in the file with his changes..
  
  #assumes dispensaries are created already
  #can be run to refresh addresses
  task :importAddresses => :environment do
    #file = File.open("./lib/tasks/addresses.txt")
    file = File.open("./lib/tasks/FULLaddresses.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split("<")            
      totalitemsread = totalitemsread + 1
      #@store = Store.find_or_initialize_by_id(attrs[0])
      #@store = Store.find_or_initialize_by(syncid: attrs[0])      

      syncid = attrs[0].to_i      

      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)

        if (@store)
        	if( attrs.last != "ERROR: check fields")      		
        		@store.addressline1 = attrs[2];
        		@store.addressline2 = attrs[3];
        		@store.city = attrs[4];
        		@store.state = attrs[5];
        		@store.zip = attrs[6];
        		
            if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end
        	end
        else
        	totalitemsskipped = totalitemsskipped + 1
  	  end #if
    else
      totalitemsskipped = totalitemsskipped + 1
    end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
    
  end # task


  ## DVU: this assumes Chon's schema.  I fed the crawler schema into this and it doesn't really work haha.  oops.  use
  ## the above task if you want to import the crawler's schema
  task :importAddressesModified => :environment do
    #file = File.open("./lib/tasks/addresses.txt")
    file = File.open("./lib/tasks/FULLaddressesModified.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    logger = Logger.new('logfile.log')
    logger.info "Start importing modified addresses"

    file.each do |line|
      attrs = line.split("<")            
      totalitemsread = totalitemsread + 1
      #@store = Store.find_or_initialize_by_id(attrs[0])
      #@store = Store.find_or_initialize_by(syncid: attrs[0])      

      syncid = attrs[0].to_i      

      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)

        if (@store)
          if( attrs.last != "ERROR: check fields")          
            @store.addressline1 = attrs[10];
            @store.addressline2 = attrs[11];
            @store.city = attrs[12];
            @store.state = attrs[13];
            @store.zip = attrs[14];
            @store.promo = attrs[9];
            
            if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
              logger.info "item skipped : syncid : " + @store.syncid.to_s
              logger.info @store.errors.full_messages
              # these stores probably had addresses, but no store items, and therefore not created in storeitem import.
            end
          end
        else
          totalitemsskipped = totalitemsskipped + 1
          logger.info 'skipped because couldnt find store with id'
          logger.info syncid
      end #if
    else
      totalitemsskipped = totalitemsskipped + 1
      
    end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
    
  end # task

task :importGeo1 => :environment do
    #file = File.open("./lib/tasks/addresses.txt")
    file = File.open("./lib/tasks/FULLgeo.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    logger = Logger.new('logfile.log')
    logger.info "Start importing geo part1"

    file.each do |line|
      attrs = line.split(",")            
      totalitemsread = totalitemsread + 1
      #@store = Store.find_or_initialize_by_id(attrs[0])
      #@store = Store.find_or_initialize_by(syncid: attrs[0])      

      syncid = attrs[0].to_i      

      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)

        if (@store)
          if( attrs.last != "ERROR: check fields")          

            @store.latitude = attrs[1]
            @store.longitude = attrs[2]

            if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
              logger.info "item skipped : syncid : " + @store.syncid.to_s
              logger.info @store.errors.full_messages
              # these stores probably had addresses, but no store items, and therefore not created in storeitem import.
            end
          end
        else
          totalitemsskipped = totalitemsskipped + 1
          logger.info 'skipped because couldnt find store with id'
          logger.info syncid
      end #if
    else
      totalitemsskipped = totalitemsskipped + 1
      
    end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
    
  end # task

task :importGeo2 => :environment do
    #file = File.open("./lib/tasks/addresses.txt")
    file = File.open("./lib/tasks/FULLgeo2.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    logger = Logger.new('logfile.log')
    logger.info "Start importing geo part2"

    file.each do |line|
      attrs = line.split(",")            
      totalitemsread = totalitemsread + 1
      #@store = Store.find_or_initialize_by_id(attrs[0])
      #@store = Store.find_or_initialize_by(syncid: attrs[0])      

      syncid = attrs[0].to_i      

      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)

        if (@store)
          if( attrs.last != "ERROR: check fields")          
            
            @store.latitude = attrs[1]
            @store.longitude = attrs[2]
            
            if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
              logger.info "item skipped : syncid : " + @store.syncid.to_s
              logger.info @store.errors.full_messages
              # these stores probably had addresses, but no store items, and therefore not created in storeitem import.
            end
          end
        else
          totalitemsskipped = totalitemsskipped + 1
          logger.info 'skipped because couldnt find store with id'
          logger.info syncid
      end #if
    else
      totalitemsskipped = totalitemsskipped + 1
      
    end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
    
  end # task
#assumes dispensaries are created already
  task :importPhonenumbers => :environment do
    #file = File.open("./lib/tasks/phonenumbers.txt")
    file = File.open("./lib/tasks/FULLphonenumbers.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split("<")            
      totalitemsread = totalitemsread + 1

      syncid = attrs[0].to_i      

      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)
        if (@store)
        	if( attrs.last != "ERROR: check fields")      		
        		@store.phonenumber = attrs[2];

        		if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end #if save
        	end	 #if
  	    end #if
      else
        totalitemsskipped = totalitemsskipped + 1
      end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
  end # task

#assumes dispensaries are created already
  task :importWebsites => :environment do
    file = File.open("./lib/tasks/FULLwebsites.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split("<")            
      totalitemsread = totalitemsread + 1

      syncid = attrs[0].to_i
      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)
        if (@store)
        	if( attrs.last != "ERROR: check fields")      		
        		@store.website = attrs[2];

        		if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end #if save
        	end	
  	    end #if
      else
        totalitemsskipped = totalitemsskipped + 1
      end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
  end # task

#assumes dispensaries are created already
  task :importDeliveryareas => :environment do
    file = File.open("./lib/tasks/FULLdeliveryareas.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split("<")            
      totalitemsread = totalitemsread + 1

      syncid = attrs[0].to_i
      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)
        if (@store)
        	if( attrs.last != "ERROR: check fields")      		
        		@store.deliveryarea = attrs[2];

        		if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end #if save
        	end	
    	  end #if
      else
        totalitemsskipped = totalitemsskipped + 1
      end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
  end # task

#assumes dispensaries are created already
  task :importFilepath => :environment do
    file = File.open("./lib/tasks/FULLfilepath.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split("<")            
      totalitemsread = totalitemsread + 1

      syncid = attrs[0].to_i
      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)
        if (@store)
        	if( attrs.last != "ERROR: check fields")      		
        		@store.filepath = attrs[2];

        		if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end #if save
        	end	
  	    end #if
      else
        totalitemsskipped = totalitemsskipped + 1
      end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
  end # task


#assumes dispensaries are created already
#NOTE: look at 'badges.txt' in sync folder.  I called it something stupid :(
  task :importStoreFeatures => :environment do
    file = File.open("./lib/tasks/FULLstorefeatures.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split("<")            
      totalitemsread = totalitemsread + 1

      syncid = attrs[0].to_i
      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)
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

        		if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end #if save
        	end	
  	    end #if
      else
        totalitemsskipped = totalitemsskipped + 1
      end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
  end # task

#assumes dispensaries are created already
  task :importAnnouncements => :environment do
    file = File.open("./lib/tasks/FULLannouncements.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split(":::")            
      totalitemsread = totalitemsread + 1

      syncid = attrs[0].to_i
      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)
        if (@store)
        	if( attrs.last != "ERROR: check fields")      		
        		@store.announcement = attrs[2];

        		if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end #if save
        	end	
  	    end #if
      else
        totalitemsskipped = totalitemsskipped + 1
      end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
  end # task  

#assumes dispensaries are created already
  task :importSocial => :environment do
    file = File.open("./lib/tasks/FULLsocial.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split("<")            
      totalitemsread = totalitemsread + 1

      syncid = attrs[0].to_i
      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)

      
        if (@store)
        	if( attrs.last != "ERROR: check fields")      		
        		@store.facebook = attrs[2];
        		@store.twitter = attrs[3];
        		@store.instagram = attrs[4];      		

        		if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end #if save
        	end	
    	  end #if
      else
        totalitemsskipped = totalitemsskipped + 1
      end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
  end # task

#assumes dispensaries are created already
  task :importFirsttimepatientdeals => :environment do
    file = File.open("./lib/tasks/FULLfirsttimepatientdeals.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split(":::")         #can't use "<" since this contains html
      totalitemsread = totalitemsread + 1

      syncid = attrs[0].to_i
      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)
        if (@store)
        	if( attrs.last != "ERROR: check fields")      		
        		@store.firsttimepatientdeals = attrs[2];

        		if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end #if save
        	end	
  	    end #if
      else
        totalitemsskipped = totalitemsskipped + 1
      end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
  end # task

#assumes dispensaries are created already
  task :importDescriptions => :environment do
    file = File.open("./lib/tasks/FULLdescriptions.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split(":::")         #can't use "<" since this contains html
      totalitemsread = totalitemsread + 1

      syncid = attrs[0].to_i
      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)

        if (@store)
        	if( attrs.last != "ERROR: check fields")      		
        		@store.description = attrs[2];

        		if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end #if save
        	end	
    	  end #if
      else
        totalitemsskipped = totalitemsskipped + 1
      end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
  end # task

#assumes dispensaries are created already
  task :importEmails => :environment do
    file = File.open("./lib/tasks/FULLemails.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split("<")         #can't use "<" since this contains html
      totalitemsread = totalitemsread + 1

      syncid = attrs[0].to_i
      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)
        if (@store)
        	if( attrs.last != "ERROR: check fields")      		
        		@store.email = attrs[2].strip;

        		if @store.save
              totalitemssaved = totalitemssaved + 1
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end #if save
        	end	
  	    end #if
      else
        totalitemsskipped = totalitemsskipped + 1
      end #if

    end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
  end # task

#assumes dispensaries are created already
  task :importStorehours => :environment do
    #file = File.open("./lib/tasks/storehours.txt")
    file = File.open("./lib/tasks/FULLstorehours.txt")
    totalitemsread = 0
    totalitemssaved = 0
    totalitemsskipped = 0
    file.each do |line|
      attrs = line.split("<")     
      totalitemsread = totalitemsread + 1

      tds = Simpleweed::Timedateutil::Timedateservice.new
      syncid = attrs[0].to_i
      if syncid != 0  #if attrs[0] is an error string "Error", don't import
        @store = Store.find_by(syncid: syncid)
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
            puts saturday[0]
            puts 'currentid = ' + @store.syncid.to_s

            # if (@store.syncid.to_s == "25563")
            #   binding.pry
            # end

            saturdayOpen = tds.getMilitaryTimeFromAMPMString(saturday[0].strip)
            if saturdayOpen != "Closed"
              saturdayClosed = tds.getMilitaryTimeFromAMPMString(saturday[1])
              @store.storehourssaturdayopenhour = saturdayOpen[0]
              @store.storehourssaturdayopenminute = saturdayOpen[1]
              @store.storehourssaturdayclosehour = saturdayClosed[0]
              @store.storehourssaturdaycloseminute = saturdayClosed[1]
            else
              @store.saturdayclosed = true;
            end

      		if @store.save
              totalitemssaved = totalitemssaved + 1
              puts 'lastsaved = ' + @store.syncid.to_s
            else         
              totalitemsskipped = totalitemsskipped + 1
              puts @store.errors.full_messages  
            end #if save
      	end	#if attrs.last != "ERROR: check fields"
	    end #if (@store)
    else
        totalitemsskipped = totalitemsskipped + 1
    end #if
  end # file.each do
    puts 'totalread = ' + totalitemsread.to_s
    puts 'totalsaved = ' + totalitemssaved.to_s
    puts 'totalskipped = ' + totalitemsskipped.to_s
  end # task


end