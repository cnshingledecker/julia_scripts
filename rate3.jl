println("Welcome to rate3.jl, where rates for CIRIS are plotted")
using DataFrames
using Gadfly

path = "/scratch/cns7ae/$DIRNAME/"
outfile = "rates-plot.pdf"
basefile = "_reactions.wsv"
numspecies = 16
xmax = 1e15
xmin = 1e13

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

p = Array(Gadfly.Plot,numspecies)
d = Array(Gadfly.Plot,numspecies)

for n=1:numspecies

    println("Plotting data for species $n")

    df = readtable(
        path*string(n)*basefile,
        header = true,
        names = [:Percent,:Time, :Fluence, :Label, :Type],
        eltypes = [Float64,Float64,Float64, String, String]
    )

    proddf = DataFrame()
    proddf = df[df[:Type].=="Production",:]

    destdf = DataFrame
    destdf = df[df[:Type].=="Destruction",:]

    p[n] = plot(
        proddf,
        x="Fluence",
        y="Percent",
        color = "Label",
        Geom.line,
        Scale.x_log10,
        Scale.y_log10,
        Guide.xlabel("Fluence"),
        Guide.ylabel("Fractional Importance")
    )

    push!(p[n],plottheme)

    d[n] = plot(
        destdf,
        x="Fluence",
        y="Percent",
        color = "Label",
        Geom.line,
        Scale.x_log10,
        Scale.y_log10,
        Guide.xlabel("Fluence"),
        Guide.ylabel("Fractional Importance")
    )

    push!(d[n],plottheme)
end

println("Ending rate3.jl!")
