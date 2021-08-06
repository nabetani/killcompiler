CXX="g++-7"
# CXX="g++-11"
# CXX="clang++"

def test_aster(n)
  aster = "*"*n
  src=<<~"SRC"
  #include <cstdio>
  #include <cstdlib>

  int main()
  {
      unsigned long long a=0;
      #{"++"*n} a;
      printf("a=%llu\\n", a);
      return 0;
  }
  SRC

  File.open( "fuga.cpp", "w" ){ |f| f.puts(src) }
  puts %x((time #{CXX} -O0 fuga.cpp ) && time ./a.out)
  puts( "n=#{n}  err = #{$?}")
  $?==0
end

n=1
loop do
  break unless test_aster(n)
  n*=2
end

a = [*(n/2)..n]
p(a.bsearch do |n|
  !test_aster(n)
end)
