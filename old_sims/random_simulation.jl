using Pkg
using Agents
using StatsBase
using DataFrames

# We create ethnic agents. 
mutable struct ethnic_og 
    e::String # probability of using a language (Substitutes P1)
    g::Float64 # Level of grievance (Substitutes p in theory of Henri)
    gr::Float64 # Grievance rate; how much unsuccesful communication matters. 
end

# We create a population based on these ethnic agents 
function create_ethnic_og()
    e = sample(["A", "a"], Weights([0.7, 0.3]))
    g = rand()
    gr = 0.001

    return ethnic_og(e, g, gr)
end 

Ethiopia = [create_ethnic_og() for i in 1:100]

rand(Ethiopia)

function communication_og!(x::ethnic_og, y::ethnic_og)
    e = x.e # Ethnicity of first random agent
    s = y.e # Ethnicty of second random agent

    if e == "A" && s == "a"
        x.g = x.g + x.gr
        y.g = y.g + y.gr
      elseif e == "A" && s != "a"
        x.g = x.g - x.gr
        y.g = y.g - y.gr
      end

      return x.g
      

end


[communication_og!(rand(Ethiopia), rand(Ethiopia)) for t in 1:100]


mean([ethnic.g for ethnic in Ethiopia]) # Calculates the mean aggrievement within Ethiopia

function avg_me_g(x::Array{ethnic})
    mean([ethnic.g for ethnic in x])
end 

avg_me_g(Ethiopia)


history = [begin
             communication!(rand(Ethiopia), rand(Ethiopia))
             avg_me_g(Ethiopia)
             end for t in 1:1_000_000]

import Plots


using Plots
plot(1:1_000_000, history, color=:black, legend=false)


small_e = [create_ethnic() for i in 1:20]

small_history = [communication!(rand(small_e), l) for t in 1:100, l in small_e]

plot(small_history)