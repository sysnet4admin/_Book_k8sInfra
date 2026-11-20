#!/usr/bin/env bash
apt-get install openjdk-21-jdk -y
./mvnw clean package 
docker build -t optimal-img .
