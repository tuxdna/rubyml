class SparseVector
  def initialize(h = {})
    @h = h
  end

  def [](x)
    @h[x] || 0.0
  end

  def []=(x, val)
    @h[x] = val
  end

  def indices
    @h.keys
  end

  def cosine(that)
    i1 = self.indices
    i2 = that.indices
    locations = i1.concat(i2).uniq
    a_dot_b_sum = 0.0
    a_sq_sum = 0.0
    b_sq_sum = 0.0
    locations.each do |l|
      x1 = self[l]
      x2 = that[l]
      a_dot_b_sum += x1 * x2
      a_sq_sum += x1 * x1
      b_sq_sum += x2 * x2
    end
    a_dot_b_sum / ( Math.sqrt(a_sq_sum) * Math.sqrt(b_sq_sum) )
  end
end
