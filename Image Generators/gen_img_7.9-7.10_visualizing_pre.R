# Generates the figures for the 7.9-7.10 Visualizing PRE worksheet
# (By Chapter (ABCD)/Chapter 07/7.9-7.10 Visualizing PRE Worksheet (Teacher Guide).docx)
# and matches the plots in the companion notebook
# (miniJNB-7.9-7.10-Visualizing PRE-COMPLETE.ipynb).
#
# Color scheme (colorblind-safe and grayscale-distinct; checked with CVD
# simulation 2026-07-06): empty model line = navyblue, SS Total squares = blue,
# state model line + SS Error squares = firebrick, SS Model squares = seagreen
# (closest R named color to Okabe-Ito bluish green #009E73 — darkgreen was
# confusable with firebrick under red-green colorblindness and too close to
# it in grayscale; seagreen passes both checks).
#
# PNGs are written to the current working directory.

library(coursekata)

# gf_reduce() and gf_square_reduce() are still in beta, so we source them here
source("https://raw.githubusercontent.com/coursekata/beta-functions/refs/heads/main/gf_reduce.R")

# ── data ──────────────────────────────────────────────────────────────────────
id <- 1:10
date <- rep(c("2025-06-08", "2025-06-09", "2025-06-10", "2025-06-11", "2025-06-12"), each = 2)
state <- rep(c("CA", "NV"), times = 5)
avg_temp <- c(70.2, 78.9, 71.5, 80.1, 69.8, 82.3, 72.0, 85.0, 73.4, 88.2)
temp_data <- data.frame(id, date, state, avg_temp)

empty_model <- lm(avg_temp ~ NULL, data = temp_data)
state_model <- lm(avg_temp ~ state, data = temp_data)

# ── figures ───────────────────────────────────────────────────────────────────
# fig1: both models on the jitter plot (not currently embedded in the worksheet)
fig1 <- gf_jitter(avg_temp ~ state, data = temp_data, width = 0.2) %>%
  gf_model(empty_model, color = "navyblue") %>%
  gf_model(state_model, color = "firebrick")
ggsave("fig1_models.png", fig1, width = 6, height = 4, dpi = 200)

# fig2: SS Total — squared residuals from the empty model
fig2 <- gf_jitter(avg_temp ~ state, data = temp_data, width = 0.2) %>%
  gf_model(empty_model, color = "navyblue") %>%
  gf_square_resid(empty_model, fill = "blue", color = "blue")
ggsave("fig2_sstotal.png", fig2, width = 6, height = 4, dpi = 200)

# fig3: SS Error — squared residuals from the state model
fig3 <- gf_jitter(avg_temp ~ state, data = temp_data, width = 0.2) %>%
  gf_model(state_model, color = "firebrick") %>%
  gf_square_resid(state_model, fill = "firebrick", color = "firebrick")
ggsave("fig3_sserror.png", fig3, width = 6, height = 4, dpi = 200)

# fig4: SS Model — squares from the difference between the two models' predictions
fig4 <- gf_jitter(avg_temp ~ state, data = temp_data, width = 0.2) %>%
  gf_model(empty_model, color = "navyblue") %>%
  gf_model(state_model, color = "firebrick") %>%
  gf_square_reduce(state_model, fill = "seagreen", color = "seagreen")
ggsave("fig4_ssmodel.png", fig4, width = 6, height = 4, dpi = 200)
