## Outline

## Commands

    $ bundle install --deployment
    $ bundle exec news_classifier.rb


## Setting up JRuby

    $ rvm install jruby
    $ rvm use jruby-1.7.17


Recommendation via clustering

    "You might also like": How would we go about that? To clarify the idea, let's look at a naive solution:

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



## Classification

Naive Bayes Classifier

    $ bundle exec naivebayes.rb -i data/iris.csv -d ,
    $ wget -c http://stat-computing.org/dataexpo/2009/1987.csv.bz2
    $ wget -c http://stat-computing.org/dataexpo/2009/2008.csv.bz2
	
	$ awk -F, '{print $1,$2,$3,$5,$6,$7,$8,$15,$16,$17,$18,$19,$4}' ~/demo-data-rubyml/1987.csv > flight-sample.csv

    $ bundle exec naivebayes.rb -n 12 -i flight-sample.csv -d ' '

Statistical Text Classifier

    $ bundle exec news_classifier.rb


## Clustering



### Reuters Data setup

    $ cd /home/saleem/projects/mine/ruby-ml/rubyml/clustering/reuters/
    $ wget -c http://www.daviddlewis.com/resources/testcollections/reuters21578/reuters21578.tar.gz
    $ mkdir reuters-sgm/
    $ cd reuters-sgm/
    $ tar zxf ../reuters21578.tar.gz

	$ wget -c https://archive.apache.org/dist/lucene/java/3.6.2/lucene-3.6.2.tgz
	$ tar zxf lucene-3.6.2.tgz

Using Java

    $ java -cp lucene-core-3.6.2.jar:./contrib/benchmark/lucene-benchmark-3.6.2.jar  org.apache.lucene.benchmark.utils.ExtractReuters  ../data/reuters-sgm/ ../data/reuters-out 
    Deleting all files in /home/tuxdna/work/learn/mine/rubyml/lucene-3.6.2/../data/reuters-out-tmp


Using Scala

    $ scala -cp "lucene*.jar"
    scala> import org.apache.lucene.benchmark.utils.ExtractReuters
    import org.apache.lucene.benchmark.utils.ExtractReuters
    
    scala> val reutersIn = "/home/saleem/projects/mine/ruby-ml/rubyml/clustering/reuters/reuters-sgm"
    scala> val reutersOut = "/home/saleem/projects/mine/ruby-ml/rubyml/clustering/reuters/reuters-out"
    scala> ExtractReuters.main(Array(reutersIn, reutersOut))
    Deleting all files in /home/saleem/projects/mine/ruby-ml/rubyml/clustering/reuters/reuters-out-tmp




## Recommendation


### Prepare / inspect data

Very small data set

    $ bundle exec recommend.rb -i data/intro.csv -d ,

100K Dataset

    $ bundle exec recommend.rb -i ml-100k/ua.base

1M Dataset

	$ awk -F"::" '{print $1}'  ml-1m/ratings.dat | sort | uniq | wc -l
	6040

	$ awk -F"::" '{print $2}'  ml-1m/ratings.dat | sort | uniq | wc -l
	3706

	$ awk -F"::" '{print $3}'  ml-1m/ratings.dat | sort | uniq | wc -l
	5

    $ bundle exec recommend.rb -i ml-1m/ratings.dat -d '::'


[Ruby Toolbox: Recommendation Engines](https://www.ruby-toolbox.com/categories/Recommendation_Engines)



Kinds of support needed is:

 * linear algebra
 * vector arithmeic
 * matrix operation
 * sparse/dense matrix representation
 * probability distribution functions
 * visualization via Matplotlib and other tools

