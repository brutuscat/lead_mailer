require "spec_helper"

describe HooksController do
  describe "routing" do

    it "routes to #hook" do
      post("hooks").should route_to("hooks#dispatcher")
    end

  end
end
