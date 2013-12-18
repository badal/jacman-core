#!/usr/bin/env ruby
# encoding: utf-8

# File: catalog.rb
# Created: 27/07/13
#
# (c) Michel Demazure & Kenji Lefevre

module JacintheManagement
  module Core
    # Catalogue methods
    module Catalog
      # transfer top directory for catalog
      TRANSFERT_CATALOGUE_DIR = File.join(TRANSFERT_DIR, 'Catalogue')
      # transfer directory for articles
      TRANSFERT_ARTICLE_DIR = File.join(TRANSFERT_CATALOGUE_DIR, 'Articles')
      # transfer directory for nomenclature
      TRANSFERT_NOMENCLATURE_DIR = File.join(TRANSFERT_CATALOGUE_DIR, 'Nomenclatures')
      # transfer directory for stock
      TRANSFERT_STOCK_DIR = File.join(TRANSFERT_CATALOGUE_DIR, 'Stock')
      # transfer directory for tariffs
      TRANSFERT_TARIFF_DIR = File.join(TRANSFERT_CATALOGUE_DIR, 'Tarifs')

      ### exportation

      # sql command for catalog exporting
      EXPORT_SQL = SqlScriptFile.new('catalog_export').script

      # export catalogue to file +catalogue.csv+
      def self.export_catalogue
        dump_file = File.join(DATADIR, 'catalogue.csv')
        puts "Dumping catalog data into file #{dump_file}"
        lines = Sql.answer_to_query(CATALOG_MODE, EXPORT_SQL)
        File.open(dump_file, 'w') do |file|
          # TODO: here encode if necessary # .encode(Encoding.default_external) }
          lines.each { |line| file.puts line.force_encoding('utf-8') }
        end
      end

      ### importation

      ## sql fragments

      # sql fragment for articles
      ARTICLE_SQL = SqlScriptFile.new('catalog_article').script

      # sql fragment for nomenclature
      NOMENCLATURE_SQL = SqlScriptFile.new('catalog_nomenclature').script

      # sql fragment for tariff
      TARIFF_SQL = SqlScriptFile.new('catalog_tariff').script

      # sql fragment for stock
      STOCK_SQL = SqlScriptFile.new('catalog_tariff').script

      ## importation of articles, nomenclature, tariff

      # Regexp to select lines
      KN_REGEXP = /^(K|N)/

      # import in catalog DB articles from Sage
      def self.import_articles
        AspawayImporter.new('Catalogue/Articles/Articles.slk').fetch
        slk_file = File.join(TRANSFERT_ARTICLE_DIR, 'Articles.slk')
        csv_file = File.join(TRANSFERT_ARTICLE_DIR, 'Articles.csv')
        WinFile.convert_from_sylk(slk_file, csv_file)
        Sql.extract_file_and_load(csv_file, CATALOG_MODE, KN_REGEXP, ARTICLE_SQL)
      end

      # import in DB nomenclature from Sage
      def self.import_nomenclature
        AspawayImporter.new('Catalogue/Nomenclatures/Nomenclatures.slk').fetch
        slk_file = File.join(TRANSFERT_NOMENCLATURE_DIR, 'Nomenclatures.slk')
        csv_file = File.join(TRANSFERT_NOMENCLATURE_DIR, 'Nomenclatures.csv')
        WinFile.convert_from_sylk(slk_file, csv_file)
        Sql.extract_file_and_load(csv_file, CATALOG_MODE, KN_REGEXP, NOMENCLATURE_SQL)
      end

      # import in catalog DB tariffs from Sage
      def self.import_tariffs
        AspawayImporter.new('Catalogue/Tarifs/Tarifs.csv').fetch
        csv_file = File.join(TRANSFERT_TARIFF_DIR, 'Tarifs.csv')
        utf8_file = File.join(TRANSFERT_TARIFF_DIR, 'Tarifs-utf8.csv')
        WinFile.convert_to_unicode(csv_file, utf8_file)
        Sql.extract_file_and_load(utf8_file, CATALOG_MODE, KN_REGEXP, TARIFF_SQL)
      end

      ## importation of stock

      # Regexp to select lines and extract catalog data
      CAT_REGEXP = /^(?<item>N\w*)\t+(?<qty>\d*).*/

      # import in catalog DB stocks from Sage
      def self.import_stock
        csv_file = build_stock_csv_file
        Sql.extract_file_and_load(csv_file, CATALOG_MODE, CAT_REGEXP, STOCK_SQL) do |mtch|
          "#{mtch[:item]}\t#{mtch[:qty]}"
        end
      end

      # build Stock csv file by extracting lines from Stock txt file
      def self.build_stock_csv_file
        AspawayImporter.new('Catalogue/Stock/Stock.txt').fetch
        puts 'Building Stock utf-8 file'
        txt_file = File.join(TRANSFERT_STOCK_DIR, 'Stock.txt')
        utf8_file = File.join(TRANSFERT_STOCK_DIR, 'Stock_utf8.txt')
        WinFile.convert_to_unicode(txt_file, utf8_file)
        puts 'Building Stock csv file'
        csv_file = File.join(TRANSFERT_STOCK_DIR, 'Stock.csv')
        Utils.extract_lines(utf8_file, csv_file, /\b{3}/)
        csv_file
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__

  include JacintheManagement
  Catalog.import_tariffs

end
