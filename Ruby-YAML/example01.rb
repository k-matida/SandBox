## YAML Document
str = <<END
- name: Shiina
  birth: 1988-01-01
  age: 6
  favorite:
    - Thomas
    - Pokemon
- name: Sumire
  smoker: false
  birth: 2000-02-02
  age: 4
END

## to Ruby Object
require 'yaml'
require 'pp'
yaml = YAML.load(str)
pp yaml

