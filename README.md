<p align="center"><img src="https://raw.githubusercontent.com/JujuAdams/hotglue/master/LOGO.png" style="display:block; margin:auto; width:300px"></p>

<h1 align="center">Hotglue</h1>

<p align="center">GameMaker LTS 2026 package import and merge tool by <a href="https://www.jujuadams.com/" target="_blank">Juju Adams</a></p>

&nbsp;

## Introduction

Hotglue is a package importer for GameMaker LTS 2026. It is primarily written in GML and the interface uses ImGUI. I wrote Hotglue to make it easier to quickly set up projects and keep their library code updated.

### Features

- Download and import GameMaker packages from remote storage without going through the steps manually. Supports GitHub, gists, itch.io, and Verdaccio (npm).
- Private GitHub user and organisation repos are supported.
- Import loose files directly (from either remote or local sources) as assets. Scripts, sprites, audio, and datafiles are supported.
- Import packages and assets stored locally on your machine.
- Check for updates to packages from the Hotglue tool and then download and import them.
- Custom "favourites" collection for you to have easy access to your preferred packages.

### Limitations

- Hotglue only works on Windows. No macOS or Linux support is planned.
- Hotglue does not resolve dependencies. If a package requires another separate package to operate normally then this tool will not automatically import the dependency for you.
- Occasionally you will run into GitHub rate limiting. This can be worked around by using a GitHub developer application.
- Updating a package will replace all of the configuration macros you have changed. This is inconvenient.
- Downloading packages from itch.io is unreliable.
- The UI is ugly, let's be honest. READMEs and other formatted documents are displayed as raw text which is often hard to read.

&nbsp;

## Setup

