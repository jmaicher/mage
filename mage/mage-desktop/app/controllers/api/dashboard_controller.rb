class API::DashboardController < API::ApplicationController
  before_filter :authenticate!
  before_filter :current_sprint_filter

  def dashboard
    burndown_chart = Charts::Burndown.new(@sprint)
    progress_donut_chart = Charts::ProgressDonut.new(@sprint)

    dashboard = {
      sprint: SprintRepresenter.new(@sprint),
      burndown: Charts::BurndownRepresenter.new(burndown_chart),
      progressDonut: Charts::ProgressDonutRepresenter.new(progress_donut_chart)
    }

    render json: dashboard
  end

private

  # TODO
  def current_sprint_filter
    @sprint = Sprint.last
  end

end # API::DashboardController
