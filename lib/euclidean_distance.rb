require 'lib/distance'

class EuclideanDistance
  include Distance
  def distance(v1, v2)
    upper_lim  = [v1.size, v2.size].max
    (0 ... upper_lim).map {
      
    }
  end
end
