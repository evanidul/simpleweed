module BootstrapModal
	def modal_wrapper_id
	  '#modal'
	end
	 
	def assert_modal_visible
	  page.find(modal_wrapper_id).visible? 
	end
	 
	def assert_modal_hidden
	   !page.find(modal_wrapper_id).visible? 
	end
end