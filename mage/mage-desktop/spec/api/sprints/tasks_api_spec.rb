require 'spec_helper'

describe 'Sprints::Tasks API', integration: true do
  let(:sprint) { create :sprint }
  let(:sprint_backlog_item) { create(:backlog_item, backlog: sprint.backlog) }  
  let(:current_user) { create :user }

  before :each do
    sign_in current_user
  end

  describe 'POST /api/sprints/:id/tasks' do
    let(:method) { :post }
    let(:endpoint) { api_sprint_backlog_item_tasks_path(sprint, sprint_backlog_item) }

    it "creates a new task for the sprint backlog item and responds with the json representation" do
      params = {
        description: "Awesome tasks are awesome",
        estimate: 5
      }
      do_api_request_without_token params

      expect(response.status).to eq(201)
      expect(Task.count).to eq(1)

      task = Task.last 
      expect(task.sprint_backlog).to eq(sprint.backlog)
      expect(task.backlog_item).to eq(sprint_backlog_item)

      expected_body = TaskRepresenter.new(task).to_json
      actual_body = response.body

      expect(actual_body).to be_json_eql(expected_body)
    end
  end
end # Sprints::Tasks API
