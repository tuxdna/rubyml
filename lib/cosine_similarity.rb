require 'matrix'

class CosineSimilarity
  def distance(m1, m2)
    ## since we know that similarity is in range [0,1]
    ## we can take distance = Cos( PI - InvCos(similarity) )
    cos_inv = Math.acos(similarity)
    Math.cos(Math.PI - cos_inv)
  end

  # calculate euclidean distance between two single row-vectors ( Matrix / Vector)
  def similarity(m1, m2)
    if m1.is_a?(SparseVector) && m2.is_a?(SparseVector)
      m1.cosine(m2)
    elsif m2.size == m1.size
      a_dot_b = 0.0
      a_sq_sum = 0.0
      b_sq_sum = 0.0
      m1.each2(m2) do |x1,x2|
        a_dot_b = x1 * x2
        a_sq_sum += x1 * x1
        b_sq_sum += x2 * x2
      end
      a_dot_b / ( Math.sqrt(a_sq_sum) * Math.sqrt(b_sq_sum) )
    else
      0.0
    end
  end
end
