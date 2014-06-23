require 'test/unit'

require 'canopy'
require 'euclidean_distance'

class ClusterTest < Test::Unit::TestCase
  def setup
    # nothing
  end
  def test_canopy_clustering
    dm = EuclideanDistance.new
    points_arr = [
                  [1,1], [2,1], [1,2], [2,2], [3,3],
                  [8,8], [9,8], [8,9], [9,9], [5,6]
                 ]
    points = points_arr.map { |arr| Vector[*arr] }

    canopy_clusterer = Canopy.new(dm, 7.0, 3.0, points)
    canopies = canopy_clusterer.run
    canopies.each do |canopy|
      p canopy.map { |c| points[c] }
    end
  end
  def tear_down
    # nothing
  end
end
