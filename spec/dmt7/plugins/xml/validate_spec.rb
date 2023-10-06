# frozen_string_literal: true

RSpec.describe DMT7::Plugins::XML::Validate do
  subject(:instance) { described_class.call(game_configs:, modlet_path:) }

  let(:game_configs) { DMT7::Plugins::XML::Parse.new(options[:game_config_path]) }
  let(:modlet_path) { "spec/fixtures/test_mod" }
  let(:options) do
    {
      game_config_path: "spec/fixtures/test_mod/Config",
    }
  end

  it "validates the XMLs in MODLET_PATH" do
    expect(instance.valid?).to be(true)
  end

  describe "#errors" do
    subject(:errors) { instance.errors }

    it "returns an Array" do
      expect(errors).to be_an(Array)
    end

    it "is empty" do
      expect(errors).to be_empty
    end
  end

  describe "#modlet_configs" do
    subject(:modlet_configs) { instance.modlet_configs }

    it "returns a DMT7::Plugins::XML::Parse" do
      expect(modlet_configs).to be_a(DMT7::Plugins::XML::Parse)
    end
  end
end
