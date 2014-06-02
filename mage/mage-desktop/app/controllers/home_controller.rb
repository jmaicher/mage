class HomeController < ApplicationController
 
  def index
    @activity_stream = ActivityStream.get
  end

end
