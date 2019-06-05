#!/bin/sh
#Daniel McGuinness 2019

ME="Daniel J McGuinness" #Set this to the file attributor
FFLAG=0
DIRFLAG=0

display_help(){
  echo "NAME"
  echo "  cinit - Initializes a C repository with default files."
  echo ""
  echo "SYNOPSIS"
  echo "  cinit [OPTIONS]... DIRECTORY"
  echo ""
  echo "DESCRIPTION"
  echo "  Creates DIR.c DIR.h and DIR_test.c files along with a Makefile."
  echo ""
  echo "  -f        -- overwrites directory if it already exists."
  echo "  -u STRING -- overwrites default user copyright stamp with STRING."
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
    rm -rf "${PWD:?}"/"$1"
  fi
fi


if [ "$DIRFLAG" -eq 1 ]; then
  echo "Directory already exists"
else
  mkdir "$PWD"/"$1"
  printf "/* %s $(date +%Y) */\n\n#include \"%s.h\"" "$ME" "$1" >> "$PWD"/"$1"/"$1".c
  printf "/* %s $(date +%Y) */" "$ME" >> "$PWD"/"$1"/"$1".h
  printf "/* %s $(date +%Y) */\n\n#include \"%s.h\"\n\nint main(){\n\treturn 0;\n}" "$ME" "$1" >> "$PWD"/"$1"/"$1"_test.c
  printf "all:\n\tgcc %s_test.c %s.c\n\nclean:\n\trm -f ./a.out" "$1" "$1"  >> "$PWD"/"$1"/Makefile
fi
