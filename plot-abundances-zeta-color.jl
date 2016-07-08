using Gadfly
using Cairo
using DataFrames
using Colors


# General plot/data variables
path     = "/Volumes/Untitled/new_images/" #"/home/cns/Desktop/"
infile   = "f6c.csv"
outfile  = "f6c.pdf"
temp     = "15" #K
logn     = "4" #log(nH2)
title    = "T=$temp K, n<sub>H</sub>=10<sup>$logn</sup> cm<sup>-3</sup>" #ζ=10<sup>-17</sup> s<sup>-1</sup>"
ylabel   = "[HCO<sup>+</sup>]/[DCO<sup>+</sup>]" #"[HCO<sup>+</sup>]/[DCO<sup>+</sup>]" #"OPR(H<sub>2</sub>)"  #"n<sub>X</sub>/n<sub>H</sub>"
keylabel = "Initial OPR" #"ζ (s<sup>-1</sup>)"
xmax     = 10^(-15.0)
xmin     = 10^(-18.0)
ymax     = 10^(3.0)
ymin     = 10^(0.0)
obs      = true #true
obsxmin  = xmin
obsxmax  = xmax
obsymin  = 18 #600 #18
obsymax  = 50 #800 #50
plotType = 3

#=
1 = Multiline abundance vs time with color
2 = Several line abundance vs time with color/style
3 = Zetaplot + isoreps
4 = Standard abundance vs time for arbitrary species
=#


# Plot theme variables
plottheme = Gadfly.Theme(
                        line_width=2pt,
                        minor_label_font_size=13pt,
                        minor_label_color=colorant"black",
                        major_label_font_size=15pt,
                        major_label_color=colorant"black",
                        key_label_color=colorant"black",
                        key_title_color=colorant"black",
                        key_title_font_size=15pt,
                        key_label_font_size=13pt,
                        grid_color=colorant"black")

# 1) Multiline abundance vs time w. color
if plotType == 1
  println("Now reading $infile contents")
  ab_df = readtable(
                    path*infile,
                    names = [:Time,:Ratio,:ζ],
                    eltypes = [Float64,Float64,Float64]
  )


  println("Now generating plotType $plotType")
  p1 = plot(
            ab_df[ab_df[:Time].<xmax,:],
            x="Time",
            y="Ratio",
            Scale.x_log10,
            Scale.y_log10,
            Geom.line,
            color = "ζ",
            Guide.colorkey(keylabel),
            Guide.title(title),
            Guide.ylabel(ylabel),
            Guide.xlabel("Time (yr)"),
            Scale.color_log10(colormap=Scale.lab_gradient(
                                                          colorant"darkblue",
                                                          colorant"mediumblue",
                                                          colorant"deepskyblue",
                                                          colorant"turquoise",
                                                          colorant"lightgreen",
                                                          colorant"gold",
#                                                          colorant"yellow"
                                                          ))
            )

  # Apply the theme to the plot
  push!(p1,plottheme)

  println("Now exporting PDF for $outfile")
  draw(PDF(path*outfile,6inch,5inch),p1)

# 2) Few line OPR vs time plot
elseif plotType == 2
  println("Reading in data for $infile")
  ab_df = readtable(
                    path*infile,
                    names = [:Time,:OPR,:InitOPR,:ζ,:Set],
                    eltypes = [Float64,Float64,Float64,Float64,Float64]
                   )

  ab_df[:Set] = Int64[Int64(x) for x in ab_df[:Set]]
  ab_df = ab_df[ab_df[:Time].<xmax,:]

  #Setup the layer dataframes
  println("Setting up dataframe layers")
  l1_df = DataFrame()
  l1_df = ab_df
  l1_df = l1_df[l1_df[:Set] .== 0, :]
  l1 = layer(
             l1_df,
             x="Time",
             y="OPR",
             Geom.line,
             Theme(
                   default_color=colorant"gold",
                   line_width=2pt
                   )
            )


  l2_df = DataFrame()
  l2_df = ab_df
  l2_df = l2_df[l2_df[:Set] .== 1, :]
  l2 = layer(
             l2_df,
             x="Time",
             y="OPR",
             Geom.line,
             Theme(
                   default_color=colorant"gold",
                   line_width=2pt,
                   line_style=Gadfly.get_stroke_vector(:dot)
                   )
            )

  l3_df = DataFrame()
  l3_df = ab_df
  l3_df = l3_df[l3_df[:Set] .== 2, :]
  l3 = layer(
             l3_df,
             x="Time",
             y="OPR",
             Geom.line,
             Theme(
                   default_color=colorant"deepskyblue",
                   line_width=2pt
                   )
            )

  l4_df = DataFrame()
  l4_df = ab_df
  l4_df = l4_df[l4_df[:Set] .== 3, :]
  l4 = layer(
             l4_df,
             x="Time",
             y="OPR",
             Geom.line,
             Theme(
                   default_color=colorant"deepskyblue",
                   line_width=2pt,
                   line_style=Gadfly.get_stroke_vector(:dot)
                   )
            )

  println("Now generating $outfile")
  p2 = plot(
            l1, l2, l3, l4,
            Guide.manual_color_key(
                                   "ζ (s<sup>-1</sup>)",
                                   ["10<sup>-15</sup>","10<sup>-17</sup>"],
                                   ["gold","deepskyblue"]
                                  ),
            Scale.x_log10(maxvalue=xmax),
            Scale.y_log10,
            Guide.title(title),
            Guide.ylabel(ylabel),
            Guide.xlabel("Time (yr)")
           )

  push!(p2,plottheme)
  println("Now exporting $outfile")
  draw(PDF(path*outfile,6inch,5inch),p2)

