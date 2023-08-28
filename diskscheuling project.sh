#!/usr/bin/bash

#it is use to clear all everything before loading full programm
clear

echo -e "\nPROJECT TO FIND SEEK TIME USING DISK SCHEDULING ALGORITHM\n\n\n "
echo -e "-----------------WELCOME---------------------\n\n"

#HELPING FUNCTION1: sorting function:
sort(){
	for((i=0;i<$2;i++))
	do
	   for((j=0;j<$2-$i-1;j++))
	   do
		   if [ ${arr[j]} -gt ${arr[$((j+1))]} ]
	           then 
		       temp=${arr[j]}
		       arr[$j]=${arr[$((j+1))]}
		       arr[$((j+1))]=$temp
	           fi
	   done
	done
}

#HELPING FUNCTION2: function to find greatest value in queue before position head
b_h(){
	for((i=0;i<$2;i++))
	do
		if [ ${arr[i]} -ge $3 ]
		then	
			if [ $4 == "l" ]
			then		
		        	return ${arr[$i-1]}
			elif [ $4 == "s" ]
			then
				if [ ${arr[i]} -gt $3 ]
				then
				     	return ${arr[$i]}
				else
					return ${arr[$i+1]}
				fi
			else
				echo "somthing went wrong in direction....."
				exit 0
			fi
		fi
	done	 
}

#HELPING FUNCTION3: for making an absolute value:
poss(){
	if [ $1 -lt 0 ]
	then
		return $(($1*-1))
	else
		return $1
	fi
}

