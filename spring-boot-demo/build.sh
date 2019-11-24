#!/bin/sh
mvn clean install
docker build -t sudheej/sping-test .