

function communicate(x::VariationalLearner) # Pick grammar in henri's. 
    sample(["G1", "G2"], Weights([x.p, 1 - x.p])) # same as before, but two grammars and the p of success 
end
