require 'spec_helper'

describe AddressesController do

  describe "GET 'subregion_options'" do
    it "returns http success" do
      get 'subregion_options'
      response.should be_success
    end
  end

end
