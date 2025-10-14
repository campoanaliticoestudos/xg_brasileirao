library(ggsoccer)
library(ggrepel)
library(rvest)
library(jsonlite)
# Carregue os pacotes
library(tidyverse)
library(UpSetR)
library(patchwork)
library(UpSetR)
library(ggplot2)
library(patchwork)
library(ggplotify) # Para converter gráficos base para ggplot2
library(cowplot)
library(UpSetR)
library(UpSetR)
library(ggplot2)
library(dplyr)
library(tidyr)

dados<- read_csv("Vasco da Gama 2-3 Corinthians - Brasileirão 2025.csv")
dados
names(dados)
table(dados$type)
library(dplyr)
library(ggplot2)
library(showtext)

# Fonte estilo Opta
font_add_google("Rajdhani", "optatext")
showtext_auto()
table(dados$teamId)
library(dplyr)
library(ggplot2)
library(showtext)

dados =  dados %>%
  filter(teamId=="1226")
# Fonte estilo Opta
font_add_google("Rajdhani", "optatext")
showtext_auto()

# --- Filtrar apenas ações ofensivas (ajuste se quiser incluir mais tipos)
dados_ofensivos <- dados %>% 
  filter(type %in% c("Pass","ShotOnPost","SavedShot","Goal","MissedShots","TakeOn","BallTouch"))

# --- Classificar em terços ofensivos
dados_tercos <- dados_ofensivos %>%
  mutate(terco = case_when(
    x < 33.3 ~ "Esquerda",
    x < 66.6 ~ "Centro",
    TRUE ~ "Direita"
  )) %>%
  group_by(terco) %>%
  summarise(toques = n(), .groups = "drop") %>%
  mutate(perc = round(100 * toques / sum(toques), 1))

# --- Preparar posições para o gráfico
tercos_plot <- dados_tercos %>%
  mutate(
    x_min = c(0, 33.3, 66.6),
    x_max = c(33.3, 66.6, 100),
    cor = ifelse(terco == "Esquerda", "#E57373", "#FFFFFF")
  )

# --- Gráfico no estilo Opta
grafico = ggplot(tercos_plot) +
  geom_rect(aes(xmin = x_min, xmax = x_max, ymin = 0, ymax = 100, fill = cor),
            color = "black", alpha = 0.6) +
  scale_fill_identity() +
  
  # texto principal (percentuais)
  geom_text(aes(x = (x_min+x_max)/2, y = 60, label = paste0(perc, "%")),
            family = "optatext", fontface = "bold", size = 8) +
  
  # texto secundário (nº de toques ofensivos)
  geom_text(aes(x = (x_min+x_max)/2, y = 48, 
                label = paste0(toques, "\ntoques\nofensivos")),
            family = "optatext", size = 4, lineheight = 0.9) +
  
  # setas de direção do ataque
  annotate("segment", x = 16.6, xend = 16.6, y = 20, yend = 40,
           arrow = arrow(length = unit(0.3,"cm")), size = 1.2) +
  annotate("segment", x = 50, xend = 50, y = 20, yend = 40,
           arrow = arrow(length = unit(0.3,"cm")), size = 1.2) +
  annotate("segment", x = 83.3, xend = 83.3, y = 20, yend = 40,
           arrow = arrow(length = unit(0.3,"cm")), size = 1.2) +
  
  # títulos e legendas traduzidos
  labs(title = "Vasco - Terços Ofensivos",
       subtitle = "Brasileirão 2025 | Vasco da Gama 2-3 Corinthians",
       caption = "Distribuição (%) dos toques ofensivos em cada terço do campo") +
  
  theme_void() +
  theme(
    plot.title = element_text(family = "optatext", face = "bold", size = 20),
    plot.subtitle = element_text(family = "optatext", size = 12),
    plot.caption = element_text(family = "optatext", size = 10, hjust = 0.5)
  )
# --- Salvar gráfico em arquivo PNG
ggsave("Vasco_tercos_ofensivos.png",plot =  grafico, width = 8, height = 6,
       dpi = 100, units = "in", bg = "#FFFFFF")

