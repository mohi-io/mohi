#!/bin/sh

gradleFilePath="$1"

if [ -z "$gradleFilePath" ]; then
  echo "Missing $1 parameter for gradleFilePath"
  exit 1
fi

function replace() {
  sed s/"$1"/"$2"/ $gradleFilePath > tmpfile ; mv tmpfile $gradleFilePath
}

replace "providedRuntime" "runtime"
replace "providedCompile" "compile"
sed "s/description = '\(.*\)\'/description = \"\1\"/" $gradleFilePath > tmpfile ; mv tmpfile $gradleFilePath