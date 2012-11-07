require 'yaml'

## make HashArray
hashlist = [ 
	{
	'name' => 'Shiina',
	'age' => 6,
	'birth' => Date.new(1999,1,1),
	'favorite' => ['Thomas', 'Pokemon'],
  },
  {
	'name' => 'Sumire',
	'age' => 4,
	'birth' => Date.new(2001,2,2),
	'smoker' => false,
  },
]

## to String YAMLFormat
str = YAML.dump(hashlist) # or hashlist.to_yaml()
puts str
