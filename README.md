<h1 align="center">Hotglue</h1>

<p align="center">GameMaker LTS 2026 package import and merge tool by <a href="https://www.jujuadams.com/" target="_blank">Juju Adams</a></p>

&nbsp;

## Introduction

Hotglue is a package importer for LTS 2026 than I wrote to make it easier to quickly set up projects and keep their library cose updated. It makes working on multiple projects a smoother experience by removing friction from maintaining the codebase.

### Features

- Download and import GameMaker packages from remote storage without going through the steps manually. Supports GitHub, gists, itch.io, and NPM (Verdaccio).
- Import loose files directly (from either remote or local sources) as assets. Scripts, sprites, audio, and datafiles are supported.
- Import packages and assets stored locally on your machine.
- Check for updates to packages from the Hotglue tool and then download and import them automatically.
- Custom "favourites" collection for you to have easy access to your preferred packages.

### Limitations

- Please use source control.
- Hotglue only works on Windows. No macOS or Linux support is planned.
- Does not resolve dependencies. If a package requires another separate package to operate normally then this tool will not automatically import the dependency for you.
- Occasionally runs into GitHub rate limiting. This can be worked around by using a GitHub developer application.
- Updating a package will replace all of the configuration macros you have changed. This is inconvenient but, to be fair, is no worse than doing the upgrade manually.
- Downloading packages from itch.io is unreliable.
- The UI is ugly, let's be honest. READMEs and other formatted documents are displayed as raw text which is often hard to read.

&nbsp;

## Building from source

You may build and run Hotglue from source using GameMaker LTS 2026. This is helpful if you'd like to customise Hotglue or contribute to its development. Building from source is **optional** and if you'd rather then you can skip this section and proceed to "Setup".

1. Create a new GitHub developer application. We will use this later to reduce GitHub rate limits.
2. Clone the repo using the tool of your choice.
3. Open the project in GameMaker LTS 2026.
4. Open `__HotglueConfig`. Set `HOTGLUE_GITHUB_CLIENT_ID` and `HOTGLUE_GITHUB_CLIENT_SECRET`.
5. Create an executable on disk in a **permanent location**. We can run the tool directly from the IDE in the future but for URI registration we must have a static location for an executable.
6. Run the executable and follow the first time setup process. Be sure to register a URI. Verify that the interface works and that packages can be imported. Close the executable when you're done.
7. Return to the IDE. Re-run the tool from the IDE and verify the interface and URI works as expected.

&nbsp;

## Setup

1. Download the .zip file for the [latest release](https://github.com/JujuAdams/Hotglue/releases).
2. Extract the .zip file to a **permanent location**. If you move the Hotglue executable then you will need to re-register URIs so it's best to choose a location and leave Hotglue there.
3. Run the executable. You will be taken through the "First-Time Setup".
4. Hotglue can now be used. If you need to adjust any settings, click the "Settings" button in the menu bar.
