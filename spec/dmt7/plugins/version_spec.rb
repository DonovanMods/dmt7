# frozen_string_literal: true

RSpec.describe DMT7::Plugins::Version do
  subject(:instance) { described_class.new(modlet_path) }

  let(:modlet_path) { "spec/fixtures/test_mod" }
  let(:options) { { dry_run: true } }

  before { Opt.merge!(options) }

  describe "#major" do
    it { is_expected.to respond_to(:major) }
    it { expect(instance.major).to eq(1) }
  end

  describe "#minor" do
    it { is_expected.to respond_to(:minor) }
    it { expect(instance.minor).to eq(2) }
  end

  describe "#patch" do
    it { is_expected.to respond_to(:patch) }
    it { expect(instance.patch).to eq(3) }
  end

  describe "#to_a" do
    it { is_expected.to respond_to(:to_a) }
    it { expect(instance.to_a).to eq([1, 2, 3]) }
  end

  describe "#to_s" do
    it { is_expected.to respond_to(:to_s) }
    it { expect(instance.to_s).to eq("1.2.3") }
  end

  describe "#bump" do
    it "increments the version in modinfo_data" do
      expect(instance.bump.modinfo_data).to match(/Version value="1.2.4"/)
    end

    context "when given a major version" do
      let(:options) { { major: 10, minor: nil, patch: nil } }

      it "replaces the major version" do
        expect(instance.bump.to_a).to eq([10, 0, 0])
      end
    end

    context "when given a minor version" do
      let(:options) { { major: nil, minor: 10, patch: nil } }

      it "replaces the minor version" do
        expect(instance.bump.to_a).to eq([1, 10, 0])
      end
    end

    context "when given a patch version" do
      let(:options) { { major: nil, minor: nil, patch: 10 } }

      it "replaces the patch version" do
        expect(instance.bump.to_a).to eq([1, 2, 10])
      end
    end

    context "when given no version options" do
      let(:options) { { major: nil, minor: nil, patch: nil } }

      it "increments the patch version" do
        expect(instance.bump.to_a).to eq([1, 2, 4])
      end
    end

    context "when given a major and minor version" do
      let(:options) { { major: 10, minor: 10, patch: nil } }

      it "replaces the major and minor version" do
        expect(instance.bump.to_a).to eq([10, 10, 0])
      end
    end

    context "when given a major and patch version" do
      let(:options) { { major: 10, minor: nil, patch: 10 } }

      it "replaces the major and patch version" do
        expect(instance.bump.to_a).to eq([10, 0, 10])
      end
    end

    context "when given a minor and patch version" do
      let(:options) { { major: nil, minor: 10, patch: 10 } }

      it "replaces the minor and patch version" do
        expect(instance.bump.to_a).to eq([1, 10, 10])
      end
    end
  end

  describe "#save" do
    before do
      allow(File).to receive(:write)
    end

    context "when given a dry run option" do
      let(:options) { { dry_run: true } }

      it "does not save the version" do
        instance.bump.save

        expect(File).not_to have_received :write
      end
    end

    context "when not given a dry run option" do
      let(:options) { { dry_run: false } }

      it "saves the version" do
        instance.bump.save

        expect(File).to have_received(:write).with(instance.modinfo_file, instance.modinfo_data)
      end
    end
  end
end
