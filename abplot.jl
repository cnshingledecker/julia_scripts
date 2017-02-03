using DataFrames
using Gadfly


dirnames = ["barrier_ciris", "new_paper_output", "1_stepfac", "10_stepfac"]

dirlabels = ["Base model","Ea=300K", "Δz=1 θ (θ ≈ 10<sup>4</sup>)", "Δz=10 θ (θ ≈ 10<sup>3</sup>)"]

# Input parameters
path = "/scratch/cns7ae/ciris/"
abundanceFile = "abundance.wsv"
plotname = "f3.pdf" #"abundance_plot.pdf"
thick = 1.0e-5
edge  = 3.5e-6
denom = 2*thick*edge*edge*1.0e20
iceSize = (170^3)/3
xmax    = 1.0e18
xmin    = 1.0e10
ymin    = (10^(-5.0)) #0.5
species = "O3" # all, O2, O, O3

plottheme = Gadfly.Theme(
    line_width=2pt,
    minor_label_font_size=13pt,
    minor_label_color=colorant"black",
    major_label_font_size=15pt,
    major_label_color=colorant"black",
    key_label_color=colorant"black",
    key_title_color=colorant"black",
    key_title_font_size=12pt,
    key_label_font_size=11pt,
    grid_color=colorant"black")

println("Initializing dataframes")
ab_tot_df = DataFrame()
O3ab_df   = DataFrame()
Oab_df    = DataFrame()
O2ab_df   = DataFrame()


for i = 1:size(dirnames,1)
    println("Reading input file in $(dirnames[i])")

    modelOutput = readtable(
        path*dirnames[i]*"/"*abundanceFile,
        names = [:Fluence, :Time, :Geminacy, :O2, :O, :O3, :Oex,:O2ex,:O3ex,:Atoms],
        eltypes = [Float64,Float64, Float64, Int64,Int64,Int64,Int64,Int64,Int64,Int64],
        header = false
    )


    println("Populating dataframes")
    Oab_df = vcat(Oab_df,
                  DataFrame(
                      Fluence=modelOutput[:Fluence],
                      Abundance=modelOutput[:O]/denom,
                      Species="O",
                      Type=dirlabels[i]
                  )
                  )


    O3ab_df = vcat(
        O3ab_df,
        DataFrame(
            Fluence=modelOutput[:Fluence],
            Abundance=modelOutput[:O3]/denom,
            Species="O<sub>3</sub>",
            Type=dirlabels[i]
        )
    )


    O2ab_df = vcat(
        O2ab_df,
        DataFrame(
            Fluence=modelOutput[:Fluence],
            Abundance=modelOutput[:O2]/denom,
            Species="O<sub>2</sub>",
            Type=dirlabels[i]
        )
    )

    ab_tot_df = vcat(ab_tot_df,
                     DataFrame(
                         Fluence=modelOutput[:Fluence],
                         Abundance=modelOutput[:O2]/denom,
                         Species="O<sub>2</sub>",
                         Type=dirlabels[i]
                     ),
                     DataFrame(
                         Fluence=modelOutput[:Fluence],
                         Abundance=modelOutput[:O]/denom,
                         Species="O",
                         Type=dirlabels[i]
                     ),
                     DataFrame(
                         Fluence=modelOutput[:Fluence],
                         Abundance=modelOutput[:O3]/denom,
                         Species="O<sub>3</sub>",
                         Type=dirlabels[i]
                     )
                     )

end

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

O3exp[:Abundance] = O3exp[:Abundance].*1.0e20
O3exp[:Abundance] = O3exp[:Abundance]./6.02214e23
plot_df[:Abundance] = plot_df[:Abundance].*1.0e20
plot_df[:Abundance] = plot_df[:Abundance]./6.02214e23

println("Generating plots")
o3 = plot(
    O3exp,
    x="Fluence",
    y="Abundance",
    color="Type",
    #          Geom.smooth,
    Geom.point,
    # Guide.title("Species vs. Fluence"),
    Guide.xlabel("Fluence (ions cm<sup>-2</sup>)"),
    Guide.ylabel("[O<sub>3</sub>] (mol cm<sup>-3</sup>)"),
    Scale.x_log10(minvalue=xmin,maxvalue=xmax),
    Scale.y_log10
)

plot_df = plot_df[xmax.>plot_df[:Fluence].>xmin,:]
plot_df = plot_df[plot_df[:Abundance].>ymin,:]


push!(o3,layer(
    plot_df,
    x="Fluence",
    y="Abundance",
    color="Type",
    Geom.line))
push!(o3,plottheme)

o2 = plot(
    O2ab_df,
    x="Fluence",
    y="Abundance",
    color="Type",
    Geom.line,
    # Guide.title("Species vs. Fluence"),
    Guide.xlabel("Fluence (ions cm<sup>-2</sup>)"),
    Guide.ylabel("Abundance (cm<sup>-3</sup>) * 10<sup>20</sup>"),
    Scale.x_log10(minvalue=xmin,maxvalue=xmax),
    Scale.y_log10
)
push!(o2,plottheme)

plot_df = vcat(plot_df,O2ab_df)


println("Now exporting plot")
draw(PDF(path*"f3.pdf",6inch,4inch),o3)
#draw(PDF(path*plotname, 6inch, 5inch), p1)
println("Ending script!!")
#quit()
