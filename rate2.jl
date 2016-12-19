println("Welcome to rate2.jl, where rates for CIRIS are plotted")
using DataFrames
using Gadfly

path = "/scratch/cns7ae/losalamos9/"
outfile = "rates-plot.pdf"
xmax = 1e15
xmin = 1e13
speciesName = "O<sub>3</sub>"
speciesNum  = 7

plottheme = Gadfly.Theme(
    highlight_width=0pt,
    default_point_size=2pt,
    line_width=2pt,
    minor_label_font_size=13pt,
    minor_label_color=colorant"black",
    major_label_font_size=15pt,
    major_label_color=colorant"black",
    key_label_color=colorant"black",
    key_title_color=colorant"black",
    key_title_font_size=8pt,
    key_label_font_size=6pt,
    grid_color=colorant"black")

o_prod_filename  = "o_prod.wsv"
o2_prod_filename = "o2_prod.wsv"
o3_prod_filename = "o3_prod.wsv"
o_dest_filename  = "o_dest.wsv"
o2_dest_filename = "o2_dest.wsv"
o3_dest_filename = "o3_dest.wsv"

ostar_prod_filename  = "ostar_prod.wsv"
o2star_prod_filename = "o2star_prod.wsv"
o3star_prod_filename = "o3star_prod.wsv"
ostar_dest_filename  = "ostar_dest.wsv"
o2star_dest_filename = "o2star_dest.wsv"
o3star_dest_filename = "o3star_dest.wsv"

o_prod_output = path*o_prod_filename
o2_prod_output = path*o2_prod_filename
o3_prod_output = path*o3_prod_filename
o_dest_output = path*o_dest_filename
o2_dest_output = path*o2_dest_filename
o3_dest_output = path*o3_dest_filename

ostar_prod_output = path*ostar_prod_filename
#o2star_prod_output = path*o2star_prod_filename
o3star_prod_output = path*o3star_prod_filename
ostar_dest_output = path*ostar_dest_filename
o2star_dest_output = path*o2star_dest_filename
o3star_dest_output = path*o3star_dest_filename


#=
Generate the dataframes containing the input and output dataframes
=#
println("Generating initial dataframes")

o_prod_reactions = readtable(
    o_prod_output,
    header = true,
    names = [:Count,:Time, :Fluence, :ID, :Label],
    eltypes = [Int64,Float64,Float64,Int64,String]
)

println("Generated o prod")

println("Now reading $o2_prod_output")
o2_prod_reactions = readtable(
    o2_prod_output,
    header = true,
    names = [:Count,:Time, :Fluence, :ID, :Label],
    eltypes = [Int64,Float64,Float64,Int64,String]
)

println("Generated o2 prod")

o3_prod_reactions = readtable(
    o3_prod_output,
    header = true,
    names = [:Count,:Time, :Fluence, :ID, :Label],
    eltypes = [Int64,Float64,Float64,Int64,String]
)

println("Generated o3 prod")

o_dest_reactions = readtable(
    o_dest_output,
    header = true,
    names = [:Count,:Time, :Fluence, :ID, :Label],
    eltypes = [Int64,Float64,Float64,Int64,String]
)

println("Generated o dest")

o2_dest_reactions = readtable(
    o2_dest_output,
    header = true,
    names = [:Count,:Time, :Fluence, :ID, :Label],
    eltypes = [Int64,Float64,Float64,Int64,String]
)

println("Generated o2 dest")

o3_dest_reactions = readtable(
    o3_dest_output,
    header = true,
    names = [:Count,:Time, :Fluence, :ID, :Label],
    eltypes = [Int64,Float64,Float64,Int64,String]
)

println("Generated o3 dest")

println("Now plotting p1")

p1 = plot(
#    destdf[xmax.>destdf[:Fluence].>xmin,:],
    o_prod_reactions,
    x="Fluence",
    y="Count",
    color="Label",
    Geom.line,
#    Geom.smooth(method=:lm,smoothing=0.9),
    Guide.title("O Prod. Reactions"),
    Guide.xlabel("Fluence"),
    Guide.colorkey("Reaction #"),
    Guide.ylabel("Count"),
#    Coord.Cartesian(xmin=fluenceArr[1],xmax=fluenceArr[size(fluenceArr,1)])
    Scale.x_log10(minvalue=xmin,maxvalue=xmax),
#    Scale.y_log10
)


push!(p1,plottheme)
println("Plotted p1")

p2 = plot(
#    destdf[xmax.>destdf[:Fluence].>xmin,:],
    o2_prod_reactions,
    x="Fluence",
    y="Count",
    color="Label",
    Geom.line,
#    Geom.smooth(method=:lm,smoothing=0.9),
    Guide.title("O<sub>2</sub> Prod. Reactions"),
    Guide.xlabel("Fluence"),
    Guide.colorkey("Reaction #"),
    Guide.ylabel("Count"),
#    Coord.Cartesian(xmin=fluenceArr[1],xmax=fluenceArr[size(fluenceArr,1)])
    Scale.x_log10(minvalue=xmin,maxvalue=xmax),
#    Scale.y_log10
)


push!(p2,plottheme)
println("Plotted p2")

