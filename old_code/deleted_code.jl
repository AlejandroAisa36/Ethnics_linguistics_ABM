

function communicate(x::VariationalLearner) # Pick grammar in henri's. 
    sample(["G1", "G2"], Weights([x.p, 1 - x.p])) # same as before, but two grammars and the p of success 
end


function sn_communication!(x::sn_ethnic, y::sn_ethnic)
    e = x.e # Ethnicity of first random agent
    s = y.e # Ethnicty of second random agent

    if x.g > 0 && y.g > 0
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
    elseif x.g <= 0 && y.g > 0
       if e == "A" && s == "a"  
         x.g = 0 + x.gr
         y.g = y.g + y.gr
       elseif e == "A" && s == "A"  
         x.g = 0 
         y.g = y.g - y.gr
       elseif e == "a" && s == "A" 
         x.g = 0 + x.gr
         y.g = y.g + y.gr
       elseif e == "a" && s == "a" 
         x.g = x.g - x.gr
         y.g = y.g - y.gr
        end
    elseif x.g > 0 && y.g <= 0
        if e == "A" && s == "a"  
          x.g = x.g + x.gr
          y.g = 0 + y.gr
        elseif e == "A" && s == "A"  
          x.g = x.g - x.gr
          y.g = 0
        elseif e == "a" && s == "A" 
          x.g = x.g + x.gr
          y.g = 0 + y.gr
        elseif e == "a" && s == "a" 
          x.g = x.g - x.gr
          y.g = 0
         end
    elseif x.g <= 0 && y.g <= 0
        if e == "A" && s == "a"  
         x.g = 0 + x.gr
         y.g = 0 + y.gr
        elseif e == "A" && s == "A" 
         x.g = 0
         y.g = 0
        elseif e == "a" && s == "A"  
         x.g = 0 + x.gr
         y.g = 0 + y.gr
        elseif e == "a" && s == "a"  
         x.g = 0
         y.g = 0
        end
    elseif x.g < 1 && y.g < 1
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
   elseif x.g >=1 && y.g < 1
      if e == "A" && s == "a"  
        x.g = 1
        y.g = y.g + y.gr
      elseif e == "A" && s == "A"  
        x.g = 1 - x.gr
        y.g = y.g - y.gr
      elseif e == "a" && s == "A" 
        x.g = 1
        y.g = y.g + y.gr
      elseif e == "a" && s == "a" 
        x.g = 1 - x.gr
        y.g = y.g - y.gr
       end
   elseif x.g < 1 && y.g >= 1
       if e == "A" && s == "a"  
         x.g = x.g + x.gr
         y.g = 1
       elseif e == "A" && s == "A"  
         x.g = x.g - x.gr
         y.g = 1 - y.gr
       elseif e == "a" && s == "A" 
         x.g = x.g + x.gr
         y.g = 1
       elseif e == "a" && s == "a" 
         x.g = x.g - x.gr
         y.g = 1 - y.gr
        end
   elseif x.g >= 1 && y.g >= 1
       if e == "A" && s == "a"  
        x.g = 1
        y.g = 1
       elseif e == "A" && s == "A" 
        x.g = 1 - x.gr
         y.g = 1 - y.gr
       elseif e == "a" && s == "A"  
        x.g = 1
        y.g = 1
       elseif e == "a" && s == "a"  
        x.g = 1 - x.gr
         y.g = 1 - y.gr
       end
    end
 return y.g
end


grouped_0_g = combine(groupby(sf_df_0, :e), :g => mean)
