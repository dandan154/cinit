#!/bin/sh

ME="Daniel J McGuinness" #Set this to the file attributor
FFLAG=0
DIRFLAG=0

display_help(){
  echo "NAME"
  echo "\tcinit - Initializes a C repository with default files."
  echo ""
  echo "SYNOPSIS"
  echo "\tcinit [OPTIONS]... DIRECTORY"
  echo ""
  echo "DESCRIPTION"
  echo "\tCreates DIR.c DIR.h and DIR_test.c files along with a Makefile."
  echo ""
  echo "\t-f        -- overwrites directory if it already exists."
  echo "\t-u STRING -- overwrites default user copyright stamp with STRING."
}

#Process command line options
while getopts fu: o
do
  case "$o" in
    f)  FFLAG=1;;
    u)  ME=${OPTARG};;
    [?])  display_help
          exit 0;;
  esac
done
shift $((OPTIND-1))

#Check if directory argument exists
if [ -z "$1" ]; then
  display_help
  exit 0
fi

#Check if directory exists
if [ -d "$1" ]; then
  if [ "$FFLAG" -eq 0 ]; then
    DIRFLAG=1
  else
    rm -rf $PWD/$1
  fi
fi


if [ "$DIRFLAG" -eq 1 ]; then
  echo "Directory already exists"
else
  mkdir $PWD/$1
  echo "/* $ME `date +%Y` */\n\n#include \"$1.h\"" >> $PWD/$1/$1.c
  echo "/* $ME `date +%Y` */" >> $PWD/$1/$1.h
  echo "/* $ME `date +%Y` */\n\n#include \"$1.h\"\n\nint main(){\n\treturn 0;\n}" >> $PWD/$1/$1_test.c
  echo "all:\n\tgcc $1_test.c $1.c\n\nclean:\n\trm -f ./a.out">> $PWD/$1/Makefile
fi
