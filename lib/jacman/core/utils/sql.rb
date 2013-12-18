#!/usr/bin/env ruby
# encoding: utf-8

# File: sql.rb
# Created: 21/07/13
#
# (c) Michel Demazure & Kenji Lefevre

module JacintheManagement
  # encapsulating mysql client methods
  module Sql
    # Initial text of all sql commands
    # @raise RuntimeError if wrong mode
    # @param [Hash] mode connecting mode
    # @return [String] system command for this mode
    def self.sql(mode)
      fail 'Wrong mode' unless mode[:user] && mode[:password]
      "#{MYSQL}  -u #{mode[:user]} -p#{mode[:password]} #{mode[:database]}"
    end

    # Send the query to the MySQL client, ignoring the answer
    # @param [Hash] mode connecting mode
    # @param [String] query query to be sent
    def self.query(mode, query)
      system "#{sql(mode)} -e \"#{query}\""
    end

    # send the query to the MySQL client, recovering the answer
    # @param [Hash] mode connecting mode
    # @param [String] query query to be sent
    # @return [Array<String>] answer
    def self.answer_to_query(mode, query)
      open "|#{sql(mode)} -e \"#{query}\"" do |pipe|
        pipe.readlines.map { |line| line.force_encoding('utf-8') }
      end
    end

    # WARNING: 'pipe_command' looks like 'query', but is different !
    #    because of commands for the client (like DELIMITER)
    # Pipe the given command to the MySQL client
    # @param [Hash] mode connecting mode
    # @param [String] command command to be piped
    def self.pipe_command(mode, command)
      open("|#{sql(mode)}", 'w') do |pipe|
        pipe.puts(command)
      end
    end

    # Reset the list of loaded sql files
    def self.reset_loaded_files_list
      @loaded_sql_files = Set.new
    end

    # Pipe the given file to the MySQL client
    # @param [Hash] mode connecting mode
    # @param [Path] file full path of file to be piped
    def self.pipe_sql_file(mode, file)
      Dir.chdir(File.dirname(file))
      system "#{sql(mode)} < #{File.basename(file)}"
      @loaded_sql_files << file if @loaded_sql_files && !file.is_a?(::Tempfile)
    end

    # pipe all selected file to the MySQL client
    # @param [Hash] mode connecting mode
    # @param [Path] dir directory to search
    # @param [String] pattern Dir.glob pattern of files to be piped
    # @param [Regexp] exclude_pattern filenames to be excluded
    def self.pipe_files_in_directory(mode, dir, pattern, exclude_pattern = nil)
      Dir.chdir(dir)
      Dir.glob(pattern).each do |filename|
        file = File.join(dir, filename)
        next if @loaded_sql_files.include?(file) || file =~ exclude_pattern
        puts file
        pipe_sql_file(mode, file)
      end
    end

    # Dump the database
    # @param [Hash] mode connecting mode
    # @param [String] tables list of tables to be dumped, separated by spaces
    # @return [Array<String>] lines produced by the MYSQLDUMP command
    def self.dump(mode, tables)
      temp_file = File.join(DATADIR, 'dump.temp')
      Utils.delete_if_exists(temp_file)
      command = "#{MYSQLDUMP} -u#{mode[:user]} -p#{mode[:password]} #{SQL_DUMP_OPTIONS} \
      #{mode[:database]} #{tables} > #{temp_file} "
      system command
      File.readlines(temp_file)
    end

    # Utility to build an extracted file and load it in sql
    # @param [Hash] mode connecting mode
    # @param [Path] in_file file to extract lines from
    # @param [Path] out_file file to be filled by extracted line and then loaded
    # @param [String] sql end of sql command "INTO ..."
    # @param [Regexp] regexp regexp to select lines
    # @param [Block] blok block to be given to Utils.extract_lines
    def self.filter_and_load(in_file, out_file, mode, regexp, sql, &blok)
      puts "Extracting lines from #{in_file} matching #{regexp}"
      Utils.extract_lines(in_file, out_file, regexp, &blok)
      puts "Loading #{out_file} in DB #{mode[:database]}"
      Sql.load_file(mode, out_file, sql)
    end

    # Utility to "LOAD DATA LOCAL INFILE" lines extracted from a file
    # @param [Hash] mode connecting mode
    # @param [Path] in_file file to extract lines from
    # @param [String] sql end of sql command "INTO ..."
    # @param [Regexp] regexp regexp to select lines
    # @param [Block] blok block to be given to Utils.extract_lines
    def self.extract_file_and_load(in_file, mode, regexp, sql, &blok)
      dir, name = File.split(in_file)
      extracted_file = File.join(dir, "extracted-#{name}")
      Utils.delete_if_exists(extracted_file)
      filter_and_load(in_file, extracted_file, mode, regexp, sql, &blok)
    end

    # Utility to "LOAD DATA LOCAL INFILE"
    # @param [Hash] mode connecting mode
    # @param [Path] file file to load
    # @param [String] sql end of sql command "INTO ..."
    def self.load_file(mode, file, sql)
      command = "LOAD DATA LOCAL INFILE '#{file}' IGNORE " + sql
      Sql.pipe_command(mode, command)
    end
  end
end
