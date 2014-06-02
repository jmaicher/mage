class BacklogItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :backlog_item_filter, only: [:edit, :update]

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

      redirect_to :backlog, flash: { success: "&#x2713; Backlog Item successfully created" }
    rescue => e
      render :new
    end
  end

  def edit
  end

  def update
    if @backlog_item.update(backlog_item_params)
      current_user.create_activity! "backlog_item.update", object: @backlog_item 
      redirect_to :backlog, flash: { success: "&#x2713; Backlog Item successfully updated" } 
    else
      render :edit
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
