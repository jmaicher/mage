class DashboardController < ApplicationController
 
  def show
    @activity_stream = ActivityStream.get
  end

end # DashboardController
