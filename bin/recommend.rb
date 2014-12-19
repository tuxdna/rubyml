#!/usr/bin/ruby

require 'optparse'
require 'set'
require 'ap'
require 'pp'

require 'matrix'
require 'sparse_vector'
require 'cosine_similarity'
require 'euclidean_distance'

## Read ratings from GroupLens
# Download ml-100k.zip from: http://grouplens.org/datasets/movielens/

## Parse CLI Options

ratings_file = nil
distance_metric = "cosine"
separator = "\t"
output_limit = nil

OptionParser.new do |o|
  o.on('-i RATINGS_FILE') { |r| ratings_file = r }
  o.on('-d SEPARATOR') { |d| separator = d }
  o.on('-m DISTANCE_METRIC') { |m| distance_metric = m }
  o.on('-l LIMIT') { |l| output_limit = l.to_i }
  o.on('-h') { puts o; exit }
  o.parse!
end

if ratings_file.nil?
  puts "Ratings file not given."
  exit
end

## Setup appropriate Distance Metric
dm = nil
case distance_metric
when "cosine" then 
  dm = CosineSimilarity.new
when "euclidean" then 
  dm = EuclideanDistance.new
when  "tanimoto" then
  dm = TanimotoSimilarity.new
else
  puts "Invalid distance metric. Select one of cosine, euclidean or tamimoto"
  exit
end

sim = dm

f = File.new(ratings_file, "r")

# user_to_item_mapping = {
#   1 => {item1: 2, item3: 4},
#   2 => {item2: 3, item1: 5},
#   3 => {item2: 4, item5: 5}
# }

# item_to_user_mapping = {
#   item1: [ 1, 2],
#   item2: [ 3, 4],
#   item3: [ 1],
#   item5: [ 3]
# }


user_ratings = {} # user -> items mapping
item_users = {} # item -> users mapping

all_items = Set.new

f.readlines.map do |line|
  ## parse this line
  l = line.chomp
  next if l.length == 0 # skip empty line
  entries = l.chomp.split(separator) # => ["196", "242", "3", "881250949"]
  # p entries
  u = entries[0..2].map {|x| x.to_i }
  user_id, item_id, rating = u

  ## add item to list
  all_items.add(item_id)

  ## associate item ratings with user
  item_ratings = user_ratings[user_id]
  item_ratings = {} if item_ratings.nil? ## initialize if required
  item_ratings[item_id] = rating
  user_ratings[user_id] = item_ratings

  ## associate user with item
  users = item_users[item_id]
  users = Set.new if users.nil? ## initialize if required
  users.add(user_id)
  item_users[item_id] = users
end

# puts "User Ratings:"
# pp user_ratings

# puts "All Items:"
# pp all_items

# puts "Item User Map:"
# pp item_users

# determine the limit on output
output_limit = if output_limit.nil? then
                 user_ratings.length
               else 
                 [output_limit || 0, user_ratings.length].min
               end
puts 

## Algorithm: User Based Recommender
# for every item i that u has no preference for yet
#   for every other user v that has a preference for i
#     compute a similarity s between u and v
#     incorporate v's preference for i, weighted by s, into a running average
# return the top items, ranked by weighted average

user_ratings.keys.each do |this_user_id|
  puts "User: #{this_user_id}"
  # this user ratings
  ratings = user_ratings[this_user_id]
  # already rated items
  rated_items = ratings.map{ |x| x[0] }.to_set
  # items which were not rated by this user
  unrated_items = all_items - rated_items

  this_rating_vector = SparseVector.new(ratings)
  # # debug messages
  # pp rated_items
  # pp unrated_items
  # puts "#{all_items.length} #{rated_items.length} #{unrated_items.length}"

  selected = unrated_items.map do |unrated_item|
    other_users = item_users[unrated_item] - [this_user_id].to_set
    estimated_rating = 0.0
    other_users.each do |that_user_id|
      that_ratings = user_ratings[that_user_id]
      that_rating_vector = SparseVector.new(that_ratings)
      similarity = sim.similarity(this_rating_vector, that_rating_vector)
      estimated_rating += similarity * that_ratings[unrated_item]
    end
    estimated_rating = estimated_rating / other_users.length
    # puts "estimated_rating: #{estimated_rating}"
    [unrated_item, estimated_rating]
  end
  # Remove invalid ratings
  selected =  selected.select {|x| ! x[1].nan? }
  # take upto top 5 recommendations
  recommendations = selected.sort_by{ |x| x[1] }.reverse[0...5]

  if recommendations.length > 0
    # # debug messages
    puts "Originally:"
    p ratings
    puts 
    puts "Recommended:"
    p recommendations
    puts 
  end

  output_limit -= 1

  if output_limit <= 0
    exit
  end

end
