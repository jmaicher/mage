require 'spec_helper'

describe Charts::Burndown do
  it "only includes completed days" do
    start_date = Time.now - 1.day
    end_date = start_date + 3.days
    sprint = create :sprint, start_date: start_date, end_date: end_date 

    tasks = [
      create(:task, estimate: 5, completed_at: start_date, sprint_backlog: sprint.backlog),
      create(:task, estimate: 3, completed_at: start_date + 1.days, sprint_backlog: sprint.backlog),
      create(:task, estimate: 7, sprint_backlog: sprint.backlog)
    ]

    chart = Charts::Burndown.new(sprint)

    expect(chart.number_of_days).to eq(4)
    expect(chart.amount_complete).to eq(15)

    expect(chart.days[0].amount).to eq(15)
    expect(chart.days[1].amount).to eq(10)
    expect(chart.days[2]).to be_nil 
  end

  it "computes the correct data when all days are completed" do
    start_date = Time.now - 4.days
    end_date = start_date + 3.days
    sprint = create :sprint, start_date: start_date, end_date: end_date 

    tasks = [
      create(:task, estimate: 5, completed_at: start_date, sprint_backlog: sprint.backlog),
      create(:task, estimate: 3, completed_at: start_date + 1.days, sprint_backlog: sprint.backlog),
      create(:task, estimate: 7, completed_at: start_date + 3.days, sprint_backlog: sprint.backlog)
    ]

    chart = Charts::Burndown.new(sprint)

    expect(chart.number_of_days).to eq(4)
    expect(chart.amount_complete).to eq(15)

    expect(chart.days[0].amount).to eq(15)
    expect(chart.days[1].amount).to eq(10)
    expect(chart.days[2].amount).to eq(7)
    expect(chart.days[3].amount).to eq(7)
    expect(chart.days[4].amount).to eq(0)
  end  

end # Charts::Burndown
