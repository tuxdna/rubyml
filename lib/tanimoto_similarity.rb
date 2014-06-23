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
      # Math.sqrt((m2 - m1).map{ |e| e * e }.inject(:+))
      m1.each_with_index do |x,i|
        s += x * m2[i]
      end
      sum  / m2.size
    else
      0
    end
  end
end
