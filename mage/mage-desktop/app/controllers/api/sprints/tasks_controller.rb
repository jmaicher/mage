class API::Sprints::TasksController < API::ApplicationController
  before_filter :authenticate!
  before_filter :sprint_filter
  before_filter :sprint_backlog_item_filter
  before_filter :task_filter, only: [:update]

  def create
    task = Task.new task_params
    task.backlog_item = @backlog_item
    task.sprint_backlog = @sprint.backlog
    
    if task.save
      response = TaskRepresenter.new(task)
      status = 201
    else
      response = task.errors
      status = 422
    end 

    render json: response, status: status
  end

  def update
    @task.update_attributes task_params

    if @task.save
      response = TaskRepresenter.new(@task)
      status = 201
    else
      response = @task.errors
      status = 422
    end 

    render json: response, status: status
  end

private
  
  def sprint_backlog_item_filter
    @backlog_item = BacklogItem.find(params[:item_id])
  end

  def task_filter
    @task = Task.find(params[:id])
  end

  def task_params
    params.permit(:description, :estimate)
  end

end # ::TasksController
