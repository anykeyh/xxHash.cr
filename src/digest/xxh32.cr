require "digest"

class Digest::XXH32 < ::Digest
  extend ClassMethods

  private P1 = 2654435761_u32
  private P2 = 2246822519_u32
  private P3 = 3266489917_u32
  private P4 = 668265263_u32
  private P5 = 374761393_u32

  @seed   : UInt32 = 0
  @digest : UInt32 = 0
  
  @len    : UInt32 = 0
  @buf    : Slice(UInt8)
  
  @v0 : UInt32 = 0
  @v1 : UInt32 = 0
  @v2 : UInt32 = 0
  @v3 : UInt32 = 0

  def initialize(seed = 0)
    @seed = UInt32.new(seed)
    @digest = 0
    
    sp2 = @seed &+ P2

    @v0 = (sp2 &+ P1)
    @v1 = sp2
    @v2 = (@seed)
    @v3 = (@seed &- P1)

    @len = 0
    @buf = Bytes.new(0)
  end

  # Store the output digest of #digest_size bytes in dst.
  def final_impl(dst : Bytes) : Nil
    @digest = digest_hash()

    dst[0] = (@digest >> 24).to_u8!
    dst[1] = (@digest >> 16).to_u8!
    dst[2] = (@digest >> 8).to_u8!
    dst[3] = (@digest).to_u8!
  end

  # Resets the object to it's initial state,
  # so a new digest can be generated.
  private def reset_impl() : Nil
    sp2 = @seed &+ P2

    @v0 = (sp2 &+ P1)
    @v1 = sp2
    @v2 = (@seed)
    @v3 = (@seed &- P1)

    @len = 0
    @buf = Bytes.new(0)
  end

  # Returns the digest output size in bytes.
  # XXH32 is a 32-bit digest, so the size is 4 bytes.
  def digest_size() : Int32
    4
  end

  # Incremental hashing.
  #
  # TODO: Use modulo.
  private def update_impl(data : Bytes) : Nil
    data = @buf + data

    loop do
      if data.size >= 16
        slice16 = data[0,16]
        data += 16
        @len += 16
        {% for i in 0..3 %}
          v = @v{{i}} &+ b2i32({{i*4}}, slice16) &* P2
          v = rotl(v, 13) &* P1
          @v{{i}} = v
        {% end %}
      else
        @buf = data
        break
      end
    end
  end

  #

  private def digest_hash()
    buf = @buf
    
    if @len >= 16
      hash = rotl(@v0, 1)  &+
             rotl(@v1, 7)  &+
             rotl(@v2, 12) &+
             rotl(@v3, 18)
    else
      hash = @seed &+ P5
    end

    @len += buf.size

    ptr = buf.size

    hash = hash &+ @len

    p = 0
    while p <= (ptr - 4)
      mem = b2i32(p, buf)
      hash = hash &+ mem &* P3
      hash = rotl(hash, 17) &* P4
      p += 4
    end

    while p < ptr
      hash = hash &+ buf[p].to_u32 &* P5
      hash = rotl(hash, 11) &* P1
      p += 1
    end

    hash ^= hash >> 15
    hash = hash &* P2
    hash ^= hash >> 13
    hash = hash &* P3
    hash ^= hash >> 16

    hash
  end

  # Get the digest as an originary unsigned integer, rather
  # than a collection of bytes.
  def to_u32
   digest_hash
  end

  private def b2i32(idx, bytes)
    (bytes.to_unsafe + idx).unsafe_as(Pointer(UInt32)).value
  end

  # apply byte rotation for a 32 bits buffer
  private def rotl(buffer, offset)
    (buffer << offset) | (buffer >> (32 - offset))
  end

end  

