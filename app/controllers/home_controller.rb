
class HomeController < ApplicationController
  def initialize
    @cloud = CloudFiles::Connection.new(:username => "admin:admin",
	:api_key => "admin", :auth_url => "http://swift01:8080/auth/v1.0")
    @con = @cloud.container("demo")
    @swift_demo_files = @con.objects
  end
  def index
    @info = @con.object(@swift_demo_files.first).object_metadata
  end

  def file
    path = params[:path]
    obj = @con.object(@con.objects.first)
    send_data(obj.data, :type => "image/jpeg", :disposition => "inline")
  end
end
