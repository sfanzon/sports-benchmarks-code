# Figures 1–3 from analysis.qmd, with the same calculations and styling.
# Run from the replication-package folder: Rscript scripts/chess_figures.R
# Saves vector PDFs and 600 dpi PNGs in figures/. No additional R packages needed.

chess_colours <- c(blue = "#0072B2", orange = "#D55E00")

chess_plot_frame <- function(x, ylim, xlab, x_ticks, y_ticks, yaxs = "i") {
  old_par <- par(mar = c(4.4, 4.5, 3.2, 1), family = "sans",
                 cex = 1, cex.axis = 0.95, cex.lab = 1.05,
                 mgp = c(2.7, 0.7, 0), tcl = -0.25,
                 col.axis = "#444444", col.lab = "#222222")

  # Draw the common frame; each figure adds its own curves
  plot(x, rep(NA_real_, length(x)), type = "n", ylim = ylim,
       xlab = xlab, ylab = "Points total", axes = FALSE,
       xaxs = "i", yaxs = yaxs)
  abline(h = y_ticks, col = "#EEEEEE", lwd = 0.7)
  axis(1, at = x_ticks, col = "#AAAAAA")
  axis(2, at = y_ticks, las = 1, col = "#AAAAAA")
  invisible(old_par)
}

chess_plot_legend <- function(labels, cex = 0.95) {
  legend("top", inset = c(0, -0.19), xpd = NA, horiz = TRUE,
         legend = labels, col = chess_colours, lty = c(1, 2), lwd = 2,
         bty = "n", cex = cex)
}

draw_figure_1 <- function() {
  draw_probability <- seq(0, 1, length.out = 1000)
  upper <- 14 / 2 + 1.96 * sqrt(14 * (1 - draw_probability) / 4)
  lower <- 14 / 2 - 1.96 * sqrt(14 * (1 - draw_probability) / 4)

  old_par <- chess_plot_frame(
    draw_probability, ylim = c(0, 14), xlab = "Draw probability",
    x_ticks = seq(0, 1, by = 0.2), y_ticks = seq(0, 14, by = 2)
  )
  lines(draw_probability, upper, col = chess_colours["blue"], lwd = 2)
  lines(draw_probability, lower, col = chess_colours["orange"], lwd = 2, lty = 2)
  chess_plot_legend(c("Upper bound", "Lower bound"))
  par(old_par)
}

draw_figure_2 <- function() {
  games <- 1:50
  draw_probability <- 0.794
  upper <- games / 2 + 1.96 * sqrt(games * (1 - draw_probability) / 4)
  lower <- games / 2 - 1.96 * sqrt(games * (1 - draw_probability) / 4)

  old_par <- chess_plot_frame(
    games, ylim = range(c(lower, upper)), xlab = "Number of games",
    x_ticks = c(1, 10, 20, 30, 40, 50), y_ticks = seq(0, 30, by = 5), yaxs = "r"
  )
  lines(games, upper, col = chess_colours["blue"], lwd = 2)
  lines(games, lower, col = chess_colours["orange"], lwd = 2, lty = 2)
  chess_plot_legend(c("Upper bound", "Lower bound"))
  par(old_par)
}

draw_figure_3 <- function() {
  d <- seq(0, 1, length.out = 1000)
  homogeneous_upper <- 7 + qnorm(0.975) * sqrt(14 * (1 - d) / 4)
  homogeneous_lower <- 7 - qnorm(0.975) * sqrt(14 * (1 - d) / 4)
  mu_upper <- 0.6 * (1 - d) + d / 2
  mu_lower <- 0.4 * (1 - d) + d / 2
  heterogeneous_upper <- 14 * mu_upper + qnorm(0.975) *
    sqrt(pmax(0, 14 * (mu_upper * (1 - mu_upper) - d / 4)))
  heterogeneous_lower <- 14 * mu_lower - qnorm(0.975) *
    sqrt(pmax(0, 14 * (mu_lower * (1 - mu_lower) - d / 4)))

  old_par <- chess_plot_frame(
    d, ylim = c(0, 14), xlab = "Draw probability",
    x_ticks = seq(0, 1, by = 0.2), y_ticks = seq(0, 14, by = 2)
  )
  lines(d, homogeneous_upper, col = chess_colours["blue"], lwd = 2)
  lines(d, homogeneous_lower, col = chess_colours["blue"], lwd = 2)
  lines(d, heterogeneous_upper, col = chess_colours["orange"], lwd = 2, lty = 2)
  lines(d, heterogeneous_lower, col = chess_colours["orange"], lwd = 2, lty = 2)
  chess_plot_legend(c("Equal strength (p = 0.5)",
                      "Different strengths (p = 0.4, 0.6)"), cex = 0.9)
  par(old_par)
}

export_figure <- function(draw, name) {
  pdf(file.path("figures", paste0(name, ".pdf")),
      width = 7, height = 5, pointsize = 12, bg = "white", useDingbats = FALSE)
  tryCatch(draw(), finally = dev.off())

  png(file.path("figures", paste0(name, ".png")),
      width = 7, height = 5, units = "in", res = 600,
      pointsize = 12, bg = "white")
  tryCatch(draw(), finally = dev.off())
}

dir.create("figures", showWarnings = FALSE)
export_figure(draw_figure_1, "figure-1")
export_figure(draw_figure_2, "figure-2")
export_figure(draw_figure_3, "figure-3")
cat("Figures 1–3 saved as vector PDFs and 600 dpi PNGs in figures/.\n")
