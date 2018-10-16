library(reshape2)
library(ggplot2)

scores <- read.csv("raw_scores.tsv", sep="\t", head=TRUE)
all_scores <- melt(scores)

ggplot(all_scores, aes(value, color=variable)) + geom_density()
