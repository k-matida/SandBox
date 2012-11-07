#!/usr/bin/ruby

## print-yaml.rb
## usage: ruby print-yaml.rb file.yaml [file2.yaml ..]

require 'yaml'
require 'pp'

str = ARGF.read() # 入力読み
data = YAML.load(str) # パースする
pp data
