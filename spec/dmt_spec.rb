# frozen_string_literal: true

RSpec.describe DMT do
  it "has a version number" do
    expect(DMT::VERSION).not_to be_nil
  end

  it "has a program name" do
    expect(DMT::PROGRAM_NAME).not_to be_nil
  end
end
