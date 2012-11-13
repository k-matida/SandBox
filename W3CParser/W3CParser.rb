#!/usr/bin/env jruby
#
# 応答がt秒以上かかった画面のランキング上位n件を表示する。
#
require 'optparse'
require 'yaml'
require 'rubygems'
require 'active_record'

class LogTableAttr
  def initialize(config_file_name)
    ActiveRecord::Base.logger = Logger.new('debug.log')
    config = YAML.load_file('database.yml')
    ActiveRecord::Base.establish_connection(
      :adapter => config['ADAPTER'],
      :database => config['DBNAME']
    )
  end

  def select(time, date, line)
    puts "%-40s %s"%['画面名','件数']
    Log.find(
      :all,
      :select => "cs_uri_stem, count(*) as cnt",
      :conditions => ['abs(time_taken) > (:time * 1000 ) AND date = :date', {:time => time, :date => date }],
      :order => 'cnt desc',
      :group => 'cs_uri_stem',
      :limit => line
    ).each do |row|
      puts "%-37s %d"%[row.cs_uri_stem,row.cnt]
    end
  end
end

class Log < ActiveRecord::Base
end

class W3CParser
  def main
    args_parse
    LogTableAttr.new('database.yml').select(@TIME, @DATE, @LINES)
  end

  private 
  def args_parse
    OptionParser.new do |opt|
      opt.version = "0.1.0"
      opt.on('-t SECONDS[-]', '--time SECONDS[-]', 'かかった時間SECONDS以上を検索対象とする。既定値 10秒') {|v| @TIME = v }
      opt.on('-n COUNT[-]', '--lines COUNT[-]', '上位COUNT件数を表示する。既定値 10件') {|v| @LINES = v }
      opt.on('-d DATE[-]', '--date DATE[-]', '対象の日付を選択する。format m/d/yyyy。省略時は実行日') {|v| @DATE = v }
      opt.parse!
      # Defalut value
      @TIME ||= "10"
      @LINES ||= "10"
      @DATE ||= `date "+%m/%d/%Y"` 
    end 
  end
end

W3CParser.new.main
