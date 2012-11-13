#!/usr/bin/env jruby
#
# テキスト形式のIIS(W3CFormat)ログをDBに登録する
#
# なお、IIS W3C形式のログは、出力形式がカスタマイズ可能である。
# そのためこのプログラムで処理できるフォーマットを明記する必要が
# ある。
require 'optparse'
require 'csv'
require 'yaml'
require 'rubygems'
require 'active_record'

class LogTableMapper 

  def initialize (config_file_name)
    config = YAML.load_file(config_file_name)
    @dbname = config["DBNAME"] 
    @adapter = config["ADAPTER"]
    #ActiveRecord::Base.logger = Logger.new("debug.log")
  end

  def connect
    ActiveRecord::Base.establish_connection(
      :adapter => @adapter,
      :database => @dbname
    )
  end

  def insertlog csv_file_name
    self.connect
    Log.transaction do
      CSV.foreach(csv_file_name) do |row|
        log = Log.new
        log.c_ip = row[0]
        log.date = row[2]
        log.time = row[3]
        log.s_computername = row[5]
        log.time_taken = row[7]
        log.sc_bytes = row[8]
        log.cs_bytes = row[9]
        log.sc_status = row[10]
        log.sc_win32_status = row[11]
        log.cs_method = row[12]
        log.cs_uri_stem = row[13]
        log.save
      end
    end 
  end
end

class Log < ActiveRecord::Base
end

class W3C2SQLite3
  attr_reader :csv_file_name

  def main
    args_parse
    LogTableMapper.new("database.yml").insertlog(@csv_file_name)
  end

  private
  def args_parse
    usage="Usage: W3C2SQLie3 FILENAME"
    OptionParser.new usage do |opt|
      opt.version = "0.1.0"
      opt.parse!
      if ARGV[0].nil? 
        puts "Usage: W3C2SQLite3.rb FILENAME"
        exit
      else
        @csv_file_name = ARGV[0] 
      end
    end
  end
end

W3C2SQLite3.new.main