1. Download the .zip file for the [latest release](https://github.com/JujuAdams/Hotglue/releases).
2. Extract the .zip file to a **permanent location**. If you move the Hotglue executable then you will need to re-register URIs so it's best to choose a location and leave Hotglue there.
3. Run the executable. You will be taken through the "First-Time Setup".
4. Hotglue can now be used. If you need to adjust any settings, click the "Settings" button in the menu bar.

### Building from source

You may build and run Hotglue from source using GameMaker LTS 2026. This is helpful if you'd like to customise Hotglue or contribute to its development. Building from source is **optional** and if you'd rather then you can skip this section.

1. Create a new GitHub developer [OAuth application](https://github.com/settings/developers). We will use this to increase GitHub's rate limits.
2. Clone the repo using the tool of your choice.
3. Open the project in GameMaker LTS 2026.
4. Open `__HotglueConfig`. Set `HOTGLUE_GITHUB_CLIENT_ID` and `HOTGLUE_GITHUB_CLIENT_SECRET`.
5. Create an executable on disk in a **permanent location**. We can run the tool directly from the IDE in the future but for URI registration we must have a static location for an executable.
6. Run the executable and follow the first time setup process. Be sure to register a URI. Verify that the interface works and that packages can be imported. Close the executable when you're done.
7. Return to the IDE. Re-run the tool from the IDE and verify the interface and URI works as expected.

&nbsp;

## Importing

You may import the following types of file:

- GameMaker packages (.yymps)
- Individual assets from GameMaker projects (.yyp)
- Individual assets from GameMaker compressed projects (.yyz)
- Loose files (.png / .gml / .ogg etc.)
- Archives of the above (.zip / .tar / .tgz / .gz)

Hotglue can only import into a GameMaker LTS 2026 project. Hotglue can import from a wide variety of GameMaker versions using the native GameMaker [ProjectTool](https://manual.gamemaker.io/monthly/en/IDE_Tools/Project_Tool.htm).

The source for imported files may be one of the following:
- Local files on your machine
- GitHub repositories (releases only)
- GitHub gists
- Free and public itch.io pages
- Verdaccio (npm)

Files may be imported from the "Import" tab. This is accessed by clicking the "Import" button in the menu bar for the application. This will reveal a submenu where you can choose between "Channels", "From local project", and "Froom loose files".

**Please note that Hotglue will not back up files for you.** Proceed with caution. Make sure you back up any significant changes you've made (such as library config macros) and **always use source control**.

### Importing from channels

A "channel" is a collection of packages. A channel could be one of the following:
- GitHub user
- GitHub organisation
- Verdaccio (npm) instance
- JSON file hosted on a server that lists repository locations
- Directory on your local machine

Channels are useful for organising packages. GitHub users and organisations that are private may be accessed but this requires authorising GitHub access. This is done during the First-Time Setup. Alternatively, GitHub can be authorised from the Settings tab. **Please note that you may only import assets as a package when downloading from a channel.**

Before importing assets, you must select a release version (or download version for packages hosted on itch.io). You must also select a destination project. Click on the "Import ->" button in the centre of the window to begin the import process. You will be asked to confirm the import job. Be careful to examine the changes that Hotglue will make before confirming the operation.

Once Hotglue has finished importing the package, the package will appear in the "Imported" section of the destination project overview. You may remove this package or update it at a later date by clicking the appropriate buttons.

### Importing from a local project

Hotglue can import individual assets from a local project. This is helpful to quickly share assets without having to go through the package creation process. Any files that you import can be added together as a package or they can be added individually. You may add project assets as well as datafiles.

The project on the left-hand side of the screen, once opened, is the source project. The project on the right-hand side of the screen is the destination project. Any conflicting files (files with the same name that exist in both projects) will be highlighted in red. If a folder has some conflicted files and some non-conflicted files then it will be highlighted in orange. You can mark a file in the source project for import by clicking on their names. You may unmark a file by clicking on their name again. Clicking on a folder will mark/unmark all of its contents recursively.

Once you have marked one or more files for import, click the "Import ->" button in the middle of the window. You may optionally choose to import the files as a package. You will be asked to confirm the import job. Be careful to examine the changes that Hotglue will make before confirming the operation.

### Importing from loose files

Hotglue can import individual files from local storage. You may add project assets as well as datafiles.

Click on the "Add loose file..." button to open a file dialog. Choose the file that you would like to add; this file will then show up on the right-hand side of the screen. Hotglue will guess at the asset type you are looking to add and will also guess an asset name. You should review the asset name and asset type per file. Adjust as appropriate.

Once you have added one or more files for import, click the "Import ->" button in the middle of the window. You may optionally choose to import the files as a package. You will be asked to confirm the import job. Be careful to examine the changes that Hotglue will make before confirming the operation.

&nbsp;

## Channels

A "channel" is a collection of packages. Channels are used to collect together multiple repositories to make tools easier to find.

You may add a channel in the "Settings" tab. You may also remove most channels if you no longer have a need for them. The "GameMaker Kitchen" channel type is a special channel designed to read [GameMaker Kitchen](https://www.gamemakerkitchen.com/) links.

|Channel Type       |Example URL / Path                                                                     |
|-------------------|---------------------------------------------------------------------------------------|
|JSON               |`https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json`|
|Directory          |`D:/Work/Local Packages`                                                               |
|GitHub user        |`https://github.com/jujuadams`                                                         |
|GitHub organisation|`https://github.com/GameMakerDiscord`                                                  |
|Verdaccio (npm)    |`https://gmpm.gamemaker.io/`                                                           |
|GameMaker Kitchen  |`https://www.gamemakerkitchen.com/resource.json`                                       |

You can find an example of the JSON format [here](https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json).

### "Custom" channel

The "Custom" channel can be used for one-off links to repositories or packages in local storage. You may add repositories to the "Custom" channel via the "Explore Channels" tab. Click either button in the left-hand pane to add content.

### "Favourites" channel

The "Favourites" channel can be used to make access to your most-used packages easier. You can make a repository into a favourite by clicking on the "Favourite" checkbox where it is visible.
