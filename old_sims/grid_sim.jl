using Pkg
using Agents
using StatsBase
using DataFrames

# We create ethnic agents. 
@agent struct ethnic(GridAgent{2}) 
    e::String # probability of using a language (Substitutes P1). The moment is ethnicity. 
    g::Float64 # Level of grievance (Substitutes p in theory of Henri).
    gr::Float64 # Grievance rate; how much unsuccesful communication matters. (Substitutes gamma).
    m::Integer
end


function communication!(x::ethnic, y::ethnic)
    e = x.e # Ethnicity of first random agent
    s = y.e # Ethnicty of second random agent

    if e == "A" && s == "a"
        x.g = x.g + x.gr
        y.g = y.g + y.gr
    elseif e == "A" && s == "A"
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    elseif e == "a" && s == "A"
        x.g = x.g + x.gr
        y.g = y.g + y.gr
    elseif e == "a" && s == "a"
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    end
      
 return y.g
end


dims = (50, 50)
space = GridSpaceSingle(dims)

function e_step!(agent::ethnic, model)
  interlocutor = random_nearby_agent(agent, model)
  if interlocutor !== nothing
    communication!(interlocutor, agent)
  end
end

model = StandardABM(ethnic, space; 
                    agent_step! = e_step!)

for i in 1:2500
  add_agent_single!(model; 
                      e = sample(["A", "a"], Weights([0.7, 0.3])),
                      g = 0.2,
                      gr = 0.001)
end

nagents(model)

data_grid, _ = run!(model, 100; adata = [:g])


function getg(a)
    return a.g
end



fig, meta = abmplot(model; agent_color = getg)
fig