using Gadfly
using DataFrames

m_p = 1.6726218e-27 #Proton mass in kg
MeV2J = 1.6021766e-13 #1 MeV in J
eV2J = 1.6021766e-19 #1 eV in J
c = 2.998e8 #Speed of Light in a Vacuum in m/s
debug = false
Emin = 3.0e5 #Minimum energy in eV
exponent = 2.6

function j(E)
  Eg = E/1.0e9
  factor1 = 0.90/(0.85 + Eg)^exponent
  factor2 = 1.0/(1.0 + 0.01/Eg)
  return 4*π*factor1*factor2
end

function β_i(E)
  EJ = E*eV2J
  return sqrt((2.0*EJ)/m_p)/c
end

function σ_i(E)
  β =  β_i(E)
  factor1 = (1.23e-20)/(β^2)
  logfactor = log10((β^2)/(1.0-β^2))
  factor2 = 6.20 + logfactor - 0.43*β^2
  return factor1*factor2
end

function integrand(E)
  return j(E)*σ_i(3.0e5)
end

energies = Emin:5.0e7:1.0e10

flux = Array(Float64,size(energies,1))

for i in 1:size(energies,1)
  flux[i] = j(energies[i])
end

p1 = plot(x=energies/1.0e9,y=flux,Geom.line,Scale.x_log10,Scale.y_log10)

intFlux = quadgk(integrand,Emin,Inf)
intFlux = 2.0*(5.0/3.0)*intFlux[1]

println("Integrated Flux=$(intFlux)")

println("Ending script")
