using Gadfly
using Cairo
using DataFrames
using Colors

# General plot/data variables
path     = "/home/cns/Dropbox/KMC-MD_project/cj_0_khop_20/" #"/home/cns/Desktop/"
infile1  = "new_kt.wsv"
infile2  = "new_kthop.wsv"
infile3  = "pxt.wsv"
outfile  = "kt.pdf"
title    = "HFI (Chfi=7) and Exchange Effects on P<sub>x</sub>(t)"
ylabel   = "P<sub>x</sub>(t)"
keylabel = "Type"
xmax     = 0
xmin     = 10
ymax     = 1
ymin     = 0

# Plot theme variables
plottheme = Gadfly.Theme(
    highlight_width = 0pt,                     
    default_point_size = 1pt, 
    line_width=2pt,
    minor_label_font_size=13pt,
    minor_label_color=colorant"black",
    major_label_font_size=15pt,
    major_label_color=colorant"black",
    key_label_color=colorant"black",
    key_title_color=colorant"black",
    key_title_font_size=15pt,
    key_label_font_size=10pt,
    grid_color=colorant"black")

println("Now reading $infile1 contents")
kt = readtable(
    path*infile1,
    names = [:Time,:Pxt],
    eltypes = [Float64,Float64]
)

println("Now reading $infile2 contents")
kthop = readtable(
    path*infile2,
    names = [:Time,:Pxt],
    eltypes = [Float64,Float64]
)

println("Now reading $infile3 contents")
pxt = readtable(
    path*infile3,
    names = [:Time,:Pxt],
    eltypes = [Float64,Float64]
)

kt[:Type] = "Kubo-Toyabe"
kthop[:Type] = "Hopping(k<sub>hop</sub>=2)"
pxt[:Type] = "Model"

pltdf = DataFrame()

pltdf = vcat(pltdf, kt, kthop, pxt)

p1 = plot(
    pltdf[pltdf[:Pxt].<1.0,:],
    x="Time",
    y="Pxt",
    Geom.point,
    color = "Type",
    Guide.colorkey(keylabel),
    Guide.title(title),
    Guide.ylabel(ylabel),
    Guide.xlabel("tΔ")
    )


# Apply the theme to the plot
push!(p1,plottheme)

println("Now exporting PDF for $outfile")
draw(PDF(path*outfile,6inch,5inch),p1)

println("ENDING SCRIPT")
