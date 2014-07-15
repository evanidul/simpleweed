require 'test_helper'
 
class Urlservice < ActiveSupport::TestCase

	test "adds http to link" do
		service = Simpleweed::Url::Urlservice.new
		result = service.url_with_protocol("www.yahoo.com")
		assert_equal( "http://www.yahoo.com", result, "wrong result")		
	end

	test "leaves link alone if it has http already" do
		service = Simpleweed::Url::Urlservice.new
		result = service.url_with_protocol("http://www.yahoo.com")
		assert_equal( "http://www.yahoo.com", result, "wrong result")		
	end

end