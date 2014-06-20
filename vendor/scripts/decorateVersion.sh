#!/bin/sh

gradleFilePath="$1"

if [ -z "$gradleFilePath" ]; then
  echo "Missing $1 parameter for gradleFilePath"
  exit 1
fi

versionRepo='https://github.com/Zenedith/gradle-versions-plugin/raw/mvnrepo'
versionClassPath='com.github.zenedith:gradle-versions-plugin:0.5-beta-2'
isVersionAvailable=`grep "gradle-versions-plugin" "$gradleFilePath"`

if [ ! -z "$isVersionAvailable" ]; then
  echo "already have version, done!"
  exit 0
fi

isBuildscript=`grep "buildscript" $gradleFilePath`

gradleContent=`cat<<EOT

buildscript {
  repositories {
    maven { url '$versionRepo' }
    maven { url 'http://repo.maven.apache.org/maven2' }
  }
  dependencies {
    classpath '$versionClassPath'
  }

EOT`

if [ -z "$isBuildscript" ]; then
  echo "$gradleContent\n}\n$(cat $gradleFilePath)" > $gradleFilePath
  echo "\napply plugin: 'versions'" >> $gradleFilePath
else
#  sed s/"$isBuildscript"// $gradleFilePath
  cat $gradleFilePath | sed -e "s/$isBuildscript//" > tmp
  mv tmp $gradleFilePath
  echo "$gradleContent\n$(cat $gradleFilePath)" > $gradleFilePath
  echo "\napply plugin: 'versions'" >> $gradleFilePath

fi