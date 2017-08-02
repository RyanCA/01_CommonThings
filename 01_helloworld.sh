#!/bin/sh
######################################################################
###### How to call these functions                              ######
###### 0. Set the file excutable                                ######
######    $> chmod 764 HelloWorld.sh                            ######
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

echo "Hello"; # I found this statement is important otherwise it will be failed to execute command $> . HelloWorld.sh because all the other statements are in function

#################################################
###### Display the arguments of the script ######
###### The difference between ', " and `   ######
###### http://stackoverflow.com/questions/6697753/difference-between-single-and-double-quotes-in-bash ######
#################################################
HelloParam(){
echo "Starting HelloParam()";
echo 'File name of current script:$0='$0; # $ won't be interpreated by '
echo "Number of arguments \$#="$#;        # $ will be interpreated by " ( ` and \ also will be interpreated by " ) 
echo "All arguments \$*="$*;
echo "All arguments \$@="$@;
echo "\$1="$1;
echo "Exit status of last command \$?="$?; #Actually it is the return value of last command
echo "Process number of current shell \$\$="$$;
echo "Process number of last background command \$!="$!;

echo "Ending HelloPara()";
}


#####################################################################################################
###### scripts to work with stdin such as pipe |                                               ######
###### (pipe is used to convert standard output as standar input for next command)             ######
###### There are two types of input 1. Standard input 2. Input as arguement                    ######
###### How to execute this script eg:1. $> chmod +777 HelloWorld.sh 2. $> ps | . HelloWorld.sh ###### 
#####################################################################################################

# IFS='' (or IFS=) prevents leading/trailing whitespace from being trimmed.
# -r prevents backslash escapes from being interpreted.
# || [[ -n $line ]] prevents the last line from being ignored if it doesn't end with a \n (since read returns a non-zero exit code when it encounters EOF).

HelloPipe(){
printf "Starting HelloPipe() \n";
while IFS='' read -r line; do
    echo "Text read from file: $line"
done

printf "Ending HelloPipe() \n";
}


#################################################
###### Display the input and check return  ######
###### $>HelloString abc efg               ######
###### $>echo $?   #To get the return of 10######
#################################################
HelloString(){
   echo "Hello, you are in HelloString() Function, $1, $2";
   return 10;
}
  
#################################################
###### Meaning of  #!/bin/sh               ######
#################################################
#A script may specify #!/bin/bash on the first line, meaning that the script should always be run with bash, rather than another shell.   
   
#################################################
###### Difference between source, . and sh ######
#################################################
#http://stackoverflow.com/questions/13786499/what-is-the-difference-between-sh-and-source  


###############################################################################
######   If you define a func with same name already in unix             ######
######   the func will be override with the new implementation           ######
######   DONE                                                            ######
###############################################################################
tac(){
    # ps -ef | tac  # you can see the original output
	# after apply this implementation, the command tac just changed it behavior 
    echo "Hello Tac"
}


###############################################################################
######   How to response with signal when script is running              ######
######   Not working yet                                                 ######
###############################################################################
helloSignal(){

	#https://www.tutorialspoint.com/unix/unix-signals-traps.htm
	#trap is waitting for receiving signals; exit command must be there 
	#signal 2 is CTRL+C; signal 3 is CTRL+D
	trap "echo pid $$, shell name $0 is receiving signal" 2 #; exit
	
	local temp=0

	while [[ temp -eq 0 ]]
	do
	   echo "Sleeping ... "
	   sleep 1s #sleep for 1 second
	done
}

###############################################################################
######   How to return string and retrieve it from calling script        ######
######   DONE                                                            ######
###############################################################################

#Understanding the concetps of command substitutiona and variable substition
#https://www.tutorialspoint.com/unix/unix-shell-substitutions.htm

#Understanding the concept of process substitution, it is very similar to pipe ??? Need more reasearch on this
#http://tldp.org/LDP/abs/html/process-sub.html
##Good to learn ???
#There's a mistake, you need <<(command) not <<<$(command)
#<<() is a Process Substitution, $() is a command substitution and <<< is a here-string.

#So substitution always deal with output stuff
helloString(){
   echo "String line 1: abc"
   echo "String line 2: def"
}

#How to get the func return. 
#Be aware that if you put below block ahead of the func difinition such as,  
#at the begining of the script, shell won't know the command helloString. 
#here is the error message for reference:
#bash: helloString: command not found...
returnString=""
returnString=`helloString`
echo 'returnString='$returnString 
   
#######Try the one how to take input for a command   ??? #######
