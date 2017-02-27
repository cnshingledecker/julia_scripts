using Gadfly
using Cairo
using DataFrames

K2eV = 8.61733e-5 #K->eV

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
    key_title_font_size=12pt,
    key_label_font_size=10pt,
    grid_color=colorant"black")

function b2(e,t)
  return 1.0e12*exp(-e/t)
end

function τ(e,t)
  rn = rand(1)
  return (-1.0/b2(e,t))*log(rn[1])
end

df100 = DataFrame()
df100[:temp] = 1:1:1.0e3
df100[:time] = 0.0
df100[:ed] = 100.0
df100[:str] = "0.008"

df200 = DataFrame()
df200[:temp] = 1:1:1.0e3
df200[:time] = 0.0
df200[:ed] = 200.0
df200[:str] = "0.01"

df300 = DataFrame()
df300[:temp] = 1:1:1.0e3
df300[:time] = 0.0
df300[:ed] = 300.0
df300[:str] = "0.02"

df400 = DataFrame()
df400[:temp] = 1:1:1.0e3
df400[:time] = 0.0
df400[:ed] = 400.0
df400[:str] = "0.03"

df500 = DataFrame()
df500[:temp] = 1:1:1.0e3
df500[:time] = 0.0
df500[:ed] = 500.0
df500[:str] = "0.04"

df = DataFrame()
df = vcat(df, df100, df200, df300, df400, df500)

for i in 1:size(df[:temp],1)
  if i%1000 == 0 println("$i of $(size(df,1))") end
  df[:time][i] = τ(df[:ed][i],df[:temp][i])
  df[:ed][i] = df[:ed][i]*K2eV
end

p1 = plot(
          df,
          x="temp",
          y="time",
          color="str",
          Geom.smooth,
          Scale.color_discrete,
          Scale.y_log10,
          Scale.x_log10,
          Guide.xlabel("Temperature (K)"),
          Guide.ylabel("Hopping time (s)"),
          Guide.colorkey("E<sub>b</sub>(eV)"),
         )
push!(p1,plottheme)

draw(PDF("f0.pdf",6inch,4.5inch),p1)

println("Ending script")
