class API::BacklogItems::TaggingsController < API::ApplicationController
  before_action :get_and_set_backlog_item
  before_action :get_and_set_tagging, only: [:show, :destroy]

  def index
    taggings = @backlog_item.taggings
    decorator = CollectionRepresenter.new(API::Collection.new(taggings))
    respond_with decorator
  end

  def show
    decorator = BacklogItemTaggingRepresenter.new(@tagging)
    respond_with decorator
  end

  def create
    tag_name = params[:tag][:name].strip
    tag = Tag.where(name: tag_name).first_or_create!

    unless tagging = @backlog_item.taggings.where(tag_id: tag.id).first
      tagging = @backlog_item.taggings.create tag: tag
      status = 201 # created
    else
      status = 409 # conflict
    end

    decorator = BacklogItemTaggingRepresenter.new(tagging)
    respond_with decorator, {
      status: status,
      location: api_backlog_item_tagging_url(@backlog_item, 3)
    }
  end

  def destroy
    if @tagging.destroy
      head 200
    else
      head 417
    end
  end

private

  def get_and_set_backlog_item
    @backlog_item = BacklogItem.find(params[:backlog_item_id])
  end

  def get_and_set_tagging
    @tagging = @backlog_item.taggings.find(params[:id])
  end

end
