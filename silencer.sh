#!/bin/bash
finished=0
selectionmade=0
rulesfile=am_rules.txt
statefile=silencer.state
selectedalert="nothing"
desiredsilenceduration=0
re='^[0-9]+$'


while [ $finished = 0 ];
do
clear
echo "-------------------------------------------"
echo "Welcome to the Be-Quiet-Alertmanager script"
echo "-------------------------------------------"
echo "The currently selected alert is:"
echo $selectedalert
echo ""
echo "Options:"
echo ""
echo "1 - change alert selection"
echo "2 - silence the currently selected alert"
echo "3 - list all active silences"
echo "4 - end an active silence"
echo "5 - quit"
echo ""
echo "Please type the number of your desired option, followed by Enter:"
read userinput1



if [ $userinput1 = "1" ];
then
selectedalert=$(cat $rulesfile | grep alert: | awk '{ print $3 }' | percol)
selectionmade=1




elif [ $userinput1 = "2" ];
then
clear
echo "Silence alert $selectedalert"
echo "Enter a number of minutes that you would like to silence this alert for."
echo "Type 'debug' for debug information."
echo "To cancel the operation, enter anything else that isn't a number,"
read desiredsilenceduration


if ! [ $desiredsilenceduration =~ $re ];
then
if [ $desiredsilenceduration = "debug" ];
then
echo "DEBUG INFO HERE"
read -p "Press ENTER to continue."
else
   echo "Non-number entered. Operation Cancelled."
   read -p "Press ENTER to continue."
   fi
else
if [ $desiredsilenceduration > 1000 ];
then
echo "That's a bit silly."
echo "I might have to get a second opinion on that."
read -p "Press ENTER to acknowledge that you have alerted the system administrator."
else
#timestamp=now()
#desiredendtime=now() + $desiredsilenceduration
echo "Sending request..."
silenceID=$(curl https://localhost:9093/api/v1/silences -d '{
      "matchers": [
        {
          "name": "$selectedalert",
          "value": ".*",
          "isRegex": true
        }
      ],
      "startsAt": "$timestamp",
      "endsAt": "$desiredendtime",
      "createdBy": "api",
      "comment": "Silence",
      "status": {
        "state": "active"
      }

}')

# PROCESS silenceID  !!!

echo "Updating records..."
echo $selectedalert,$silenceID >> $statefile
echo "State file updated."
read -p "Press ENTER to continue."
fi
fi







elif [ $userinput1 = "3" ];
then
clear
echo "Currently Silenced Alerts"
echo "-------------------------"
if [ -f $statefile ]; then
   cat $statefile
   read -p "Press ENTER to continue."
else
   echo "There are no currently silenced alerts."
   read -p "Press ENTER to continue."
fi






elif [ $userinput1 = "4" ];
then
echo "Not implemented yet."
read -p "Press ENTER to continue."



elif [ $userinput1 = "5" ];
then
finished=1
else
echo "Invalid selection."
read -p "Press ENTER to continue."







fi
done
clear
echo "Thankyou for using the Be-Quiet-Alertmanager script!"

