(function(store_item_name, id){
	bootstrap_alert.warning(store_item_name + " has been unfollowed", null, "success");	
	$("#" + id).remove();
})("<%= @store_item.name %>", <%= @store_item.id %>)
