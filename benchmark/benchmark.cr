require "../src/xx_hash"
require "benchmark"

STR_16 = "0123456789abcdef"
STR_32 = "0123456789abcdef0123456789abcdef"

def create_1giga_string
  String.new(Bytes.new(size: 1024*1024*1024){ Random.rand(0x00..0xff).to_u8 })
end

Benchmark.ips do |x|
  long_text = create_1giga_string

  x.report("32bits 16 bytes string") {  XXHash.hash32(STR_16) }
  x.report("64bits 16 bytes string") {  XXHash.hash64(STR_16) }

  x.report("32bits 32 bytes string") {  XXHash.hash32(STR_32) }
  x.report("64bits 32 bytes string") {  XXHash.hash64(STR_32) }

  x.report("32bits 1GB string") {  XXHash.hash32(long_text) }
  x.report("64bits 1GB string") {  XXHash.hash64(long_text) }
end