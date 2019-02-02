require "decoder"

describe "Decoder" do
  let(:decoder) { Decoder.new("input.txt") }
  let(:input) { %w{aaaaa-bbb-z-y-x-123[abxyz]} }

  before do
    allow(File).to receive(:readlines).and_return(input)
  end

  describe "#run" do
    it "reads the input file" do
      expect(File).to receive(:readlines).and_return(input)
      decoder.run
    end

    it "calls #parse_line" do
      expect(decoder).to receive(:parse_line).with("aaaaa-bbb-z-y-x-123[abxyz]").and_return(["aaaaa-bbb-z-y-x", "123", "abxyz"])
      decoder.run
    end

    it "calls #decode" do
      expect(decoder).to receive(:decode).with("aaaaa-bbb-z-y-x-")
      decoder.run
    end

    it "calls #decrypt" do
      expect(decoder).to receive(:decrypt).with("aaaaa-bbb-z-y-x-", 123)
      decoder.run
    end

    it "returns the answer" do
      allow(decoder).to receive(:decrypt).with("aaaaa-bbb-z-y-x-", 123).and_return("north pole")
      expect(decoder.run).to  eql "Sum of sector ids: 123\nNorth pole sector id: 123"
    end
  end
  
end
