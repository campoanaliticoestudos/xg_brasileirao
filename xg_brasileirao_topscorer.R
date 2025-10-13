# =====================================================
# Gráfico: Expected Goals (xG) por clube - Brasileirão
# =====================================================
# Autor: Campo Analítico (Aldrei Peralta)
# Fonte de dados: FBRef
# -----------------------------------------------------
# Este script cria um gráfico de barras horizontais
# mostrando o xG acumulado de cada clube e seu artilheiro.
# =====================================================

# ---- Pacotes necessários ----
library(ggplot2)   # Criação dos gráficos
library(dplyr)     # Manipulação dos dados
library(showtext)  # Uso de fontes do Google Fonts
library(scales)    # Formatação de escalas numéricas
library(glue)      # Inserção de texto dinâmico

# ---- Fonte personalizada ----
font_add_google("Montserrat", "mont")
showtext_auto()  # Ativa renderização da fonte

# ---- Base de dados ----
df <- tibble::tribble(
  ~Squad,                     ~xG,  ~TopScorer,
  "Palmeiras",                 37.2, "Vitor Roque - 10",
  "Flamengo",                  38.2, "Giorgian De Arrascaeta - 14",
  "Cruzeiro",                  36.0, "Kaio Jorge - 15",
  "Mirassol",                  39.5, "Reinaldo - 9",
  "Botafogo (RJ)",             34.7, "Jefferson Savarino - 4",
  "Bahia",                     31.4, "Willian José, Luciano Juba - 5",
  "Fluminense",                27.2, "Germán Cano - 6",
  "São Paulo",                 35.0, "Luciano - 6",
  "RB Bragantino",             31.8, "Isidro Pitta, Jhonatan Jowjow - 6",
  "Ceará",                     27.3, "Pedro Raul - 7",
  "Vasco da Gama",             33.8, "Pablo Vegetti - 12",
  "Corinthians",               31.8, "Yuri Alberto - 7",
  "Grêmio",                    29.3, "Martin Braithwaite - 6",
  "Atlético Mineiro",          28.6, "Hulk, Rony - 4",
  "Internacional",             38.9, "Alan Patrick - 9",
  "Santos",                    30.9, "Álvaro Barreal - 6",
  "Vitória",                   28.0, "Renato Kayser - 7",
  "Fortaleza",                 31.0, "Breno - 4",
  "Juventude",                 19.9, "Gabriel Taliari, Enmerson Batalla - 4",
  "Sport Recife",              28.3, "Derik Lacerda - 5"
)

# ---- Organização dos dados ----
df <- df %>%
  arrange(xG) %>%  # Ordena pelo xG (para gráfico horizontal)
  mutate(
    Squad = factor(Squad, levels = Squad),
    color = ifelse(Squad == "Mirassol", "#d94a49", "#bfbfbf"), # destaca o Mirassol
    label = paste0(xG) # texto do valor exibido
  )

# ---- Configurações de saída ----
out_w <- 1012   # largura em pixels
out_h <- 1350   # altura em pixels
out_file <- "xg_brasileirao_topscorer.png" # nome do arquivo

# ---- Criação do gráfico ----
p <- ggplot(df, aes(x = Squad, y = xG)) +
  geom_col(aes(fill = color), width = 0.65, show.legend = FALSE) +  # barras
  coord_flip(expand = FALSE) +  # barras horizontais
  geom_text(aes(label = label), hjust = -0.02, size = 4, family = "mont") +  # valores à direita
  geom_text(aes(y = 0, label = TopScorer),
            x = df$Squad,
            y = -2.5,  # posição dos nomes
            hjust = 0,
            size = 3.5,
            family = "mont") +
  scale_fill_identity() +
  scale_y_continuous(expand = c(0,0), limits = c(-5, max(df$xG)*1.12)) +
  labs(
    title = "Expected Goals (xG) - Brasileirão Série A",
    subtitle = "xG acumulado por clube com artilheiro principal",
    caption = "Source: FBRef | Visualization: Campo Analitico DataViz - Aldrei Peralta"
  ) +
  theme_minimal(base_family = "mont") +
  theme(
    plot.title = element_text(size = 20, face = "bold", hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 12)),
    plot.caption = element_text(size = 8, hjust = 0),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "#efefef"),
    axis.text.y = element_text(size = 11, face = "bold", hjust = 0),
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    plot.margin = margin(20, 30, 20, 30)
  )

# ---- Salvar gráfico ----
ggsave(out_file, p, width = out_w/150, height = out_h/150, dpi = 150)
message(glue("Gráfico salvo em: {out_file}"))
