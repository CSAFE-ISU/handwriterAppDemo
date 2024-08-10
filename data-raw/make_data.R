templateK40 <- readRDS(file.path("data-raw", "templateK40.rds"))
templateK40$template_graphs <- NULL
templateK40$wcd <- templateK40$wcd[templateK40$iters,]
save(templateK40, file = "data/templateK40.rda")
