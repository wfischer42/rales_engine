describe "Merchants API" do
  describe "#index" do
    it "returns all merchants" do
      get '/api/v1/merchants'
      expect(response).to be_successful
    end
  end
end
