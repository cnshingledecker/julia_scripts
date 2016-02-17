#=
This is a script that renumbers the IDs for reactions in a chemical network
The script takes 2 arguments, the first of which is the file to be renumbered, 
and the second is the number to start to count at (inclusive).
=#

infile = open(ARGS[1])
outfile = open("renumbered_$(ARGS[1])","w")
start  = int(ARGS[2])

println("The infile is $(ARGS[1])")
println("The outfile is renumbered_$(ARGS[1])")
println("The starting number is $(ARGS[2])")

num = start
for ln in eachline(infile)
#  println(ln)
  newln = ln
  numstr = @sprintf("%5d",num)
  outline = "$(newln[1:166])$numstr$(newln[172:end])"
  write(outfile,outline)
  num = num + 1
end

close(infile)
close(outfile)