# 3) Zetaplot + isoreps
elseif plotType == 3
  println("Reading data from $infile")
  ab_df = readtable(
                     path*infile,
                     names = [:ζ, :Ratio, :OPR],
                     eltypes = [Float64, Float64, UTF8String]
                   )

  ab_df = ab_df[xmin.< ab_df[:ζ] .<xmax,:]

  # Make the layers
  println("Now creating layers")
  l1_df  = DataFrame()
  l1_df  = ab_df[ab_df[:OPR].=="Varied",:]
  l1_df  = l1_df[l1_df[:Ratio].>ymin,:]
  println("test")
  varied = layer(
             l1_df,
             x="ζ",
             y="Ratio",
             Geom.point,
             Theme(
                   default_color=colorant"deepskyblue",
                   default_point_size=2pt,
                   colorkey_swatch_shape=:circle
                   )
            )


  l2_df  = DataFrame()
  l2_df  = ab_df[ab_df[:OPR].=="0.01",:]
  l2_df  = l2_df[l2_df[:Ratio].>ymin,:]
  opr0_01 = layer(
             l2_df,
             x="ζ",
             y="Ratio",
             Geom.line,
             Theme(
                   default_color=colorant"goldenrod",
                   colorkey_swatch_shape=:square,
                   line_width=2pt
                   )
            )


  l3_df  = DataFrame()
  l3_df  = ab_df[ab_df[:OPR].=="0.1",:]
  l3_df  = l3_df[l3_df[:Ratio].>ymin,:]
  opr0_1 = layer(
             l3_df,
             x="ζ",
             y="Ratio",
             Geom.line,
             Theme(
                   default_color=colorant"magenta",
                   colorkey_swatch_shape=:square,
                   line_width=2pt
                   )
            )


  l4_df  = DataFrame()
  l4_df  = ab_df[ab_df[:OPR].=="3",:]
  l4_df  = l4_df[l4_df[:Ratio].>ymin,:]
  opr3 = layer(
             l4_df,
             x="ζ",
             y="Ratio",
             Geom.line,
             Theme(
                   default_color=colorant"green",
                   colorkey_swatch_shape=:square,
                   line_width=2pt
                   )
            )

  println("Generating plotType $plotType")
  p3 = plot(
            opr0_01, opr0_1, opr3, varied,
            Guide.manual_color_key(
                                   "$keylabel",
                                   ["Varied","0.01","0.1","3"],
                                   ["deepskyblue","goldenrod","magenta","green"]
                                  ),
            Scale.x_log10(minvalue=xmin, maxvalue=xmax),
            Scale.y_log10(minvalue=ymin, maxvalue=ymax),
            Guide.title(title),
            Guide.ylabel(ylabel),
            Guide.xlabel("ζ (s<sup>-1</sup>)")
           )

  push!(p3,plottheme)

  if obs == true
    obsLayer = layer(
                     x=[obsxmin,obsxmax,obsxmax,obsxmin],
                     y=[obsymin,obsymin,obsymax,obsymax],
                     Geom.polygon(
                                  preserve_order=true,
                                  fill=true
                                  ),
                     Theme(
                           lowlight_opacity=1000,
                           default_color=colorant"gray"
                     )
                    )
    push!(p3,obsLayer)
  end

  println("Now exporting $outfile")
  draw(PDF(path*outfile,6inch,5inch),p3)
elseif plotType == 4
  println("Now reading $infile")
  ab_df = readtable(
                    path*infile,
                    names = [:Time,:Abundance,:Species],
                    eltypes = [Float64, Float64, UTF8String]
                   )

  ab_df = ab_df[ab_df[:Time].<xmax,:]
  for i in 1:length(ab_df[:Species])
    ab_df[:Species][i] = replace(ab_df[:Species][i],"+","<sup>+</sup>")
  end

  println("Now generating plotType $plotType")
  p4 = plot(
            ab_df,
            x="Time",
            y="Abundance",
            color="Species",
            Geom.line,
            Guide.colorkey(keylabel),
            Guide.title(title),
            Guide.ylabel(ylabel),
            Guide.xlabel("Time (yr)"),
            Scale.x_log10(minvalue=xmin,maxvalue=xmax),
            Scale.y_log10(minvalue=ymin,maxvalue=ymax)
  )

  push!(p4,plottheme)

  println("Now exporting $outfile")
  draw(PDF(path*outfile,6inch,5inch),p4)
end

println("ENDING SCRIPT")
