
(function(response) {	
	$("#" + "unfollow-item-form-" + response.item_id ).replaceWith("<%= escape_javascript(render(:partial => 'follow_item_button', :locals => {item:  @store_item } )) %>")		
})(
	{
		message:'ok',	
		item_id: "<%= @store_item.id %>",		
	}
)