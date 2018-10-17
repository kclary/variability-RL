envs="BreakoutNoFrameskip-v0"
algs="acer a2c trpo_mpi ppo2 deepq"
timesteps="3e6 1e7"
work1=/mnt/nfs/work1/jensen/kclary
iters="1 2 3 4 5 6 7 8 9 10"

# make sure we have all the pip dependencies we want installed
pip3 install gym[atari] --user
pip3 install 'tensorboard<1.8.0,>=1.7.0' --user

# Run for 3e6 on titanx-short
# Run for 1e7 on titanx-long

runner="baselines/baselines/run.py"

for steps in $timesteps; do
    for alg in $algs; do
		for env in $envs; do
			for iter in $iters; do
			    iftb=''

			    model=$work1/$env.$alg.$steps.$iter.model

			    if [[ "$steps" = "3e6" ]]; then
				partition="titanx-short"
			    else
				partition="titanx-long"
			    fi
			    uid=$env.$alg.$steps.$iter
			    dest=scripts/run_cmd_$uid.sbatch

			    echo "Running on $partition. Command saved to $dest."

			    cmd="#!/bin/bash
	#
	#SBATCH --job-name=$uid
	#SBATCH --output=$uid.out
	#SBATCH -e $uid.err
	#SBATCH --mem=16g


	python3 $runner $iftb --alg=$alg --env=$env --num_timesteps=$steps --save_path=$model"
			    echo "$cmd"
			    echo "$cmd" > $dest
			    #sbatch -p $partition --gres=gpu:1 $dest
		    done;
	    exit
		done;
	exit
    done;
done