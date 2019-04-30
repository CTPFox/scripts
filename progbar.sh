#!/bin/bash
input=${1}
period=1 				#how long each tick should last in seconds
columns=$(tput cols)			#get how many columns we have
drawspace=6   				#reserve columns to draw % indicator
available=$(( columns-drawspace ))

if (( input < available )); then
	fitscreen=1;
else
  fitscreen=$(( input / available ));
  fitscreen=$((fitscreen+1));
fi

aldone() { for ((done=0; done<(elapsed / fitscreen) ; done=done+1 )); do printf "▇"; done }
remaining() { for (( remain=(elapsed/fitscreen) ; remain<(input/fitscreen) ; remain=remain+1 )); do printf " "; done }
percentage() { printf "| %s%%" $(( ((elapsed)*100)/(input)*100/100 )); }
clean() { printf "\r"; }

for (( elapsed=1; elapsed<=input; elapsed=elapsed+1 )); do
    aldone; remaining; percentage
    sleep "$period"
    clean
done
clean

