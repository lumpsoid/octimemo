{
  description = "flutter development";

  inputs = {
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.devshell.follows = "devshell";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    android-nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
      };
      # Everything to make Flutter happy
      sdk = android-nixpkgs.sdk.${system} (sdkPkgs:
        with sdkPkgs; [
          cmdline-tools-latest
          build-tools-30-0-3
          build-tools-33-0-1
          build-tools-34-0-0
          platform-tools
          emulator
          #patcher-v4
          platforms-android-28
          platforms-android-34
          platforms-android-35
          system-images-android-34-google-apis-playstore-x86-64
        ]);
      pinnedJDK = pkgs.jdk17;
      pinnedFlutter = pkgs.flutter;
    in {
      # don't need to write the <system> part
      # because we inherited system in pkgs
      devShells = {
        default = pkgs.mkShell {
          name = "octimemo-flutter-devshell";

          buildInputs = [
            # Android
            pinnedJDK
            sdk

            # Flutter
            pinnedFlutter

            # Code hygiene
            pkgs.gitlint

            # firebase integration
            pkgs.firebase-tools

            # ci/cd
            pkgs.bundler  # for fastlane
          ];

          # android specific envs
          ANDROID_HOME = "${sdk}/share/android-sdk";
          ANDROID_SDK_ROOT = "${sdk}/share/android-sdk";
          ANDROID_AVD_HOME = "/home/qq/.config/.android/avd";
          JAVA_HOME = pinnedJDK;

          GRADLE_USER_HOME = "/home/qq/.gradle";


          shellHook = ''
            export PATH="$PATH":"$HOME/.pub-cache/bin"

            # Define your tasks as shell functions
            function run-app {
              local flavor="$1"

              echo "Starting $flavor..."
              flutter run --flavor "$flavor" --target ./lib/main_"$flavor".dart --debug
            }

            # Create a help command to list available tasks
            function dev-help {
              echo "Available development commands:"
              echo "  run-app        - Start the app with flavor"
              echo "  dev-help       - Show this help message"
            }

            # Print the help message when entering the shell
            echo "Development environment loaded. Type 'dev-help' to see available commands."
          '';
        };
      };
    });
}
