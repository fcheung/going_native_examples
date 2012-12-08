require 'ffi'
module C
  extend FFI::Library
  ffi_lib 'c'
  attach_function 'puts',
                  [:string], 
                  :int
end
C.puts "Hello world"
