#!/usr/bin/ruby

require 'optparse'
require 'dictionary'
require 'matrix'

## Read ratings from GroupLens
# Download ml-100k.zip from: http://grouplens.org/datasets/movielens/

## Parse CLI Options

input_file = nil
separator = ","
OptionParser.new do |o|
  o.on('-i IRIS_DATA') { |r| input_file = r }
  o.on('-d SEPARATOR') { |d| separator = d }
  o.on('-h') { puts o; exit }
  o.parse!
end

if input_file.nil?
  puts "Input file not given."
  exit
end

f = File.new(input_file, "r")
all_lines = f.readlines.map{|l| l.chomp  }.select{|l| l.length > 0}
f.close

dict = Dictionary.new

puts "header"
p all_lines[0]

features = []
target = []

all_lines[1..-1].each do |l|
  entries = l.split(separator)
  category_code = dict.add(entries[4])

  # Encode the Vector
  # Sepal.Length Sepal.Width Petal.Length Petal.Width
  arr = entries[0..3].map{ |x| x.to_f }
  vec = Vector[*arr]

  p [vec, category_code, dict.get_inverted(category_code)]

  target.push(category_code)
  features.push(vec)
end

puts "Features and target variable loaded"
puts "Categories and their codes: "

p Hash[dict.keys.map{ |k| [k, dict.get(k)] }]

puts "Building the NaiveBayes model..."

p features.zip(target).group_by{|x| x[1]}
