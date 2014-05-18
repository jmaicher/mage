
shared_examples_for "meeting action" do
  it "should respond with bad request if the meeting does not exist" do
    meeting.destroy!
    do_api_request
    expect(response.status).to eq(404)
  end
end # meeting action
