use strict;

my $i;
my $j;
my $line;
my $curacc;
my $preacc;
#my $threshold=0.1;


my $numlayers=4;

	my $lrate=0.005;
	my $layersizes = "2208,1000,500,7"; # 129*11+129
	#for(my $i=0;$i<$numlayers -2;$i++)
	#{
	#	$layersizes	  .= ",500";
	#}	
	#$layersizes	  .= ",7";########################
	

	my $node=500;
	
#	my $hidname = "";
#	for(my $i=0;$i<$numlayers -2;$i++)
#	{
#		$hidname	  .= "_h500";
#	}	

	my $exe 						= "./code_BP_GPU_for_SE_Dropout_NAT_esAT_GPU1/BPtrain";
	my $gpu_used				= 1;

	my $bunchsize				= 3;#128
	my $momentum				= 0.9;
	my $weightcost			= 0;
	my $fea_dim					= 24;
	my $fea_context			= 91;
	my $traincache			= 102400;  ############ how many samples per chunk #102400
	my $init_randem_seed= 27863875;   ############ every epoch must change
	my $targ_offset			= ($fea_context-1)/2;
	my $dpflag=1;
	my $v_omit=0.1;
	my $h_omit=0.2;
		

	my $CF_DIR					= ".";
	my $norm_file				= "/vol/vssp/datasets/audio/dcase2016/task4/pfile/train_aug_all_fold3_random_cv3_random_fea_mfc24.fea_norm";
	my $fea_file				= "/vol/vssp/datasets/audio/dcase2016/task4/pfile/train_aug_all_fold3_random_cv3_random_fea_mfc24.pfile";
	my $targ_file				= "/vol/vssp/datasets/audio/dcase2016/task4/pfile/train_aug_all_fold3_random_cv3_random_lab.pfile";########################
		
	#my $train_sent_range		= "0-3994"; 
	#my $cv_sent_range				= "3995-4377";
	my $train_sent_range		= "0-10524"; 
	my $cv_sent_range				= "10525-10795";
	
	my $MLP_DIR					= "models/24d_fold3_atDCASE2016_NAT_trainAG_batch$bunchsize\_momentum$momentum\_frContext$fea_context\_lrate$lrate\_node$node\_numlayer$numlayers\-Rand_2208_1h1000_1h500_7-DPv${v_omit}h${h_omit}-est7bin-GPU2";###########################################################################
	
	system("mkdir $MLP_DIR");
	my $outwts_file			= "$MLP_DIR/mlp.1.wts";
	my $log_file				= "$MLP_DIR/mlp.1.log";
	my $initwts_file		= "lib/Rand_2208_1h1000_1h500_7.belta0.5.wts";
#	
	#printf("2");
	print "iter 1 lrate is $lrate\n"; 
	system("$exe" .
		" gpu_used=$gpu_used".
		" numlayers=$numlayers".
		" layersizes=$layersizes".
		" bunchsize=$bunchsize".
		" momentum=$momentum".
		" weightcost=$weightcost".
		" lrate=$lrate".
		" fea_dim=$fea_dim".
		" fea_context=$fea_context".
		" traincache=$traincache".
		" init_randem_seed=$init_randem_seed".
		" targ_offset=$targ_offset".
		" initwts_file=$initwts_file".
		" norm_file=$norm_file".
		" fea_file=$fea_file".
		" targ_file=$targ_file".
		" outwts_file=$outwts_file".
		" log_file=$log_file".
		" train_sent_range=$train_sent_range".
		" cv_sent_range=$cv_sent_range".
	  " dropoutflag=$dpflag".
		" visible_omit=$v_omit".
		" hid_omit=$h_omit"
		);
		
#	die;
#	
#		my $success=open LOG, "$log_file";
#		if(!$success)
#		{
#			printf "open log fail\n";
#		}
#		while(<LOG>)
#	  {
#	  	chomp;
#	  	if(/CV over.*/)
#	  	{
#	  	  s/CV over\. right num: \d+, ACC: //; 
#	  	  s/%//; 
#	  	  $curacc=$_;
#	  	}	  	
#	  }
#	  close LOG;
#	  
  $preacc=$curacc;
	my $destep=0;
	########################################
