# RubyML

This codebase is for the a talk:

    Title: Machine Learning with Ruby

    Abstract:

    I will discuss ways to make sense out of data. Specifically:
     * Using Classification, Clustering and Recommendation algorithms
     * and a demo

    Requirements
     * A basic understanding of Ruby Programming Language
     * Basic mathematics: Probability and Statistics

## Installation

Add this line to your application's Gemfile:

    gem 'rubyml'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubyml

## Usage

When using the bundler

    $ bundle install
    $ bundle update -V
    $ bundle exec news_classifier.rb


When using only gem command

    $ gem build *.gemspec; gem install --local -V rubyml-0.0.1.gem
    $ news_classifier.rb


To test

    $ bundle install
    $ bundle update -V
    $ bundle exec rake test

## Outline



## Reuters Data setup


Scala to the rescue

    $ scala -cp "lucene*.jar"
    scala> import org.apache.lucene.benchmark.utils.ExtractReuters
    import org.apache.lucene.benchmark.utils.ExtractReuters
    
    scala> val reutersIn = "/home/saleem/projects/mine/ruby-ml/rubyml/clustering/reuters/reuters-sgm"
    scala> val reutersOut = "/home/saleem/projects/mine/ruby-ml/rubyml/clustering/reuters/reuters-out"
    scala> ExtractReuters.main(Array(reutersIn, reutersOut))
    Deleting all files in /home/saleem/projects/mine/ruby-ml/rubyml/clustering/reuters/reuters-out-tmp



Recommendation via clustering

    "You might also like": How would we go about that? To clarify the idea, let’s look at a naive solution:

    Split the current post title into its individual words
    Get all other posts
    Sort all other posts by those with the most words in their body in common with our title


Processing images

    i = Magick::Image.read(filename).first
      out_filename = File.join(cropped_dir, File.split(filename).last)
     i.quantize(2, Magick::GRAYColorspace) \
    .contrast(sharpen=true) \
    .negate(grayscale=true) \
    .enhance \
    .adaptive_blur(radius=0.0, sigma=1.0) \
    .despeckle \
    .resize_to_fill(28, 28) \
    .write(out_filename)



### Classification


### Clustering


### Recommendation

[Ruby Toolbox: Recommendation Engines](https://www.ruby-toolbox.com/categories/Recommendation_Engines)

## Contributing

1. Fork it ( http://github.com/tuxdna/rubyml/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## References

 * [My Machine Learning Notes](http://tuxdna.github.io/pages/machine-learning.html)
 * [My Apache Mahout Notes](http://tuxdna.github.io/pages/mahout.html)
 * [My Mahout Scala Talk](http://tuxdna.in/files/presentations/mahout-scala-talk.html)
 * [Following Redirects with Net/HTTP](http://www.railstips.org/blog/archives/2009/03/04/following-redirects-with-nethttp/)

## Notes

Clustering:  Jaccard Coefficient, K-Means Clustering
Classification: Handwritten digit recognition LibSVM
Recommendation: 

ML With Ruby

 * AI4R
 * SciRuby
 * JRuby and Mahout
 
 Challenges to be solved:
  * Fast Math
  * Easy Plotting
  * Integrated Environment for ML
  
Machine Learning - Peter Flach
BigML
Dundas
Kaggle

http://bit.ly/bryanl-machine-learning-intro-talk-code
https://github.com/bryanl/bryanl-wickedruby2013

 * [News Aggregator App](https://github.com/siyelo/newsagg)

http://blog.siyelo.com/intro-to-machine-learning-in-ruby/
http://www.confreaks.com/videos/2887-rubyconf2013-thinking-about-machine-learning-with-ruby
http://insideintercom.io/machine-learning-way-easier-than-it-looks/
http://yann.lecun.com/exdb/mnist/
https://github.com/arnab/ocr
http://neovintage.blogspot.in/2011/11/text-classification-using-support.html
http://slides.com/arnab_deka/ml-with-ruby
https://www.igvita.com/2008/01/07/support-vector-machines-svm-in-ruby/
http://www.cs.waikato.ac.nz/ml/weka/
https://weka.waikato.ac.nz/explorer
http://www.cs.waikato.ac.nz/ml/weka/mooc/dataminingwithweka/
http://en.wikipedia.org/wiki/Support_vector_machine
https://coreos.com/docs/running-coreos/platforms/qemu/
https://coreos.com/docs/quickstart/
http://momolog.info/2010/10/07/ruby-map-array-to-hash/
