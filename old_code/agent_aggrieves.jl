using StatsBase
using Agents


# For practical purposes we're now in Ethiopia
# Ethnicities would be Amhara (A) and Afar (ea)
# Thus, gramars would be amharic (L1; G1; P1) and afar (L2; G2; P2)


# Ethnicity would now be the same as language, but would eventualy change

# We create the agent: 
mutable struct ethnic 
   e::String # probability of using a language (Substitutes P1)
   g::Float64 # Level of grievance (Substitutes p in theory of Henri)
   gr::Float64 # Grievance rate; how much unsuccesful communication matters. 
end

jorge = ethnic("A", 0.2, 0.05)

struct me_country
      P1::Float64 # Probability of ethnic A
      P2::Float64 # Probability of ethnic a 
end   

Ethiopia = me_country(0.7, 0.3) # 70% of amaras, 30% of afars 


function sample_ethnic(x::me_country) # me_country is any country. The space
     sample(["L1", "L2"], Weights([x.P1, x.P2]))
end 

sample_ethnic(Ethiopia) # We sample one language 


function interaction!(x::ethnic, y::me_country)
    e = x.e # Selects one ethnic agent.  Later would be to pick a random agent. 
    s = sample_ethnic(y) # Elects one ethnicity 

    if e == "A" && s == "L1"
        x.g = x.g + x.gr
      elseif e == "A" && s == "L2"
        x.g = x.g - x.gr
      elseif e == "a" && s == "L1"
        x.g = x.g - x.gr
      elseif e == "a" && s == "L2"
        x.g = x.g + x.gr
      end
    
      return x.g

end


interaction!(jorge, Ethiopia)






