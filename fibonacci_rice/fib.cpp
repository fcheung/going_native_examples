#include "rice/Class.hpp"

using namespace Rice;

long calculate_fibonacci(Object self, long n){
  long result = 1, previous=0;
  for(long i=0; i< n-1;i++){
    long old_previous = previous;
    previous = result;
    result = old_previous + result;
  }
  return result;
}

extern "C"
void Init_fib(){
  Class rb_cTest = define_class("Fibonnaci").
                      define_singleton_method("value", &calculate_fibonacci);
}