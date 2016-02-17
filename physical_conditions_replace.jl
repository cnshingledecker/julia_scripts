filename = "ff_collapse.d"
infile = open(filename)
ρ      = 1.0E4
av     = 10.0E0
temp   = 10.0E0

outfile = open("isochoric_$filename","w")
for ln in eachline(infile)
#  println(ln)
  newln = ln
  ρ_str = @sprintf("%14.6E",ρ)
  av_str = @sprintf("%14.6E",av)
  temp_str = @sprintf("%14.6E",temp)
  println(ρ_str,av_str,temp_str)
  outline = "$(newln[1:14])$(ρ_str)$(av_str)$(temp_str)\n"
  write(outfile,outline)
end

close(infile)
close(outfile)

