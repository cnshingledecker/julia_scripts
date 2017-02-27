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

# Atomic oxygen
σ_atomic = σ_proton[σ_proton[:Species].=="O",:]
# Filter out elastic σ
σ_atomic_el = σ_atomic[σ_atomic[:Type].=="Elastic",:]
oel_layer = layer(σ_atomic_el,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#9db38b"))
# Filter out excitation σ
σ_atomic_ex = σ_atomic[σ_atomic[:Type].=="Excitation",:]
oex_layer = layer(σ_atomic_ex,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#ac422b"))
# Filter out ionization σ
σ_atomic_ion = σ_atomic[σ_atomic[:Type].=="Ionization",:]
oion_layer = layer(σ_atomic_ion,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#829ed0"))

sigo = plot(
           oel_layer, oex_layer, oion_layer, 
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
           Guide.manual_color_key("Collision Type",["Elastic","Excitation","Ionization"],[colorant"#9db38b",colorant"#ac422b",colorant"#829ed0"]),
#           Guide.title("Proton Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(sigo,plottheme)

# Molecular oxygen
σ_o2 = σ_proton[σ_proton[:Species].=="O2",:]
# Filter out elastic σ
σ_o2_el = σ_o2[σ_o2[:Type].=="Elastic",:]
o2el_layer = layer(σ_o2_el,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#9db38b"))
# Filter out excitation σ
σ_o2_ex = σ_o2[σ_o2[:Type].=="Excitation",:]
o2ex_layer = layer(σ_o2_ex,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#ac422b"))
# Filter out ionization σ
σ_o2_ion = σ_o2[σ_o2[:Type].=="Ionization",:]
o2ion_layer = layer(σ_o2_ion,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#829ed0"))

sigo2 = plot(
           o2el_layer, o2ex_layer, o2ion_layer, 
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
           Guide.manual_color_key("Collision Type",["Elastic","Excitation","Ionization"],[colorant"#9db38b",colorant"#ac422b",colorant"#829ed0"]),
#           Guide.title("Proton Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(sigo2,plottheme)

# Ozone 
σ_o3 = σ_proton[σ_proton[:Species].=="O3",:]
# Filter out elastic σ
σ_o3_el = σ_o3[σ_o3[:Type].=="Elastic",:]
o3el_layer = layer(σ_o3_el,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#9db38b"))
# Filter out excitation σ
σ_o3_ex = σ_o3[σ_o3[:Type].=="Excitation",:]
o3ex_layer = layer(σ_o3_ex,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#ac422b"))
# Filter out ionization σ
σ_o3_ion = σ_o3[σ_o3[:Type].=="Ionization",:]
o3ion_layer = layer(σ_o3_ion,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#829ed0"))

sigo3 = plot(
           o3el_layer, o3ex_layer, o3ion_layer, 
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
           Guide.manual_color_key("Collision Type",["Elastic","Excitation","Ionization"],[colorant"#9db38b",colorant"#ac422b",colorant"#829ed0"]),
#           Guide.title("Proton Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(sigo3,plottheme)


# Atomic oxygen
eσ_atomic = σ_electron[σ_electron[:Species].=="O",:]
# Filter out elastic σ
eσ_atomic_el = eσ_atomic[eσ_atomic[:Type].=="Elastic",:]
eoel_layer = layer(eσ_atomic_el,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#9db38b"))
# Filter out excitation σ
eσ_atomic_ex = eσ_atomic[eσ_atomic[:Type].=="Excitation",:]
eoex_layer = layer(eσ_atomic_ex,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#ac422b"))
# Filter out ionization σ
eσ_atomic_ion = eσ_atomic[eσ_atomic[:Type].=="Ionization",:]
eoion_layer = layer(eσ_atomic_ion,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#829ed0"))

esigo = plot(
           eoel_layer, eoex_layer, eoion_layer, 
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
           Guide.manual_color_key("Collision Type",["Elastic","Excitation","Ionization"],[colorant"#9db38b",colorant"#ac422b",colorant"#829ed0"]),
#           Guide.title("Proton Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(esigo,plottheme)

# Molecular oxygen
eσ_o2 = σ_electron[σ_electron[:Species].=="O2",:]
# Filter out elastic σ
eσ_o2_el = eσ_o2[eσ_o2[:Type].=="Elastic",:]
eo2el_layer = layer(eσ_o2_el,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#9db38b"))
# Filter out excitation σ
eσ_o2_ex = eσ_o2[eσ_o2[:Type].=="Excitation",:]
eo2ex_layer = layer(eσ_o2_ex,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#ac422b"))
# Filter out ionization σ
eσ_o2_ion = eσ_o2[eσ_o2[:Type].=="Ionization",:]
eo2ion_layer = layer(eσ_o2_ion,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#829ed0"))

esigo2 = plot(
           eo2el_layer, eo2ex_layer, eo2ion_layer, 
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
           Guide.manual_color_key("Collision Type",["Elastic","Excitation","Ionization"],[colorant"#9db38b",colorant"#ac422b",colorant"#829ed0"]),
#           Guide.title("Proton Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(esigo2,plottheme)

# Ozone 
eσ_o3 = σ_electron[σ_electron[:Species].=="O3",:]
# Filter out elastic σ
eσ_o3_el = eσ_o3[eσ_o3[:Type].=="Elastic",:]
eo3el_layer = layer(eσ_o3_el,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#9db38b"))
# Filter out excitation σ
eσ_o3_ex = eσ_o3[eσ_o3[:Type].=="Excitation",:]
eo3ex_layer = layer(eσ_o3_ex,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#ac422b"))
# Filter out ionization σ
eσ_o3_ion = eσ_o3[eσ_o3[:Type].=="Ionization",:]
eo3ion_layer = layer(eσ_o3_ion,x="energy",y="σ",Geom.line,Theme(line_width=3pt,default_color=colorant"#829ed0"))

esigo3 = plot(
           eo3el_layer, eo3ex_layer, eo3ion_layer, 
           Scale.x_log10,
           Scale.y_log10(minvalue=10^(-20.0),maxvalue=10^(-15.0)),
           Guide.xlabel("Particle Energy (eV)"),
           Guide.ylabel("σ (cm<sup>2</sup>)"),
           Guide.manual_color_key("Collision Type",["Elastic","Excitation","Ionization"],[colorant"#9db38b",colorant"#ac422b",colorant"#829ed0"]),
#           Guide.title("Proton Cross Sections vs. Particle Energy"),
           Theme(default_point_size=1.5pt)
          )

push!(esigo3,plottheme)

println("Now exporting plot")
draw(PDF(path*"f1a.pdf", 5.5inch, 3.5inch), sigo)
draw(PDF(path*"f1b.pdf", 5.5inch, 3.5inch), sigo2)
draw(PDF(path*"f1c.pdf", 5.5inch, 3.5inch), sigo3)
draw(PDF(path*"f2a.pdf", 5.5inch, 3.5inch), esigo)
draw(PDF(path*"f2b.pdf", 5.5inch, 3.5inch), esigo2)
draw(PDF(path*"f2c.pdf", 5.5inch, 3.5inch), esigo3)
#draw(PDF(path*"f2a.pdf", 5.5inch, 3.5inch), p1)
#draw(PDF(path*"f2b.pdf", 5.5inch, 3.5inch), p2)
#draw(PDF(path*plotname, 5.5inch, 9inch), vstack(p1,p2))
println("Now ending script")
