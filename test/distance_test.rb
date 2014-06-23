require 'euclidean_distance'
require 'tanimoto_similarity'
require 'matrix'
require 'test/unit'

class DistanceTest < Test::Unit::TestCase
  def setup
    # nothing
  end
  def test_euclidean_distance
    d = EuclideanDistance.new
    v1 = [1,2,3,4,5]
    v2 = [5,4,3,2,1]
    vec1 = Vector[*v1]
    vec2 = Vector[*v2]
    assert_equal( 6.324555320336759, d.distance(vec1,vec2))
  end
  def test_tanimoto_similarity
    d = TanimotoSimilarity.new
    v1 = [1,0,1,0]
    v2 = [1,1,0,0]
    vec1 = Vector[*v1]
    vec2 = Vector[*v2]
    assert_equal(0.75, d.distance(vec1,vec2))
  end
  def tear_down
    # nothing
  end
end
