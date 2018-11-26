1. clone this repo
2. run.sh to train agents 10M steps on several Atari environments
3. move trained agents to the models folder 
4. run_scores.sh or get_scores.sh to play 100 games and collect final scores
5. extract_raw_scores.py to combine collected scores into a single tsv
6. plot_learning_curves.R and plot_scores.R to replicate the plots shown in the paper

To cite this work, please use: 
@inproceedings{clary2018variability,
title={{Let's Play Again: Variability of Deep Reinforcement Learning Agents in Atari Environments}},
author={Clary, Kaleigh and Tosch, Emma and Foley, John and Jensen, David},
booktitle={{Critiquing and Correcting Trends in Machine Learning Workshop at Neural Information Processing Systems}},
year={2018}
}
