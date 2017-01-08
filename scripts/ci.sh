#!/usr/bin/env bash

xcodebuild -scheme "HandyJSON iOS Tests" -sdk "iphonesimulator10.2" -destination "OS=10.2,name=iPhone 7" -configuration Debug ONLY_ACTIVE_ARCH=NO test | xcpretty -c;

xcodebuild -scheme "HandyJSON macOS" test

xcodebuild -scheme "HandyJSON tvOS" -destination "platform=tvOS Simulator,name=Apple TV 1080p" test
