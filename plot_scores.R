library(reshape2)
library(ggplot2)
library(stringr)
library(plyr)
library(gridExtra)

# array of models, environments
models <- c("ppo2", "a2c", "acer", "acktr", "deepq")
envs <- c("BreakoutNoFrameskip-v4","PongNoFrameskip-v4", "EnduroNoFrameskip-v4", "QbertNoFrameskip-v4", "BeamRiderNoFrameskip-v4", "SeaquestNoFrameskip-v4", "SpaceInvadersNoFrameskip-v4")
timesteps <- "1e7"
nmodels <- 10

# load scores into dataframe
all_scores <- lapply(1:length(models), function(mod) { 
  model_scores <- lapply(1:length(envs), function(env){ 
    score_files <- lapply(1:nmodels, function(i) { 
      fname <- paste0("data/model_scores_", paste(envs[env], models[mod], timesteps, i-1, "model.tsv", sep="."))
    }) 
    
    score_files <- unlist(score_files)
    
    scores <- lapply(1:length(score_files), function(f) { 
      if(file.exists(score_files[f])) read.csv(score_files[f], sep="\t", head=FALSE)  
    })
    names(scores) <- seq_along(scores)
    scores[sapply(scores, is.null)] <- NULL
    if(length(scores) > 0) { 
      scores <- melt(scores, level=1)
      
      scores$L1 <- as.numeric(scores$L1)
      scores$random_seed_id <- scores$L1-1
      scores$L1 <- NULL
      scores$variable <- NULL
      
      scores <- rename(scores, replace = c("value"="final_score", "V1"="model"))
      scores$random_seed_id <- factor(scores$random_seed_id)
      scores$environment <- envs[env]
      scores$algorithm <- models[mod]
      
      # plotting
      model_id <- paste0(envs[env], "--", models[mod])
      g1 <- ggplot(scores, aes(final_score, fill=random_seed_id)) + geom_histogram() + xlab("") + ylab("") +
        facet_wrap(~random_seed_id, nrow=2) + theme_bw() + theme(legend.position="none") + 
        theme(axis.text=element_text(size=20), axis.title=element_text(size=30)) + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
      
      g2 <- ggplot(scores, aes(final_score, color=random_seed_id)) + geom_density(bins=40) + ylab("") +
        theme_bw() + theme(legend.position="none") +theme(axis.text=element_text(size=20), axis.title=element_text(size=28)) + xlab("Score") + 
        theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
      plot(arrangeGrob(g1,g2))
      ggsave(paste0("plots/", model_id, "_", "comb.png"), arrangeGrob(g1,g2), "png")
      
      scores
    }
  })
  names(model_scores) <- seq_along(model_scores)
  model_scores[sapply(model_scores, is.null)] <- NULL
  model_scores <- do.call(rbind, model_scores)
})
names(all_scores) <- seq_along(all_scores)
all_scores[sapply(all_scores, is.null)] <- NULL
all_scores <- do.call(rbind, all_scores)



# save all scores to file
write.csv(all_scores, "data/all_scores.tsv")