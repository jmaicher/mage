class ProductBacklogController < ApplicationController
  before_filter :authenticate_user!

  def show
    @items = product_backlog.items.includes(:tags, :acceptance_criteria)
    @unprioritized_items, @prioritized_items = @items.partition { |item| item.priority.nil? }
    @max_priority = product_backlog.max_priority 
    @append_priority = product_backlog.append_priority

    @bootstrapped_data = bootstrapped_data
  end

  def insert
    backlog_item_id = params.require(:backlog_item_id)
    priority = Integer(params.require(:priority)) rescue nil

    item = product_backlog.items.where(id: backlog_item_id).first
    redirect_to :back if item.nil?

    product_backlog.insert_at(item, priority)
    redirect_to :back
  end

  def bootstrapped_data
    @bootstrapped_data = {
      product_backlog: ProductBacklogRepresenter.new(product_backlog) 
    }.to_json
  end

end
