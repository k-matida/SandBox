# YAML TEXT
str = <<END
langs:
	- name: Ruby
	  url:  http://www.ruby-lang.org
	- name: Python
	  url:  http://www.python.org
	- name: PHP
	  url:  http://www.php.net
END

## after parse, it make tree
require 'yaml'
tree = YAML.parse(str) # tree => YAML::Syck::Node object 

p tree.methods
## search for YPath
path_list = tree.search("/langs/*/name")
p path_list

## take out a specifil node
  if RUBY_VERSION >= "1.8.3"
    arrary = tree.select("/langs/*/name") 
		arrary.each do |node|
	  p. node.transform #> "Ruby" "Python" "PHP"
		end
	else 
		node = tree.select("/langs/*/name")
    name_list = node.transform
		p name_list
	end		

