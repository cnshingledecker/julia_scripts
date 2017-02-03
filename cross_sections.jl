using DataFrames
using Gadfly

# Input parameters
path = "/scratch/cns7ae/ciris/sigtest/"
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
                  names = [:energy, :σ, :Type, :Species],
                  eltypes = [Float64, Float64, String, String],
                  header = false
                 )

σ_electron = readtable(
                  path*electronFile,
                  names = [:energy, :σ, :Type, :Species],
                  eltypes = [Float64, Float64, String, String],
                  header = false
                 )

#println("Now filtering out Total elastic cross-section")


println("Now plotting data")

σ_proton = σ_proton[σ_proton[:σ].>10^(-20.0),:]
σ_proton = σ_proton[σ_proton[:σ].<10^(-15.0),:]
σ_electron = σ_electron[σ_electron[:σ].>10^(-20.0),:]
σ_electron = σ_electron[σ_electron[:σ].<10^(-15.0),:]

red_sig_elec = DataFrame()
red_sig_elec = vcat(red_sig_elec,
                     σ_electron[σ_electron[:Type].=="Elastic",:],
                     σ_electron[σ_electron[:Type].=="Excitation",:],
                     σ_electron[σ_electron[:Type].=="Ionization",:])

σ_electron = red_sig_elec

sort!(σ_proton,cols=[:Type])
sort!(σ_electron,cols=[:Type])

sigo = plot(
           σ_proton[σ_proton[:Species].=="O",:],
           x="energy",
           y="σ",
           color="Type",
           Geom.line,
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
#           Guide.title("Proton Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(sigo,plottheme)

sigo2 = plot(
           σ_proton[σ_proton[:Species].=="O2",:],
           x="energy",
           y="σ",
           color="Type",
           Geom.line,
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
#           Guide.title("Proton Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(sigo2,plottheme)

sigo3 = plot(
           σ_proton[σ_proton[:Species].=="O3",:],
           x="energy",
           y="σ",
           color="Type",
           Geom.line,
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
#           Guide.title("Proton Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(sigo3,plottheme)


esigo = plot(
           σ_electron[σ_electron[:Species].=="O",:],
           x="energy",
           y="σ",
           color="Type",
           Geom.line,
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
#           Guide.title("Electron Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(esigo,plottheme)

esigo2 = plot(
           σ_electron[σ_electron[:Species].=="O2",:],
           x="energy",
           y="σ",
           color="Type",
           Geom.line,
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
#           Guide.title("Electron Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(esigo2,plottheme)

esigo3 = plot(
           σ_electron[σ_electron[:Species].=="O3",:],
           x="energy",
           y="σ",
           color="Type",
           Geom.line,
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
#           Guide.title("Electron Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(esigo3,plottheme)

println("Now exporting plot")
draw(PDF(path*"f1a.pdf", 6inch, 4.5inch), sigo)
draw(PDF(path*"f1b.pdf", 6inch, 4.5inch), sigo2)
draw(PDF(path*"f1c.pdf", 6inch, 4.5inch), sigo3)
draw(PDF(path*"f2a.pdf", 6inch, 4.5inch), esigo)
draw(PDF(path*"f2b.pdf", 6inch, 4.5inch), esigo2)
draw(PDF(path*"f2c.pdf", 6inch, 4.5inch), esigo3)
#draw(PDF(path*"f2a.pdf", 6inch, 4.5inch), p1)
#draw(PDF(path*"f2b.pdf", 6inch, 4.5inch), p2)
#draw(PDF(path*plotname, 6inch, 9inch), vstack(p1,p2))
println("Now ending script")
