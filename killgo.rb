# CC="gcc-7"
# CC="gcc-11"
CC="clang"

def test_aster(n)
  aster = "*"*n
  src=<<~"SRC"
    package main

    import (
      "log"
      "unsafe"
    )
    
    func main() {
      var p #{aster}uintptr
      x := (uintptr)((unsafe.Pointer)(&p))
      *(*uintptr)((unsafe.Pointer)(&p)) = x
      log.Println(#{aster}p)
    }
    SRC

  Dir.chdir("go") do
    File.open( "main.go", "w" ){ |f| f.puts(src) }
    puts %x(time go run main.go)
    puts("n=#{n}  err = #{$?}")
  end
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
