require 'spec_helper'

describe Activity do
  it { should belong_to(:actor) }
  it { should belong_to(:object)
        .with_foreign_key("activity_object_id") }
  it { should belong_to(:context) }

  it { should validate_presence_of(:actor) }
  it { should validate_presence_of(:key) }

  it "should allow random parameters" do
    activity = build :activity
    activity.params = { foo: "bar" }
    activity.save!

    expect(Activity.first.params[:foo]).to eq("bar")
  end
end # Activity
