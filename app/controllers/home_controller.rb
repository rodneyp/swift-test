
class HomeController < ApplicationController
  def index
    @swift_demo_files = "some text"
    @cloud = CloudFiles::Connection.new(:username => "admin:admin",
	:api_key => "admin", :auth_url => "http://swift01:8080/auth/v1.0")
    @con = @cloud.container("demo")
    @swift_demo_files = @con.objects
  end
end
