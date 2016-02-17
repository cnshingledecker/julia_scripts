#= 
This is a script that computes the total rate for non-thermal 
radiation chemistry processes using experimental and theoretical
data. 
=#

ϕ = 10.0E0 #cosmic-ray flux in cm^-2 s^-1
data = [0.88,0.59,6.22,2.86,1.66] # Ralf's experimental data in molecules/eV
S_e = 3.837E7 # Electronic stopping power in ASW in units of eV*cm^2/g
μ = 7.30606E-26 # 44 amu in grams (i.e. mass of acetaldehyle/vinylalcohol
G = μ*data
println("The experimental data in units of grams/eV is $G")

σ = G*S_e
println("The cross-section for this process is $σ")

σ_tot = sum(σ)
J = σ_tot*ϕ
println("********************************************")
println("The rate constant for the process is $J s^-1")
println("********************************************")
