# Quantifying reasonable performance expectations in (non-traditional) sports

This repository reproduces the numerical analyses in the following paper:

**Fry, J., Stevenson, F., Fanzon, S., Serbera, J.-P., & Smales, T. (forthcoming).
Quantifying reasonable performance expectations in (non-traditional) sports.**

Paper versions:  (I will Replace `ARXIV_ID` and `DOI` when available)  

- [arXiv version](https://arxiv.org/abs/ARXIV_ID)
- [published version](https://doi.org/DOI).

The paper uses probabilistic models of round-robin and rankings-based
competitions to quantify what counts as reasonable performance given the level
of competition and the variability of results. It applies these models to the
Chess Candidates Tournament and the NCAA cross-country championships to assess
observed performances against those benchmarks. It also examines how competition
formats and scoring rules shape whether teammates' performances reinforce one
another or come at each other's expense.

## Contents

This replication package contains:

- **Data:** CSV transcriptions of Tables 1–3 and 5 of the paper in `data/`,
  described in notebook Section 4 and below.
- **Quarto notebook:** [analysis.qmd](analysis.qmd) contains the R code that
  reproduces Figures 1–3 and the Monte Carlo results in Table 4, along with
  rank diagnostics and sensitivity checks. Written by Silvio Fanzon and John Fry.
- **Scripts:** The `/scripts` folder contains
  [chess_figures.R](scripts/chess_figures.R) for Figures 1–3 and
  [cross_country.R](scripts/cross_country.R) for the complete cross-country
  analysis. Both use the same code as the notebook.
- **Figures:** vector PDFs and 600 dpi PNGs of Figures 1–3 in `figures/`.

The first column below refers to the paper; the last column gives the location
in the notebook.

| Paper reference | Analysis | Notebook location |
| --- | --- | --- |
| Section 2.1, Figure 1 | Bounds from equation (2), varying the draw probability with 14 games. | Section 5.1: Figure 1 |
| Section 2.1, Figure 2 | Bounds from equation (2), varying the number of games with draw probability 0.794. | Section 5.2: Figure 2 |
| Section 2.2, Figure 3 | Homogeneous and heterogeneous bounds from equations (2) and (4). | Section 5.3: Figure 3 |
| Section 3.3, Table 4, normal-model row | Monte Carlo mean and central 95% score interval. | Section 6.1: Cross-country: normal model |
| Section 3.3, Table 4, discrete-uniform row | Monte Carlo mean and central 95% score interval. | Section 6.2: Cross-country: discrete-uniform model |
| Section 3.3, Tables 4–5 | Observed scores, inadmissible-rank and tie diagnostics, and sensitivity of the benchmarks and team classifications to forward staggering. | Section 4: Data and Section 6.3: Robustness checks |

## Data

The `data/` folder contains UTF-8 CSV transcriptions of the manuscript tables:

| File | Paper table | Rows | Columns |
| --- | --- | --- | --- |
| `candidates_winners_2013_2026.csv` | Table 1 | 8 | `year`, `winner`, `score_out_of_14` |
| `candidates_2026_results.csv` | Table 2 | 8 | `position`, `player`, `score_out_of_14` |
| `fide_ratings_2026_10.csv` | Table 3 | 9 | `player`, `rating` |
| `ncaa_2025_team_scores.csv` | Table 5 | 32 | `team`, `score` |



## R scripts and figure outputs

The `scripts/` folder contains two standalone scripts using the same code as
the notebook:

- [chess_figures.R](scripts/chess_figures.R): the shared plot styling and all
  three chess figures. Saves the figures in `figures/`.
- [cross_country.R](scripts/cross_country.R): both million-repetition
  cross-country simulations, invalid-rank and tie diagnostics,
  forward staggering, and checks for changes in the 32
  observed teams' classifications. Requires the R package MASS and the NCAA
  CSV file in `data/`.

Run either script from the replication-package folder:

```sh
Rscript scripts/chess_figures.R
Rscript scripts/cross_country.R
```

Each chess figure is saved at 7 by 5 inches as a vector PDF and a 600 dpi PNG
(4200 by 3000 pixels). Use the PDF for scalable lines and text, or the PNG when
an image file is required.

| Figure in the paper | Vector PDF | High-resolution PNG |
| --- | --- | --- |
| Figure 1 | [figure-1.pdf](figures/figure-1.pdf) | [figure-1.png](figures/figure-1.png) |
| Figure 2 | [figure-2.pdf](figures/figure-2.pdf) | [figure-2.png](figures/figure-2.png) |
| Figure 3 | [figure-3.pdf](figures/figure-3.pdf) | [figure-3.png](figures/figure-3.png) |

When changing a calculation or plot in the notebook, update the corresponding
script as well so that the two copies remain consistent.

## Running the notebook

### Inspect and run individual code blocks

Open `analysis.qmd` in RStudio or in VS Code with the Quarto and R extensions.
Run the code blocks in document order. The blocks share an R session. Run the
shared plot-styling block in Section 5 before the chess figures, and run the
cross-country setup and normal-model simulation before the rank diagnostics
and sensitivity checks.
There is no need to render the entire document to inspect each calculation.

### Render the complete report

Open it in RStudio and run the chunks, or click **Render** to produce an HTML
report. It requires Quarto, R, MASS, rmarkdown and knitr. To render from this folder:

```sh
quarto render analysis.qmd
```

With the accompanying `_quarto.yml`, rendering produces `docs/index.html` inside the replication-package folder,
running all calculations and including their outputs and plots by default.

Run code blocks individually to inspect their
outputs. To render without running the calculations, change `eval: true` to
`eval: false` under `execute` in the notebook header. 


## Citation and licence

If you use the replication package, please cite the paper using the
[BibTeX entry](citation.bib).

The notebook and code use [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/).
See [LICENSE.md](LICENSE.md) for details.
