# xg_brasileirao

# 📊 Expected Goals (xG) - Brasileirão Série A

Visualização criada em **R** usando `ggplot2`, `dplyr` e `showtext`.

O gráfico mostra o **xG acumulado por clube** e o **principal artilheiro** de cada equipe na Série A.

![xG Brasileirão](xg_brasileirao_topscorer.png)

---

## 🧾 Código utilizado
O script completo está disponível em [`xg_brasileirao_topscorer.R`](xg_brasileirao_topscorer.R).

Principais pontos:
- **Fonte Montserrat** importada via `showtext`.
- **Destaque visual** para o clube “Mirassol”.
- **Eixo horizontal** com `coord_flip()`.
- **Exportação automática** do gráfico com `ggsave()`.

---

# 🛡️ Top Defensive Actions — Paulo Henrique (Série A 2025)

Visualização criada em **R** usando `ggplot2`, `dplyr` e `showtext`.

O gráfico mostra as **10 partidas** em que **Paulo Henrique** registrou o maior número de **Tackles + Interceptions (Tkl+Int)** durante a temporada 2025.

![Paulo Henrique Defensive Actions](paulo_henrique_defensive_actions.png)

---

## 🧾 Código utilizado
O script completo está disponível em [`paulo_henrique_defensive_actions.R`](paulo_henrique_defensive_actions.R).

Principais pontos:
- Leitura do dataset via `read_csv()`.
- Seleção e formatação das variáveis de interesse (`Opponent`, `Date`, `Tkl+Int`).
- Destaque para as **10 partidas de maior desempenho defensivo**.
- Gradiente de cor azul representando intensidade de ações defensivas.

---

### 💡 Reproduzindo o gráfico
1. Baixe o arquivo CSV original do FBRef e ajuste o caminho do arquivo no script.
2. Instale os pacotes necessários:
   ```r
   install.packages(c("ggplot2", "dplyr", "showtext", "ggtext", "readr"))
