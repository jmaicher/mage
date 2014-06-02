class HomeController < ApplicationController
 
  def index
    @activities = Activity.all
  end

end
