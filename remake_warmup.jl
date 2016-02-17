filename = "warm_up.d"
infile = open(filename)
start_time = 0.422949E7

outfile = open("new_$(filename)at","w")
old_time_str = ""
for ln in eachline(infile)
#  println(ln)
  newln = ln

  new_time = "$(newln[3:14])"
  new_ρ    = "$(newln[17:28])"
  new_av   = "$(newln[31:42])"
  new_temp = "$(newln[45:56])"

  old_time = float(new_time)
  new_time = old_time + start_time
  new_av   = log(10.0)
#  new_av   = log(float(new_av))
  new_ρ    = log(float(new_ρ))
  new_temp = log(float(new_temp))

  ρ_str    = @sprintf("%9.3e",new_ρ)
  av_str   = @sprintf("%9.3e",new_av)
  temp_str = @sprintf("%9.3e",new_temp)
  time_str = @sprintf("%9.3e",new_time)

  if ( old_time_str == time_str )
    continue
  else
    println(old_time,ρ_str,av_str,temp_str)
    outline = "$(time_str)  $(ρ_str) $(av_str) $(temp_str)\n"
  end
  write(outfile,outline)
  old_time_str = time_str
end

close(infile)
close(outfile)

