#!/usr/bin/env bash
yum -y install java-1.8.0-openjdk-devel
./mvnw clean package
docker build -t optimal-img .