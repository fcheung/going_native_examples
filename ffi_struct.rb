require 'ffi'

module LibC
  extend FFI::Library
  ffi_lib FFI::Library::LIBC
  
  class Timezone < FFI::Struct
    layout :tz_minuteswest, :int,
           :tz_dsttime, :int
  end
  
  class Timeval < FFI::Struct
    layout :tv_sec, :time_t,
           :tv_usec, :suseconds_t 
  end
  
  attach_function :gettimeofday, [Timeval, Timezone], :int
end

out = LibC::Timeval.new
LibC.gettimeofday(out, nil)
puts "the time according to libc is #{out[:tv_sec]}"