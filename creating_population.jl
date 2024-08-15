using StatsBase
import Random
mutable struct ethnic 
    e::String # probability of using a language (Substitutes P1)
    g::Float64 # Level of grievance (Substitutes p in theory of Henri)
    gr::Float64 # Grievance rate; how much unsuccesful communication matters. 
 end

 sample(["A", "a"], weights=([0.7, 0.3]))

 sample(["L1", "L2"], Weights([x.P1, x.P2]))


function create_ethnic()
    e = sample(["A", "a"], Weights([0.7, 0.3]))
    g = rand()
    gr = 0.001

    return ethnic(e, g, gr)
end 

Ethiopia_pop = [create_ethnic() for t in 1:100]