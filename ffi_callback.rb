require 'ffi'

class FFI::Pointer
  unless defined?(put_array_of_int32)
#some implementations don't define these size specific pointer accessors
    def put_array_of_int32 offset, ints
      write_array_of_int ints
    end

    def get_array_of_int32 offset, ints
      read_array_of_int ints
    end
    
    def get_int32(offset)
      read_int
    end
  end
end

module LibC
  extend FFI::Library
  if defined?(FFI::Library::CURRENT_PROCESS)
    ffi_lib FFI::Library::CURRENT_PROCESS
  else
    ffi_lib FFI::Library::LIBC
  end
  
  callback :qsort_cmp, [ :pointer, :pointer ], :int
  attach_function :qsort, [ :pointer, :ulong, :ulong, :qsort_cmp ], :int
end
def sort(array_of_ints)
  p = FFI::MemoryPointer.new(:int32, array_of_ints.size)
  p.put_array_of_int32(0, array_of_ints)
  LibC.qsort(p, array_of_ints.size, 4) do |p1, p2|
    i1 = p1.get_int32(0)
    i2 = p2.get_int32(0)
    i1 <=> i2
  end
  p.get_array_of_int32(0, array_of_ints.size)
end
puts sort([9,2321, 17,1,32]).inspect

