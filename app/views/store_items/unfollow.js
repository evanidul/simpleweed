(function(store_item_name){
	bootstrap_alert.warning(store_item_name + " has been unfollowed", null, "success");	
})("<%= @store_item.name %>")
