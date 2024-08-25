library(readr)
library(tidyverse)

df_model1 <- read_csv("data/df_model1.csv") |> 
  transmute(
    agent_id = id, 
    ethnicity = e,
    bilingual = b, 
    iteration = time, 
    grievance = round(g, 2), 
    mobilized = m, 
  )

df_model2 <- read_csv("data/df_model2.csv")|> 
  transmute(
    agent_id = id, 
    ethnicity = e,
    bilingual = b, 
    iteration = time, 
    grievance = round(g, 2), 
    mobilized = m, 
  )

df_model3 <- read_csv("data/df_model3.csv")|> 
  transmute(
    agent_id = id, 
    ethnicity = e,
    bilingual = b, 
    iteration = time, 
    grievance = round(g, 2), 
    mobilized = m, 
  )

df_model4 <- read_csv("data/df_model4.csv")|> 
  transmute(
    agent_id = id, 
    ethnicity = e,
    bilingual = b, 
    iteration = time, 
    grievance = round(g, 2), 
    mobilized = m, 
  )

sysfonts::font_add_google("Gideon Roman", family = "gideon roman")
showtext::showtext_auto() 

mobilized_1 = df_model1 |> 
  group_by(ethnicity, iteration) |> 
  summarise(
    count = sum(mobilized)) 

pm1 <-  mobilized_1 |> 
  ggplot(aes(x = iteration, y = count, colour = ethnicity)) +
  geom_line() +
  ylim(0, 25) +
  theme_classic() +
  labs(
    title = "Figure 5: Number of mobilized agents: No bilingualism",
    subtitle = 
      "Evolution in time of the count number of mobilized indivuals, aggregated by ethnicity",
    x = "Iteration", 
    y = "Number of agents")+ 
  theme(
    plot.title = element_text(face = "bold", 
                              size = 11, 
                              hjust = 0.5, 
                              family = "gideon roman"), 
    plot.subtitle = element_text(size = 8, 
                                 hjust = 0.5, 
                                 family = "gideon roman"), 
    legend.position = "right",  
    legend.box = "vertical",     
    legend.background = element_rect(color = "black", size = 0.5),
    legend.title = element_text(size = 9, family = "gideon roman"), 
    legend.text = element_text(size = 9, family = "gideon roman"), 
    axis.title.x = element_text(size = 9, family = "gideon roman"), 
    axis.title.y = element_text(size = 9, family = "gideon roman"))

pm1


mobilized_2 = df_model2 |> 
  group_by(ethnicity, iteration) |> 
  summarise(
    count = sum(mobilized)) 

pm2 <- mobilized_2 |> 
  ggplot(aes(x = iteration, y = count, colour = ethnicity)) +
  geom_line() +
  ylim(0, 25) + 
  theme_classic()+
  labs(
    title = "Figure 6: Number of mobilized agents: 25% bilingualism",
    subtitle = 
      "Evolution in time of the count number of mobilized indivuals, aggregated by ethnicity",
    x = "Iteration", 
    y = "Number of agents")+ 
  theme(
    plot.title = element_text(face = "bold", 
                              size = 11, 
                              hjust = 0.5, 
                              family = "gideon roman"), 
    plot.subtitle = element_text(size = 8, 
                                 hjust = 0.5, 
                                 family = "gideon roman"), 
    legend.position = "right",  
    legend.box = "vertical",     
    legend.background = element_rect(color = "black", size = 0.5),
    legend.title = element_text(size = 9, family = "gideon roman"), 
    legend.text = element_text(size = 9, family = "gideon roman"), 
    axis.title.x = element_text(size = 9, family = "gideon roman"), 
    axis.title.y = element_text(size = 9, family = "gideon roman"))

pm2

mobilized_3 = df_model3 |> 
  group_by(ethnicity, iteration) |> 
  summarise(
    count = sum(mobilized)) 

pm3 <- mobilized_3 |> 
  ggplot(aes(x = iteration, y = count, colour = ethnicity)) +
  geom_line() +
  ylim(0, 25)+
  theme_classic()+
  labs(
    title = "Figure 7: Number of mobilized agents: 25% bilingualism",
    subtitle = 
      "Evolution in time of the count number of mobilized indivuals, aggregated by ethnicity",
    x = "Iteration", 
    y = "Number of agents")+ 
  theme(
    plot.title = element_text(face = "bold", 
                              size = 11, 
                              hjust = 0.5, 
                              family = "gideon roman"), 
    plot.subtitle = element_text(size = 8, 
                                 hjust = 0.5, 
                                 family = "gideon roman"), 
    legend.position = "right",  
    legend.box = "vertical",     
    legend.background = element_rect(color = "black", size = 0.5),
    legend.title = element_text(size = 9, family = "gideon roman"), 
    legend.text = element_text(size = 9, family = "gideon roman"), 
    axis.title.x = element_text(size = 9, family = "gideon roman"), 
    axis.title.y = element_text(size = 9, family = "gideon roman"))

pm3

mobilized_4 = df_model4 |> 
  group_by(ethnicity, iteration) |> 
  summarise(
    count = sum(mobilized))

pm4 <- mobilized_4 |> 
  ggplot(aes(x = iteration, y = count, colour = ethnicity)) +
  geom_line() +
  geom_vline(xintercept = mobilized_4$iteration[10], linetype = 4)+
  geom_vline(xintercept = mobilized_4$iteration[100], linetype = 4)+
  ylim(0, 25)+ 
  theme_classic() +
  labs(
    title = "Figure 8: Number of mobilize agents: progressive bilingualism",
    subtitle = 
      "Evolution in time of the count number of mobilized indivuals, aggregated by ethnicity",
    x = "Iteration", 
    y = "Number of agents")+ 
  theme(
    plot.title = element_text(face = "bold", 
                              size = 11, 
                              hjust = 0.5, 
                              family = "gideon roman"), 
    plot.subtitle = element_text(size = 8, 
                                 hjust = 0.5, 
                                 family = "gideon roman"),
    legend.title = element_text(size = 9, family = "gideon roman"), 
    legend.text = element_text(size = 9, family = "gideon roman"), 
    legend.position = "right",  
    legend.box = "vertical",     
    legend.background = element_rect(color = "black", size = 0.5),
    axis.title.x = element_text(size = 9, family = "gideon roman"), 
    axis.title.y = element_text(size = 9, family = "gideon roman"))
pm4

