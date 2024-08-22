using Pkg
using Plots
using Agents
using Graphs
using StatsBase
using GraphPlot
using Statistics
using DataFrames

@agent struct sf_ethnic(GraphAgent)
    e::String # probability of using a language (Substitutes P1). The moment is ethnicity. 
    b::Integer # Bilingualism
    g::Float64 # Level of grievance 
    gr::Float64 # Grievance rate; how much unsuccesful communication matters.
    m::Integer # 1 if mobilized 0 Otherwise 
end

function sf_communication!(x::sf_ethnic_b, y::sf_ethnic_b)
    e = x.e # Ethnicity of first random agent
    s = y.e # Ethnicty of second random agent

    Le = x.b
    ls = y.b

    x.g = clamp(x.g, 0.001, 0.999)
    y.g = clamp(y.g, 0.001, 0.999)

    if (e == "A" && s == "a") && (Le == 0 || Ls == 0)
        x.g = x.g + x.g * x.gr
        y.g = y.g + y.gr * y.gr
    elseif (e == "A" && s == "a") && (Le == 1 || Ls == 0)
        x.g = x.g - x.g * x.gr
        y.g = y.g - y.gr * y.gr
    elseif (e == "A" && s == "a") && (Le == 0 || Ls == 1)
        x.g = x.g - x.g * x.gr
        y.g = y.g - y.gr * y.gr
    elseif (e == "A" && s == "a") && (Le == 1 || Ls == 1)
        x.g = x.g - x.g * x.gr
        y.g = y.g - y.gr * y.gr
    elseif e == "A" && s == "A" 
        x.g = x.g - x.gr * x.gr
        y.g = y.g - y.gr * y.gr
    elseif e == "a" && s == "A"  && (Le == 0 || Ls == 0)
        x.g = x.g + x.g * x.gr
        y.g = y.g + y.gr * y.gr
    elseif (e == "a" && s == "A") && (Le == 1 || Ls == 0)
        x.g = x.g - x.g * x.gr
        y.g = y.g - y.gr * y.gr
    elseif (e == "a" && s == "A") && (Le == 0 || Ls == 1)
        x.g = x.g - x.g * x.gr
        y.g = y.g - y.gr * y.gr
    elseif (e == "a" && s == "A") && (Le == 1 || Ls == 1)
        x.g = x.g - x.g * x.gr
        y.g = y.g - y.gr * y.gr
    elseif e == "a" && s == "a"  
        x.g = x.g - x.gr * x.gr
        y.g = y.g - y.gr * y.gr
    end
  
end

function sf_radicalization!(x::sf_ethnic_b, y::sf_ethnic_b)

    if (x.g > 0.6 && x.e != y.e) || x.g > 0.8
        x.m = 1
    end

    if (x.g < 0.6 && x.e == y.e) || x.g < 0.2
        x.m = 0
    end
    
end


function sf_step!(agent::sf_ethnic, model)
    try
      resident = random_nearby_agent(agent, model)
      sf_communication!(resident, agent)
    catch
    end 

    try
        random_resident = random_nearby_agent(agent, model)
        sf_radicalization!(agent, random_resident)
    catch
    end
end



# No Bilingualism

sf_model_0 = StandardABM(sf_ethnic,
                    GraphSpace(static_scale_free(100, 200, 2)),
                    agent_step! = sf_step!)

for i in 1:100
    add_agent_single!(sf_model_0;
                        e = sample(["A", "a"], Weights([0.7, 0.3])),
                        b = 0, 
                        g = 0.2,
                        gr = 0.001, 
                        m = 0)
                      end


plot(sf_df_0.time, sf_df_0.g, group=sf_df_0.id)

sf_df_0, _ = run!(sf_model_0, 100; adata = [:g, :e, :m])

plot(sf_df_0.time, sf_df_0.g, group=sf_df_0.id)

# Bilingualism at 25%

sf_model_25 = StandardABM(sf_ethnic,
                    GraphSpace(static_scale_free(100, 200, 2)),
                    agent_step! = sf_step!)



for i in 1:100
  add_agent_single!(sf_model_25; 
                      e = sample(["A", "a"], Weights([0.7, 0.3])),
                      b = sample([0, 1], Weights([0.75, 0.25])), 
                      g = 0.2,
                      gr = 0.001, 
                      m = 0)
end

sf_df_25, _ = run!(sf_model_25, 100; adata = [:g, :e, :m])

plot(sf_df_25.time, sf_df_25.g, group=sf_df_25.id)


# Bilingualism at 50%

sf_model_50 = StandardABM(sf_ethnic,
                    GraphSpace(static_scale_free(100, 200, 2)),
                    agent_step! = sf_step_b!)



for i in 1:100
  add_agent_single!(sf_model_50; 
                      e = sample(["A", "a"], Weights([0.7, 0.3])),
                      b = sample([0, 1], Weights([0.5, 0.5])), 
                      g = 0.2,
                      gr = 0.001, 
                      m = 0)
end

sf_df_50, _ = run!(sf_model_50, 100; adata = [:g, :e, :m])

plot(sf_df_50.time, sf_df_50.g, group=sf_df_50.id)


