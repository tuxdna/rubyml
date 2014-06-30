#!/usr/bin/ruby

require 'optparse'
require 'dictionary'
require 'matrix'

# gaussian distribution
def g(x, #: Double,
      mu, #: Double,
      sigma #: Double
      ) 
  denom = Math.sqrt(2.0 * Math::PI * sigma)
  epart = Math::E ** (-((x - mu) * (x - mu) / (2 * sigma * sigma)))
  1.0 * epart / denom
end

# gaussian distribution vectorized
def g_vec(x, #: Double,
      mu, #: Double,
      sigma #: Double
      )
  x.zip(mu,sigma).map { |k| g(*k)}
end


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

puts "Skip header..."
# p all_lines[0]

features = []
target = []

all_lines[1..-1].each do |l|
  entries = l.split(separator)
  category_code = dict.add(entries[4])

  # Encode the Vector
  # Sepal.Length Sepal.Width Petal.Length Petal.Width
  arr = entries[0..3].map{ |x| x.to_f }
  vec = Vector[*arr]

  # p [vec, category_code, dict.get_inverted(category_code)]

  target.push(category_code)
  features.push(vec)
end

puts "Features and target variable loaded...Categories and their codes: "

p Hash[dict.keys.map{ |k| [k, dict.get(k)] }]

puts "Building the NaiveBayes model..."

actual_data = features.zip(target)
models = actual_data.group_by{|x| x[1]}.map do |e|
  cat_features_count = e[1].length
  cat_code = e[0]

  sum_vec        = Vector[ * [0.0] * 4 ]
  mean_vec       = Vector[ * [0.0] * 4 ]
  variance_vec   = Vector[ * [0.0] * 4 ]
  sigma_vec      = Vector[ * [0.0] * 4 ]

  # calculate mean
  e[1].each do |x|
    sum_vec = sum_vec + x[0]
  end
  mean_vec = sum_vec / cat_features_count

  # calcuate sum of squared-diff
  e[1].each do |x|
    diff = x[0] - mean_vec
    squared_diff = diff.map{ |k| k * k }
    variance_vec = variance_vec + squared_diff
  end
  variance_vec = variance_vec / cat_features_count
  # calculate std. deviation
  sigma_vec = variance_vec.map{ |k| Math.sqrt(k) }

  model = [
           cat_code, 
           cat_features_count,
           cat_features_count / features.size.to_f,
           mean_vec,
           sigma_vec]
  puts "category: #{cat_code}, size: #{cat_features_count}"
  print "Model prams: "
  p model
  model
end


# Run test on some random data set

puts
puts "Now evaulating the model. Will only print the mismatches..."

test_data = actual_data.sample(features.size)
test_data.each do |td|
  vec = td[0]
  cat_code = td[1]

  # calculate probability for each model
  cpl = models.map do |model|
    c, count, prob_c, mean_vec, sigma_vec = model
    pxci = 1.0
    vec.each_with_index do |k,i| 
      pxci = pxci * g(k, mean_vec[i], sigma_vec[i])
    end
    [c, prob_c * pxci]
  end
  
  predicted = cpl.max_by {|k| k[1]}
  predict_code = predicted[0]
  if predict_code != cat_code
    orig = dict.get_inverted(cat_code)
    pred = dict.get_inverted(predict_code)
    
    puts "Actual Category: #{dict.get_inverted(cat_code)}, Predicted As: #{dict.get_inverted(predict_code)}"
  end
end

