# Complete cross-country analysis from analysis.qmd, in notebook order.
# Run from the replication-package folder: Rscript scripts/cross_country.R
# Requires MASS and data/ncaa_2025_team_scores.csv.
# Runs both million-repetition simulations and all rank/score sensitivity checks.

# Observed NCAA team scores
ncaa_scores <- read.csv("data/ncaa_2025_team_scores.csv", fileEncoding = "UTF-8")

# Simulation setup
library(MASS)
B <- 1000000  # Monte Carlo repetitions for one team's score in a single race
n <- 224     # Number of runners in the race
seed <- 42   # Random seed used for each model

# Normal-model scores
# Mean vector and covariance matrix for the seven teammates
mu <- rep((n + 1) / 2, 7)
sigma <- (n + 1) / 9.8
sigma12 <- (n^2 - 8 * n + 7 / 2) / (4 * 4.9^2)
Sigma <- matrix(sigma12, nrow = 7, ncol = 7)
diag(Sigma) <- sigma^2

# Generate B rank vectors, one per row, using a fixed seed
set.seed(seed)
ranks <- mvrnorm(B, mu, Sigma)

# Calculate the team score for each row
# Allocate B entries to store one team score per Monte Carlo repetition
team_scores_normal <- numeric(B)

for (i in seq_len(B)) {
  team_ranks <- ranks[i, ]
  sorted_ranks <- sort(team_ranks)
  scoring_ranks <- sorted_ranks[1:5]
  team_scores_normal[i] <- sum(round(scoring_ranks))
}

# Mean score and endpoints of the central 95% score interval
c(mean = mean(team_scores_normal),
  quantile(team_scores_normal, c(0.025, 0.975)))

# Discrete-uniform comparison
# Set the seed for reproducibility
set.seed(seed)

# Simulate B team scores by drawing seven distinct ranks and summing the lowest five
team_scores_uniform <- replicate(B, {
  ranks <- sample.int(n, 7, replace = FALSE)
  sum(sort(ranks)[1:5])
})

# Report the mean and endpoints of the central 95% score interval
c(mean = mean(team_scores_uniform),
  quantile(team_scores_uniform, c(0.025, 0.975)))

# Rank diagnostics
# Initialise the counts of inadmissible ranks and teams containing ties
out_of_range_entries <- 0
teams_with_ties <- 0

for (i in seq_len(B)) {
  # Round the seven ranks for this simulated team
  rounded_ranks <- round(ranks[i, ])
  # Count individual ranks outside the admissible range
  out_of_range_entries <- out_of_range_entries +
    sum(rounded_ranks < 1 | rounded_ranks > n)
  # Count this team once if any rounded ranks are duplicated
  teams_with_ties <- teams_with_ties +
    as.integer(anyDuplicated(rounded_ranks) > 0)
}

# Report the counts and the percentage of teams containing ties
c(inadmissible_rounded_ranks = out_of_range_entries,
  total_ranks = length(ranks),
  teams_with_ties = teams_with_ties,
  percentage_of_teams_with_ties = 100 * teams_with_ties / B)

# Forward staggering
forward_stagger <- function(team_ranks, n) {
  corrected <- round(sort(team_ranks))
  k <- length(corrected)

  corrected[1] <- max(1, corrected[1])
  for (j in 2:k) {
    corrected[j] <- max(corrected[j], corrected[j - 1] + 1)
  }

  # Keep the ranks within the field while retaining distinct positions
  corrected[k] <- min(n, corrected[k])
  for (j in (k - 1):1) {
    corrected[j] <- min(corrected[j], corrected[j + 1] - 1)
  }
  corrected
}

# Simulate scores with ties resolved
team_scores_forward <- numeric(B)

for (i in seq_len(B)) {
  corrected_ranks <- forward_stagger(ranks[i, ], n)
  team_scores_forward[i] <- sum(corrected_ranks[1:5])
}

# Compare the original and corrected benchmarks
original_interval <- quantile(team_scores_normal, c(0.025, 0.975))
corrected_interval <- quantile(team_scores_forward, c(0.025, 0.975))

data.frame(
  method = c("Original rounding (Table 4)", "Ties resolved", "Change"),
  mean = c(mean(team_scores_normal), mean(team_scores_forward),
           mean(team_scores_forward) - mean(team_scores_normal)),
  lower = c(original_interval[1], corrected_interval[1],
            corrected_interval[1] - original_interval[1]),
  upper = c(original_interval[2], corrected_interval[2],
            corrected_interval[2] - original_interval[2]),
  row.names = NULL
)

# Check the 32 observed team classifications
ncaa_scores <- read.csv("data/ncaa_2025_team_scores.csv", fileEncoding = "UTF-8")
observed_scores <- ncaa_scores$score

classify_scores <- function(scores, interval) {
  ifelse(scores < interval[1], "Above expectations",
         ifelse(scores > interval[2], "Below expectations", "Within expectations"))
}

original_classification <- classify_scores(observed_scores, original_interval)
corrected_classification <- classify_scores(observed_scores, corrected_interval)

c(teams_checked = length(observed_scores),
  changed_classifications = sum(original_classification != corrected_classification))

# Software versions
sessionInfo()
