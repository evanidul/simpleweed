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

  task :importMenuItems => :environment do
    file = File.open("/Users/evanidul/Weed/samplemenuitems.txt")
    file.each do |line|
      attrs = line.split(",")      
      # the file hardcodes primary keys
      # @store = Store.find_by_name(attrs[0].strip)

      @store = Store.find_or_create_by(name: attrs[0].strip)
      
      # @store_item =  @store.store_items.new
      @store_item = @store.store_items.build
	  @store_item.name = attrs[1]
	  #:costhalfgram, :costonegram, :costeighthoz, :costquarteroz,
	  #:costhalfoz, :costoneoz
	  @store_item.category = attrs[2]
	  @store_item.costonegram = attrs[3]
	  @store_item.costhalfgram = attrs[4]	  
	  @store_item.costeighthoz = attrs[5]
	  @store_item.costquarteroz = attrs[6]
	  @store_item.costhalfoz = attrs[7]
	  @store_item.costoneoz = attrs[8]

	  @store_item.save
      
      
    end
  end

end