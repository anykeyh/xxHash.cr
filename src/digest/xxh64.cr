require "digest"

class Digest::XXH64 < ::Digest
  extend ClassMethods

  private P1 = 11400714785074694791_u64
  private P2 = 14029467366897019727_u64
  private P3 = 1609587929392839161_u64
  private P4 = 9650029242287828579_u64
  private P5 = 2870177450012600261_u64

  @seed   : UInt64
  @digest : UInt64

  @len : UInt32 = 0
  @buf : Slice(UInt8)
  
  @v0 : UInt64
  @v1 : UInt64
  @v2 : UInt64
  @v3 : UInt64
  
  def initialize(seed = 0)
    @seed = UInt64.new(seed)
    @digest = 0
    
    sp2 = @seed &+ P2
    @v0 = (sp2 &+ P1)
    @v1 =  sp2
    @v2 = (@seed)
    @v3 = (@seed &- P1)

    @len = 0
    @buf = Bytes.new(0)
  end

  # Stores the output digest of #digest_size bytes in dst.
  def final_impl(dst : Bytes) : Nil
    @digest = digest_hash()

    dst[0] = (@digest >> 56).to_u8!
    dst[1] = (@digest >> 48).to_u8!
    dst[2] = (@digest >> 40).to_u8!
    dst[3] = (@digest >> 32).to_u8!
    dst[4] = (@digest >> 24).to_u8!
    dst[5] = (@digest >> 16).to_u8!
    dst[6] = (@digest >> 8).to_u8!
    dst[7] = (@digest).to_u8!
  end

  # Resets the object to it's initial state,
  # so a new digest can be generated.
  private def reset_impl() : Nil
    sp2 = @seed &+ P2
    @v0 = (sp2 &+ P1)
    @v1 =  sp2
    @v2 = (@seed)
    @v3 = (@seed &- P1)

    @len = 0
    @buf = Bytes.new(0)
  end

  # Returns the digest output size in bytes.
  # XXH64 is a 64-bit digest, so the size is 8 bytes.
  def digest_size() : Int32
    8
  end
  
  # Incremental hashing.
  #
  # TODO: This could go a little faster by using module division
  # of 32 to determine how many 32 bytes segments to loop over,
  # instead of using an `if` check each cycle.
  private def update_impl(data : Bytes) : Nil
    data = @buf + data
    
    loop do
      if data.size >= 32
        slice32 = data[0,32] # get the first 32 bytes
        data += 32           # everything after 32 bytes
        @len += 32
        {% for i in 0..3 %}
          v = @v{{i}} &+ b2i64({{i*8}}, slice32) &* P2
          v = rotl(v, 31) &* P1
          @v{{i}} = v
        {% end %}
      else
        @buf = data
        break
      end
    end
  end

  # The final_imp method calls this to get the final digest as a UInt64,
  # which it then turns into Bytes.
  #
  # NOTE: I would think this would be a private method, byt Cyrstal raises
  #       and error if it is.
  
  private def digest_hash()
    buf = @buf
    
    if @len >= 32
      hash = rotl(@v0, 1)  &+
             rotl(@v1, 7)  &+
             rotl(@v2, 12) &+
             rotl(@v3, 18)

      {% for i in 0..3 %}
        v = rotl(@v{{i}} &* P2, 31)
        hash ^= v &* P1
        hash = hash &* P1 &+ P4
      {% end %}
    else
      hash = @seed &+ P5
    end

    @len += buf.size

    ptr = buf.size
    
    hash = hash &+ @len

    p = 0
    while p <= (ptr - 8)
      mem = rotl(b2i64(p, buf) &* P2, 31)

      hash ^= mem &* P1
      hash = rotl(hash, 27) &* P1 &+ P4

      p += 8
    end

    while p <= (ptr - 4)
      mem = b2i32(p, buf)

      hash ^= mem &* P1
      hash = rotl(hash, 23) &* P2 &+ P3

      p += 4
    end

    while p < ptr
      hash ^= buf[p].to_u64 &* P5
      hash = rotl(hash, 11) &* P1
      p += 1
    end

    hash ^= hash >> 33
    hash = hash &* P2
    hash ^= hash >> 29
    hash = hash &* P3
    hash ^= hash >> 32

    hash
  end

  # Get the digest as an ordinary integer, rather than
  # a colleciton of bytes.
  def to_u64
    digest_hash
  end

  private def b2i64(idx, buff)
    (buff.to_unsafe + idx).unsafe_as(Pointer(UInt64)).value
  end

  private def b2i32(idx, buff)
    (buff.to_unsafe + idx).unsafe_as(Pointer(UInt32)).value.to_u64
  end

  # apply byte rotation for a 32 bits buffer
  private def rotl(buffer, offset)
    (buffer << offset) | (buffer >> (64 - offset))
  end

end
