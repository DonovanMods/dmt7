# frozen_string_literal: true

RSpec.describe DMT7 do
  it "has a version number" do
    expect(DMT7::VERSION).not_to be_nil
  end

  it "has a program name" do
    expect(DMT7::PROGRAM_NAME).not_to be_nil
  end
end
