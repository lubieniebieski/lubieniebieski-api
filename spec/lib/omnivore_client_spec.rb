require "omnivore_client"

RSpec.describe OmnivoreClient::Item do
  let(:data) { {"url" => "https://example.com"} }
  let(:item) { described_class.new(data) }

  describe "#url" do
    it "returns the URL" do
      expect(item.url).to eq("https://example.com")
    end
  end

  describe "#public?" do
    it "returns true for items including the 'public' tag" do
      data["labels"] = [{"name" => "public"}]
      expect(item.public?).to be true
    end

    it "returns true for items including the 'bullets' tag" do
      data["labels"] = [{"name" => "bullets"}]
      expect(item.public?).to be true
    end

    it "returns false for non-public items" do
      data["labels"] = [{"name" => "non-public"}]
      expect(item.public?).to be false
    end

    it "returns false for items without tags" do
      expect(item.public?).to be false
    end
  end

  describe "#commentary" do
    it "returns the annotation provided by the author if it's present" do
      data["highlights"] = [{"type" => "NOTE", "annotation" => "This is a note"}]
      expect(item.commentary).to eq("This is a note")
    end

    it "returns nil if no highlight of type 'NOTE' is present" do
      data["highlights"] = [{"type" => "HIGHLIGHT", "annotation" => "This is a highlight"}]
      expect(item.commentary).to be_nil
    end

    it "returns nil if no highlights are present at all" do
      data["highlights"] = nil
      expect(item.commentary).to be_nil
    end

    it "returns nil if  highlights are empty" do
      data["highlights"] = []
      expect(item.commentary).to be_nil
    end
  end
end
