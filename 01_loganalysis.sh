#!/bin/sh
#Global variable
pattern=""

###############################################################################
###              This script doesn't work in Cygwin                         ###
###                                                                         ###
###              Solution 1 DOES NOT work                                   ###
### You may encounter  end of line issues when you try to execute this file ###
### The reason is the file is edited under window platform                  ###
### You need to change end of line from CRLF in winows to LF in Linux       ###
### Use NodePad++ Replace function, check on Extended and                   ###
### Input \r\n in "Find what" field and input \n in "Replace with" field    ###
###                                                                         ###
###              Solution 2 works                                           ###
### You need to download dos2unix-7.3.4-win32 from internet, run command    ###
###                                                                         ###                                                                  
### C:\_DevEnvironments\dos2unix-7.3.4-win32\bin>dos2unix.exe C:\_RyanYuLiu\01_Envir ###
### onemnt_SoftwarePacks\01.sh                                              ###
### dos2unix: converting file C:/_RyanYuLiu/01_Environemnt_SoftwarePacks/01.sh to Un ###
### ix format...                                                            ###
###                                                                         ###
### Use CMD command window to execute above command                         ###
### NOTE:Remeber you must copy the whole converted file into Cygwin folder, ###
###      DO NOT copy the content of converted file into a file in Cygwin.   ###
###      It just doesn't work. I guess reason is when you copy it to Cygwin ###
###      under windows platform, it may change the Unix return in converted ###
###      file back to windows return                                        ###
###############################################################################


#$1 fileName (it could be file name with abosolute path or relative path
#$2 pattern for searching
#Sample command 1: logMatch /home/bpmadm/TIBCO_HOME/tibco/data/tibcohost/Admin-AMX-BPM-AMX-BPM-Server/data_3.2.x/nodes/BPMNode/logs/BPM.log '######'
#Sample command 2: logMatch BPM.log '######'
#Sample command 3: logMatch ./BPM.log '######'
logMatch() {

	#echo 'Debug logMatch() $*='$*;
	#echo 'Debug logMatch() $1='$1;
	#echo 'Debug logMatch() $2='$2;

	if [ -z $1 ]; then # -z means the length of $1
	echo 'Error: First parameter can not be null. It should be the log file path.'
	return
	fi

	if [ -z $2 ]; then
	echo 'Error: Second parameter can not be null. It should be the pattern looking for.'
	return
	fi

	if [ ! -f $1 ]; then # -f means $1 if file or not
	echo 'Error: First parameter is not an existing file. It should be the log file path.'
	return
	fi

	#Concanate string and ensure they are enclosed by ""
    #pattern="\"$2\"";
	pattern=$2;
	#echo 'DEBUG logMatch() pattern='$pattern

	#find /home/bpmadm/TIBCO_HOME/tibco/data/tibcohost/Admin-AMX-BPM-AMX-BPM-Server/data_3.2.x/nodes/BPMNode/logs/ -name "BPM.log.*"
	#find $folderPath -name "$fileName" | sort -k 1 | readPipe $2



	local pathName=`dirname $1`  #This can be abosolute path or relative path depending on the input of logMatch()() command
	local fileName=`basename $1` #filename

	#echo 'DEBUG logMatch() pathName='$pathName
	#echo 'DEBUG logMatch() fileName='$fileName
	
	#find all files. Eg BPM.log.1; BPM.log.2...
	#sort by 1st column
	
	find $pathName -name "$fileName*" | sort -k 1 | readLines




}


readLines(){

	while IFS='' read -r line; do
		#echo 'DEBUG readLines() line='$line
		#echo 'DEBUG readLines() pattern='$pattern	
		grep "$pattern" $line | cut -c 1-24 | processResults $line 
		
	done

}

#$1 is the filename from calling script
processResults(){

	#echo "DEBUG processResults() \$l"$1
	
	local firstItem="";
	local lastItem="";
	local round=0;
	local fileName=`basename $1`

	while IFS='' read -r line; do
		#echo "DEBUG processResults() reading line: $line"

		if [[ $round -eq 0 ]]  # Trick: better use the shell keywod [[ instead of test [ command to avoid many pitfalls
			then 
				firstItem=$line
				lastItem=$line
			else
				lastItem=$line

		fi
		
		let "round = $round + 1"

	done


	#That means there is not content found in given log file and by searching given pattern
    if [[ $round -ne 0 ]]
	   then
	      echo '### File Name   |   Pattern    |   Occurrences   |   Timestamp 1st   |   Timestamp last ###'
	      #$(command) display the echo value
		  echo "$fileName   |   $pattern   |   $round   |   $firstItem   |   $lastItem   "
		  echo " "
	fi
	

}


########################## Below is for myself only #########################
logMtch() {

	#echo 'Debug logMatch() $*='$*;
	#echo 'Debug logMatch() $1='$1;
	#echo 'Debug logMatch() $2='$2;

	if [ -z $1 ]; then # -z means the length of $1
	echo 'Error: First parameter can not be null. It should be the log file path.'
	return
	fi

	if [ -z $2 ]; then
	echo 'Error: Second parameter can not be null. It should be the pattern looking for.'
	return
	fi

	if [ ! -f $1 ]; then # -f means $1 if file or not
	echo 'Error: First parameter is not an existing file. It should be the log file path.'
	return
	fi

	#Concanate string and ensure they are enclosed by ""
    #pattern="\"$2\"";
	pattern=$2;
	#echo 'DEBUG logMatch() pattern='$pattern




	local pathName=`dirname $1`  #This can be abosolute path or relative path depending on the input of logMatch()() command
	local fileName=`basename $1` #filename

	#echo 'DEBUG logMatch() pathName='$pathName
	#echo 'DEBUG logMatch() fileName='$fileName
	
	#find all files. Eg BPM.log.1; BPM.log.2...
	#sort by 1st column
	
	grep "$pattern" $1


}


