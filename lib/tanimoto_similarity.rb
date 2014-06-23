require 'matrix'

class TanimotoSimilarity
  def distance(m1, m2)
    ## since we know that similarity is in range [0,1]
    ## we can take distance = 1 - similarity
    1.0 - similarity(m1,m2)
  end

  # calculate euclidean distance between two single row-vectors ( Matrix / Vector)
  def similarity(m1, m2)
    if m2.size == m1.size
      sum = 0.0
      m1.each2(m2) do |x1,x2|
        sum += x1 * x2
      end
      sum  / m1.size
    else
      0
    end
  end
end
