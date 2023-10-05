# frozen_string_literal: true

module DMT7
  module ApplicationHelpers
    include Logging

    def truncate_path(path, max_depth: 5)
      spath = Pathname.new(path).to_s # Sanitize path
      dirs = spath.split("/")

      return spath unless dirs.size > max_depth

      ".../#{File.join(dirs[-max_depth..])}"
    end

    def clean_xpath(xpath)
      return "//#{xpath}" unless xpath.to_s[0] == "/"

      xpath.to_s[1] == "/" ? xpath : "/#{xpath}"
    end
  end
end
