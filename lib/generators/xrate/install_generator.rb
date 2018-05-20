require "rails/generators"
require "rails/generators/migration"

module Xrate
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("../install/templates", __FILE__)
      desc "Add the rate storage migration for Xrate"

      def self.next_migration_number(path)
        next_migration_number = current_migration_number(path) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def copy_migrations
        migration_template "create_xrate_exchange_rates.rb",
          "db/migrate/create_xrate_exchange_rates.rb"
      end
    end
  end
end
