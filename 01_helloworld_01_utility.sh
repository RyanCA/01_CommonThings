#!/bin/sh
######################################################################
###### How to call these functions                              ######
###### 0. Set the file excutable                                ######
######    $> chmod 764 01_helloworld_01_utility.sh              ######
######    $> . 01_helloworld_01_utility.sh                      ######
###### 1. Set your script file under PATH by editing .bash_profile at home folder ######
######    vi /home/bpmadm/.bash_profile                         ######
######    PATH=$PATH:/ryan; export PATH                         ######
###### 2. Exec the .bash_profile to make change effective       ######
######    $>. ~/.bash_profile                                   ######
###### 3. Verify if PATH variable has new values                ######
######    $> echo $PATH                                         ###### 
###### 4. Run these function of the script                      ######
######    $> helloparam2                                        ######
######    $> getprocessbyport 8080                              ######
######    $> HelloString ABC EFG                                ######
######    $> echo $? #To See the return value of last command   ######
######################################################################

echo "Hello, system is executing 01_helloworld_01_process_by_port.sh script now"; # I found this statement is important otherwise it will be failed to execute command $> . HelloWorld.sh because all the other statements are in function

#################################################
###### Display the arguments of the script ######
###### The difference between ', " and `   ######
###### http://stackoverflow.com/questions/6697753/difference-between-single-and-double-quotes-in-bash ######
#################################################
helloparam2(){
echo "BEGIN 01_helloworld_01_utility.sh helloparam2()";
echo 'File name of current script:$0='$0; # $ won't be interpreated by '
echo "Number of arguments \$#="$#;        # $ will be interpreated by " ( ` and \ also will be interpreated by " ) 
echo "All arguments \$*="$*;
echo "All arguments \$@="$@;
echo "\$1="$1;
echo "Exit status of last command \$?="$?; #Actually it is the return value of last command
echo "Process number of current shell \$\$="$$;
echo "Process number of last background command \$!="$!;

echo "END 01_helloworld_01_utility.sh helloparam2()";
}

#This version use Pipe to join my own function readnumberfrompipe
#Refer to another version of implementation: getprocessbyport2()
getprocessbyport(){

   echo 'BEGIN 01_helloworld_01_utility.sh getprocessbyport() input $1='$1;
   
   #######################################
   ### Tell is first parameter is null ###
   #######################################
   if [[ -z "$1" ]]; then
       echo "01_helloworld_01_utility.sh getprocessbyport() input $1 is null, return with value 1"
       return 1
   fi
   
   #The output of this line will be like 4565/tibamx_BPMNode 
   ########################################################################
   ### The following comment line is good because of it provides header ###
   ########################################################################
   #netstat -nlp | head -n 2; netstat -nlp | tail -n +3 | grep $1 | awk '{print $7}' | tail -n 1 | readpipe;
   
   #The output of this line will be like 4565/tibamx_BPMNode, and the code need to pick up process id 4565 in this case
   #awk '{print $7}' represents return 7th column
   netstat -nlp | grep $1 | awk '{print $7}' | tail -n 1 | readnumberfrompipe;

   #echo "record="$record; 
    echo "END 01_helloworld_01_utility.sh getprocessbyport()";

}

#private method
readnumberfrompipe(){
   while IFS='' read -r line; do
      echo "01_helloworld_01_utility.sh readnumberfrompipe() line=$line"
	  #The output of this line will be like 4565/tibamx_BPMNode, get number from the string
	  numberOfString=${line//[^0-9]}
	  echo "01_helloworld_01_utility.sh readnumberfrompipe() parse line and get process id=$numberOfString"
	  ps -el | head -n 1
      ps -el | grep $numberOfString;
   done
}




monitoringjob(){
    echo "BEGIN 01_helloworld_01_utility.sh monitoringjob()"

    #######################################
    ### Tell is first parameter is null ###
    #######################################
    if [[ -z "$1" ]]; then
       echo "input $1 is null, return with 1; expected input status / start / stop"
       return 1
    fi
	
	if [[ "$1" == "stop" ]]
	then
	   echo 'input $1==stop'
	   numberOfString=`jps -vl | grep MornitoringWealthManagement-1.0-SNAPSHOT.jar | awk '{print $1}'`
       echo "01_helloworld_01_utility.sh monitoringjob() get WINPID=$numberOfString"
	
	   #Showing title for better debug
	   #ps -el | head -n 1
    
	   processid=`ps -el | grep $numberOfString | awk '{print $1}'`
	   winpid=`ps -el | grep $numberOfString | awk '{print $4}'`
	   echo "01_helloworld_01_utility.sh monitoringjob() get PID=$processid"
	   echo "01_helloworld_01_utility.sh monitoringjob() get WINPID=$winpid"
	   
	elif [[ "$1" == "stop2" ]]
	then
	   echo 'input $1==stop2'
	   
	elif [[ "$1" == "stop3" ]]
	then
	   echo 'input $1==stop3'
	   
	else
	   
	fi
	
    echo "END 01_helloworld_01_utility.sh monitoringjob()"
	

}


