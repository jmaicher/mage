class ProductBacklogController < ApplicationController
  before_filter :authenticate_user!
  before_filter :product_backlog_filter

  def show
    @unprioritized_items, @prioritized_items = @backlog.items.partition { |item| item.priority.nil? }
    @max_priority = @backlog.max_priority 
    @append_priority = @backlog.append_priority
  end

  def insert
    backlog_item_id = params.require(:backlog_item_id)
    priority = Integer(params.require(:priority)) rescue nil

    item = @backlog.items.where(id: backlog_item_id).first
    redirect_to :back if item.nil?

    @backlog.insert_at(item, priority)
    redirect_to :back
  end

private

  def product_backlog_filter
    @backlog = ProductBacklog.get
  end

end
