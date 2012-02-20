
class HomeController < ApplicationController
  def initialize
    url = "http://swift01:8080/auth/v1.0"
    url = "https://10.42.0.47:8080/auth/v1.0"
    @cloud = CloudFiles::Connection.new(:username => "admin:admin",
	:api_key => "admin", :auth_url => url)
    @con = @cloud.container("demo")
    @swift_demo_files = @con.objects
    @thumb = @cloud.container("thumb")
    @thumb_objects = @thumb.objects
  end

  def index 
    @info = @con.object(@swift_demo_files[params[:n].to_i]).object_metadata unless params[:n].nil? 
    render :layout => "home"
  end

  def thumb
    path = params[:path]
    unless params[:format].nil?
      path = path + "." + params[:format]
    end
    path = CGI::unescape(path)
    unless @thumb_objects.member? path
      im = @con.object(path)
      mm = MiniMagick::Image.from_blob(im.data)
      mm.resize("120x120")
      obj = @thumb.create_object(path)
      obj.write mm.to_blob
    end 
    th = @thumb.object(path)
    send_data(th.data, :type => "image/jpeg", :disposition => "inline")
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
      render :inline => "error: must have url source" + "  " + h(params[:source])
      return
    end
    open(params[:source],"r") do |fh|
      data = fh.read
    end
    obj = @con.create_object(params[:source])
    obj.write data
    # redirect to index page after upload
    
    n = @con.objects.find_index(params[:source])
    redirect_to "/index/#{n}"
  end
end
