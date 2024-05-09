# proxmox-dashboard

<p align="center">
  <img src="/felixbruns/proxmox-dashboard/raw/branch/main/Screenshot.gif" />
</p>

A very minimal dashboard to display on my Raspberry Pi using [flutter-pi](https://github.com/ardera/flutter-pi).

## Building

Just as any other flutter project build it using
```
flutter build linux
```

Currently, only linux is supported because that's what I am building on and targetting.

Running the app can be done via
```
flutter run
```

## Deploying

To run the app on the raspberrypi boot it into CLI and follow the instructions from [flutter-pi](https://github.com/ardera/flutter-pi).

Copy the build over to the pi and start it using:
```
flutter-pi <path-to-flutter-package>
```
