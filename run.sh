unset PYTHONPATH

envs="BreakoutNoFrameskip-v4 PongNoFrameskip-v4 EnduroNoFrameskip-v4 QbertNoFrameskip-v4 BeamRiderNoFrameskip-v4 SeaquestNoFrameskip-v4 SpaceInvadersNoFrameskip-v4"
algs="acer a2c ppo2 deepq acktr"
timesteps="1e7"
work1=/mnt/nfs/work1/jensen/kclary
iters="0 1 2 3 4 5 6 7 8 9"
iters="0"

# make sure we have all the pip dependencies we want installed
pip3 install gym[atari] --user
pip3 install 'tensorboard<1.8.0,>=1.7.0' --user
pip3 uninstall atari-py --user
pip3 install 'atari-py>=0.1.1,<0.1.2' --user

# Run for 3e6 on titanx-short
# Run for 1e7 on titanx-long

runner="baselines/baselines/run.py"

for steps in $timesteps; do
    for alg in $algs; do
		for env in $envs; do
			for iter in $iters; do
			    iftb=''
                            uid=$env.$alg.$steps.$iter
			    model=$work1/$uid.model

			    if [[ "$steps" = "3e6" ]]; then
				partition="titanx-short"
			    else
				partition="titanx-long"
			    fi
         
			    dest=scripts/run_cmd_$uid.sbatch

                            export OPENAI_LOG_FORMAT=stdout,csv,tensorboard
                            export OPENAI_LOGDIR=$work1/test_logs/$uid

			    echo "Running on $partition. Command saved to $dest. Export to $OPENAI_LOGDIR"

			    cmd="#!/bin/bash
	#
	#SBATCH --job-name=$uid
	#SBATCH --output=$uid.out
	#SBATCH -e $uid.err
	#SBATCH --mem=16g
        
        # set logging environment vars
        sleep 1
	./start_python $runner $iftb --alg=$alg --env=$env --num_timesteps=$steps --save_path=$model"
			    echo "$cmd"
			    echo "$cmd" > $dest
			    sbatch -p $partition --gres=gpu:1 $dest
		    done;
	    #exit
		done;
	#exit
    done;
done
