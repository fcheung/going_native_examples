#include "rice/Class.hpp"
#include "rice/String.hpp"
#include "rice/Constructor.hpp"

using namespace Rice;

class Person {
  public:
    Person():m_name(""){}
    const std::string& get_name() const{
        return m_name;
    }
    
    void set_name(const std::string& new_name){
        m_name = new_name;
    }
    void assimilate(Person other){
    }
  private:
    std::string m_name;  
};

extern "C"
void Init_person(){
    Data_Type<Person> rb_cPerson =
    define_class<Person>("Person").
      define_constructor(Constructor<Person>()).
      define_method("name", &Person::get_name).
      define_method("name=",&Person::set_name).
      define_method("assimilate", &Person::assimilate);
}