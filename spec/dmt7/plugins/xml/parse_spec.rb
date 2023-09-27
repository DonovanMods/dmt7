# frozen_string_literal: true

RSpec.describe DMT7::Plugins::XML::Parse do
  subject(:instance) { described_class.new(path: modlet_path, verbosity: 0) }

  let(:modlet_path) { "spec/fixtures/test_mod" }
  let(:options) do
    {
      game_config_path: "spec/fixtures/test_mod/Config",
      verbosity: 0
    }
  end


end
