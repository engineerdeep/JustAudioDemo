# just_audio_demo

A demo to reproduce a bug when loading the player with a file from Files app on iOS after a delay.

# Setup
- Install pubspec dependencies.
- Run on iOS device/simulator with Apple account logged in.

# Steps to reproduce
- Click on *Add mp3 file* button, select an mp3 file.
- Click play button on the audio player and audio successfully plays.
- Now uncomment the 60 seconds delay in main.dart.
- Flutter Hot restart the app
- Click on *Add mp3 file* button, select an mp3 file.
- Wait for 60 seconds, and it throws a PlayerException.
