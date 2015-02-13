#!/usr/bin/env ruby
# encoding: utf-8
#
# File: reset_db.rb
# Created: 28/06/13
# Refactored: 06/02/15 for cloning
#
# (c) Michel Demazure & Kenji Lefevre

module JacintheManagement
  module Core
    # methods for (re)building Jacinthe database
    class ResetDb
      DB_SOURCE_DIR = File.join(SMF_SERVEUR,
                                'Jacinthe', 'Tools', 'Library', 'JacintheDatabase')
      SQL_MODULE_DIR = File.join(DB_SOURCE_DIR, 'Modules')

      # build database, with schema, tables, views, libraries...
      def self.reset_without_data
        new.reset_without_data
      end

      # build database, with everything, including dumped data
      def self.reset_and_load_data
        new.reset_and_load_data
      end

      # build a clone from dumped_data.sql
      def self.clone_db
        new(CLONE_DATABASE).reset_and_load_data
      end

      ## Default parameters give Jacinthe usual base
      def initialize(database = JACINTHE_DATABASE,
        mode = ADMIN_MODE, root_mode = ROOT_MODE)
        @database = database
        @normal_mode = mode.merge(database: @database)
        @root_mode = root_mode
        @database_root_mode = root_mode.merge(database: @database)
      end

      # build database, with schema, tables, views, libraries...
      def reset_without_data
        Sql.reset_loaded_files_list
        reset_db_schema
        reset_db_post
      end

      # build database, with everything, including dumped data
      def reset_and_load_data
        Sql.reset_loaded_files_list
        reset_db_schema
        puts "Loading #{@database} db data..."
        import_data
        puts 'Loading drupal db data...'
        Drupal.import_drupal
        reset_db_post
      end

      # build database, with schema and tables
      def reset_db_schema
        puts 'SCHEMA'
        recreate_database
        create_tables
        puts 'MODULES'
        load_tables_in_modules
      end

      # drop and recreate databose
      def recreate_database
        puts "Drop db #{@database}"
        Sql.query(@root_mode, "drop database #{@database}")
        puts "Create db #{@database}"
        qry = "CREATE DATABASE #{@database} " \
            'CHARACTER SET utf8 COLLATE utf8_general_ci;'
        Sql.query(@root_mode, qry)
      end

      # load main tables
      def create_tables
        puts "Creating tables of #{@database} db"
        Sql.pipe_files_in_directory(@normal_mode, DB_SOURCE_DIR,
                                    'Database/Tables/**/*.sql')
      end

      # load tables in modules
      def load_tables_in_modules
        Sql.pipe_files_in_directory(@normal_mode, SQL_MODULE_DIR, '*/Tables/**/*.sql')
      end

      # load libraries and views
      def reset_db_post
        load_db_lib
        load_db_modules
        start_cron
      end

      # start sql cron
      def start_cron
        puts "Run cron on #{@database} db"
        Sql.query(@normal_mode, 'CALL CRON();')
      end

      # load main libraries and views
      def load_db_lib
        puts 'Loading libraries'
        Sql.pipe_files_in_directory(@normal_mode, DB_SOURCE_DIR, 'Database/Library/*/*.sql')
        puts 'Loading views'
        Sql.pipe_files_in_directory(@normal_mode, DB_SOURCE_DIR, 'Database/Views/*.sql')
      end

      # load library and views in modules
      def load_db_modules
        puts 'Loading modules'
        Sql.pipe_files_in_directory(@normal_mode, SQL_MODULE_DIR, '**/*.sql', /Views/)
        Sql.pipe_files_in_directory(@normal_mode, SQL_MODULE_DIR, '**/Views/*.sql')
        puts 'Reloading /Sage/export_client_sage.sql with special rights'
        Dir.chdir(File.join(SQL_MODULE_DIR, 'Sage'))
        Sql.pipe_sql_file(@database_root_mode, 'export_client_sage.sql')
      end

      #  import dumped data from 'dumped_data.sql'
      def import_data
        puts "loading #{DATADIR}/dumped_data.sql in #{@database} DB"
        Dir.chdir(DATADIR)
        queries = ['SET foreign_key_checks = 0',
                   "source #{DATADIR}/dumped_data.sql",
                   'SET foreign_key_checks = 1;']
        Sql.query(@normal_mode, queries.join('; '))
      end
    end
  end
end
