require 'ffi'
module CF
  extend FFI::Library
  ffi_lib '/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation'
  attach_function 'CFStringCreateWithCString',
                  [:pointer, :string, :long_long], 
                  :pointer
  attach_function :CFShow, 
                  [:pointer],
                  :void
end
cf_string = CF.CFStringCreateWithCString(nil, "Hello world", 0x08000100)
CF.CFShow(cf_string)
