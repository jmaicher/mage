class SprintsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :sprint_filter, only: [:show, :edit, :update]

  def show
  end

  def new
    @sprint = Sprint.create
    redirect_to edit_sprint_path(@sprint)
  end

  def edit
    @bootstrapped_data = bootstrapped_data
  end

  def update
    @bootstrapped_data = bootstrapped_data
    if @sprint.update(sprint_params)
      redirect_to edit_sprint_path(@sprint)
    else
      render :edit
    end
  end

private

  def sprint_params
    params.require(:sprint).permit(:in_planning, :goal, :start_date, :end_date)
  end

  def bootstrapped_data
    {
      sprint: SprintRepresenter.new(@sprint)
    }.to_json
  end

end # SprintsController
