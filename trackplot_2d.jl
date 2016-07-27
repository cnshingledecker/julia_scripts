using DataFrames
using Gadfly

# Input parameters
path = "/home/cns/git_reading_room/losalamos/"
abundanceFile = "trackplot.csv"
plotname = "trackplot.pdf"
xmin = 1
xmax = 680


println("Reading input file")
track = readtable(
                  path*abundanceFile,
                  names = [:i, :j, :k, :Species, :Action],
                  eltypes = [Int64, Int64, Int64, UTF8String, UTF8String],
                  header = false
                 )


println("Now plotting data")
pij = plot(
           track,
           x="j",
           y="i",
           color="Species",
           Geom.point,
           Theme(default_point_size=0.2pt)
          )

println("Now exporting plot")
draw(PDF(path*plotname, 6inch, 5inch), pij)
println("Now ending script")
