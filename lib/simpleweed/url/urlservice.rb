module Simpleweed
	module Url
		class Urlservice
			
			def url_with_protocol(url)
			    /^http/.match(url) ? url : "http://#{url}"
		    end


		end #class
	end
end