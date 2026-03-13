#!/bin/bash
# Initialize some arrays
try=0
hit=0
declare -a first
declare -a second
declare -a third
declare -a fourth
declare -a fifth
declare -a yellow_all
declare time
declare log_entry

log() {
	# Output results, save to log
	log_entry="${log_entry}`date`"
	echo "Tested $try combinations"
	log_entry="$log_entry: Tested $try combinations"
	time_2=`date +'%s'`
	echo "Took $(((time_2 - time))) seconds"
	echo "Found $hit possible words"
	log_entry="$log_entry, took $(((time_2 - time))) seconds, found $hit possible words"
	echo $log_entry >> wordle.log
}

trap ctrl_c INT

ctrl_c() {
	echo "SIGINT captured."
	echo "Exiting before full completion."
	log_entry="Exiting before full completion. " 
	log
	exit 1
}

# Grab user input and sanitize
echo "Enter the untried grey letters:"
read -a grey_input
grey=$(echo "${grey_input[@]}" | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]"  | grep -o . | sort  -u | tr "\n" " ")
echo "Enter the green letter in the first position:"
read -a green_1
echo "Enter the green letter in the second position:"
read -a green_2
echo "Enter the green letter in the third position:"
read -a green_3
echo "Enter the green letter in the fourth position:"
read -a green_4
echo "Enter the green letter in the fifth position:"
read -a green_5
echo "Enter the yellow letters for the first position:"
# We need the yellow inputs whether or not there's a green there
read -a yellow_1_input
yellow_1=( $(echo "${yellow_1_input[@]}" | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )
echo "Enter the yellow letters for the second position:"
read -a yellow_2_input
yellow_2=( $(echo "${yellow_2_input[@]}" | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )
echo "Enter the yellow letters for the third position:"
read -a yellow_3_input
yellow_3=( $(echo "${yellow_3_input[@]}" | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )
echo "Enter the yellow letters for the fourth position:"
read -a yellow_4_input
yellow_4=( $(echo "${yellow_4_input[@]}" | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )
echo "Enter the yellow letters for the fifth position:"
read -a yellow_5_input
yellow_5=( $(echo "${yellow_5_input[@]}" | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )

# User input ended, start timer
time=`date +'%s'`

# Find possible letters in each non-green position. If there was already a green, set it as the only choice for that position
yellow_all=( $(echo "${yellow_1[@]} ${yellow_2[@]} ${yellow_3[@]} ${yellow_4[@]} ${yellow_5[@]}"  | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )
choices=( $(echo "${yellow_all[@]} ${grey[@]} ${green_1[@]} ${green_2[@]} ${green_3[@]} ${green_4[@]} ${green_5[@]}"  | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )

if test -z ${green_1[0]}; then
	first=( "${choices[@]}" )
	for yellow in "${yellow_1[@]}"; do
		first=( "${first[@]/$yellow}" )
	done
	first=( $(echo "${first[@]}"  | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )
else
	first=( $(echo "${green_1[0]}" | grep -o . | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | head -n 1 | tr "\n" " ") )
fi
if test -z ${green_2[0]}; then
	second=( "${choices[@]}" )
	for yellow in "${yellow_2[@]}"; do
		second=( "${second[@]/$yellow}" )
	done
	second=( $(echo "${second[@]}"  | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )
else
	second=( $(echo "${green_2[0]}" | grep -o . | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | head -n 1 | tr "\n" " ") )
fi
if test -z ${green_3[0]}; then
	third=( "${choices[@]}" )
	for yellow in "${yellow_3[@]}"; do
		third=( "${third[@]/$yellow}" )
	done
	third=( $(echo "${third[@]}"  | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )
else
	third=( $(echo "${green_3[0]}" | grep -o . | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | head -n 1 | tr "\n" " ") )
fi
if test -z ${green_4[0]}; then
	fourth=( "${choices[@]}" )
	for yellow in "${yellow_4[@]}"; do
		fourth=( "${fourth[@]/$yellow}" )
	done
	fourth=( $(echo "${fourth[@]}"  | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )
else
	fourth=( $(echo "${green_4[0]}" | grep -o . | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | head -n 1 | tr "\n" " ") )
fi
if test -z ${green_5[0]}; then
	fifth=( "${choices[@]}" )
	for yellow in "${yellow_5[@]}"; do
		fifth=( "${fifth[@]/$yellow}" )
	done
	fifth=( $(echo "${fifth[@]}"  | tr -d "[:blank:]" | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | grep -o . | sort  -u | tr "\n" " ") )
else
	fifth=( $(echo "${green_5[0]}" | grep -o . | tr -d "[:punct:]" | tr "[:lower:]" "[:upper:]" | head -n 1 | tr "\n" " ") )
fi

# Solve using possible letters and brute force
echo "Solving..."
#echo y ${yellow_all[@]}
#echo c ${choices[@]}
#echo 1 ${first[@]}
#echo 2 ${second[@]}
#echo 3 ${third[@]}
#echo 4 ${fourth[@]}
#echo 5 ${fifth[@]}
for index in $(seq 0 $((${#first[@]} - 1 )));
do
for jndex in $(seq 0 $((${#second[@]} - 1 )));
do
for kndex in $(seq 0 $((${#third[@]} - 1 )));
do
for lndex in $(seq 0 $((${#fourth[@]} - 1 )));
do
for mndex in $(seq 0 $((${#fifth[@]} - 1 )));
do
string="${first[$index]}${second[$jndex]}${third[$kndex]}${fourth[$lndex]}${fifth[$mndex]}"
let try=try+1
if [[ "$string" == *${yellow_all[0]}* ]] && [[ "$string" == *${yellow_all[1]}* ]] && [[ "$string" == *${yellow_all[2]}* ]] && [[ "$string" == *${yellow_all[3]}* ]] && [[ "$string" == *${yellow_all[4]}* ]];
then
	if [[ "`echo $string | hunspell -a -d en_US -G | grep "*"`" == "*" ]];
	then
		echo "$string, got on try $try"
		let hit=hit+1
	fi
fi
done
done
done
done
done

log
exit 0
