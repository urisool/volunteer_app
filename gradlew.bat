@echo off

:: Gradle wrapper script

java -Dorg.gradle.app.name=gradle-wrapper -Dfile.encoding=UTF-8 -classpath "%~dp0gradle/wrapper/gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain %*