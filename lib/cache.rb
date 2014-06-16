require 'fileutils'

class Cache
  CACHE_FOLDER="./cache"
  def initialize
    if ! File.exists?(CACHE_FOLDER) then
      FileUtils.mkdir_p(CACHE_FOLDER)
    end
  end
  
  def get(key)
    filename = "#{CACHE_FOLDER}/#{key}.seralized.cache"
    if File.exists?(filename) then
      f = File.new(filename, "r")
      x = f.read
      Marshal.load(x)
    else
      nil
    end
  end
  
  def put(key, data)
    filename = "#{CACHE_FOLDER}/#{key}.seralized.cache"
    f = File.new(filename, "w")
    x = Marshal.dump(data)
    f.write(x)
    f.close
  end
end
