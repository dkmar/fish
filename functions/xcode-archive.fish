function xcode-archive
   xcodebuild -scheme $argv -configuration Release -archivePath /tmp/$argv.xcarchive archive
end
