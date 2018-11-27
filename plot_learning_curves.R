require(ggplot2)

algs <- c("ppo2", "a2c", "acktr")
envs <- c("BreakoutNoFrameskip-v4", "QbertNoFrameskip-v4", "BeamRiderNoFrameskip-v4", "SeaquestNoFrameskip-v4", "SpaceInvadersNoFrameskip-v4")
timesteps <- "1e7"
nmodels <- 10

learning_curves <- read.csv("data/all_learning_curves.tsv", sep="\t")
learning_curves$random_seed_id <- as.factor(learning_curves$random_seed_id)

ls <- lapply(1:length(envs), function(env) { 
  model_id <- envs[env]
  env_curves <- learning_curves[learning_curves$env %in% envs[env],]
  g1 <- ggplot(env_curves, aes(x,y, color=alg, line=random_seed_id)) + stat_smooth() +
    xlab("Steps") + ylab("Reward")  + theme_bw() + theme(axis.text=element_text(size=20), axis.title=element_text(size=28)) + 
    theme(legend.title=element_text(size=20),   legend.text=element_text(size=18)) + guides(color=guide_legend(title="Algorithm"))
  plot(g1)
  ggsave(paste0("plots/learning_curves/", model_id, "_learning_curves_pd.png"), g1, "png")
})
