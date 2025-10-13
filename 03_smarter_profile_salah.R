# ============================================
# PERFIL DE JOGADOR ESTILO SMARTERSCOUT — COM IMAGEM LOCAL
# ============================================

# =====================
# PACOTES NECESSÁRIOS
# =====================
# Instala automaticamente se ainda não estiverem disponíveis
if (!requireNamespace("ggplot2")) install.packages("ggplot2")
if (!requireNamespace("dplyr")) install.packages("dplyr")
if (!requireNamespace("patchwork")) install.packages("patchwork")
if (!requireNamespace("cowplot")) install.packages("cowplot")
if (!requireNamespace("magick")) install.packages("magick")
if (!requireNamespace("showtext")) install.packages("showtext")

library(ggplot2)
library(dplyr)
library(patchwork)  # alternativa para sobrepor elementos
library(cowplot)    # função draw_image para inserir imagem no gráfico
library(magick)     # leitura e manipulação de imagem
library(showtext)   # uso de fontes do Google no R

# =====================
# FONTE
# =====================
font_add_google("Teko", "Teko")  # estilo semelhante ao usado pela Smarterscout
showtext_auto()

# =====================
# DADOS SIMULADOS
# =====================
# (Substitua pelos dados reais de desempenho se desejar)
set.seed(123)
df <- tibble(
  stats = c(
    "link_up_rating", "progressive_pass", "ball_retention",
    "carry_dribble_rating", "receive_in_box", "shoot",
    "rate_involvement_in_moves_ending_in_a_shot", "attacking_output",
    "disrupt_opp_moves", "recover", "aerial",
    "defending_quantity", "defending_quality"
  ),
  numbers = runif(13, 30, 95)  # notas aleatórias de 30 a 95
)

# =====================
# ORGANIZAÇÃO E CLASSIFICAÇÃO DAS VARIÁVEIS
# =====================
df <- df %>%
  mutate(part = case_when(
    stats %in% c("link_up_rating", "progressive_pass", "ball_retention", "carry_dribble_rating") ~ "POSSESSION",
    stats %in% c("receive_in_box", "shoot", "rate_involvement_in_moves_ending_in_a_shot", "attacking_output") ~ "ATTACKING",
    TRUE ~ "DEFENSIVE"
  )) %>%
  mutate(
    # Renomeia as métricas para rótulos legíveis no gráfico
    stats = case_when(
      stats == "link_up_rating" ~ "Link-up passing",
      stats == "progressive_pass" ~ "Progressive passing",
      stats == "ball_retention" ~ "Ball retention\nability*",
      stats == "carry_dribble_rating" ~ "Carry & dribble\nvolume",
      stats == "receive_in_box" ~ "Receptions in\n opp. box",
      stats == "shoot" ~ "Shot\nvolume",
      stats == "rate_involvement_in_moves_ending_in_a_shot" ~ "% involvement\nin moves ending in a shot",
      stats == "attacking_output" ~ "Attacking\noutput*",
      stats == "disrupt_opp_moves" ~ "Disrupting\nopp. moves",
      stats == "recover" ~ "Ball\nrecoveries",
      stats == "aerial" ~ "Aerial duels",
      stats == "defending_quantity" ~ "Defending\nquantity*",
      stats == "defending_quality" ~ "Defending\nquality*"
    ),
    numbers2 = ifelse(numbers < 2, 2, numbers)  # garante mínimo para a escala
  )

# Define ordem dos fatores (de baixo para cima no gráfico)
df$stats <- factor(df$stats, levels = c(
  "Defending\nquality*", "Defending\nquantity*", "Aerial duels", "Ball\nrecoveries",
  "Disrupting\nopp. moves", "Attacking\noutput*", "% involvement\nin moves ending in a shot",
  "Shot\nvolume", "Receptions in\n opp. box", "Ball retention\nability*", "Progressive passing",
  "Link-up passing", "Carry & dribble\nvolume"
))

# =====================
# IMPORTAÇÃO DA IMAGEM LOCAL
# =====================
# Verifica se o arquivo (salah.png ou .jpg) está na pasta de trabalho
candidates <- c("salah.png", "salah.jpg", "salah.jpeg")
found <- intersect(candidates, list.files())

if (length(found) == 0) {
  stop(paste0(
    "Imagem não encontrada na pasta de trabalho (", getwd(), ").\n",
    "Salve manualmente a imagem como salah.png antes de rodar o código.\n",
    "Arquivos buscados: ", paste(candidates, collapse = ", ")
  ))
}

