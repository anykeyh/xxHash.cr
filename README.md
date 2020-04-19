# xx_hash.cr

Pure Crystal implementation of [xxHash](https://github.com/Cyan4973/xxHash) 32 and 64 bits.

## Usage

```crystal
  require "xx_hash"

  # Methods are:
  # XXHash#hash32(input : IO|String, seed : UInt32 = 0)
  # XXHash#hash64(input : IO|String, seed : UInt64 = 0)

  # Examples:
  XXHash.hash32("My String")
  seed = 1234
  XXHash.hash32("My String", seed)

  seed = 1234
  File.open("somefile") do |f|
    XXHash.hash64(f, seed)
  end

```

## Performance

Test done on VM Linux with Intel i7-8750H CPU:

```
32bits 16 bytes string  29.92M ( 33.42ns) (± 6.74%)  96.0B/op             fastest
64bits 16 bytes string  28.40M ( 35.21ns) (± 7.37%)  96.0B/op        1.05× slower
32bits 32 bytes string  24.58M ( 40.68ns) (±10.96%)  96.0B/op        1.22× slower
64bits 32 bytes string  28.37M ( 35.24ns) (± 6.98%)  96.0B/op        1.05× slower
     32bits 1GB string   3.98  (251.37ms) (±12.14%)   197B/op  7521669.55× slower
     64bits 1GB string   7.49  (133.49ms) (± 8.07%)  99.0B/op  3994360.51× slower
```

That's about 7.49 GBPS throughput on this machine, probably 30 to 50% slower than C version

## Installation

Add to your shard.yml:

```yaml
  dependencies:
    xx_hash:
      github: anykeyh/xx_hash
```