#HELPING FUNCTION3: for remove given element
remove(){
	#echo "index:$2"
	for((count=$2;count<$((${#arr[@]}-1));count++))
	do
		arr[$count]=${arr[$(($count+1))]}
		
	done
}

#HLPING FUNCTION: fcfs for sstf:
fcfs_sstf(){
	f_res=0
	p=$3
	for((i=0;i<$2;i++))
	do
		res_f=$(($p-${new_arr[i]}))
		poss $res_f
		res_f=$?
		f_res=$(($f_res+$res_f))
		p=${new_arr[i]}
	done
	echo -e "\n\n\n---------OUTPUT----------\n"
	echo "SSTF Seek Time: $f_res"	
}

#function for FCFS algorithm
fcfs(){
	local f_res=0
	local p=$3
	for((i=0;i<$2;i++))
	do
		
	        res_f=$(($p-${arr[$i]}))
		poss $res_f		
		res_f=$?
		f_res=$(($f_res+$res_f))
		p=${arr[i]}
	done
	echo -e "\n\n\n--------OUTPUT--------\n"
	echo "FCFS Seek time: $f_res"
}

#function for sstf algorithm
sstf(){
        p_h=$real_p_h
	new_arr=()
	for((i=0;i<${#arr[@]};i++))
	do
		res1=$(( $p_h-${arr[0]} ))
		poss $res1
		res1=$?
		min=$res1
		#echo "loop1 ecxecuted"
		for((j=0;j<$(( ${#arr[@]}-$i ));j++))
		do
			if [[ $j<$((${#arr[*]}-$i)) ]]
			then
				res2=$(($p_h-${arr[$j]}))
			else
				break
			fi
			poss $res2
			res2=$?
			#echo min:$min and res2:$res2
			if [ $res2 -le $min ]
			then
				min=$res2
				#echo if_min: $min
				index=$j
				#echo index in inl: $index
			fi
			#echo array:${arr[@]}

		done
		#echo min:${arr[$index]}
		new_arr[i]=${arr[$index]}
		p_h=${arr[$index]}
		remove arr $index
		#echo array: ${arr[@]}

	done
	#echo shortest: ${new_arr[*]}
	fcfs_sstf new_arr ${#arr[@]} $real_p_h
}


#function for scan algorithm
scan(){
 	sort arr $2
	local l_item=${arr[0]}
	local h_item=${arr[${#arr[*]}-1]}
	
	#for largest direction
	if [ $4 == "l" ]
	then 
		local l_res=$(( ($6-$3) + ($6-$l_item) ))
		echo -e "\n\n---------OUTPUT----------\n"
		echo "Scan Se:ek Time: $l_res"
	#for smallest direction
	elif [ $4 == "s" ]
	then
		local s_res=$(( ($3+$h_item ) ))
		echo -e "\n\n---------OUTPUT----------\n"
		echo "Scan Seek Time: $s_res"
	else
		echo "somthing went wrong in direction......."
	fi

}


#function for C-scan algorithm
c_scan(){
	sort arr $2
	b_h arr $2 $3 $4
	local b_ph=$?

	if [ $4 == "l" ]
	
	then
		echo $3 $5 $6 $b_ph
		local l_res=$(( ($6-$3) + ($6-$5) + ($b_ph-$5) ))
		echo -e "\n\n\n----------OUTPUT---------\n"
		echo "C-Scan Seek time: $l_res"
	elif [ $4 == "s" ]
	then
		local s_res=$(( ($3-$5) + ($6-$5) + ($6-$b_ph) ))
		echo -e "\n\n\n-----------OUTPUT----------\n"
		echo "C-Scan Seek Time: $s_res"
	else
		echo "somthing went wrong in direction......"
	fi
}


#function for look algorithm
look(){
	sort arr $2
	local l_item=${arr[0]}
	local h_item=${arr[${#arr[*]}-1]}

	if [ $4 == "l" ]
	then 
		local l_res=$(( ($h_item-$3) + ($h_item-$l_item)  ))
		echo -e "\n\n\n----------OUTPUT----------\n"
		echo "Look Seek Time: $l_res"
	elif [ $4 == "s" ]
	then
		local s_res=$(( ($3-$l_item) + ($h_item-$l_item) ))
		echo -e "\n\n\n---------OUTPUT---------\n"
		echo "Look Seek Time: $s_res"
	
	else
		echo "Something went wrong in direction" 
	fi

	
}

#function for C-loop  algorithm
c_look(){
	sort arr $2  # ->sort function is call to sort the given array
	local l_item=${arr[0]}  # ->lowest item in queue
	local h_item=${arr[${#arr[*]}-1]}  # ->highest item in queue
	b_h arr $2 $3 $4   # ->b_h function is call to return greatest item before position head
	local b_ph=$?  # ->b_ph store the value return by b_h function
	
	# for largest direction:
	if [ $4 == "l" ]
	then
		local l_res=$(( ($h_item-$3) + ($h_item-$l_item) + ($b_ph-$l_item) ))
		echo -e  "\n\n---------OUTPUT---------\n"
		echo "C-look Seek Time: $l_res"

	#for smallest direction:
	elif [ $4 == "s" ]
	then
		local s_res=$(( ($3-$l_item) + ($h_item-$l_item) + ($h_item-$b_ph)  ))
		echo -e "\n\n----------OUTPUT---------\n"
		echo "C-look Seek Time: $s_res"
	
	#for error handling:
	else
		echo "somthing went wrong in direction...."
	fi
}


# ->main execution start from here:
#show algorithm list:
echo "Choose Algorithm"
echo "1. First Come First Serve"
echo "2. Shortest Seek Time First"
echo "3. Scan"
echo "4. C-Scan"
echo "5. Look"
echo "6. C-Look"

#take choice
read -p "Enter Choice: " choice
direc="l"
if [[ $choice == 3 || $choice == 4 || $choice == 5 || $choice == 6 ]]
then 
	echo -e  "\ns -> shortest"
	echo -e "l -> largest\n"
	read -p "Enter Direction: " d
	direc=$d
fi

# input array
arr=()
read -p "Enter length of Queue: " len
echo "Enter Queue Item:"
for ((i=0;i<$len;i++));
do
	read q
	arr[i]=$q
done

#input position head:
read -p "Enter Position Head:" p_h

#input rage:
echo "Enter Track Range:"
read -p "Start Range: " s_r
read -p "End Range: " e_r

#algo execution:
case $choice in
	1)
		#FCFS function is call here
		fcfs arr $len $p_h
		;;

	2)
		#sstf function is call here
		real_p_h=$p_h
		sstf arr $real_p_h
		;;

	3)
		#Scan function is call here
		scan arr $len $p_h $direc $s_r $e_r
		;;

	4)
		#C-scan function is call here
		c_scan arr $len $p_h $direc $s_r $e_r
		;;

	5) 
		#Look function is call here
		look arr $len $p_h $direc	
		;;

	6) 
		#C-look function is call here
		c_look arr $len $p_h $direc	
	   ;;

	*)
		echo "Somthing went wrong in choice...... .please try again!"
	   ;;
esac
