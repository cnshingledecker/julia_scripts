filename = "ff_collapse.d"
infile = open(filename)
ρ      = log(1.0E4)
av     = log(10.0E0)
temp   = log(10.0E0)

outfile = open("new_isochoric_$filename","w")
header1 = "! time    log(Av)    log(n)    log(T)   \n"
header2 = "! (yr)   (mag)      (cm-3)    (K)      \n"
write(outfile,header1)
write(outfile,header2)
for ln in eachline(infile)
#  println(ln)
  newln = ln
  ρ_str = @sprintf("%9.3e",ρ)
  av_str = @sprintf("%9.3e",av)
  temp_str = @sprintf("%9.3e",temp)
  new_time = "$(newln[3:14])"
  new_time = float(new_time)
  time_str = @sprintf("%9.3e",new_time)
  println(time_str,ρ_str,av_str,temp_str)
  outline = "$(time_str)  $(ρ_str) $(av_str) $(temp_str)\n"
  write(outfile,outline)
end

close(infile)
close(outfile)

