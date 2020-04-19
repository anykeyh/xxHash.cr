require "./spec_helper"

CASES = [
  # Case A > 32 characters fill buff for 32 and 64 bits versions
  {"Nobody inspects the spammish repetition", 0, 0xe2293b2f, 0xfbcea83c8a378bf1},
  {"Nobody inspects the spammish repetition", 1234, 0x298ce4e5, 0x55e30cd248a5419f}, #https://asecuritysite.com/encryption/xxHash

  # Case B < 16 characters no buffer filled
  {"small", 0, 0x8e52cd6a, 0xa8ce38f99756b7b3},
  {"small", 1234, 0x1acf736b, 0x3709561c2893a1d0},

  # Case C empty string
  {"", 0, 0x02cc5d05, 0xef46db3751d8e999},
  {"", 1234, 0xb625a4db, 0xe80dc1ad52e210e4},

  # Case D a long string
  {"Cras dignissim sem sed euismod pretium. Sed facilisis diam dolor. Curabitur turpis ex, euismod vel est ut, pharetra condimentum lacus. Sed eget aliquet tellus, in vestibulum tellus. Duis tellus tortor, porttitor nec arcu quis, tristique lobortis neque. Cras pharetra, sem in vestibulum mollis, dui elit vulputate nulla, eget egestas elit tellus in leo. Proin fermentum eros nec dolor dictum rutrum. Curabitur quam lacus, posuere non turpis sit amet, gravida molestie augue. Vestibulum nec venenatis purus. Pellentesque vestibulum nunc ut libero pharetra, ut egestas odio hendrerit. Duis euismod ipsum leo, id lacinia massa ultricies eu. In congue venenatis tristique. In ullamcorper augue quam, id pretium ex dictum id. Morbi blandit eleifend neque, quis pulvinar neque dignissim at. Integer sodales diam ac metus maximus, sed cursus risus commodo.", 0, 0xbc702865, 0x27b8f6a015650fb5 },
  {"Cras dignissim sem sed euismod pretium. Sed facilisis diam dolor. Curabitur turpis ex, euismod vel est ut, pharetra condimentum lacus. Sed eget aliquet tellus, in vestibulum tellus. Duis tellus tortor, porttitor nec arcu quis, tristique lobortis neque. Cras pharetra, sem in vestibulum mollis, dui elit vulputate nulla, eget egestas elit tellus in leo. Proin fermentum eros nec dolor dictum rutrum. Curabitur quam lacus, posuere non turpis sit amet, gravida molestie augue. Vestibulum nec venenatis purus. Pellentesque vestibulum nunc ut libero pharetra, ut egestas odio hendrerit. Duis euismod ipsum leo, id lacinia massa ultricies eu. In congue venenatis tristique. In ullamcorper augue quam, id pretium ex dictum id. Morbi blandit eleifend neque, quis pulvinar neque dignissim at. Integer sodales diam ac metus maximus, sed cursus risus commodo.", 1234, 0x0f8da06d, 0x1cf0478f6499f2ae },

  # Case E exactly 16 bytes
  {"1234567890abcdef", 0, 0x17fddd25, 0x1b576a0cfae1707e },
  {"1234567890abcdef", 1234, 0x3c299461, 0x0a176fa30c839a45 },

  # Case F exactly 32 bytes
  {"1234567890abcdef1234567890abcdef", 0, 0xf11e8d8c, 0xc1bf3856a435f3ec },
  {"1234567890abcdef1234567890abcdef", 1234, 0x80105224, 0x3e450250700580a0 },

]
module XXHashSpec
  it "returns correct hash" do
    CASES.each do |(str, seed, expected32, expected64)|
      computed32 = XXHash::Hash32.new(seed).digest(str)
      computed32.should eq expected32

      computed64 = XXHash::Hash64.new(seed).digest(str)
      computed64.should eq expected64
    end
  end
end