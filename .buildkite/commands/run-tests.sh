#!/bin/bash -eu

SIMULATOR_NAME=$1

xcodebuild clean test \
  -project 'ScreenObject.xcodeproj' \
  -scheme 'ScreenObject' \
  -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=14.5"
