require 'csv'
reader = CSV.open("hoge3.csv","r")
header = reader.take(1)[0]
p header 
p "=================================" 
reader.each do |row|
  p row
end
