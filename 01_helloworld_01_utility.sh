#!/bin/sh
######################################################################
###### How to call these functions                              ######
###### 0. Set the file excutable                                ######
######    $> chmod 764 01_helloworld_01_utility.sh              ######
######    $> . HelloWorld.sh                                    ######
###### 1. Set your script file under PATH by editing .bash_profile at home folder ######
######    vi /home/bpmadm/.bash_profile                         ######
######    PATH=$PATH:/home/bpmadm/Ryan; export PATH             ######
###### 2. Exec the .bash_profile to make change effective       ######
######    $>. ~/.bash_profile                                   ######
###### 3. Verify if PATH variable has new values                ######
######    $> echo $PATH                                         ###### 
###### 4. Run these function of the script                      ######
######    $> HelloParam                                         ######
######    $> ps | HelloPipe                                     ######
######    $> HelloString ABC EFG                                ######
######    $> echo $? #To See the return value of last command   ######
######################################################################

echo "Hello, this is 01_helloworld_01_process_by_port.sh."; # I found this statement is important otherwise it will be failed to execute command $> . HelloWorld.sh because all the other statements are in function

#################################################
###### Display the arguments of the script ######
###### The difference between ', " and `   ######
###### http://stackoverflow.com/questions/6697753/difference-between-single-and-double-quotes-in-bash ######
#################################################
helloparam2(){
echo "Begin 01_helloworld_01_utility.sh helloparam2()";
echo 'File name of current script:$0='$0; # $ won't be interpreated by '
echo "Number of arguments \$#="$#;        # $ will be interpreated by " ( ` and \ also will be interpreated by " ) 
echo "All arguments \$*="$*;
echo "All arguments \$@="$@;
echo "\$1="$1;
echo "Exit status of last command \$?="$?; #Actually it is the return value of last command
echo "Process number of current shell \$\$="$$;
echo "Process number of last background command \$!="$!;

echo "End 01_helloworld_01_utility.sh helloparam2()";
}

getprocessbyport(){

   echo "Begin 01_helloworld_01_utility.sh getprocessbyport() input $1, $2";
   #The output of this line will be like 4565/tibamx_BPMNode 
   netstat -nlp | head -n 2; netstat -nlp | tail -n +3 | grep $1 | awk '{print $7}' | tail -n 1 | readpipe;

   #echo "record="$record; 
    echo "End 01_helloworld_01_utility.sh getprocessbyport()";

}

readpipe(){
   while IFS='' read -r line; do
      echo "Read from pipe: $line"
	  #The output of this line will be like 4565/tibamx_BPMNode, get number from the string
	  numberOfString=${line//[^0-9]}
	  echo "Read from pipe: $numberOfString"
	  ps -el | head -n 1;
      ps -el | grep $numberOfString;
   done
}
