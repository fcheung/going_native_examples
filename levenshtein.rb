require 'inline'
class Levenshtein
  class << self
    include Inline
    
    def slow(s1, s2)
      (1..s1.length).inject((0..s2.length).to_a) do |previous_row, i|      
        (0..s2.length).inject([]) do |row_in_progress, j|
          if j > 0
            cost =  s1[i-1] == s2[j-1] ? 0 : 1
            row_in_progress << [previous_row[j] + 1, row_in_progress[j-1] + 1, previous_row[j-1] + cost].min
          else
            row_in_progress << 0
          end
        end
      end.last
    end 
  end


  begin 
    inline :C do |builder|
      builder.c_singleton <<CSRC
      long distance(char * s1, char *s2)
      {
        size_t i, j;
        size_t rows = strlen(s1) + 1;
        size_t columns = strlen(s2) + 1;

        size_t *current_row = (size_t*) malloc(sizeof(size_t)* columns);
        size_t *previous_row = (size_t*) malloc(sizeof(size_t)* columns);

        /*setup initial row*/
        for(i=0;i<columns;i++) current_row[i]=i;

        for(i=1; i< rows;i++)
        {
          /*make previous row the old current row*/
          size_t *swap = current_row;
          current_row = previous_row;
          previous_row = swap;

          /*zero out and init current_row*/
          memset(current_row, 0, sizeof(size_t)*columns);
          current_row[0]= i;

          for(j = 1; j< columns; j++)
          {
            int cost = 0;
            if( s1[i-1] != s2[j-1])
              cost = 1;
            /*set current[j] to the minimum of these 3 things*/
            size_t value = previous_row[j] + 1;
            if(current_row[j-1] + 1 < value)
              value = current_row[j-1] + 1;
            if(previous_row[j-1] + cost < value)
              value = previous_row[j-1] + cost;
  
            current_row[j]=value;
          }
        }
        size_t result = current_row[columns-1];
        free(current_row);
        free(previous_row);
        return result;
      }
CSRC
    end
  rescue CompilationError
    puts "Warning: falling back to ruby version of Levenshtein: slow"
    singleton_class.send :alias_method, :distance, :slow
  end
end


require 'benchmark'
include Benchmark

alphabet = ('a'..'z').to_a
strings = 100.times.collect {alphabet.sample(10).join}

bmbm(5) do |x|
  x.report("native") do
    strings.each do |s1|
      strings.each do |s2|
        Levenshtein.distance(s1,s2)
      end
    end
  end

  x.report("ruby") do
    strings.each do |s1|
      strings.each do |s2|
        Levenshtein.slow(s1,s2)
      end
    end
  end
end
     
