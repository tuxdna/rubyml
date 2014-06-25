#!/usr/bin/ruby

require 'optparse'
require 'set'

## Read ratings from GroupLens
# Download ml-100k.zip from: http://grouplens.org/datasets/movielens/

## Parse CLI Options

ratings_file = nil
OptionParser.new do |o|
  o.on('-i RATINGS_FILE') { |r| ratings_file = r }
  o.on('-h') { puts o; exit }
  o.parse!
end

if ratings_file.nil?
  puts "Ratings file not given."
  exit
end

f = File.new(ratings_file, "r")

user_ratings = Hash.new([])
all_items = Set.new

f.readlines[0..100].map do |l|
  entries = l.chomp.split("\t") # => ["196", "242", "3", "881250949"]
  u = entries[0..2].map {|x| x.to_i }
  user_id, item_id, rating = u
  all_items.add(item_id)
  e = user_ratings[user_id]
  e.push( [item_id, rating] )
  user_ratings[user_id] = e
end

p user_ratings.keys
p all_items


## Algorithm: User Based Recommender
# for every item i that u has no preference for yet
#   for every other user v that has a preference for i
#     compute a similarity s between u and v
#     incorporate v's preference for i, weighted by s, into a running average
# return the top items, ranked by weighted average

user_ratings.keys.each do |user_id|
  puts "Determine recommendations for User: #{user_id} ..."
  ratings = user_ratings[user_id]
  rated_items = user_ratings.map { |x| x[0] }.to_set
  unrated_items = all_items - rated_items
  unrated_items.each do |unrated_item|
    ## TODO
  end
end
