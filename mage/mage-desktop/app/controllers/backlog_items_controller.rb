class BacklogItemsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @backlog_item = BacklogItem.new
  end

  def create
    @backlog_item = BacklogItem.new backlog_item_params
    
    # Use service layer?  
    begin
      BacklogItem.transaction do
        @backlog_item.save!
        product_backlog.insert(@backlog_item)
      end

      redirect_to :backlog, flash: { success: "&#x2713; Success :-)" }
    rescue => e
      render :new
    end
  end

private

  def product_backlog
    @backlog ||= ProductBacklog.get
  end

  def backlog_item_params
    params.require(:backlog_item).permit(:title, :description, :tag_list)
  end

end
