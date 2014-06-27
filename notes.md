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



### Classification


### Clustering


### Recommendation

[Ruby Toolbox: Recommendation Engines](https://www.ruby-toolbox.com/categories/Recommendation_Engines)
