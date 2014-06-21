class API::DashboardController < API::ApplicationController
  before_filter :authenticate!
  before_filter :current_sprint_filter

  def dashboard
    chart = Charts::Burndown.new(@sprint)

    dashboard = {
      sprint: SprintRepresenter.new(@sprint),
      burndown: Charts::BurndownRepresenter.new(chart)
    }

    render json: dashboard
  end

private

  # TODO
  def current_sprint_filter
    @sprint = Sprint.last
  end

end # API::DashboardController
