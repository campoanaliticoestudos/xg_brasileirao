# =====================================================
# Gráfico: Distribuição de Chutes em Formato Polar (2010–2019)
# =====================================================
# Autor: Campo Analítico (Aldrei Peralta)
# Objetivo:
# Criar uma visualização circular que organiza temporadas
# em posições semelhantes às de um relógio, mostrando
# o desempenho dos atacantes por tipo e resultado de chute.
# =====================================================

# =====================
# PACOTES
# =====================
library(ggplot2)   # Criação do gráfico
library(dplyr)     # Manipulação de dados
library(showtext)  # Fontes do Google Fonts

# =====================
# FONTE
# =====================
font_add_google("Barlow Semi Condensed", "barlow")
showtext_auto()

# =====================
# DADOS SIMULADOS
# =====================
# (Substitua por um CSV real, se desejar usar dados de verdade)
set.seed(123)
shots <- tibble(
  season = sample(2010:2019, 500, replace = TRUE),
  distance = runif(500, 2, 30),
  result = sample(c("Scored", "Saved", "Missed"), 500, replace = TRUE, prob = c(0.25, 0.45, 0.3)),
  type = sample(c("Open Play", "Freekick", "Penalty"), 500, replace = TRUE, prob = c(0.85, 0.1, 0.05))
)

# =====================
# ORGANIZAÇÃO DAS TEMPORADAS
# =====================
unique_seasons <- sort(unique(shots$season))
n_seasons <- length(unique_seasons)
angle_step <- 360 / n_seasons  # ângulo de separação entre temporadas

shots <- shots %>%
  mutate(
    season_order = match(season, unique_seasons),
    # define ângulo central e aplica leve jitter para não sobrepor pontos
    angle = (season_order - 1) * angle_step,
    angle_jitter = angle + runif(n(), min = -angle_step * 0.2, max = angle_step * 0.2)
  )

# =====================
# RÓTULOS DAS TEMPORADAS
# =====================
label_radius <- max(shots$distance) + 5
season_labels <- tibble(
  season = unique_seasons,
  angle = (seq_along(unique_seasons) - 1) * angle_step,
  label_angle = ifelse(angle >= 90 & angle <= 270, angle + 180, angle), # ajusta texto para não ficar de cabeça pra baixo
  y = label_radius
)

# =====================
# CORES E FORMAS
# =====================
colors <- c("Missed" = "#FF004F", "Saved" = "#FFB000", "Scored" = "#00BFFF")
shapes <- c("Open Play" = 21, "Freekick" = 4, "Penalty" = 22)

# =====================
# CRIAÇÃO DO GRÁFICO POLAR
# =====================
plot_polar <- ggplot(shots, aes(x = angle_jitter, y = distance)) +
  geom_point(aes(fill = result, shape = type),
             size = 3, color = "black", alpha = 0.9) +
  
  # Rótulos dos anos nas bordas (como números de relógio)
  geom_text(data = season_labels,
            aes(x = angle, y = y, label = season, angle = label_angle),
            color = "gray90", family = "barlow", size = 4, fontface = "bold") +
  
  # Legendas e escalas
  scale_fill_manual(values = colors) +
  scale_shape_manual(values = shapes) +
  coord_polar(start = 0, direction = -1) +   # formato circular
  scale_y_reverse(limits = c(label_radius, 0)) + # centraliza os pontos
  
  # Tema escuro e elegante
  theme_minimal(base_family = "barlow") +
  theme(
    plot.background = element_rect(fill = "#0A0A1A", color = NA),
    panel.background = element_rect(fill = "#0A0A1A", color = NA),
    panel.grid = element_line(color = "#2A2C3A", size = 0.3),
    legend.position = "right",
    legend.background = element_rect(fill = "#0A0A1A"),
    legend.text = element_text(color = "gray80"),
    legend.title = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(color = "white", size = 18, face = "bold"),
    plot.subtitle = element_text(color = "gray80", size = 13)
  ) +
  labs(
    title = "Profiling the most prolific attackers across Europe's Top 5 Leagues",
    subtitle = "Discrete seasonal layout — years positioned like a clock (2010–2019)",
    caption = "Visualization: Campo Analitico DataViz — Aldrei Peralta"
  )

# Exibe o gráfico
plot_polar

# =====================
# SALVAR A IMAGEM
# =====================
ggsave(
  filename = "attacker_profiling_polar.png",
  plot = plot_polar,
  width = 1012 / 96,
  height = 1012 / 96,
  dpi = 96,
  bg = "#0A0A1A"
)

message("Gráfico salvo como: attacker_profiling_polar.png")
