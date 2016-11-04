using DataFrames
using Gadfly

# Input parameters
path = "/home/cns/losalamos/"
ratesFile = "rates.csv"

println("Reading input file")
modelOutput = readtable(
                  path*ratesFile,
                  names = [:Geminacy, :J2, :J3, :k12, :k13],
                  eltypes = [Float64,Float64,Float64,Float64,Float64],
                  header = false
                  )

g_mean = mean(modelOutput[:Geminacy])
j2_mean = mean(modelOutput[:J2])
j3_mean = mean(modelOutput[:J3])
k12_mean = mean(modelOutput[:k12])
k13_mean = mean(modelOutput[:k13])


println("Geminacy=$g_mean")
println("J2=$j2_mean")
println("J3=$j3_mean")
println("k12=$k12_mean")
println("k13=$k13_mean")

maxG = maximum(modelOutput[:Geminacy],1)
maxJ2 = maximum(modelOutput[:J2],1)
maxJ3 = maximum(modelOutput[:J3],1)
