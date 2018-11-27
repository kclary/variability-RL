unset PYTHONPATH

envs="BreakoutNoFrameskip-v4 QbertNoFrameskip-v4 BeamRiderNoFrameskip-v4 SeaquestNoFrameskip-v4 SpaceInvadersNoFrameskip-v4"
algs="acer a2c ppo2 acktr"
timesteps="1e7"

# point work1 to your model directory
work1=$PWD/models/

seeds="2364 196 2307 9228 6811 3355 3410 1966 1228 1939"

# make sure we have all the pip dependencies we want installed
pip3 install gym[atari] --user
pip3 install 'tensorboard<1.8.0,>=1.7.0' --user
pip3 uninstall atari-py --user
pip3 install 'atari-py>=0.1.1,<0.1.2' --user

for steps in $timesteps; do
    for alg in $algs; do
		for env in $envs; do
            iter=-1
			for seed in $seeds; do
                (( iter++ ))
                uid=$env.$alg.$steps.$iter
			    model=$work1/$uid.model

				partition="titanx-short"
			    dest=scripts/run_cmd_$uid.sbatch

			    echo "Running on $partition. Command saved to $dest."

			    cmd="#!/bin/bash
	#
	#SBATCH --job-name=$uid
	#SBATCH --output=$uid.out
	#SBATCH -e $uid.err
        
        sleep 1
        PYTHONPATH=$PYTHONPATH:variability_RL:baselines python -m baselines.run_exp --alg=$alg --env=$env --num_timesteps=0 --load_path=$model --play --num_env=1"
			    echo "$cmd"
			    echo "$cmd" > $dest
			    sbatch -p $partition --gres=gpu:1 $dest
		    done;
	    #exit
		done;
	#exit
    done;
done
