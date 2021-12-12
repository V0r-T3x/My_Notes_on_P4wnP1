#!/bin/bash


echo ${1}
if [[ ${1} =~ ^[+-]?[0-9]+$ ]]
then
   echo "this is an integer"
   exit 1
fi

echo "this is not an integer"
