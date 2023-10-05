# frozen_string_literal: true

require "spec_helper"
# require_relative "../../../lib/dmt7/support/application_helpers"

RSpec.describe DMT7::ApplicationHelpers do
  subject(:instance) { Class.new { extend DMT7::ApplicationHelpers } }

  describe ".truncate_path" do
    subject(:truncate_path) { instance.truncate_path(path, max_depth:) }

    let(:path) { "foo/bar/baz/qux/quux/corge/grault/garply/waldo/fred/plugh/xyzzy/thud" }
    let(:max_depth) { 5 }

    it "returns a String" do
      expect(truncate_path).to be_a(String)
    end

    it "truncates the path to MAX_DEPTH" do
      expect(truncate_path).to eq(".../waldo/fred/plugh/xyzzy/thud")
    end

    context "when the path is shorter than MAX_DEPTH" do
      let(:max_depth) { 20 }

      it "returns the full path" do
        expect(truncate_path).to eq(path)
      end
    end
  end

  describe ".clean_xpath" do
    subject(:clean_xpath) { instance.clean_xpath(xpath) }

    let(:xpath) { "" }
    let(:expected) { "//foo/bar/baz" }

    it "returns a String" do
      expect(clean_xpath).to be_a(String)
    end

    context "when the xpath has no leading slash" do
      let(:xpath) { "foo/bar/baz" }

      it "prepends two leading slashes" do
        expect(clean_xpath).to eq(expected)
      end
    end

    context "when the xpath has a single leading slash" do
      let(:xpath) { "/foo/bar/baz" }

      it "prepends a leading slash" do
        expect(clean_xpath).to eq(expected)
      end
    end

    context "when the xpath has a double leading slash" do
      let(:xpath) { "//foo/bar/baz" }

      it "returns the xpath" do
        expect(clean_xpath).to eq(expected)
      end
    end
  end
end
