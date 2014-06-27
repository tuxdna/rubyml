# RubyML

This codebase is for the talk:

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

## Contributing

1. Fork it ( http://github.com/tuxdna/rubyml/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Generating talk presentation

Machine Learning with Ruby

To create presentation first install landslide via pip:

    $ sudo yum install -y python-pip
    $ pip-python install landslide

Create the presentation:

    $ cd talk/
    $ landslide rubyml-talk.md --relative --copy-theme -i

Open it in your favorite browser:

    $ firefox presentation.html

Update the presentation while you are still working on it:

Install inotify-tools on Ubuntu:

    $ sudo aptitude install inotify-tools

Use inotifywait to invoke rebuild on every change

    $ while inotifywait -e close_write rubyml-talk.md ; do landslide rubyml-talk.md --relative --copy-theme -i; done

## References

 * [My Machine Learning Notes](http://tuxdna.github.io/pages/machine-learning.html)
 * [My Apache Mahout Notes](http://tuxdna.github.io/pages/mahout.html)
 * [My Mahout Scala Talk](http://tuxdna.in/files/presentations/mahout-scala-talk.html)
 * [Following Redirects with Net/HTTP](http://www.railstips.org/blog/archives/2009/03/04/following-redirects-with-nethttp/)

