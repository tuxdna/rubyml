#!/usr/bin/ruby

require 'optparse'
require 'set'

## Read ratings from GroupLens
# Download ml-100k.zip from: http://grouplens.org/datasets/movielens/

## Parse CLI Options

ratings_file = nil
separator = "\t"
OptionParser.new do |o|
  o.on('-i RATINGS_FILE') { |r| ratings_file = r }
  o.on('-d SEPARATOR') { |d| separator = d }
  o.on('-h') { puts o; exit }
  o.parse!
end

if ratings_file.nil?
  puts "Ratings file not given."
  exit
end

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

p user_ratings
p all_items


## Algorithm: User Based Recommender
# for every item i that u has no preference for yet
#   for every other user v that has a preference for i
#     compute a similarity s between u and v
#     incorporate v's preference for i, weighted by s, into a running average
# return the top items, ranked by weighted average

require 'matrix'
require 'sparse_vector'
require 'cosine_similarity'

sim = CosineSimilarity.new

user_ratings.keys.each do |this_user_id|
  puts "Determine recommendations for User: #{this_user_id} ..."
  ratings = user_ratings[this_user_id]
  this_rating_vector = SparseVector.new(ratings)
  rated_items = user_ratings.map { |x| x[0] }.to_set
  unrated_items = all_items - rated_items
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
    [unrated_item, estimated_rating]
  end
  # Remove invalid ratings
  selected =  selected.select {|x| ! x[1].nan? }
  # take upto top 5 recommendations
  recommendations = selected.sort_by{ |x| x[1] }.reverse[0...5]
  p ratings
  p recommendations
end