#	$init_randem_seed=27865600;
#	$momentum=0.7;
	########################################
	for($i= 2;$i <= 10;$i++){

		$j = $i -1;
		$initwts_file		= "$MLP_DIR/mlp.$j.wts";
		$outwts_file		= "$MLP_DIR/mlp.$i.wts";
		$log_file				= "$MLP_DIR/mlp.$i.log";
		$init_randem_seed  += 345;
    #$momentum=$momentum+0.04;
    print "iter $i lrate is $lrate\n"; 
		system("$exe" .
		" gpu_used=$gpu_used".
		" numlayers=$numlayers".
		" layersizes=$layersizes".
		" bunchsize=$bunchsize".
		" momentum=$momentum".
		" weightcost=$weightcost".
		" lrate=$lrate".
		" fea_dim=$fea_dim".
		" fea_context=$fea_context".
		" traincache=$traincache".
		" init_randem_seed=$init_randem_seed".
		" targ_offset=$targ_offset".
		" initwts_file=$initwts_file".
		" norm_file=$norm_file".
		" fea_file=$fea_file".
		" targ_file=$targ_file".
		" outwts_file=$outwts_file".
		" log_file=$log_file".
		" train_sent_range=$train_sent_range".
		" cv_sent_range=$cv_sent_range".
	  " dropoutflag=$dpflag".
		" visible_omit=$v_omit".
		" hid_omit=$h_omit"
		);
	}
		
#		my $success=open LOG, "$log_file";
#		if(!$success)
#		{
#			printf "open log fail\n";
#		}
#		while(<LOG>)
#	  {
#	  	chomp;
#	  	if(/CV over.*/)
#	  	{
#	  	  s/CV over\. right num: \d+, ACC: //; 
#	  	  s/%//; 
#	  	  $curacc=$_;
#	  	}	  	
#	  }
#	  close LOG;
#
#	  if($curacc<$preacc+$threshold)	
#	  {
#	  	print "iter $i ACC $curacc < iter $j ACC $preacc+threshold($threshold)\n";
#	  	$destep++;
#	  	print "destep is $destep\n";
#	  	if($destep>=3)
#	  	{
#	  		
#	  		unlink($outwts_file) or warn "can not delete weights file";
#	  		unlink($log_file) or warn "can not delete log file";
#	  		$i+100;
#	  		#print "finetune end\n";
#	  		last;
#	  	}
#	  	else
#	  	{
#	  	$i--;	  	
#	  	$lrate *=0.5;
# 	    }
#	  }
#	  else
#	  {
#	  	$destep=0;
#	  	$preacc=$curacc;
#	  	print "1\n\n\n\n\n\n\n\n";
#	  }
#
#	}
#	
##
	for($i= 11;$i <= 50;$i++){
		$j = $i -1;
		$initwts_file		= "$MLP_DIR/mlp.$j.wts";
		$outwts_file		= "$MLP_DIR/mlp.$i.wts";
		$log_file				= "$MLP_DIR/mlp.$i.log";
		#$lrate *= 0.9;
		#$lrate = 0.01;
		$momentum=0.9;
		$init_randem_seed  += 345;
		
		system("$exe" .
		" gpu_used=$gpu_used".
		" numlayers=$numlayers".
		" layersizes=$layersizes".
		" bunchsize=$bunchsize".
		" momentum=$momentum".
		" weightcost=$weightcost".
		" lrate=$lrate".
		" fea_dim=$fea_dim".
		" fea_context=$fea_context".
		" traincache=$traincache".
		" init_randem_seed=$init_randem_seed".
		" targ_offset=$targ_offset".
		" initwts_file=$initwts_file".
		" norm_file=$norm_file".
		" fea_file=$fea_file".
		" targ_file=$targ_file".
		" outwts_file=$outwts_file".
		" log_file=$log_file".
		" train_sent_range=$train_sent_range".
		" cv_sent_range=$cv_sent_range".
	  " dropoutflag=$dpflag".
		" visible_omit=$v_omit".
		" hid_omit=$h_omit"
		);
	}
