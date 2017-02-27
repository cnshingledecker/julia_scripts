#=
This script converts CIRIS track output to PBD format output for use 
in programs such as PYMOL
=#

using DataFrames
using Formatting

path = "/scratch/cns7ae/ciris/pbd_trackplot/"
trackfile = "trackplot.wsv"

trackdf = readtable(
                    path*trackfile,
                    names = [:type, :energy, :z, :x, :y, :pbranch, :generation],
                    eltypes = [String, Float64, Int64, Int64, Int64, Int64, Int64],
                    header = false
                   )



println("Ending script")
