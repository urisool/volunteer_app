#!/bin/sh

# Gradle wrapper script

exec java -Dorg.gradle.app.name=gradle-wrapper -Dfile.encoding=UTF-8 -classpath "$(dirname "$0")/gradle/wrapper/gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain "$@"