using DataFrames
using Gadfly

# Input parameters
path = "/home/cns/losalamos/"
protonFile = "proton_sigmas.csv"
electronFile = "electron_sigmas.csv"
plotname = "cross_sections.pdf"
xmin = 1
xmax = 1e6

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
σ_proton = readtable(
                  path*protonFile,
                  names = [:energy, :σ, :Type],
                  eltypes = [Float64, Float64, UTF8String],
                  header = false
                 )

σ_electron = readtable(
                  path*electronFile,
                  names = [:energy, :σ, :Type],
                  eltypes = [Float64, Float64, UTF8String],
                  header = false
                 )


println("Now plotting data")

p1 = plot(
           σ_proton,
           x="energy",
           y="σ",
           color="Type",
           Geom.line,
           Scale.x_log10,
           Scale.y_log10,
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
           Guide.title("Proton Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(p1,plottheme)

p2 = plot(
           σ_electron,
           x="energy",
           y="σ",
           color="Type",
           Geom.line,
           Scale.x_log10,
           Scale.y_log10,
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
           Guide.title("Electron Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(p2,plottheme)

println("Now exporting plot")
draw(PDF(path*"f2a.pdf", 6inch, 4.5inch), p1)
draw(PDF(path*"f2b.pdf", 6inch, 4.5inch), p2)
draw(PDF(path*plotname, 6inch, 9inch), vstack(p1,p2))
println("Now ending script")
