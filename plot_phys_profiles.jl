using DataFrames
using Gadfly
using Cairo
using Fontconfig

# Input parameters
path = "/home/cns/Dropbox/collapse_code/"
abundanceFile = "structure_evolution.dat"
plotname = "profiles.pdf"
maxtime = 1.0e7
mintime = 1.0e3

plottheme = Gadfly.Theme(
                        default_point_size=1.5pt,
                        line_width=2pt,
                        minor_label_font_size=10pt,
                        minor_label_color=colorant"black",
                        major_label_font_size=12pt,
                        major_label_color=colorant"black",
                        key_label_color=colorant"black",
                        key_title_color=colorant"black",
                        key_title_font_size=12pt,
                        key_label_font_size=10pt,
                        grid_color=colorant"black",
                        highlight_width=0pt)

println("Reading input file")
structure = readtable(
                  path*abundanceFile,
                  names = [:time, :Av, :n, :tgas, :tgrain],
                  eltypes = [Float64, Float64, Float64, Float64, Float64],
                  skipstart = 1,
                  separator = ' '
                 )

structure[:Av]     = 10.^structure[:Av]
structure[:n]      = 10.^structure[:n]
structure[:tgas]   = 10.^structure[:tgas]
structure[:tgrain] = 10.^structure[:tgrain]

structure = structure[mintime.<structure[:time].<maxtime,:]



println("Now plotting data")

# Plot time vs. Av
p1 = plot(
           structure,
           x="time",
           y="Av",
           Coord.cartesian(aspect_ratio=1),
           Geom.line,
           Guide.xlabel("Time (yr)"),
           Guide.ylabel("Av"),
           Scale.x_log10(maxvalue=maxtime,minvalue=mintime),
           Scale.y_log10,
           )
push!(p1,plottheme)

# Plot time vs. n 
p2 = plot(
           structure,
           x="time",
           y="n",
           Coord.cartesian(aspect_ratio=1),
           Geom.line,
           Guide.xlabel("Time (yr)"),
           Guide.ylabel("n (cm<sup>-3</sup>)"),
           Scale.x_log10(maxvalue=maxtime,minvalue=mintime),
           Scale.y_log10,
           )
push!(p2,plottheme)

# Plot time vs. Tgas 
p3 = plot(
           structure,
           x="time",
           y="tgas",
           Coord.cartesian(aspect_ratio=1),
           Geom.line,
           Guide.xlabel("Time (yr)"),
           Guide.ylabel("T<sub>gas</sub> (K)"),
           Scale.x_log10(maxvalue=maxtime,minvalue=mintime),
           Scale.y_log10,
           )
push!(p3,plottheme)

# Plot time vs. Tgrain 
p4 = plot(
           structure,
           x="time",
           y="tgrain",
           Coord.cartesian(aspect_ratio=1),
           Geom.line,
           Guide.xlabel("Time (yr)"),
           Guide.ylabel("T<sub>grain</sub> (K)"),
           Scale.x_log10(maxvalue=maxtime,minvalue=mintime),
           Scale.y_log10,
           )
push!(p4,plottheme)


println("Now exporting plot")
draw(PDF(path*"av.pdf", 6inch, 5inch), p1)
draw(PDF(path*"density.pdf", 6inch, 5inch), p2)
draw(PDF(path*"gastemp.pdf", 6inch, 5inch), p3)
draw(PDF(path*"graintemp.pdf", 6inch, 5inch), p4)
draw(PDF(path*"profiles.pdf", 6inch, 5inch), vstack(hstack(p1,p2),hstack(p3,p4)))
println("Now ending script")
