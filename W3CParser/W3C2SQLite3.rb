#!/usr/bin/env ruby
# W3C2SQLite3.rb 0.0.1
# テキスト形式のIIS(W3CFormat)ログをSQLite3に登録する
#
# Usage: ruby W3CParser [todo]
#
# sqlite3-rubyというナイスなパッケージがjRubyで使用できない！
# そのためdbi経由でSQLite3にアクセスする。
#
# なお、IIS W3C形式のログは、出力形式がカスタマイズ可能である。
# そのためこのプログラムで処理できるフォーマットを明記する必要が
# ある。サンプルでなければ。

# 後でymlに移動するよ
# データベース論理名
DBNAME='/home/hoi/git/SandBox/W3CParser/pom.sqlite3'
DBURL='DBI:jdbc:sqlite:' + DBNAME
DBUSER= nil
DBPASSWORD= nil
JDBCDRIVER= 'org.sqlite.JDBC'

unless ARGV[0]
  puts "Usage: [TODO]"
  exit 1
end

# W3C用のログテーブルにアクセスする。
require 'rubygems'
require 'java'
require 'dbi'
# dbd-jbdc 0.1.4 以外はdbd/jdbcのようで嵌った
require 'dbd/Jdbc'
require 'jdbc/sqlite3'

Dir.chdir(File.dirname(File.expand_path(DBNAME)))
dbh = DBI.connect(DBURL, DBUSER, DBPASSWORD, 'AutoCommit'=>false, 'driver'=>JDBCDRIVER)

# SQL文の管理は本当なら別の機構が必要だろう
sql = <<SQL
SELECT tbl_name
FROM sqlite_master
WHERE type=='table'
SQL

unless(dbh.execute(sql).fetch_all.include?(["log"]))
sql = <<SQL
CREATE TABLE log(
  c_ip,
  date,
  time, 
  s_computername, 
  time_taken,
  sc_bytes,
  cs_bytes,
  sc_status,
  sc_win32_status,
  cs_method, 
  cs_uri_query,
  cs_u_a
  );"
SQL
  dbh.do(sql)
end

query_insert= <<SQL
INSERT INTO log VALUES(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12)
SQL
#  :c_ip,
#  :date,
#  :time, 
#  :s_computername,
#  :time_taken,
#  :sc_bytes,
#  :cs_bytes,
#  :sc_status,
#  :sc_win32_status,
#  :cs_method, 
#  :cs_uri_query,
#  :cs_u_a
#  );"
#SQL
# ログをインサートするsqlを準備
st=dbh.prepare(query_insert)

# pg Read W3C Format file 
# 加工してインポートしたほうがよさそうだけど学習のため一行ずつ処理
require 'csv'
CSV.foreach(ARGV[0]) do |i|
  args=i.values_at(0,2,3,5,7,8,9,10,11,12,13).map{|v| v.strip}
  st.execute(*(args + [nil]))
end

dbh.commit
dbh.disconnect
