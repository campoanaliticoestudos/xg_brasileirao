# =======================================
# Análise: Desempenho do Corinthians no Brasileirão (2014–2025)
# =======================================

# --- Pacotes ---
library(dplyr)
library(tidyr)
library(ggplot2)
library(showtext)

# --- Fonte ---
font_add_google("Poppins", "Poppins")
showtext_auto()

# --- Banco de dados ---
dados <- tribble(
  ~Season, ~LgRank, ~MP, ~W, ~D, ~L, ~GF, ~GA, ~GD, ~Pts, ~Attendance, ~Top_Team_Scorer, ~Gols_Top, ~Goalkeeper,
  2025, 14, 20, 5, 7, 8, 19, 25, -6, 22, 40545, "Yuri Alberto", 5, "Hugo Souza",
  2024, 7, 38, 15, 12, 11, 59, 49, 10, 57, 43801, "Yuri Alberto", 15, "Hugo Souza",
  2023, 13, 38, 12, 14, 12, 47, 48, -1, 50, 36565, "Ángel Romero, Yuri Alberto", 8, "Cássio",
  2022, 4, 38, 15, 14, 9, 44, 36, 8, 59, 38631, "Roger Guedes", 10, "Cássio",
  2021, 5, 38, 15, 12, 11, 40, 36, 4, 57, 13772, "Jô, Roger Guedes", 7, "Cássio",
  2020, 12, 38, 13, 12, 13, 45, 51, -6, 51, 0, "Jô", 6, "Cássio",
  2019, 8, 38, 14, 14, 10, 42, 34, 8, 56, 32894, "Mauro Boselli", 6, "Cássio",
  2018, 13, 38, 11, 11, 16, 36, 34, 2, 44, 31367, "Ángel Romero", 6, "Cássio",
  2017, 1, 38, 21, 12, 5, 50, 30, 20, 71, 38052, "Jô", 18, "Cássio",
  2016, 7, 38, 15, 9, 14, 61, 50, 11, 54, 28820, "Guilherme, Marlone", 6, "Cássio",
  2015, 1, 38, 24, 9, 5, 71, 31, 40, 81, 34150, "Vágner Love", 14, "Cássio",
  2014, 4, 38, 19, 12, 7, 49, 31, 18, 69, 29013, "Paolo Guerrero", 12, "Cássio"
)

# --- Agregação ---
dados_agregado <- dados %>%
  mutate(Total = W + D + L) %>%
  select(Season, W, D, L, Total) %>%
  arrange(desc(Season))

# --- Converter para formato longo ---
dados_long <- dados_agregado %>%
  pivot_longer(cols = c(W, D, L),
               names_to = "Categoria", values_to = "Valor")

# --- Paleta de cores ---
cores <- c(
  "W" = "#01735C",   # Verde: Vitórias
  "D" = "#F4A300",   # Amarelo: Empates
  "L" = "#8B2F3D"    # Vermelho: Derrotas
)

labels <- c(
  "W" = "Vitórias",
  "D" = "Empates",
  "L" = "Derrotas"
)

# --- Gráfico ---
grafico <- ggplot(dados_long, aes(x = Valor, y = factor(Season), fill = Categoria)) +
  geom_col(position = "stack", width = 0.7, color = "black", linewidth = 0.2) +
  geom_text(data = dados_agregado,
            aes(x = Total + 1, y = factor(Season), label = Total),
            inherit.aes = FALSE, size = 3, family = "Poppins", hjust = 0) +
  scale_fill_manual(values = cores, labels = labels) +
  labs(
    title = "Desempenho do Corinthians no Brasileirão",
    subtitle = "Vitórias, Empates e Derrotas por Temporada (2014–2025)",
    x = "Quantidade de Jogos",
    y = "Temporada",
    caption = "Fonte: Wikipédia / DataViz: Campo Analítico"
  ) +
  theme_minimal(base_family = "Poppins") +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12),
    axis.text.y = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(size = 9),
    legend.position = "bottom"
  ) +
  coord_cartesian(clip = "off")

# --- Exibir ---
grafico

# --- Salvar ---
ggsave("images/desempenho_corinthians.png", grafico, width = 10, height = 6, dpi = 300)
