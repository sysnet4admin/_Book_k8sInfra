#!/usr/bin/env bash

curl $1/hpa/memory > /dev/null 2>&1 & 
echo "Successfully memory increase 10Mi in few seconds" 
