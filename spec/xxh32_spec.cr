require "./spec_helper"
require "../src/digest/xxh32"

module XXH32Spec
  # See https://asecuritysite.com/encryption/xxHash
  
  # Case A > 32 characters fill buffer
  
  it "Returns digest for filled buffer" do
    data = "Nobody inspects the spammish repetition"
    resl = 0xe2293b2f_u32

    computed32 = Digest::XXH32.new
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
  end

  it "Returns correct digest for filled buffer given a seed" do
    data = "Nobody inspects the spammish repetition"
    seed = 1234
    resl = 0x298ce4e5_u32 

    computed32 = Digest::XXH32.new(seed)
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
   end
  
  # Case B < 16 characters no buffer filled
  
  it "Returns correct digest when buffer is not full" do
    data = "small"
    resl = 0x8e52cd6a_u32
    
    computed32 = Digest::XXH32.new
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
  end
  
  it "Returns correct digest when buffer is not full given a seed" do
    data = "small"
    seed = 1234
    resl = 0x1acf736b_u32

    computed32 = Digest::XXH32.new(seed)
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
  end
  
  # Case C empty string

  it "Returns correct digest for empty string" do
    data = ""
    resl = 0x02cc5d05_u32

    computed32 = Digest::XXH32.new
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
   end

  it "return correct digest for empty string given a seed" do
    data = ""
    seed = 1234
    resl = 0xb625a4db_u32

    computed32 = Digest::XXH32.new(seed)
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
   end

  # Case D a long string

  it "Returns correct digest for long string" do
    data = "Cras dignissim sem sed euismod pretium. Sed facilisis diam dolor. Curabitur turpis ex, euismod vel est ut, pharetra condimentum lacus. Sed eget aliquet tellus, in vestibulum tellus. Duis tellus tortor, porttitor nec arcu quis, tristique lobortis neque. Cras pharetra, sem in vestibulum mollis, dui elit vulputate nulla, eget egestas elit tellus in leo. Proin fermentum eros nec dolor dictum rutrum. Curabitur quam lacus, posuere non turpis sit amet, gravida molestie augue. Vestibulum nec venenatis purus. Pellentesque vestibulum nunc ut libero pharetra, ut egestas odio hendrerit. Duis euismod ipsum leo, id lacinia massa ultricies eu. In congue venenatis tristique. In ullamcorper augue quam, id pretium ex dictum id. Morbi blandit eleifend neque, quis pulvinar neque dignissim at. Integer sodales diam ac metus maximus, sed cursus risus commodo."
    resl = 0xbc702865_u32

    computed32 = Digest::XXH32.new
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
   end

  it "Returns correct digest for long string given a seed" do
    data = "Cras dignissim sem sed euismod pretium. Sed facilisis diam dolor. Curabitur turpis ex, euismod vel est ut, pharetra condimentum lacus. Sed eget aliquet tellus, in vestibulum tellus. Duis tellus tortor, porttitor nec arcu quis, tristique lobortis neque. Cras pharetra, sem in vestibulum mollis, dui elit vulputate nulla, eget egestas elit tellus in leo. Proin fermentum eros nec dolor dictum rutrum. Curabitur quam lacus, posuere non turpis sit amet, gravida molestie augue. Vestibulum nec venenatis purus. Pellentesque vestibulum nunc ut libero pharetra, ut egestas odio hendrerit. Duis euismod ipsum leo, id lacinia massa ultricies eu. In congue venenatis tristique. In ullamcorper augue quam, id pretium ex dictum id. Morbi blandit eleifend neque, quis pulvinar neque dignissim at. Integer sodales diam ac metus maximus, sed cursus risus commodo."
    seed = 1234
    resl = 0x0f8da06d_u32

    computed32 = Digest::XXH32.new(seed)
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
   end
  
  # Case E exactly 16 bytes

  it "Returns correct digest for exactly 16 bytes" do  
    data = "1234567890abcdef"
    resl = 0x17fddd25_u32

    computed32 = Digest::XXH32.new
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
  end

  it "Retuns correct digest for exactly 16 bytes given a seed" do
    data = "1234567890abcdef"
    seed = 1234
    resl = 0x3c299461

    computed32 = Digest::XXH32.new(seed)
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
   end
  
  # Case F exactly 32 bytes

  it "Returns the correct digest for exactly 32 bytes" do
    data = "1234567890abcdef1234567890abcdef"
    resl = 0xf11e8d8c_u32

    computed32 = Digest::XXH32.new
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
   end

  it "Returns to correct digest for exactly 32 bytes given a seed" do
    data = "1234567890abcdef1234567890abcdef"
    seed = 1234
    resl = 0x80105224_u32

    computed32 = Digest::XXH32.new(seed)
    computed32 << data
    computed32.to_u32.should eq resl
    computed32.reset
   end

end
