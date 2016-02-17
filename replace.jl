#= 
This is a script that searches some file for a string and replaces 
said string with another. In this case, the file is usually a
chemical network and the string is a species name. 
=#


species = ARGS[1]
println("Species is $species")

newspecies = ARGS[2]
println("New species is $newspecies")

if ( ARGS[3] == "grain" )
  basefile = "grain_reactions.in"
  network = open("$(species)_$(basefile)")
  grainsp = "J$species"
  newgrain = "J$(newspecies)"
elseif ( ARGS[3] == "gas" )
  basefile = "gas_reactions.in"
  network = open("$(species)_$(basefile)")
end

outfile = open("$(newspecies)_$(basefile)","w")

for ln in eachline(network)
  newln = replace(ln,species,newspecies)
# apparently, replace() is smart enough to 
# not care if there is a J in front of the 
# string
#  if ( ARGS[3] == "grain" ) 
#    newln = replace(newln,grainsp,newgrain)
#  end
  println(newln)
  write(outfile,newln)
end

close(network)
close(outfile)
