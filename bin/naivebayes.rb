#!/usr/bin/ruby

require 'optparse'
require 'dictionary'
require 'matrix'
require 'pp'

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

number_of_features = 4

## Parse CLI Options
input_file = nil
separator = ","
OptionParser.new do |o|
  o.on('-i IRIS_DATA') { |r| input_file = r }
  o.on('-d SEPARATOR') { |d| separator = d }
  o.on('-n NUM_FEATURES') { |l| number_of_features = l.to_i }
  o.on('-h') { puts o; exit }
  o.parse!
end

if input_file.nil?
  puts "Input file not given."
  exit
end

dict = Dictionary.new



f = File.new(input_file, "r")
puts "Skip header..."
f.readline
# p all_lines[0]
# numer of feature variables
NF = number_of_features
features = []
target = []

## all_lines = f.readlines.map{|l|   }.select{|l| l.length > 0}
line_count = 0
f.readlines.each do |ln|
  line_count += 1
  l = ln.chomp
  print "#{line_count}\r"
  entries = l.split(separator)
  # Encode the Vector
  # Sepal.Length Sepal.Width Petal.Length Petal.Width
  puts "WARNING: Feature length mismatch" if entries.length < NF

  arr = entries[0...NF].map{ |x| x.to_f }
  # print ln
  # puts arr

  vec = Vector[*arr]
  category_code = dict.add(entries[NF])
  target.push(category_code)
  features.push(vec)

  # p [vec, category_code, dict.get_inverted(category_code)]

  if line_count % 10000 == 0
    GC.start
  end

end
f.close

puts "Features and target variable loaded..."
puts "Total features: #{features.length}"
puts

puts NF

puts "Categories and their codes: "
p Hash[dict.keys.map{ |k| [k, dict.get(k)] }]
puts

puts "Building the NaiveBayes model..."

actual_data = features.zip(target)
models = actual_data.group_by{|x| x[1]}.map do |e|
  # pp e
  cat_features_count = e[1].length
  cat_code = e[0]

  sum_vec        = Vector[ * [0.0] * NF ]
  mean_vec       = Vector[ * [0.0] * NF]
  variance_vec   = Vector[ * [0.0] * NF ]
  sigma_vec      = Vector[ * [0.0] * NF ]

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

(1..10).each do |i|
  test_data = actual_data.sample(features.size / 2)
  puts "Total entries: #{test_data.length}"

  mismatches = 0
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

    predicted = cpl.reject{ |k| k[1].nan? }.max_by{ |k| k[1] }

    next if predicted.nil?

    predict_code = predicted[0]
    if predict_code != cat_code
      orig = dict.get_inverted(cat_code)
      pred = dict.get_inverted(predict_code)

      # puts "Actual Category: #{dict.get_inverted(cat_code)}, Predicted As: #{dict.get_inverted(predict_code)}"
      mismatches += 1
    end
  end

  puts "Total mismatches: #{mismatches}"
  accuracy = 1 - (1.0 * mismatches / test_data.length)
  puts "Accuracy: #{100*accuracy}%"
end

