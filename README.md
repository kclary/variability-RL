


# Installation and Dependencies
1. Clone this repo, and install the Python dependencies listed in requirements.txt. We used Python 3.6. 
2. Clone the OpenAI Baselines fork listed as a submodule and follow the installation instructions.

# Experiment Replication
1. Execute `run.sh` to train agents 10M steps on several Atari environments. For information about the cluster used for these experiments, please see the [UMass gypsum documentation](https://maxwell.cs.umass.edu/gypsum/index.php?n=Main.HomePage).
2. To plot learning curves, `python extract_learning_curves.py` to pull all logs into a single file, and use `plot_learning_curves.R` to generate learning curve plots in ggplot.
2. Once models have trained, execute `run_scores.sh` to play 100 games with each model and collect final game scores.
3. Use `plot_scores.R` to replicate the score distribution plots shown in the paper. 


To cite this work, please use: 

``` 
@inproceedings{clary2018variability,
  title={{Let's Play Again: Variability of Deep Reinforcement Learning Agents in Atari Environments}},
  author={Clary, Kaleigh and Tosch, Emma and Foley, John and Jensen, David},
  booktitle={{Critiquing and Correcting Trends in Machine Learning Workshop at Neural Information Processing Systems}},
  year={2018}
  }
```


