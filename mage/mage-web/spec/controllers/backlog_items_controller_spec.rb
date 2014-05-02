require 'spec_helper'

describe BacklogItemsController do

  before :each do
    sign_in create(:user)
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
  end

end
