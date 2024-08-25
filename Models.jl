using Pkg
using CSV
using Plots
using Agents
using Graphs
using Random
using StatsBase
using GraphPlot
using Statistics
using DataFrames

include("causal_mechanism.jl")

# Model 1: No bilingualism

model_1 = StandardABM(
    sf_ethnic, # Populated by ethnic agents 
    GraphSpace(static_scale_free(100, 500, 4)), # 100 agents, 500 links, 4 k initially
    agent_step! = sf_step!) # two step iterations.
    
    
for i in 1:100 # We populate the network
        add_agent_single!(model_1;
                            e = sample(["A", "a"], Weights([0.7, 0.3])), # 70% A, 30% a
                            b = 0, # All non-bilingual
                            g = 0.5,
                            gr = 0.1, # Bad communication matters 10%
                            m = 0)
end 

# Model 2: 25% of bilingualism

model_2 = StandardABM(
    sf_ethnic,
    GraphSpace(static_scale_free(100, 500, 4)),
    agent_step! = sf_step!) 



for i in 1:100
  add_agent_single!(model_2; 
                      e = sample(["A", "a"], Weights([0.7, 0.3])),
                      b = sample([0, 1], Weights([0.75, 0.25])), # 25% of bilingual agents
                      g = 0.5,
                      gr = 0.1, 
                      m = 0)
end

# Model 3: 50% of bilingualism

model_3 = StandardABM(
    sf_ethnic,
    GraphSpace(static_scale_free(100, 500, 4)),
    agent_step! = sf_step!)



for i in 1:100
  add_agent_single!(model_3; 
                      e = sample(["A", "a"], Weights([0.7, 0.3])),
                      b = sample([0, 1], Weights([0.5, 0.5])), # 50% of bilingual agents
                      g = 0.5,
                      gr = 0.1, 
                      m = 0)
end

# Model 4: Progressive bilingualism

model_4 = StandardABM(
    sf_ethnic,
    GraphSpace(static_scale_free(100, 500, 4)),
    agent_step! = sf_step_prog!)

for i in 1:100
        add_agent_single!(model_4;
                            e = sample(["A", "a"], Weights([0.7, 0.3])),
                            b = 0, # Starts with no bilingual agents
                            g = 0.5,
                            gr = 0.1, # Bad communication matters 5%
                            m = 0)
end

# Running the models

Random.seed!(123)

df_model1, _ = run!(model_1, 300; adata = [:g, :e, :m, :b]) 
CSV.write("data/df_model1.csv", df_model1)

df_model2, _ = run!(model_2, 300; adata = [:g, :e, :m, :b]) 
CSV.write("data/df_model2.csv", df_model2)

df_model3, _  = run!(model_3, 300; adata = [:g, :e, :m, :b]) 
CSV.write("data/df_model3.csv", df_model3)

df_model4, _  = run!(model_4, 300; adata = [:g, :e, :m, :b]) 
CSV.write("data/df_model4.csv", df_model4)


# Importing the dataframes

df_model1 = DataFrame(CSV.read("data/df_model1.csv", DataFrame)) 
df_model2 = DataFrame(CSV.read("data/df_model2.csv", DataFrame)) 
df_model3 = DataFrame(CSV.read("data/df_model3.csv", DataFrame)) 
df_model4 = DataFrame(CSV.read("data/df_model4.csv", DataFrame)) 

# Plotting the grievance 

plot(
    df_model1.time, 
    df_model1.g, 
    group=df_model1.id, 
    xaxis = "Time", 
    yaxis = "Grievance",
    legend = false)

plot(
    df_model2.time, 
    df_model2.g, 
    group=df_model2.id,
    xaxis = "Time", 
    yaxis = "Grievance",
    legend = false)

plot(
    df_model3.time, 
    df_model3.g, 
    group=df_model3.id, 
    xaxis = "Time", 
    yaxis = "Grievance",
    legend = false)

plot(
    df_model4.time, 
    df_model4.g, 
    group=df_model4.id, 
    xaxis = "Time", 
    yaxis = "Grievance",
    legend = false)

# Grouped by ethnicity

grouped_1 = combine(groupby(df_model1, [:e, :time]), :g => mean) 
CSV.write("data/grouped_1.csv", grouped_1)

grouped_2 = combine(groupby(df_model2, [:e, :time]), :g => mean) 
CSV.write("data/grouped_2.csv", grouped_2)

grouped_3 = combine(groupby(df_model3, [:e, :time]), :g => mean) 
CSV.write("data/grouped_3.csv", grouped_3)

grouped_4 = combine(groupby(df_model4, [:e, :time]), :g => mean) 
CSV.write("data/grouped_4.csv", grouped_4)

# Plotted by ethnicity

plot(
    grouped_1.time, 
    grouped_1.g_mean, 
    group=grouped_1.e, 
    xaxis = "Time", 
    yaxis = "Average grievance per ethnic")

plot(
    grouped_2.time, 
    grouped_2.g_mean,
    group=grouped_2.e, 
    xaxis = "Time", 
    yaxis = "Average grievance per ethnic")

plot(
    grouped_3.time, 
    grouped_3.g_mean, 
    group=grouped_3.e, 
    xaxis = "Time", 
    yaxis = "Average grievance per ethnic")

plot(
    grouped_4.time, 
    grouped_4.g_mean, 
    group=grouped_4.e, 
    xaxis = "Time", 
    yaxis = "Average grievance per ethnic")



