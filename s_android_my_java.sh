#! /bin/bash
echo "Force Java"
echo "-----------------------------------------------------------------------------------------------"
echo;echo
export ANDROID_JAVA_TOOLCHAIN="/usr/local/java/java_current/bin"
export ANDROID_PRE_BUILD_PATHS="/usr/local/java/java_current/bin"
export | grep ANDROID | grep java
