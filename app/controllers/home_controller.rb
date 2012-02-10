
class HomeController < ApplicationController
  def initialize
    @cloud = CloudFiles::Connection.new(:username => "admin:admin",
	:api_key => "admin", :auth_url => "http://swift01:8080/auth/v1.0")
    @con = @cloud.container("demo")
    @swift_demo_files = @con.objects
  end
  def index 
    @info = @con.object(@swift_demo_files[params[:n].to_i]).object_metadata unless params[:n].nil? 
  end

  def file
    path = params[:path]
    unless params[:format].nil?
      path = path + "." + params[:format]
    end
    path = CGI::unescape(path)
    obj = @con.object(path)
    send_data(obj.data, :type => "image/jpeg", :disposition => "inline")
  end

  def upload
  end

  def upload_post
    require 'open-uri'
    data = nil
    unless /^http:/.match(params[:source])
      render :inline => "error: must have url source" + "  " + params[:source]
      return
    end
    open(params[:source],"r") do |fh|
      data = fh.read
    end
    obj = @con.create_object(params[:source])
    obj.write data
    # redirect to index page after upload
  end
end