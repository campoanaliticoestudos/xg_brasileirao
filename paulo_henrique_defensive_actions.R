# =====================================================
# Gráfico: Ações Defensivas de Paulo Henrique (Série A 2025)
# =====================================================
# Autor: Campo Analítico (Aldrei Peralta)
# Fonte de dados: FBRef
# -----------------------------------------------------
# Este script cria um gráfico de barras horizontais mostrando
# as 10 partidas em que Paulo Henrique teve mais ações defensivas
# (Tackles + Interceptions) na temporada.
# =====================================================

# =====================
# CARREGAMENTO DE DADOS
# =====================
library(readr)
scouted_paulo_henrique_1_ <- read_csv("C:/Users/aldre/Downloads/scouted - paulo henrique (1).csv")

# Visualiza estrutura da base
glimpse(scouted_paulo_henrique_1_)

# =====================
# PACOTES
# =====================
library(ggplot2)   # Criação do gráfico
library(dplyr)     # Manipulação de dados
library(showtext)  # Fonte do Google
library(ggtext)    # Suporte a texto rico em ggplot

# Fonte similar à usada pela The Athletic
font_add_google("Roboto Condensed", "roboto")
showtext_auto()

# =====================
# PREPARAÇÃO DOS DADOS
# =====================
df <- scouted_paulo_henrique_1_ %>%
  select(Date, Opponent, `Tkl+Int`) %>%
  mutate(
    # Trata valores faltantes
    Opponent = ifelse(Opponent == "", "Unknown", Opponent),
    # Cria uma variável com o nome do adversário e data formatada
    Match = paste0(Opponent, " (", format(Date, "%d %b"), ")")
  ) %>%
  arrange(desc(`Tkl+Int`)) %>%
  slice_head(n = 10) %>%  # Mostra apenas as 10 partidas com mais ações
  mutate(Match = factor(Match, levels = rev(Match)))  # Mantém ordem no gráfico

# =====================
# CRIAÇÃO DO GRÁFICO
# =====================
plot_paulo <- ggplot(df, aes(y = Match, x = `Tkl+Int`, fill = `Tkl+Int`)) +
  geom_col(width = 0.6, color = "white") +  # barras horizontais
  geom_text(aes(label = `Tkl+Int`),
            hjust = -0.2, family = "roboto", size = 4.5, fontface = "bold") +
  scale_fill_gradient(low = "#d6e4f0", high = "#3066BE") +  # gradiente de cor
  scale_x_continuous(expand = expansion(mult = c(0, 0.15))) +  # espaço extra à direita
  theme_minimal(base_family = "roboto") +
  theme(
    panel.grid = element_blank(),
    axis.title = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_text(face = "bold", size = 12),
    plot.title = element_text(face = "bold", size = 18, hjust = 0),
    plot.subtitle = element_text(size = 13, color = "gray30"),
    plot.caption = element_text(size = 10, color = "gray40"),
    legend.position = "none",
    plot.margin = margin(30, 60, 20, 30)
  ) +
  labs(
    title = "Top defensive actions by Paulo Henrique this season",
    subtitle = "Tackles + Interceptions (Tkl+Int) per match — Série A 2025",
    caption = "Source: FBRef | Visualization: Campo Analitico DataViz — Aldrei Peralta"
  )

# Exibe o gráfico
plot_paulo

# =====================
# SALVAR A IMAGEM (1012x1350 px)
# =====================
ggsave(
  filename = "paulo_henrique_defensive_actions.png",
  plot = plot_paulo,
  width = 1012 / 96,   # largura em polegadas
  height = 1350 / 96,  # altura em polegadas
  dpi = 96,
  bg = "white",
  units = "cm"
)

message("Gráfico salvo como: paulo_henrique_defensive_actions.png")
