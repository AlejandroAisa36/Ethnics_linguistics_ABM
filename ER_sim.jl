using Pkg
using Plots
using Agents
using Graphs
using StatsBase
using Statistics
using DataFrames

# We create ethnic agents. 
@agent struct er_ethnic(GraphAgent)
    e::String # probability of using a language (Substitutes P1). The moment is ethnicity. 
    g::Float64 # Level of grievance (Substitutes p in theory of Henri).
    gr::Float64 # Grievance rate; how much unsuccesful communication matters. (Substitutes gamma).
end


function er_communication!(x::er_ethnic, y::er_ethnic)
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
    
    x.g = clamp(x.g, 0, 1)
    y.g = clamp(y.g, 0, 1)

 return y.g
end


function er_step!(agent::er_ethnic, model)
  try
    interlocutor = random_nearby_agent(agent, model)
    er_communication!(interlocutor, agent)
  catch
  end
end

er_model = StandardABM(er_ethnic,
                    GraphSpace(erdos_renyi(100, 0.5)),
                    agent_step! = er_step!)

for i in 1:100
  add_agent_single!(er_model; 
                      e = sample(["A", "a"], Weights([0.7, 0.3])),
                      g = 0.2,
                      gr = 0.001)
end

nagents(er_model)

data_er, _ = run!(er_model, 1000; adata = [:g, :e])

plot(data_er.time, data_er.g, group=data_er.id)