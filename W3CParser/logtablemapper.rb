#
# logtablemapper.rb 
#
# class LogTableMapper
# class Log
#
require 'csv'
require 'yaml'
require 'rubygems'
require 'active_record'

class LogTableMapper 
  def initialize
  end

  def connect(config_file_name)
    config = YAML.load_file(config_file_name)
    ActiveRecord::Base.establish_connection(
      :adapter => config["ADAPTER"],
      :database => config["DBNAME"]
    )
  end

  def insertlog(csv_file_name)
    Log.transaction do
      CSV.foreach(csv_file_name) do |row|
        log = Log.new
        log.c_ip = row[0]
        log.date = row[2].strip
        log.time = row[3]
        log.s_computername = row[5]
        log.time_taken = row[7]
        log.sc_bytes = row[8]
        log.cs_bytes = row[9]
        log.sc_status = row[10]
        log.sc_win32_status = row[11]
        log.cs_method = row[12]
        log.cs_uri_stem = row[13].strip
        log.save
      end
    end 
  end
end

class Log < ActiveRecord::Base
end
