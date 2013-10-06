require 'rails/generators/active_record'

module SimpleHashtag
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(path)
        ActiveRecord::Generators::Base.next_migration_number(path)
      end

      def generate_migration
          migration_template "migrations/create_hashtags_migration.rb", "db/migrate/create_simple_hashtag_hashtags.rb"
          migration_template "migrations/create_hashtaggings_migration.rb", "db/migrate/create_simple_hashtag_hashtaggings.rb"
      end
    end
  end
end
