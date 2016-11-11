using DataFrames
using Gadfly

# Input parameters
path = "/home/cns/losalamos/"
abundanceFile = "trackplot.csv"
plotname = "trackplot.pdf"
xmin = 1
xmax = 119 
imax = 339.
jmax = 119.
kmax = 119.
isize = 1.0e-5*1e7 #nm
jsize = 3.5e-6*1e7 #cm
ksize = 3.5e-6*1e7 #cm
xtrack=(53/119)*jsize
ytrack=(61/119)*ksize


plottheme = Gadfly.Theme(
                        default_point_size=1pt,
                        line_width=2pt,
                        minor_label_font_size=13pt,
                        minor_label_color=colorant"black",
                        major_label_font_size=15pt,
                        major_label_color=colorant"black",
                        key_label_color=colorant"black",
                        key_title_color=colorant"black",
                        key_title_font_size=15pt,
                        key_label_font_size=13pt,
                        grid_color=colorant"black",
                        highlight_width=0pt)

println("Reading input file")
track = readtable(
                  path*abundanceFile,
                  names = [:z, :y, :x, :Species, :Action],
                  eltypes = [Float64, Float64, Float64, UTF8String, UTF8String],
                  header = false
                 )

for i in 1:nrow(track)
  track[:z][i] = ((track[:z][i]/imax)*isize)
  track[:y][i] = ((track[:y][i]/jmax)*jsize)
  track[:x][i] = ((track[:x][i]/kmax)*ksize)
end

track = track[isize.>track[:z].>0,:]
track = track[jsize.>track[:y].>0,:]
track = track[ksize.>track[:x].>0,:]

# trackview_df = DataFrame()
# trackview_df = vcat(trackview_df,
#                     DataFrame(
#                               x=track[:j],
#                               y=track[:i],
#                               Species=track[:Species],
#                               view="View 1"
#                               ),
#                     DataFrame(
#                               x=track[:k],
#                               y=track[:i],
#                               Species=track[:Species],
#                               view="View 2"
#                               ),
#                     DataFrame(
#                               x=track[:k],
#                               y=track[:j],
#                               Species=track[:Species],
#                               view="View 3"
#                               )
#                     )

dens_df = DataFrame()
dens_df = vcat(dens_df,
               DataFrame(
                         x=track[:x],
                         y=track[:y],
                         r=0.0,
                         Species=track[:Species]
                         )
              )

for i in 1:length(dens_df[:x])
  dens_df[:r][i] = sqrt((dens_df[:x][i]-xtrack)^2 + (dens_df[:y][i]-ytrack)^2)
end

#Sort the columns by r-value
sort!(dens_df, cols = [order(:r)])
#Find the radius containing 2σ of the damage
P = 95.45
tot = nrow(dens_df)
ind = round(Int,((P*tot)/100))
radius = dens_df[:r][ind]

function circletop(x,h,k,r)
  sqrt(r^2 - (x-h)^2) + k
end

function circlebottom(x,h,k,r)
   -1*sqrt(r^2 - (x-h)^2) + k
end

#Generate the circle that will be plotted over the top-down graph
xstart = xtrack-radius
xend = xtrack+radius
xpoint = xstart:1e-2:xend
ypoint = Array(Float32,size(xpoint,1))
ypoint2 = Array(Float32,size(xpoint,1))
for i in 1:size(xpoint,1)
  ytemp = 0.0
  xtemp = xpoint[i]
  ytemp = circletop(xtemp,xtrack,ytrack,radius)
  ypoint[i] = ytemp
  ypoint2[i] = circlebottom(xtemp,xtrack,ytrack,radius)
end


println("Now plotting data")

pij = plot(
           track,
           x="y",
           y="z",
          #  color="Species",
           color="Action",
           Coord.cartesian(fixed=true),
           Geom.point,
           Guide.xlabel("y (nm)"),
           Guide.ylabel("z (nm)"),
           Scale.x_continuous(minvalue=0, maxvalue=50),
           Scale.y_continuous(minvalue=0, maxvalue=50),
           Scale.color_discrete_manual(colorant"magenta",colorant"green",colorant"deepskyblue")
           )
push!(pij,plottheme)


pik = plot(
           track,
           x="x",
           y="z",
          #  color="Species",
           color="Action",
           Geom.point,
           Guide.xlabel("x (nm)"),
           Guide.ylabel("z (nm)"),
           Coord.cartesian(fixed=true),
           Scale.x_continuous(minvalue=0, maxvalue=50),
           Scale.y_continuous(minvalue=0, maxvalue=50),
           Scale.color_discrete_manual(colorant"magenta",colorant"green",colorant"deepskyblue")
          #  Scale.color_discrete_manual(colorant"deepskyblue",colorant"magenta",colorant"green")
          )

push!(pik,plottheme)

pjk_path = plot(
           track,
           x="x",
           y="y",
          #  color="Species",
           color="Action",
           Geom.point,
           Guide.xlabel("x (nm)"),
           Guide.ylabel("y (nm)"),
           Coord.cartesian(fixed=true),
           Scale.x_continuous(minvalue=0, maxvalue=50),
           Scale.y_continuous(minvalue=0, maxvalue=50),
           Scale.color_discrete_manual(colorant"magenta",colorant"green",colorant"deepskyblue")
          #  Scale.color_discrete_manual(colorant"magenta",colorant"deepskyblue",colorant"green")
          #  Scale.color_discrete_manual(colorant"deepskyblue",colorant"magenta",colorant"green")
          )
push!(pjk_path,plottheme)

pjk = plot(
           dens_df[50.>dens_df[:x].>0,:],
          #  dens_df,
           x="x",
           y="y",
#           color="Species",
#           Geom.point,
#           Geom.contour,
           Guide.xlabel("x (nm)"),
           Guide.ylabel("y (nm)"),
           Coord.cartesian(fixed=true),
           Geom.histogram2d(xbincount=55, ybincount=55),
           Scale.x_continuous(minvalue=0, maxvalue=50),
           Scale.y_continuous(minvalue=0, maxvalue=50),
          )
push!(pjk,plottheme)

push!(pjk,layer(x=xpoint,y=ypoint,Geom.path,Theme(default_color=colorant"red")))
push!(pjk,layer(x=xpoint,y=ypoint2,Geom.path,Theme(default_color=colorant"red")))


#set_default_plot_size(50cm, 7.5cm)
# p_tot = plot(trackview_df,
#              layer(
#                    trackview_df[trackview_df[:Species] .== "electron", :],
#                    Geom.subplot_grid(Geom.point),
#                    xgroup="view", x="x", y="y",
#                    color="Species",
#                    Theme(default_point_size=1.5pt),
#                    ),
#              layer(
#                    trackview_df[trackview_df[:Species] .== "proton", :],
# #                   Geom.subplot_grid(Geom.point),
#                    Geom.point,
#                    xgroup="view", x="x", y="y",
#                    color="Species",
#                    Theme(default_point_size=1.5pt),
#                    )
#
#             )
#

#push!(p_tot, layer(trackview_df[trackview_df[:Species] .== "low-energy electron", :], xgroup="view", x="x", y="y", color="Species",
#             Geom.subplot_grid(Geom.point)))

println("Now exporting plot")
draw(PDF(path*"f1a.pdf", 6inch, 5inch), pij)
draw(PDF(path*"f1b.pdf", 6inch, 5inch), pik)
draw(PDF(path*"f1c.pdf", 6inch, 5inch), pjk_path)
draw(PDF(path*"f1d.pdf", 6inch, 5inch), pjk)
println("Now ending script")
