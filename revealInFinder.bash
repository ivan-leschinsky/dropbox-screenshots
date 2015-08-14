#!/bin/bash
#
# revealInFinder.bash
#
# 05.26.2006
#
# caesurae@gmail.com
#
# tested on Mac OS X 10.3.9 build 7W98 - Darwin 7.9.0 - AppleScript 1.9.3
#
# reveal the given file(s) and/or folder(s) in a Finder window
#
# usage: revealInFinder.bash ~/dir/file "/dir/dir/my file" file
#


# if no arguments are given, echo the usage string
if [ $# -lt 1 ]; then
  echo 'Usage: '"$0"' ~/dir/file "/dir/dir/my file" file' >&2 
  exit 1
fi

# define $n, gets +1 for each argument given
# not sure if $n is needed, how to get index number of $1, $2, etc.?
n=0

# define $act, gets +1 for each argument that passes test
act=0

# step thru each argument one at a time
for thearg in "$@"; do

  n=$(( n + 1 )) 

  # if $thearg exists then
  if [ -e "$thearg" ]; then

    # if $thearg exists in the current working directory (i.e. no path given)
    if [ -e "${PWD}/$thearg" ]; then

      # set thearg to dirname & basename of $thearg
      thearg="${PWD}/$thearg"		
    fi

    # create a applescript statement using $thearg for osascript to execute
    osatext='tell application "Finder" to reveal POSIX file "'"$thearg"'"'
    /usr/bin/osascript -e "$osatext"

    # $act activates Finder after processing the remaining arguments
    act=$(( act + 1 )) 
    
  # else if $thearg does not exist then
  else

    # if $thearg is not the last argument given then
    if [ $n -lt $# ]; then

      # ask to continue processing the remaining arguments
      echo -n '"'"$thearg"'" does not exist and will be ignored. continue?  (y/n)? ' >&2
      read ans
      case $ans in
        "n" ) exit 1 ;;
        "y" ) continue ;;
      esac

    # else if $thearg is the last arguement then
    else

      # print the "does not exist" string and exit
      echo '"'"$thearg"'" does not exist.' >&2

      # exit status 1 indicates an error occurred
      exit 1
    fi
  fi
done

# if $act is greater than 0 then activate the finder
if [ $act -gt 0 ]; then
  /usr/bin/osascript -e 'tell application "Finder" to activate'		
fi

# exit status 0 indicates all is ok
exit 0
