require 'test/unit'
require 'sparse_vector'

class VectorTest < Test::Unit::TestCase
  def setup
  end
  def test_spars_vector
    sv = SparseVector.new({0 => 10, 1 => 11})
    assert_equal(sv[0], 10)
    sv[0]= 12
    assert_equal(sv[0], 12)

    sv2 = SparseVector.new({0 => 11, 2 => 12})
    assert_equal(sv2[1], 0)
    assert_equal(sv2[2], 12)

    c = sv2.cosine(sv)
    assert_equal(c, 0.4981132075471698)
  end
  def tear_down
  end
end
