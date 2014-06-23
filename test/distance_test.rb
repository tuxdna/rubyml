require 'euclidean_distance'
require 'matrix'
require 'test/unit'

class DistanceTest < Test::Unit::TestCase
  def setup
    # nothing
  end
  def test_euclidean_distance
    d = EuclideanDistance.new
    v1 = [1,2,3,4,5,6,76,2,34,123]
    v2 = [2,3,4,56,6,7,8,65,4,0]
    vec1 = Vector[*v1]
    vec2 = Vector[*v2]
    d.distance(vec1,vec2)
  end
  def tear_down
    # nothing
  end
end
