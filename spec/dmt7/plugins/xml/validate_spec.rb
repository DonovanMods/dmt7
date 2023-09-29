# frozen_string_literal: true

RSpec.describe DMT7::Plugins::XML::Validate do
  subject(:instance) { described_class.new(game_configs:, modlet_path:, options:) }

  let(:game_configs) { DMT7::Plugins::XML::Parse.new(options[:game_config_path]) }
  let(:modlet_path) { "spec/fixtures/test_mod" }
  let(:options) do
    {
      game_config_path: "spec/fixtures/test_mod/Config",
      verbosity: 0
    }
  end

  it "validates the XMLs in MODLET_PATH" do
    expect(instance.valid?).to be(true)
  end
end
