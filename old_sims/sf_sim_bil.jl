using Pkg
using Plots
using Agents
using Graphs
using StatsBase
using GraphPlot
using Statistics
using DataFrames

@agent struct sf_ethnic(GraphAgent)
    e::String # Ethnicity 
    b::Integer # Bilingualism
    g::Float64 # Level of grievance 
    gr::Float64 # Grievance rate; how much unsuccesful communication matters.
    m::Integer # 1 if mobilized 0 Otherwise 
end

function sf_communication!(x::sf_ethnic, y::sf_ethnic)
    e = x.e # Ethnicity of first random agent
    s = y.e # Ethnicty of second random agent

    Le = x.b 
    Ls = y.b
    
    # Grievance can only be between 0 and 1
    x.g = clamp(x.g, 0.01, 0.99) 
    y.g = clamp(y.g, 0.01, 0.99)

    if (e == "A" && s == "a") && (Le == 0 || Ls == 0)
        x.g = x.g + (x.g * x.gr)
        y.g = y.g + y.gr
    elseif (e == "A" && s == "a") && (Le == 1 || Ls == 0)
        x.g = x.g - x.gr
        y.g = y.g - x.gr
    elseif (e == "A" && s == "a") && (Le == 0 || Ls == 1)
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    elseif (e == "A" && s == "a") && (Le == 1 || Ls == 1)
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    elseif e == "A" && s == "A" 
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    elseif (e == "a" && s == "A")  && (Le == 0 || Ls == 0)
        x.g = x.g + (x.g * x.gr)
        y.g = y.g + y.gr
    elseif (e == "a" && s == "A") && (Le == 1 || Ls == 0)
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    elseif (e == "a" && s == "A") && (Le == 0 || Ls == 1)
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    elseif (e == "a" && s == "A") && (Le == 1 || Ls == 1)
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    elseif e == "a" && s == "a"  
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    end
  
end

function sf_radicalization!(x::sf_ethnic, y::sf_ethnic)

    # If moderate aggrieved and companion mobilize, she mobilises (join the fire)
    if x.g > 0.6 && (x.e == y.e && y.m == 1)
        x.m = 1
    # She is as aggrieved that she may mobilize alone (starts the fire)
    elseif  x.g > 0.8  
        x.m = 1
    # No reason to mobilize 
    else 
        x.m = 0
    end
    
end


function sf_step!(agent::sf_ethnic, model)
    # Tries to communicate with a neighbour
    try
      resident = random_nearby_agent(agent, model)
      sf_communication!(resident, agent)
    catch
    end 

    # Wants to look for "help"
    try
        random_resident = random_nearby_agent(agent, model)
        sf_radicalization!(agent, random_resident)
    catch
    end
end



# No Bilingualism

sf_model_0 = StandardABM(sf_ethnic,
                    GraphSpace(static_scale_free(100, 500, 4)),
                    agent_step! = sf_step!)

for i in 1:100
    add_agent_single!(sf_model_0;
                        e = sample(["A", "a"], Weights([0.7, 0.3])),
                        b = 0, 
                        g = 0.2,
                        gr = 0.05, # Bad communication matters 5%
                        m = 0)
end

sf_df_0, _ = run!(sf_model_0, 300; adata = [:g, :e, :m])

plot(sf_df_0.time, sf_df_0.g, group=sf_df_0.id)

grouped_0 = combine(groupby(sf_df_0, [:e, :time]), :g => mean) 

plot(grouped_0.time, grouped_0.g_mean, group=grouped_0.e)


# Bilingualism at 25%

sf_model_25 = StandardABM(sf_ethnic,
                    GraphSpace(static_scale_free(100, 500, 4)),
                    agent_step! = sf_step!) 



for i in 1:100
  add_agent_single!(sf_model_25; 
                      e = sample(["A", "a"], Weights([0.7, 0.3])),
                      b = sample([0, 1], Weights([0.75, 0.25])), 
                      g = 0.2,
                      gr = 0.05, 
                      m = 0)
end

sf_df_25, _ = run!(sf_model_25, 300; adata = [:g, :e, :m])

plot(sf_df_25.time, sf_df_25.g, group=sf_df_25.id)

grouped_25 = combine(groupby(sf_df_25, [:e, :time]), :g => mean) 

plot(grouped_25.time, grouped_25.g_mean, group=grouped_25.e)


# Bilingualism at 50%

sf_model_50 = StandardABM(sf_ethnic,
                    GraphSpace(static_scale_free(100, 500, 4)),
                    agent_step! = sf_step!)



for i in 1:100
  add_agent_single!(sf_model_50; 
                      e = sample(["A", "a"], Weights([0.7, 0.3])),
                      b = sample([0, 1], Weights([0.5, 0.5])), 
                      g = 0.2,
                      gr = 0.05, 
                      m = 0)
end

sf_df_50, _ = run!(sf_model_50, 300; adata = [:g, :e, :m])

plot(sf_df_50.time, sf_df_50.g, group=sf_df_50.id)

grouped_50 = combine(groupby(sf_df_50, [:e, :time]), :g => mean) 

plot(grouped_50.time, grouped_50.g_mean, group=grouped_50.e)


# New model: progressive bilingualism 

function sf_step_prog!(agent::sf_ethnic, model)
    # Tries to communicate with a neighbour
    
    step = abmtime(model)

    try 
        resident = random_nearby_agent(agent, model)
        if step < 10
            agent.b = 0
            resident.b = 0
        elseif step >= 10 && step < 100
            agent.b = sample([0, 1], Weights([0.75, 0.25]))
            resident.b = sample([0, 1], Weights([0.75, 0.25]))
        else
            agent.b = sample([0, 1], Weights([0.5, 0.5]))
            resident.b = sample([0, 1], Weights([0.5, 0.5]))
        end
        # Communicates with a resident
    sf_communication!(resident, agent)

    catch
    end 

    try 
    # Looks for help
    random_resident = random_nearby_agent(agent, model)
    sf_radicalization!(agent, random_resident)
    catch
    end

end

sf_model_prog = StandardABM(sf_ethnic,
                    GraphSpace(static_scale_free(100, 500, 4)),
                    agent_step! = sf_step_prog!)

for i in 1:100
    add_agent_single!(sf_model_prog;
                        e = sample(["A", "a"], Weights([0.7, 0.3])),
                        b = 0, 
                        g = 0.2,
                        gr = 0.005, # Bad communication matters 5%
                        m = 0)
end

sf_df_prog, _ = run!(sf_model_prog, 300; adata = [:g, :e, :m])

plot(sf_df_prog.time, sf_df_prog.g, group=sf_df_prog.id)

grouped_prog = combine(groupby(sf_df_prog, [:e, :time]), :g => mean) 

plot(grouped_prog.time, grouped_prog.g_mean, group=grouped_prog.e)
