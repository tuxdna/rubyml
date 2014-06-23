class Dictionary
  def initialize
    @d = {}
    @inverted_d = {}
  end

  def add(k)
    if @d.has_key?(k)
      s = @d[k]
    else
      s = @d.keys.size + 1
      @d[k] = s
      @inverted_d[s] = k
    end
    s
  end

  def get(k)
    if @d.has_key?(k) then @d[k] else -1 end
  end

  def get_inverted(s)
    if @inverted_d.has_key?(s) then @inverted_d[s] else "" end
  end

  def keys
    @d.keys
  end

  def size
    @d.keys.size + 1
  end

end
