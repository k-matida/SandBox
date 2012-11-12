#!/usr/bin/env jruby
# W3CParser.rb
# 応答がt秒以上かかった画面のランキング上位n件を表示する。
#

# option解析
require 'optparse'
OptionParser.new do |opt|
  # バージョン情報
  Version = "0.1.0"
  opt.on('-t SECONDS[-]', '--time SECONDS[-]', 'かかった時間SECONDS以上を検索対象とする。既定値 10秒') {|v| @TIME = v }
  opt.on('-n COUNT[-]', '--lines COUNT[-]', '上位COUNT件数を表示する。既定値 10件') {|v| @LINES = v }
  opt.on('-d DATE[-]', '--date DATE[-]', '対象の日付を選択する。format mm/dd/yyyy。省略時は実行日') {|v| @DATE = v }
  opt.parse!
  # Defalut value
  @TIME ||= "10"
  @LINES ||= "10"
  @DATE ||= `date "+%m/%d/%Y"` 
end 

# configファイルの読込
require 'yaml'
config = YAML.load_file('W3CPConfig.yml')
DBNAME = config['DBNAME']
DBURL = config['DBURLPREFIX'] + config['DBNAME']
DBUSER = config['DBUSER']
DBPASSWORD = config['DBPASSWORD'] 
JDBCDRIVER = config['JDBCDRIVER']

# W3C用のログテーブルにアクセスする。
require 'rubygems'
require 'java'
require 'dbi'
require 'dbd/Jdbc' # dbd-jbdc 0.1.4 以外はdbd/jdbcのようで嵌った
require 'jdbc/sqlite3'

Dir.chdir(File.dirname(File.expand_path(DBNAME)))
DBI.connect(DBURL, DBUSER, DBPASSWORD, 'AutoCommit'=>false, 'driver'=>JDBCDRIVER) do |dbh|
  query = <<SQL
  SELECT
    cs_uri_query
    , count(*) as cnt
  FROM
    log
  WHERE 
    abs(time_taken) > (:1 * 1000) 
    AND date = :2
  GROUP BY
    cs_uri_query
  ORDER BY
    cnt desc
  LIMIT :3 
SQL
  puts "%-40s %s"%['画面名','件数']
  dbh.execute(query, @TIME, @DATE, @LINES ).fetch do |row|
    puts "%-37s %d"%[row[0],row[1]]
  end
  dbh.commit
end
