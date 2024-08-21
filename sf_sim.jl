using Pkg
using Plots
using Agents
using Graphs
using StatsBase
using Statistics
using DataFrames

@agent struct sf_ethnic(GraphAgent)
    e::String # probability of using a language (Substitutes P1). The moment is ethnicity. 
    g::Float64 # Level of grievance 
    gr::Float64 # Grievance rate; how much unsuccesful communication matters.
    m::Integer # 1 if mobilized 0 Otherwise 
end

function sf_communication!(x::sf_ethnic, y::sf_ethnic)
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

 if x.g >= 0.8
    x.m = 1
 end 

 if y.g >= 0.8
    y.m = 1
 end 
end


function sf_step!(agent::sf_ethnic, model)
    try
      interlocutor = random_nearby_agent(agent, model)
      sf_communication!(interlocutor, agent)
    catch
    end
end

sf_model = StandardABM(sf_ethnic,
                    GraphSpace(static_scale_free(100, 200, 2)),
                    agent_step! = sf_step!)

for i in 1:100
  add_agent_single!(sf_model; 
                      e = sample(["A", "a"], Weights([0.7, 0.3])),
                      g = 0.2,
                      gr = 0.001, 
                      m = 0)
end

data_sf, _ = run!(sf_model, 1000; adata = [:g, :e, :m])

plot(data_sf.time, data_sf.m, group=data_sf.id)

