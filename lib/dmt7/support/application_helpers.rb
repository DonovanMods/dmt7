# frozen_string_literal: true

module DMT7
  module ApplicationHelpers
    def truncate_path(path, max_depth: 5)
      spath = Pathname.new(path).to_s # Sanitize path
      dirs = spath.split("/")

      return spath unless dirs.size > max_depth

      ".../#{File.join(dirs[-max_depth..])}"
    end
  end
end