# Lê o arquivo de imagem encontrado
img_file <- found[1]
img <- image_read(img_file)

# Redimensiona a imagem para caber melhor no layout
img <- image_scale(img, "600")

# =====================
# CRIAÇÃO DO GRÁFICO
# =====================
p <- ggplot(df, aes(x = numbers, y = stats)) +
  geom_vline(xintercept = c(0, 20, 40, 60, 80, 100), color = "#626262") +  # linhas de referência
  geom_vline(xintercept = 50, color = "#767676", linetype = 2) +           # linha central (média)
  geom_bar(aes(fill = part, color = part), stat = "identity", width = 0.8) +  # barras coloridas
  geom_point(aes(x = numbers2, color = part), size = 20, shape = 21,
             fill = "#34363b", stroke = 2) +
  geom_text(aes(x = numbers2, label = round(numbers)), family = "Teko",
            fontface = 2, color = "white", size = 9) +

  # Blocos laterais com as categorias
  geom_rect(aes(xmin = -3, xmax = 0, ymin = -Inf, ymax = Inf), color = "#626262", inherit.aes = FALSE) +
  geom_rect(aes(xmin = -3, xmax = 0, ymin = 13.4, ymax = 9.6),
            color = "#70FFFA", fill = "#70FFFA") +
  geom_rect(aes(xmin = -3, xmax = 0, ymin = 9.4, ymax = 5.6),
            color = "#FFE570", fill = "#FFE570") +
  geom_rect(aes(xmin = -3, xmax = 0, ymin = 5.4, ymax = 0.6),
            color = "#FF9970", fill = "#FF9970") +

  # Rótulos verticais das seções
  geom_text(aes(x = -1.5, y = 11.5, label = "P\nO\nS\nS\nE\nS\nS\nI\nO\nN"),
            family = "Teko", fontface = 2, color = "#34363b", size = 10, lineheight = 0.7) +
  geom_text(aes(x = -1.5, y = 7.5, label = "A\nT\nT\nA\nC\nK\nI\nN\nG"),
            family = "Teko", fontface = 2, color = "#34363b", size = 10, lineheight = 0.7) +
  geom_text(aes(x = -1.5, y = 3, label = "D\nE\nF\nE\nN\nS\nI\nV\nE"),
            family = "Teko", fontface = 2, color = "#34363b", size = 10, lineheight = 0.7) +

  # Escala e cores
  scale_x_continuous(limits = c(-3, 100), breaks = c(0, 25, 50, 75, 100)) +
  scale_color_manual(values = c(
    "POSSESSION" = "#70FFFA",
    "ATTACKING"  = "#FFE570",
    "DEFENSIVE"  = "#FF9970"
  )) +
  scale_fill_manual(values = c(
    "POSSESSION" = "#70FFFA",
    "ATTACKING"  = "#FFE570",
    "DEFENSIVE"  = "#FF9970"
  )) +

  # Títulos e legendas
  labs(
    title = "Mohamed Salah - Liverpool",
    subtitle = "2021-22 | 2787 minutes at RW | 30 years",
    tag = "*Adjusted for England Premier League",
    caption = "Campo Analítico (@campoanalitico)"
  ) +

  coord_cartesian(clip = "off") +
  theme(
    plot.background = element_rect(fill = "#34363b", color = "#34363b"),
    plot.margin = margin(3,1,3,1, "cm"),
    plot.title = element_text(family = "Teko", face = 2, color = "gray", size = 50, hjust = 0.5),
    plot.subtitle = element_text(family = "Teko", color = "gray", size = 30, hjust = 0.5),
    plot.caption = element_text(color = "gray", family = "Teko", size = 25, vjust = -15),
    panel.background = element_rect(fill = "#34363b", color = "#34363b"),
    panel.grid = element_blank(),
    axis.text.y = element_text(color = "gray", size = 22, family = "Teko", face = 2),
    axis.text.x = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "none"
  )

# =====================
# INSERÇÃO DA IMAGEM NO GRÁFICO
# =====================
p_final <- ggdraw(p) +
  draw_image(img, x = 0.05, y = 0.02, width = 0.24, height = 0.24, hjust = 0, vjust = 0)

# =====================
# SALVAR A IMAGEM FINAL
# =====================
ggsave("smarter_profile_salah_manual.png", plot = p_final, width = 17, height = 17, dpi = 300)

# Exibir no RStudio
print(p_final)
