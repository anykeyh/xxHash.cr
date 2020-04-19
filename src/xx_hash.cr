require "./xx_hash/**"

module XXHash
  VERSION = "v0.1"

  def self.hash64(value, seed = 0)
    Hash64.new(seed).digest(value)
  end

  def self.hash32(value, seed = 0)
    Hash32.new(seed).digest(value)
  end
end