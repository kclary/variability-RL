library(reshape2)
library(ggplot2)

scores <- read.csv("raw_scores.tsv", sep="\t", head=TRUE)
all_scores <- melt(scores)

g1 <- ggplot(all_scores, aes(value, fill=variable)) + geom_histogram() + facet_wrap(~variable)
plot(g1)

g2 <- ggplot(all_scores, aes(value, color=variable)) + geom_density()
plot(g2)

