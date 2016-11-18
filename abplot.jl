using DataFrames
using Gadfly

# Input parameters
path = "/home/cns/losalamos/"
abundanceFile = "abundance.csv"
plotname = "f3.pdf" #"abundance_plot.pdf"
thick = 6.e-6
edge  = 3.5e-6
denom = thick*edge*edge*1.0e20
iceSize = (170^3)/3
xmax    = 1.0e16
xmin    = 1.0e12
ymin    = (10^(-0.5)) #0.5
species = "O3" # all, O2, O, O3

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

println("Reading input file")
modelOutput = readtable(
                  path*abundanceFile,
                  names = [:AltFluence, :Fluence, :Time, :O2, :O, :O3],
                  eltypes = [Float64,Float64,Float64,Int64,Int64,Int64],
                  header = false
                  )

println("Initializing dataframes")
ab_tot_df = DataFrame()
O3ab_df   = DataFrame()
Oab_df    = DataFrame()
O2ab_df   = DataFrame()

println("Populating dataframes")
Oab_df = vcat(Oab_df,
              DataFrame(
                        Fluence=modelOutput[:AltFluence],
                        # Fluence=modelOutput[:Fluence],
                        Abundance=modelOutput[:O]/denom,
                        Species="O",
                        Type="Theory"
                       )
             )


O3ab_df = vcat(
               O3ab_df,
               DataFrame(
                         Fluence=modelOutput[:AltFluence],
                        #  Fluence=modelOutput[:Fluence],
                         Abundance=modelOutput[:O3]/denom,
                         Species="O<sub>3</sub>",
                         Type="Theory"
                        )
              )


O2ab_df = vcat(
               O2ab_df,
               DataFrame(
                         Fluence=modelOutput[:AltFluence],
                        #  Fluence=modelOutput[:Fluence],
                         Abundance=modelOutput[:O2]/denom,
                         Species="O<sub>2</sub>",
                         Type="Theory"
                        )
             )

ab_tot_df = vcat(ab_tot_df,
                 DataFrame(
                           Fluence=modelOutput[:AltFluence],
                          #  Fluence=modelOutput[:Fluence],
                           Abundance=modelOutput[:O2]/denom,
                           Species="O<sub>2</sub>",
                           Type="Theory"
                           ),
                 DataFrame(
                           Fluence=modelOutput[:AltFluence],
                          #  Fluence=modelOutput[:Fluence],
                           Abundance=modelOutput[:O]/denom,
                           Species="O",
                           Type="Theory"
                           ),
                 DataFrame(
                           Fluence=modelOutput[:AltFluence],
                          #  Fluence=modelOutput[:Fluence],
                           Abundance=modelOutput[:O3]/denom,
                           Species="O<sub>3</sub>",
                           Type="Theory"
                           )
                )


expFluence = [8.e11,5.e12,1.1e13,4.e13,1.15e14,2.e14,7.e14,2.1e15,7.5e15]
expAbundance = [0.5,1.5,2.15,2.9,3.4,3.8,4.1,3.9,4.17]
O3exp = DataFrame(
                  Fluence=expFluence,
                  Abundance=expAbundance,
                  Species="O<sub>3</sub>",
                  Type="Experiment"
)

#O3total = vcat(O3total,O3ab_df,O3exp)

# species_ab_af = DataFrame()
# species_ab_df = vcat(species_ab_df,O3ab_df, O2ab_df, Oab_df)
# Select the dataframe to plot
plot_df = DataFrame()
if species == "all"
  plot_df  = vcat(plot_df,ab_tot_df)
elseif species == "O2"
  plot_df = vcat(plot_df,O2ab_df)
elseif species == "O"
  plot_df = vcat(plot_df,Oab_df)
elseif species == "O3"
  plot_df = vcat(plot_df,O3ab_df)
end

println("Generating plots")
p1 = plot(
          O3exp,
          x="Fluence",
          y="Abundance",
          color="Type",
          Geom.point,
          # Guide.title("Species vs. Fluence"),
          Guide.xlabel("Fluence (ions cm<sup>-2</sup>)"),
          Guide.ylabel("Abundance (cm<sup>-3</sup>) * 10<sup>20</sup>"),
          Scale.x_log10(minvalue=xmin,maxvalue=xmax),
          Scale.y_log10(minvalue=ymin)
#          Scale.y_log10(maxvalue=10.0)
)

plot_df = plot_df[xmax.>plot_df[:Fluence].>xmin,:]
plot_df = plot_df[plot_df[:Abundance].>ymin,:]


push!(p1,layer(
               plot_df,
               x="Fluence",
               y="Abundance",
               color="Type",
               Geom.line))
push!(p1,plottheme)

println("Now exporting plot")
#draw(PDF(path*plotname,6inch,9inch),vstack(p1,p2,p3,p4))
draw(PDF(path*plotname, 6inch, 5inch), p1)
println("Ending script!!")
quit()
