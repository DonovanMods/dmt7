# frozen_string_literal: true

RSpec.describe DMT7::Plugins::XML::Parse do
  subject(:instance) { described_class.call(config_path) }

  let(:elements) { %w[items] }
  let(:files) { %w[testing.xml] }
  let(:files_hash) { files.each_with_object({}) { |f, h| h[f] = elements } }

  it "is an Application Service" do
    expect(described_class).to be < DMT7::ApplicationService
  end

  shared_examples "a config dir" do
    it "is a success" do
      expect(instance.success?).to be(true)
    end

    describe "#files" do
      it "returns a hash of files and elements" do
        expect(instance.files).to eq(files_hash)
      end
    end

    describe "#element_names" do
      it "returns the element names" do
        expect(instance.element_names).to eq(elements)
      end
    end
  end

  context "when the XMLs fail to load" do
    let(:config_path) { "spec/fixtures/missing_mod" }

    it "is a failure" do
      expect(instance.failure?).to be(true)
    end

    it "has an error message" do
      expect(instance.errors.to_s).to match(/invalid directory #{config_path}/i)
    end
  end

  context "when given the game config path" do
    let(:config_path) { "spec/fixtures/test_game/Config" }

    it_behaves_like "a config dir"
  end

  context "when given a modlet path" do
    let(:config_path) { "spec/fixtures/test_mod" }
    let(:elements) { %w[configs] }

    it_behaves_like "a config dir"
  end
end
