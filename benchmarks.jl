using DataFrames
using Gadfly

# Input parameters
path = "/home/cns/Downloads/"
abundanceFile = "benchmarks.csv"
plotname = "benchmarks.pdf"

plottheme = Gadfly.Theme(
                        default_point_size=3pt,
                        line_width=2pt,
                        minor_label_font_size=13pt,
                        minor_label_color=colorant"black",
                        major_label_font_size=15pt,
                        major_label_color=colorant"black",
                        key_label_color=colorant"black",
                        key_title_color=colorant"black",
                        key_title_font_size=15pt,
                        key_label_font_size=10pt,
                        grid_color=colorant"black",
                        highlight_width=0pt)

println("Reading input file")
results = readtable(
                  path*abundanceFile,
                  names = [:lang, :test, :time],
                  eltypes = [String, String, Float64],
                  header = false
                 )


p1 = plot(
          results,
           x="time",
           y="lang",
           color="test",
           Geom.point,
#           Geom.contour,
           Guide.xlabel("time"),
           Guide.ylabel("language"),
           Scale.x_log10,
            )
push!(p1,plottheme)

println("Now exporting plot")
draw(PNG("/home/cns/Dropbox/presentations/tuna_talk/benchmarks.png", 6inch, 5inch), p1)
println("Now ending script")
