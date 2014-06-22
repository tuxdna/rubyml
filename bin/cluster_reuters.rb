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

require 'dictionary'

reuters_location = "/home/tuxdna/work/learn/external/ml-data/reuters/reuters-out"
input_files = Dir.glob(reuters_location+"/*.txt")

dict = Dictionary.new

input_files[0..10].each do |input_file|
  data = File.read(input_file).split("\n\n")
  datetime = data[0] || ""
  title = data[1] || "" 
  body = data[2] || ""
  title_words = title.split(/\s+/)
  body_words = body.split(/\s+/)
  vec = title_words.map { |w| dict.add(w) } + body_words.map { |w| dict.add(w) }
  p title
  p body
  p vec
  ## Verify
  # p vec.map { |s| dict.get_inverted(s) }.join(" ")
end
