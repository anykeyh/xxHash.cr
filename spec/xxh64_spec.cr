require "./spec_helper"
require "../src/digest/xxh64"

module XXH64Spec
  # See https://asecuritysite.com/encryption/xxHash

  # Case A > 32 characters fill buffer

  it "Returns digest for filled buffer" do
    data = "Nobody inspects the spammish repetition"
    resl = 0xfbcea83c8a378bf1_u64

    computed64 = Digest::XXH64.new
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end 

  it "Returns correct digest for filled buffer given a seed" do
    data = "Nobody inspects the spammish repetition"
    seed = 1234
    resl = 0x55e30cd248a5419f_u64

    computed64 = Digest::XXH64.new(seed)
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end

  # Case B < 32 chracters no buffer filled

  it "Returns correct digest when buffer is not filled" do
    data = "small"
    resl = 0xa8ce38f99756b7b3_u64

    computed64 = Digest::XXH64.new
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end

  it "Returns correct digest when buffer is not filled given a seed" do
    data = "small"
    seed = 1234
    resl = 0x3709561c2893a1d0_u64

    computed64 = Digest::XXH64.new(seed)
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end

  # Case C - empty string

  it "Returns correct digest for empty string" do
    data = ""
    resl = 0xef46db3751d8e999_u64

    computed64 = Digest::XXH64.new
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end

  it "Returns correct digest for empty string give a seed" do
    data = ""
    seed = 1234
    resl = 0xe80dc1ad52e210e4_u64

    computed64 = Digest::XXH64.new(seed)
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end

  # Case D - a long string

  it "Returns correct digest for long string" do
    data = "Cras dignissim sem sed euismod pretium. Sed facilisis diam dolor. Curabitur turpis ex, euismod vel est ut, pharetra condimentum lacus. Sed eget aliquet tellus, in vestibulum tellus. Duis tellus tortor, porttitor nec arcu quis, tristique lobortis neque. Cras pharetra, sem in vestibulum mollis, dui elit vulputate nulla, eget egestas elit tellus in leo. Proin fermentum eros nec dolor dictum rutrum. Curabitur quam lacus, posuere non turpis sit amet, gravida molestie augue. Vestibulum nec venenatis purus. Pellentesque vestibulum nunc ut libero pharetra, ut egestas odio hendrerit. Duis euismod ipsum leo, id lacinia massa ultricies eu. In congue venenatis tristique. In ullamcorper augue quam, id pretium ex dictum id. Morbi blandit eleifend neque, quis pulvinar neque dignissim at. Integer sodales diam ac metus maximus, sed cursus risus commodo."
    resl = 0x27b8f6a015650fb5_u64

    computed64 = Digest::XXH64.new
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end

  it "Returns correct digest for long string given a seed" do
    data = "Cras dignissim sem sed euismod pretium. Sed facilisis diam dolor. Curabitur turpis ex, euismod vel est ut, pharetra condimentum lacus. Sed eget aliquet tellus, in vestibulum tellus. Duis tellus tortor, porttitor nec arcu quis, tristique lobortis neque. Cras pharetra, sem in vestibulum mollis, dui elit vulputate nulla, eget egestas elit tellus in leo. Proin fermentum eros nec dolor dictum rutrum. Curabitur quam lacus, posuere non turpis sit amet, gravida molestie augue. Vestibulum nec venenatis purus. Pellentesque vestibulum nunc ut libero pharetra, ut egestas odio hendrerit. Duis euismod ipsum leo, id lacinia massa ultricies eu. In congue venenatis tristique. In ullamcorper augue quam, id pretium ex dictum id. Morbi blandit eleifend neque, quis pulvinar neque dignissim at. Integer sodales diam ac metus maximus, sed cursus risus commodo."
    seed = 1234
    resl = 0x1cf0478f6499f2ae_u64

    computed64 = Digest::XXH64.new(seed)
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end

  # Case E - exactly 16 bytes

  it "Returns correct digest for exactly 16 bytes" do
    data = "1234567890abcdef"
    resl = 0x1b576a0cfae1707e_u64

    computed64 = Digest::XXH64.new
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end

  it "Returns correct digest for exactly 16 bytes give a seed" do
    data = "1234567890abcdef"
    seed = 1234
    resl = 0x0a176fa30c839a45_u64

    computed64 = Digest::XXH64.new(seed)
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end

  # Case F - exactly 32 bytes

  it "Returns correct digest for exactly 32 bytes" do
    data = "1234567890abcdef1234567890abcdef"
    resl = 0xc1bf3856a435f3ec_u64

    computed64 = Digest::XXH64.new
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end

  it "Returns correct digest for exactly 32 bytes give a seed" do
    data = "1234567890abcdef1234567890abcdef"
    seed = 1234
    resl = 0x3e450250700580a0_u64

    computed64 = Digest::XXH64.new(seed)
    computed64 << data
    computed64.to_u64.should eq resl
    computed64.reset
  end

end
