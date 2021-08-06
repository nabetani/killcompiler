# CC="gcc-7"
# CC="gcc-11"
CC="clang"

def test_aster(n)
  aster = "*"*n
  src=<<~"SRC"
  #include <stdio.h>
  #include <stdlib.h>
  #include <stddef.h>

  int main()
  {
      intptr_t #{aster}a;
      *(intptr_t*)&a = (intptr_t)&a;
      printf("a=%p, *..*a=%jd\\n", a, #{aster}a);
      return 0;
  }
  SRC

  File.open( "hoge.c", "w" ){ |f| f.puts(src) }
  puts %x((time #{CC} -O0 hoge.c ) && time ./a.out)
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