p3 = plot(
#    destdf[xmax.>destdf[:Fluence].>xmin,:],
    o3_prod_reactions,
    x="Fluence",
    y="Count",
    color="Label",
    Geom.line,
#    Geom.smooth(method=:loess,smoothing=0.9),
    Guide.title("O<sub>3</sub> Prod. Reactions"),
    Guide.xlabel("Fluence"),
    Guide.colorkey("Reaction #"),
    Guide.ylabel("Count"),
#    Coord.Cartesian(xmin=fluenceArr[1],xmax=fluenceArr[size(fluenceArr,1)])
    Scale.x_log10(minvalue=xmin,maxvalue=xmax),
#    Scale.y_log10
)


push!(p3,plottheme)
println("Plotted p3")

r1 = plot(
#    destdf[xmax.>destdf[:Fluence].>xmin,:],
    o_dest_reactions,
    x="Fluence",
    y="Count",
    color="Label",
    Geom.line,
#    Geom.smooth(method=:lm,smoothing=0.9),
    Guide.title("O Dest. Reactions"),
    Guide.xlabel("Fluence"),
    Guide.colorkey("Reaction #"),
    Guide.ylabel("Count"),
#    Coord.Cartesian(xmin=fluenceArr[1],xmax=fluenceArr[size(fluenceArr,1)])
    Scale.x_log10(minvalue=xmin,maxvalue=xmax),
#    Scale.y_log10
)


push!(r1,plottheme)
println("Plotted r1")

r2 = plot(
#    destdf[xmax.>destdf[:Fluence].>xmin,:],
    o2_dest_reactions,
    x="Fluence",
    y="Count",
    color="Label",
    Geom.line,
#    Geom.smooth(method=:lm,smoothing=0.9),
    Guide.title("O<sub>2</sub> Dest. Reactions"),
    Guide.xlabel("Fluence"),
    Guide.colorkey("Reaction #"),
    Guide.ylabel("Count"),
#    Coord.Cartesian(xmin=fluenceArr[1],xmax=fluenceArr[size(fluenceArr,1)])
    Scale.x_log10(minvalue=xmin,maxvalue=xmax),
#    Scale.y_log10
)


push!(r2,plottheme)
println("Plotted r2")

r3 = plot(
#    destdf[xmax.>destdf[:Fluence].>xmin,:],
    o3_dest_reactions,
    x="Fluence",
    y="Count",
    color="Label",
    Geom.line,
#    Geom.smooth(method=:lm,smoothing=0.9),
    Guide.title("O<sub>3</sub> Dest. Reactions"),
    Guide.xlabel("Fluence"),
    Guide.colorkey("Reaction #"),
    Guide.ylabel("Count"),
#    Coord.Cartesian(xmin=fluenceArr[1],xmax=fluenceArr[size(fluenceArr,1)])
    Scale.x_log10(minvalue=xmin,maxvalue=xmax),
#    Scale.y_log10
)


push!(r3,plottheme)
println("Plotted r3")


# Now plotting excited species reactions

ostar_prod_reactions = readtable(
    ostar_prod_output,
    header = true,
    names = [:Count,:Time, :Fluence, :ID, :Label],
    eltypes = [Int64,Float64,Float64,Int64,String]
)

println("Generated o* prod")

ostar_dest_reactions = readtable(
    ostar_dest_output,
    header = true,
    names = [:Count,:Time, :Fluence, :ID, :Label],
    eltypes = [Int64,Float64,Float64,Int64,String]
)

println("Generated o* dest")

println("Generated dataframe of reactions output")

s1 = plot(
#    destdf[xmax.>destdf[:Fluence].>xmin,:],
    ostar_prod_reactions,
    x="Fluence",
    y="Count",
    color="Label",
    Geom.line,
#    Geom.smooth(method=:lm,smoothing=0.9),
    Guide.title("O<sup>*</sup> Prod. Reactions"),
    Guide.xlabel("Fluence"),
    Guide.colorkey("Reaction #"),
    Guide.ylabel("Count"),
#    Coord.Cartesian(xmin=fluenceArr[1],xmax=fluenceArr[size(fluenceArr,1)])
    Scale.x_log10(minvalue=xmin,maxvalue=xmax),
#    Scale.y_log10
)

push!(s1,plottheme)
println("Plotted s1")


t1 = plot(
#    destdf[xmax.>destdf[:Fluence].>xmin,:],
    ostar_dest_reactions,
    x="Fluence",
    y="Count",
    color="Label",
    Geom.line,
#    Geom.smooth(method=:lm,smoothing=0.9),
    Guide.title("O<sup>*</sup> Dest. Reactions"),
    Guide.xlabel("Fluence"),
    Guide.colorkey("Reaction #"),
    Guide.ylabel("Count"),
#    Coord.Cartesian(xmin=fluenceArr[1],xmax=fluenceArr[size(fluenceArr,1)])
    Scale.x_log10(minvalue=xmin,maxvalue=xmax),
#    Scale.y_log10
)


push!(t1,plottheme)
println("Plotted t1")



#println("Generating final output pdf")
#draw(PDF(path*"o_reactions.pdf",6inch,9inch),vstack(p1,r1))
#draw(PDF(path*"o2_reactions.pdf",6inch,9inch),vstack(p2,r2))
#draw(PDF(path*"o3_reactions.pdf",6inch,9inch),vstack(p3,r3))
#draw(PDF(path*"o*_reactions.pdf",6inch,9inch),vstack(s1,t1))
#draw(PDF(path*"o2*_reactions.pdf",6inch,9inch),vstack(s2,t2))
#draw(PDF(path*"o3*_reactions.pdf",6inch,9inch),vstack(s3,t3))

println("Ending rate2.jl!")
#quit()
