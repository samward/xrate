require "xrate"
require "rails"

module Xrate
  class Railtie < Rails::Railtie
    railtie_name :xrate

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
