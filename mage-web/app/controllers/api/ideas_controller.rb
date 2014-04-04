class API::IdeasController < API::ApplicationController

  def index
    ideas = Idea.all.map { |idea| IdeaRepresenter.new(idea) }
    coll = API::Collection.new(ideas, self: api_ideas_url)
    
    render json: ::CollectionRepresenter.new(coll)
  end # index

  def create
    idea = Idea.new(idea_params)

    if idea.save
      response = ::IdeaRepresenter.new(idea)
      status = :created
    else
      response = idea.errors
      status = :unprocessable_entity
    end

    render json: response, status: status
  end # create

private

  def idea_params
    params.require(:idea).permit(:title, :description)
  end

end
