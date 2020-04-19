module XXHash
  struct Hash64
    private P1 = 11400714785074694791_u64
    private P2 = 14029467366897019727_u64
    private P3 = 1609587929392839161_u64
    private P4 = 9650029242287828579_u64
    private P5 = 2870177450012600261_u64

    @len : UInt32 = 0
    @ptr : Int32 = 0

    @v0 : UInt64
    @v1 : UInt64
    @v2 : UInt64
    @v3 : UInt64

    @seed : UInt64

    def initialize(seed)
      @seed = UInt64.new(seed)

      sp2 = @seed &+ P2
      @v0 = (sp2 &+ P1)
      @v1 =  sp2
      @v2 = (@seed)
      @v3 = (@seed &- P1)

      @len = 0
      @ptr = 0
    end

    private def update_impl(bytes : Bytes, size)
      @len += size

      if size == 32 # Full buffer
        {% for i in 0..3 %}
          v = @v{{i}} &+ b2i64({{i*8}}, bytes) &* P2
          v = rotl(v, 31) &* P1
          @v{{i}} = v
        {% end %}
      else # End of stream
        @ptr = size
      end

    end

    protected def update(io, slice)
      loop do
        len = io.read(slice)
        break if len == 0
        update_impl(slice, len)
      end
    end

    def digest(s : String)
      digest(IO::Memory.new(s))
    end

    def digest(io)
      buffer = uninitialized UInt8[32]
      slice = buffer.to_slice

      update(io, slice)

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

      hash = hash &+ @len

      p = 0
      while p <= (@ptr - 8)
        mem = rotl(b2i64(p, slice) &* P2, 31)

        hash ^= mem &* P1
        hash = rotl(hash, 27) &* P1 &+ P4

        p += 8
      end

      while p <= (@ptr - 4)
        mem = b2i32(p, slice)

        hash ^= mem &* P1
        hash = rotl(hash, 23) &* P2 &+ P3

        p += 4
      end

      while p < @ptr
        hash ^= slice[p].to_u64 &* P5
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
end