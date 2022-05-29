# frozen_string_literal: true

require_relative "db_reporter/version"
require_relative "db_reporter/structure"
require_relative "db_reporter/document"

module DbReporter
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "tasks/generate.rake"
    end
  end if defined?(Rails)
end
