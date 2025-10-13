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

