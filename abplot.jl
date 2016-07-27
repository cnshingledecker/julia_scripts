using DataFrames
using Gadfly

# Input parameters
path = "/home/cns/git_reading_room/losalamos/best_run_072016/"
abundanceFile = "abundance.csv"
plotname = "abundance_plot.pdf"
thick = 3.5e-6
edge  = 3.5e-6
denom = thick*edge*edge*1.0e20
iceSize = (102^3)/3
xmax    = 1.0e16
xmin    = 1.0e12
species = "O3" # all, O2, O, O3

println("Reading input file")
modelOutput = readtable(
                  path*abundanceFile,
                  names = [:Time, :Fluence, :O2, :O, :O3, :Numprotons],
                  eltypes = [Float64,Float64,Int64,Int64,Int64,Int64],
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
                        Fluence=modelOutput[:Fluence],
                        Abundance=modelOutput[:O]/denom,
                        Species="O"
                       )
             )


O3ab_df = vcat(
               O3ab_df,
               DataFrame(
                         Fluence=modelOutput[:Fluence],
                         Abundance=modelOutput[:O3]/denom,
                         Species="O3"
                        )
              )


O2ab_df = vcat(
               O2ab_df,
               DataFrame(
                         Fluence=modelOutput[:Fluence],
                         Abundance=modelOutput[:O2]/denom,
                         Species="O2"
                        )
             )

ab_tot_df = vcat(ab_tot_df,
                 DataFrame(
                           Fluence=modelOutput[:Fluence],
                           Abundance=modelOutput[:O2]/denom,
                           Species="O<sub>2</sub>"
                           ),
                 DataFrame(
                           Fluence=modelOutput[:Fluence],
                           Abundance=modelOutput[:O]/denom,
                           Species="O"
                           ),
                 DataFrame(
                           Fluence=modelOutput[:Fluence],
                           Abundance=modelOutput[:O3]/denom,
                           Species="O<sub>3</sub>"
                           )
                )

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
          plot_df[xmax.>plot_df[:Fluence].>xmin,:],
          x="Fluence",
          y="Abundance",
          color="Species",
          Geom.line,
          Geom.smooth,
          Guide.title("Species vs. Fluence"),
          Guide.xlabel("Fluence (ions cm<sup>-2</sup>)"),
          Guide.ylabel("Abundance (cm<sup>-3</sup>) * 10<sup>20</sup>"),
          Scale.x_log10(minvalue=xmin,maxvalue=xmax),
#          Scale.y_log10(maxvalue=10.0)
)



println("Now exporting plot")
#draw(PDF(path*plotname,6inch,9inch),vstack(p1,p2,p3,p4))
draw(PDF(path*plotname, 6inch, 5inch), p1)
println("Ending script!!")
