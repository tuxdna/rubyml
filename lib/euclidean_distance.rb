require 'matrix'

class EuclideanDistance
  # calculate euclidean distance between two single row-vectors ( Matrix / Vector)
  def distance(m1, m2)
    if m2.size == m1.size
      Math.sqrt((m2 - m1).map{ |e| e * e }.inject(:+))
    else
      Float::INFINITY
    end
  end

  def similarity(m1, m2)
    dist = distance(m1,m2)
    ## Calculate similarity = 1 / ( 1 + distance )
    1.0 / (1.0 + dist)
  end
end
