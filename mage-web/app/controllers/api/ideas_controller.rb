class API::IdeasController < API::ApplicationController

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
  end

private

  def idea_params
    params.require(:idea).permit(:title, :description)
  end

end
