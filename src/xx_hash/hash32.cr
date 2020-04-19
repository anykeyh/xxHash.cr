module XXHash
  struct Hash32
    private P1 = 2654435761_u32
    private P2 = 2246822519_u32
    private P3 = 3266489917_u32
    private P4 = 668265263_u32
    private P5 = 374761393_u32

    @len : UInt32 = 0
    @ptr : Int32 = 0

    @v0 : UInt32
    @v1 : UInt32
    @v2 : UInt32
    @v3 : UInt32

    @seed : UInt32

    def initialize(seed)
      @seed = UInt32.new(seed)

      sp2 = @seed &+ P2

      @v0 = (sp2 &+ P1)
      @v1 = sp2
      @v2 = (@seed)
      @v3 = (@seed &- P1)

      @len = 0
      @ptr = 0
    end

    private def update_impl(bytes : Bytes, size)
      @len += size

      if size == 16
        {% for i in 0..3 %}
          v = @v{{i}} &+ b2i32({{i*4}}, bytes) &* P2
          v = rotl(v, 13) &* P1
          @v{{i}} = v
        {% end %}
      else
        @ptr = size
      end

    end

    def update(io, slice)
      loop do
        len = io.read(slice)
        break if len == 0
        update_impl(slice, len)
      end

      self
    end

    def digest(s : String)
      digest(IO::Memory.new(s))
    end

    def digest(io)
      buffer = uninitialized UInt8[16]
      slice = buffer.to_slice

      update(io, slice)

      if @len >= 16
        hash = rotl(@v0, 1)  &+
               rotl(@v1, 7)  &+
               rotl(@v2, 12) &+
               rotl(@v3, 18)
      else
        hash = @seed &+ P5
      end

      hash = hash &+ @len

      p = 0
      while p <= (@ptr - 4)
        mem = b2i32(p, slice)
        hash = hash &+ mem &* P3
        hash = rotl(hash, 17) &* P4
        p += 4
      end

      while p < @ptr
        hash = hash &+ slice[p].to_u32 &* P5
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

    private def b2i32(idx, bytes)
      (bytes.to_unsafe + idx).unsafe_as(Pointer(UInt32)).value
    end

    # apply byte rotation for a 32 bits buffer
    private def rotl(buffer, offset)
      (buffer << offset) | (buffer >> (32 - offset))
    end

  end
end