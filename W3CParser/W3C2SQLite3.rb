#!/usr/bin/env jruby
#
# テキスト形式のIIS(W3CFormat)ログをDBに登録する
#
# なお、IIS W3C形式のログは、出力形式がカスタマイズ可能である。
# そのためこのプログラムで処理できるフォーマットを明記する必要が
# ある。
require 'optparse'
require 'logtablemapper'

class W3C2SQLite3
  attr_reader :csv_file_name

  def main
    args_parse
    logt = LogTableMapper.new
    logt.connect('database.yml')
    logt.insertlog(@csv_file_name)
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
