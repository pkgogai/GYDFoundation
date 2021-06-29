#!/bin/bash

dirPath=$(dirname $0)
cd $dirPath

sudo rm -rf /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/File\ Templates/Source/GYDObject.xctemplate/*
sudo mkdir -p /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/File\ Templates/Source/GYDObject.xctemplate

sudo cp -R GYDObject.xctemplate/ /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/File\ Templates/Source/GYDObject.xctemplate/

