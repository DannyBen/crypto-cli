describe "crypto" do
  def crypto(args = "")
    `ruby ./crypto #{args}`
  end

  context "without arguments" do
    it "shows usage" do
      expect(crypto).to include "Usage"
    end
  end

  context "with just a currency name" do
    it "converts 1 unit to USD" do
      expect(crypto "eth").to match(/1 ETH = \d+ USD/)
    end
  end

  context "with units and currency name" do
    it "converts the requested units to USD" do
      half_eth = crypto("0.5 eth")[/([\d\.]+) USD/, 1].to_f
      full_eth = crypto("1 eth")[/([\d\.]+) USD/, 1].to_f

      expect(crypto "0.5 eth").to match(/0.5 ETH = (\d+\.\d+) USD/)
      expect(half_eth).to be < (full_eth * 0.51)
    end
  end

  context "with source and target currency" do
    it "converts to the target currency" do
      expect(crypto "eth eur").to match(/1 ETH = (\d+) EUR/)
    end
  end

  context "with units, source and target currency" do
    it "converts to the target currency" do
      expect(crypto "0.5 eth eur").to match(/0.5 ETH = (\d+\.\d+) EUR/)
    end
  end

  context "with full sentence" do
    it "converts units from source to target currency" do
      expect(crypto "1 eth to eur").to match(/1.0 ETH = (\d+\.\d+) EUR/)
    end
  end
end