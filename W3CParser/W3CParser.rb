#!/usr/bin/env ruby
# W3CParser.rb 0.0.1
# 
# 応答がN秒以上かかった画面のランキング上位M件を表示する。
#
# Usage: ruby W3CParser [todo]
#

# 後でymlに移動するよ
# データベース論理名
DBNAME='/home/hoi/git/SandBox/W3CParser/pom.sqlite3'
DBURL='DBI:jdbc:sqlite:' + DBNAME
DBUSER= nil
DBPASSWORD= nil
JDBCDRIVER= 'org.sqlite.JDBC'

# W3C用のログテーブルにアクセスする。
require 'rubygems'
require 'java'
require 'dbi'
# dbd-jbdc 0.1.4 以外はdbd/jdbcのようで嵌った
require 'dbd/Jdbc'
require 'jdbc/sqlite3'

Dir.chdir(File.dirname(File.expand_path(DBNAME)))
dbh = DBI.connect(DBURL, DBUSER, DBPASSWORD, 'AutoCommit'=>false, 'driver'=>JDBCDRIVER)

sql=<<SQL
SELECT
  cs_uri_query
  , count(*) as cnt
FROM
  log
GROUP BY
  cs_uri_query
ORDER BY
  cnt desc
LIMIT 10
SQL

puts "%-40s %s"%['画面名','件数']

log_table = dbh.execute(sql)
log_table.fetch do |row|
  puts "%-37s %d"%[row[0],row[1]]
end

dbh.commit
dbh.disconnect
