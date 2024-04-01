require "spec_helper"
require "link"

RSpec.describe Link do
  let(:link) { described_class.new(url: "https://example.com?utm_source=foo", timestamp: Time.now) }
  describe "#clean_url" do
    it "removes query params from the URL" do
      expect(link.clean_url).to eq("https://example.com")
    end
  end

  describe "#url" do
    it "is required" do
      expect { described_class.new(timestamp: Time.now) }.to raise_error(ArgumentError)
    end

    it "calls #clean_url on the URL" do
      expect(link.url).to eq("https://example.com")
    end
  end
end
