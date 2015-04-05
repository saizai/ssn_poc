# -*- encoding: utf-8 -*-
# stub: mysql_big_table_migration 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "mysql_big_table_migration"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Mark Woods"]
  s.date = "2015-04-05"
  s.description = "  A Rails plugin that adds methods to ActiveRecord::Migration to allow columns \n  and indexes to be added to and removed from large tables with millions of\n  rows in MySQL, without leaving processes seemingly stalled in state \"copy\n  to tmp table\".\n"
  s.email = "engineering@analoganalytics.com"
  s.files = ["README", "Rakefile", "lib/mysql_big_table_migration", "lib/mysql_big_table_migration.rb", "lib/mysql_big_table_migration/version.rb", "test/database.yml", "test/mysql_big_table_migration_test.rb", "test/schema.rb", "test/test_helper.rb"]
  s.homepage = "http://github.com/analog-analytics/mysql_big_table_migration"
  s.rubygems_version = "2.4.6"
  s.summary = "allow columns and indexes to be added to and removed from large tables"
end
