#!/usr/bin/ruby
##
# Reuters corpus 
# Download, unzip, and extract reuters text data from SGML files
# WORK_DIR=/tmp/clustering/reuters
# mkdir -p $WORK_DIR
# curl http://kdd.ics.uci.edu/databases/reuters21578/reuters21578.tar.gz -o ${WORK_DIR}/reuters21578.tar.gz
# mkdir -p ${WORK_DIR}/reuters-sgm
# tar xzf ${WORK_DIR}/reuters21578.tar.gz -C ${WORK_DIR}/reuters-sgm
# mahout org.apache.lucene.benchmark.utils.ExtractReuters file://${WORK_DIR}/reuters-sgm file://${WORK_DIR}/reuters-out
#

require 'set'
require 'matrix'
require 'optparse'

require 'dictionary'
require 'canopy'
require 'euclidean_distance'
require 'tanimoto_similarity'

reuters_location = nil
distance_metric = nil
documents_limit = 100 # Process upto 100 documents

## Parse CLI Options
OptionParser.new do |o|
  o.on('-r REUTERS_CORPUS_LOCATION') { |r| reuters_location = r }
  o.on('-d DISTANCE_METRIC') { |d| distance_metric = d }
  o.on('-l LIMIT') { |l| documents_limit = l.to_i }
  o.on('-h') { puts o; exit }
  o.parse!
end

if reuters_location.nil?
  puts "Path to reuters text corpus not provided"
  exit
end

if ! Dir.exists?(reuters_location)
  puts "Path to reuters text corpus doesn't exist: #{reuters_location}"
  exit
end

## Setup appropriate Distance Metric
dm = nil
case distance_metric
when "euclidean" then 
  dm = EuclideanDistance.new
when  "tanimoto" then
  dm = TanimotoSimilarity.new
else
  puts "Invalid distance metric. Select one of euclidean or tamimoto"
  exit
end

if distance_metric.nil?
  puts "Distance metric not provided"
  exit
end

## Read Reuters corups text files
input_files = Dir.glob(reuters_location+"/*.txt")
puts "Setup dictionary for domain vocabulary..."
dict = Dictionary.new

puts "Read text files..."
documents_bow = input_files[0...100].map do |input_file|
  puts input_file
  data = File.read(input_file).split("\n\n")
  datetime = data[0] || ""
  title = data[1] || "" 
  body = data[2] || ""
  title_words = title.split(/\s+/)
  body_words = body.split(/\s+/)
  vec = title_words.map { |w| dict.add(w) } + body_words.map { |w| dict.add(w) }
  # p title; # p body; # p vec
  # p vec.map { |s| dict.get_inverted(s) }.join(" ") ## Verify
  {title: title, body: body, vector: Set.new(vec)}
end

points = documents_bow.map do |entry|
  bag = entry[:vector]
  arr = Array.new(dict.size, 0)
  bag.each { |x| arr[x] = 1 }
  p [dict.size, arr.length]
  if dict.size != arr.length
    p entry
  end
  arr
  Vector[*arr]
end

canopy_clusterer = Canopy.new(dm, 15, 8, points)
canopies = canopy_clusterer.run
canopies.each do |canopy|
  puts "Canopy: intra cluster distance = #{canopy[:intra_cluster_distance]}"
  canopy[:points].map do |c| 
    doc = documents_bow[c]
    puts " -> " +doc[:title]
  end
end
