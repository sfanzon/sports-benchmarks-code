# Quantifying reasonable performance expectations in (non-traditional) sports

Code to replicate numerical analyses in:

**Fry, J., Stevenson, F., Fanzon, S., Serbera, J.-P., & Smales, T. (forthcoming).
Quantifying reasonable performance expectations in (non-traditional) sports.
RMAA.**

Paper versions: [arXiv version](https://arxiv.org/abs/ARXIV_ID) and
[published version](https://doi.org/DOI). Replace `ARXIV_ID` and `DOI` when available.

**Code repository:** [GitHub](https://github.com/sfanzon/sports-benchmarks-code).

The notebook includes a contents menu, a citation section with downloadable
BibTeX (`citation.bib`), and a license and attribution section. The notebook
and code use [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/),
as on Silvio Fanzon's F1 companion-code page. See `LICENSE.md` for the licence
reference. Third-party data remain subject to their source terms.

The paper constructs probabilistic performance benchmarks for elite chess and
cross-country running. This notebook computes the supplied chess performance
bounds and simulates cross-country team scores under two models of competitive
balance. It shows how the modelling assumptions affect the scores considered
within a central 95% confidence interval.

## Contents

This replication package contains:

- **Data:** CSV transcriptions of Tables 1–3 and 5 of the paper in `data/`,
  described in notebook Section 2 and below.
- **R notebook:** [analysis.qmd](analysis.qmd), containing code for Figures 1–3
  and the Monte Carlo results in Table 4, together with additional rank
  diagnostics and sensitivity checks. Notebook authors: Silvio Fanzon and
  John Fry.
- **Scripts:** [chess_figures.R](scripts/chess_figures.R) for Figures 1–3 and
  [cross_country.R](scripts/cross_country.R) for the complete cross-country
  analysis, using the same code as the notebook.
- **Figures:** vector PDFs and 600 dpi PNGs of Figures 1–3 in `figures/`.

The first column below refers to the paper; the last column gives the location
in the notebook.

| Paper reference | Analysis | Notebook location |
| --- | --- | --- |
| Section 2.1, Figure 1 | Bounds from equation (2), varying the draw probability with 14 games. | Section 4.1: Figure 1 |
| Section 2.1, Figure 2 | Bounds from equation (2), varying the number of games with draw probability 0.794. | Section 4.2: Figure 2 |
| Section 2.2, Figure 3 | Homogeneous and heterogeneous bounds from equations (2) and (4). | Section 4.3: Figure 3 |
| Section 3.3, Table 4, normal-model row | Monte Carlo mean and central 95% confidence interval, plus additional diagnostics and sensitivity checks. | Section 5: Cross-country: normal model |
| Section 3.3, Table 4, discrete-uniform row | Monte Carlo mean and central 95% confidence interval. | Section 6: Cross-country: discrete-uniform comparison |
| Section 3.3, Table 5 | Observed team scores and checks for classification changes when ties are resolved by forward staggering. | Data; Impossible ranks and ties |

The diagnostics reuse the original normal-model draws. They count invalid
rounded ranks and ties, and assess
forward staggering while retaining the original Table 4 benchmark. They also
check whether any of the 32 observed teams changes classification.

## Reproducibility coverage

The notebook provides the numerical calculations for Figures 1–3 and Table 4.
The data in Tables 1–3 and 5 are supplied as CSV files; the notebook does not
recreate the manuscript's formatted tables. Code for Figures 1–2 was
reconstructed from equation (2), the captions and the plots. The original
normal-model calculation reproduces the updated Table 4 mean of 552.25 and
interval of 331–774; the discrete-uniform calculation gives 422.06 and 180–701.

The notebook does not collect external data or reproduce the paper's theoretical
derivations. The empirical data are transcriptions of the manuscript tables;
independent verification against primary sources remains to be documented.

## Data

The `data/` folder contains UTF-8 CSV transcriptions of the manuscript tables:

| File | Paper table | Rows | Columns |
| --- | --- | --- | --- |
| `candidates_winners_2013_2026.csv` | Table 1 | 8 | `year`, `winner`, `score_out_of_14` |
| `candidates_2026_results.csv` | Table 2 | 8 | `position`, `player`, `score_out_of_14` |
| `fide_ratings_2026_10.csv` | Table 3 | 9 | `player`, `rating` |
| `ncaa_2025_team_scores.csv` | Table 5 | 32 | `team`, `score` |

**Source:** `RMAApaperrevision2.docx`, Tables 1, 2, 3 and 5, transcribed on
20 October 2026. These files preserve the manuscript values; they have not been
independently checked against official tournament results or the FIDE archive.
Primary-source links and any data corrections remain to be documented.

Chess scores are points out of 14. `year` is text so that `2020–21` is retained.
`position` follows the ordering in Table 2. The ratings are the October 2026
values reported in Table 3. NCAA scores are the observed team totals in Table 5;
its model-dependent performance arrows are excluded and are calculated from
the simulated benchmarks in the notebook. Both halves of the printed NCAA table are combined
into one list. Whitespace and position punctuation have been normalised; names,
years and numerical values are retained.

Tables 1–2 provide historical context. The rating file records the 65-point
illustration, and the NCAA file supplies the inputs for team classifications.
The NCAA score file is used in the classification checks; the other CSV files
document the paper's empirical inputs and context.
The game records underlying the draw-rate estimate of 0.794 attributed to
Stevenson (2026) were not supplied; that estimate is not reconstructed here.

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

Open `analysis.qmd` in VS Code with the Quarto and R extensions. Run the setup
block first, then execute the code blocks you want to inspect in document order,
using the **Run Cell** controls. Run the shared plot-styling block in notebook
Section 4 before running a chess figure block. Blocks share the R session: the rank checks use
the normal-model draws.
There is no need to render the entire document to inspect each calculation.

### Render the complete report

Open it in RStudio and run the chunks, or click **Render** to produce an HTML
report. It requires Quarto, R, MASS, rmarkdown and knitr. To render from this folder:

```sh
quarto render analysis.qmd
```

With the accompanying `_quarto.yml`, rendering produces `docs/index.html` inside the replication-package folder,
running all calculations and including their outputs and plots by default. The configuration
and `theme-custom-light.scss` / `theme-custom-dark.scss` provide the website
styling, navigation and light/dark themes. Run code blocks individually to inspect their
outputs. To render without running the calculations, change `eval: true` to
`eval: false` under `execute` in the notebook header. The original Word documents
are not needed at runtime. All notebook cells were previously checked locally
with R 4.6.1 and MASS 7.3-65; the final block prints the software session when run.

### Website publication

The generated `docs/` folder is the GitHub Pages publishing directory, following
the same arrangement as the F1 replication repository. The `sports-benchmarks-code/`
folder is intended to become the repository root. The output includes the HTML
landing page, supporting resources and a `.nojekyll` file. After each notebook
update, render again and include the updated `docs/` folder when publishing.
In GitHub Pages settings, select **Deploy from a branch**, the branch containing
the rendered files, and **/docs** as the folder.

The intended website address is
<https://www.silviofanzon.com/sports-benchmarks-code/>.
Rendering locally does not publish the website or change GitHub Pages settings.

## Sources and changes

The notebook uses 1,000,000 simulations per model and records explicit seeds
and the software versions. Both team simulations sort all seven runners before
selecting the five lowest ranks, following the correction in
`R code cross country 2.docx`. The original `Rcodecrosscountry.docx` selected
five entries before sorting. The original Word documents are unchanged and are
not needed to run the notebook.

The three supplied calculations are retained, but this is a cleaned version of
the corrected source rather than a literal transcription of both historical
versions. The normal draws are generated together instead of one at a time,
the seeds and diagnostics are new, and the uniform-score variance from the
second source is included. The chess formulas are algebraically equivalent;
`pmax(0, ...)` guards against a negative variance caused by floating-point
rounding. The three chess plots use consistent dimensions, typography, axes, colours
and line styles, with legends placed above the plotting area. The historical
console outputs are not copied as new results. Code for Figures 1–2 was not
present in the supplied source-code documents; it has been reconstructed from
equation (2), the captions and the plots in the paper. It uses the coefficient
1.96 printed in equation (2). Figure 3 retains `qnorm(0.975)` from the supplied
code. The reconstructed curves reproduce the specified mathematics and ranges;
fonts and plot dimensions need not match the embedded images exactly.

Normal ranks are rounded, without clipping or resampling. The notebook reports
out-of-range rounded ranks and ties rather than assuming they never occur.
The central 95% score intervals are confidence intervals. The two models differ
in both the rank distribution and dependence between teammates, so agreement
is not assumed. Forward staggering is an additional sensitivity check, not a
replacement for the original rounded normal-model benchmark.
