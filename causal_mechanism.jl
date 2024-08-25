


# Struct for agents. 

@agent struct sf_ethnic(GraphAgent)
    e::String # Ethnicity 
    b::Integer # Bilingualism
    g::Float64 # Level of grievance 
    gr::Float64 # Grievance rate. 
    m::Integer # 1 if mobilized 0 Otherwise 
end


# Main function: causal mechanism for increase of grievance, communication between agents.

function sf_communication!(x::sf_ethnic, y::sf_ethnic)
    e = x.e # Ethnicity of first random agent
    s = y.e # Ethnicty of second random agent

    Le = x.b # Bilinguialism of first agent 
    Ls = y.b # Bilingualism of second agent 
    
    # Coerce function so grievance can only be between 0 and 1
    x.g = clamp(x.g, 0, 1) 
    y.g = clamp(y.g, 0, 1)
    
    # Different ethnicity, unsuccesful communication
    if (e == "A" && s == "a") && (Le == 0 || Ls == 0) 
        x.g = x.g + (x.g * x.gr)
        y.g = y.g + (y.gr * y.gr)

    # Different ethnicity, succesfull communication
    elseif (e == "A" && s == "a") && (Le == 1 || Ls == 0)
        x.g = x.g - x.gr
        y.g = y.g - x.gr
    elseif (e == "A" && s == "a") && (Le == 0 || Ls == 1)
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    elseif (e == "A" && s == "a") && (Le == 1 || Ls == 1)
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    
    # Same ethnicity 
    elseif e == "A" && s == "A" 
        x.g = x.g - x.gr
        y.g = y.g - y.gr

    # Different ethnicity, unsuccesful communication
    elseif (e == "a" && s == "A")  && (Le == 0 || Ls == 0)
        x.g = x.g + (x.g * x.gr)
        y.g = y.g + y.gr
    
    # Different ethnicity, succesfull communication
    elseif (e == "a" && s == "A") && (Le == 1 || Ls == 0)
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    elseif (e == "a" && s == "A") && (Le == 0 || Ls == 1)
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    elseif (e == "a" && s == "A") && (Le == 1 || Ls == 1)
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    
    # Same ethnicity 
    elseif e == "a" && s == "a"  
        x.g = x.g - x.gr
        y.g = y.g - y.gr
    end
    
    # Coerce function so grievance can only be between 0 and 1
    x.g = clamp(x.g, 0, 1) 
    y.g = clamp(y.g, 0, 1)
  
end

# Second function: the consequence of communication and grievance: radicalization.

function sf_radicalization!(x::sf_ethnic, y::sf_ethnic)

    # If agents is moderately aggrieved but a companion mobilizes, she mobilises (joins the fire)
    if x.g > 0.6 && (x.e == y.e && y.m == 1)
        x.m = 1
    # If the agent is sufficiently aggrieved, she may mobilize alone (starts the fire)
    elseif  x.g > 0.8  
        x.m = 1
    # No reason to mobilize 
    else 
        x.m = 0
    end
    
end

# Third function: interation step for the model

function sf_step!(agent::sf_ethnic, model)
    # Communication with a random neighbour.
    try
      resident = random_nearby_agent(agent, model)
      sf_communication!(resident, agent)
    catch
    end 

    # After communication moves to another agent. 
    try
        random_resident = random_nearby_agent(agent, model)
        sf_radicalization!(agent, random_resident)
    catch
    end
end

# Fourth function: variation of the interation step. 

function sf_step_prog!(agent::sf_ethnic, model)
    
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
    # Looks for another 
    random_resident = random_nearby_agent(agent, model)
    sf_radicalization!(agent, random_resident)
    catch
    end

end
