#!/usr/bin/env bash

COUNTER = 0
while true
do
  COUNTER=$((COUNTER + 1))
  echo -ne "$COUNTER - " ; curl $1 
done
