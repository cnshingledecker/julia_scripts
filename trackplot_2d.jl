using DataFrames
using Gadfly
using Cairo

# Input parameters
path = "/scratch/cns7ae/ciris/trackplot_final17/"
abundanceFile = "trackplot.csv"
plotname = "trackplot.pdf"
imax = 428.
jmax = 428.
kmax = 428.
isize = 1.3e-5*1e8 #nm
jsize = 1.3e-5*1e8 #cm
ksize = 1.3e-5*1e8 #cm
xtrack=(237.0/jmax)*(jsize)
ytrack=(249.0/kmax)*(ksize)


plottheme = Gadfly.Theme(
                        default_point_size=1.5pt,
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
                  eltypes = [Float64, Float64, Float64, String, String],
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
  sqrt((r^2 - (x-h)^2)) + k
end

function circlebottom(x,h,k,r)
   -1*sqrt((r^2 - (x-h)^2)) + k
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
           track[1000.>track[:z].>1,:],
           x="y",
           y="z",
           Coord.cartesian(aspect_ratio=1),
           Geom.point,
           Guide.xlabel("y (\u212b)"),
           Guide.ylabel("z (\u212b)"),
           Guide.manual_color_key(
                                   "Species",
                                   ["Primary Ion","Secondary Electron"],
                                   ["green","deepskyblue"],
                                  ),
           Scale.x_continuous(minvalue=500, maxvalue=1000),
           Scale.y_continuous(minvalue=0, maxvalue=500),
           Scale.color_discrete_manual(colorant"magenta",colorant"green",colorant"deepskyblue")
           )
push!(pij,plottheme)

proton_track = DataFrame()
proton_track[:z] = linspace(1,1000,1000)
proton_track[:y] = 719.86
proton_track[:x] = 756.308
proton_track[:Species] = "proton"

push!(pij,layer(proton_track[proton_track[:Species].=="proton",:],x="y",y="z",Geom.line,Theme(default_color=colorant"green",line_width=2pt)))


pik = plot(
           track[1000.>track[:z].>1,:],
           x="x",
           y="z",
           Geom.point,
           Guide.manual_color_key(
                                   "Species",
                                   ["Primary Ion","Secondary Electron"],
                                   ["green","deepskyblue"],
                                  ),
           Guide.xlabel("x (\u212b)"),
           Guide.ylabel("z (\u212b)"),
           Coord.cartesian(aspect_ratio=1),
           Scale.x_continuous(minvalue=500, maxvalue=1000),
           Scale.y_continuous(minvalue=0, maxvalue=500),
           Scale.color_discrete_manual(colorant"magenta",colorant"green",colorant"deepskyblue")
          #  Scale.color_discrete_manual(colorant"deepskyblue",colorant"magenta",colorant"green")
          )

push!(pik,plottheme)
push!(pik,layer(proton_track[proton_track[:Species].=="proton",:],x="x",y="z",Geom.line,Theme(default_color=colorant"green",line_width=2pt)))


pjk_path = plot(
                track,
                Guide.xlabel("x (\u212b)"),
                Guide.ylabel("y (\u212b)"),
                Coord.cartesian(aspect_ratio=1.0),
                Scale.x_continuous(minvalue=500, maxvalue=1000),
                Scale.y_continuous(minvalue=500, maxvalue=1000),
                Scale.color_discrete_manual(colorant"magenta",colorant"green",colorant"deepskyblue"),
           Guide.manual_color_key(
                                   "Species",
                                   ["Primary Ion","Secondary Electron"],
                                   ["green","deepskyblue"],
                                  ),
                layer(
                      x=[756.3],
                      y=[719.86],
                      Geom.point,
                      Theme(default_color=colorant"green",
                             default_point_size=3pt,
                             highlight_width=0pt)
                      ),
                layer(
                      x="x",
                      y="y",
                      Geom.point,
                      ),

                )
push!(pjk_path,plottheme)
#push!(pjk_path,layer(track[track[:Species].=="proton",:],x="x",y="y",Geom.point,Theme(default_color=colorant"green",default_point_size=5pt,highlight_width=0pt))) 

pjk = plot(
#           dens_df[50.>dens_df[:x].>0,:],
           dens_df,
           x="x",
           y="y",
#           color="Species",
#           Geom.point,
#           Geom.contour,
           Guide.xlabel("x (nm)"),
           Guide.ylabel("y (nm)"),
           Coord.cartesian(fixed=true),
           Geom.histogram2d(xbincount=55, ybincount=55),
#           Scale.x_continuous(minvalue=0, maxvalue=50),
#           Scale.y_continuous(minvalue=0, maxvalue=50),
            Scale.color_log10(colormap=Scale.lab_gradient(
                                                          colorant"darkblue",
                                                          colorant"mediumblue",
                                                          colorant"deepskyblue",
                                                          colorant"turquoise",
                                                          colorant"lightgreen",
                                                          colorant"gold",
                                                          colorant"yellow"
                                                          ))
            )
push!(pjk,plottheme)

circle_df = DataFrame()
circle_df = vcat(circle_df,
                  DataFrame(
                            x=xpoint,
                            y=ypoint,
                            Action="radius= 182 \u212b"),
                  )


#push!(pjk,layer(circle_df,x="x",y="y",Geom.point,Theme(default_color=colorant"red")))
#push!(pjk_path,layer(circle_df,x="x",y="y",Geom.path,Theme(default_color=colorant"red")))
#push!(pjk_path,layer(x=xpoint,y=ypoint2,Geom.path,Theme(default_color=colorant"red")))


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
draw(PDF(path*"f3a.pdf", 5.5inch, 3.5inch), pij)
draw(PDF(path*"f3b.pdf", 5.5inch, 3.5inch), pik)
draw(PDF(path*"f3c.pdf", 5.5inch, 3.5inch), pjk_path)
draw(PDF(path*"f3d.pdf", 5.5inch, 3.5inch), pjk)

draw(PNG(path*"f3a.png", 6.5inch, 5inch), pij)
draw(PNG(path*"f3b.png", 6.5inch, 5inch), pik)
draw(PNG(path*"f3c.png", 6.5inch, 5inch), pjk_path)
draw(PNG(path*"f3d.png", 6.5inch, 5inch), pjk)

println("Now ending script")
