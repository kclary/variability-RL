import os
import pandas as pd
from baselines import results_plotter


algs = ["a2c", "ppo2", "acktr"]
envs = ["BeamRider", "Breakout", "Seaquest", "Qbert", "Pong", "Enduro", "SpaceInvaders"]
env_extension = "NoFrameskip-v4"
envs = [env+env_extension for env in envs]

n_steps = ["1e7"]
iters = range(0,10)


def main():
    # load training curves for all 
    results = {}
    for env in envs:
        for alg in algs: 
            for steps in n_steps: 
                m_ids = [env + "." + alg + "." + str(steps) + "." + str(i) for i in iters]
                for m_id in m_ids: 
                    log_dir = os.path.join(".", "logs", m_id)
                    if os.path.exists(log_dir): 
                        try: 
                            xy_list = results_plotter.prepare_results([log_dir], 1e7, results_plotter.X_TIMESTEPS, results_plotter.Y_REWARD, env+"--"+alg)
                            results[m_id] = xy_list
                        except: 
                            pass


    all_curves = pd.DataFrame()
    for k in results.keys(): 
        env, alg, steps, i = k.split('.')
        curve = pd.DataFrame({'alg':alg, 'env':env, 'random_seed_id':i, 'x': results[k][0][0].tolist(), 'y':results[k][0][1].tolist()})

        #append to all_curves
        all_curves = all_curves.append(curve, ignore_index = True)

    # save to tsv
    all_curves.to_csv(os.path.join(".", "data", "all_learning_curves.tsv"), sep="\t")


if __name__ == '__main__':
    main()