
shared_examples "authenticated API endpoint" do

  describe "when user is not authenticated" do

    it "should respond with 401" do
      do_api_request({}, {})
      expect(response.status).to eq(401)
    end

  end

end # authenticated API action
