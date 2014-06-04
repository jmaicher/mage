class API::BacklogItems::AcceptanceCriteriaController < API::ApplicationController
  before_filter :authenticate!
  before_filter :backlog_item_filter
  before_filter :acceptance_criteria_filter, only: [:update]

  def create
    criteria = @backlog_item.acceptance_criteria.build criteria_params
    upsert(criteria)
  end # update

  def update
    @criteria.update_attributes criteria_params
    upsert(@criteria)
  end # update


private

  def upsert criteria
    if criteria.save
      response = AcceptanceCriteriaRepresenter.new(criteria)
      status = :created
    else
      response = criteria.errors
      status = :unprocessable_entity
    end

    render json: response, status: status

  end # upsert

  def criteria_params
    params.permit(:description)
  end

end # API::BacklogItem::AcceptanceCriteria
