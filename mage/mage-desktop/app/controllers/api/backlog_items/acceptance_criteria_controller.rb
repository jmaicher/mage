class API::BacklogItems::AcceptanceCriteriaController < API::ApplicationController
  before_filter :authenticate!
  before_filter :backlog_item_filter
  before_filter :authorize_user!
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
    is_new = criteria.new_record?

    if criteria.save
      response = AcceptanceCriteriaRepresenter.new(criteria)

      if is_new
        status = :created
        current_user.create_activity! "acceptance_criteria.create", object: criteria
      else
        status = :ok
      end
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
