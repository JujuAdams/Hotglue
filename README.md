<h1 align="center">Hotglue</h1>

<p align="center">GameMaker LTS 2026 package import and merge tool by <a href="https://www.jujuadams.com/" target="_blank">Juju Adams</a></p>

## Features

- Download and import GameMaker packages from remote storage without going through the steps manually. Supports GitHub, gists, itch.io, and NPM (Verdaccio).
- Import loose files directly (from either remote or local sources) as assets. Scripts, sprites, audio, and datafiles are supported.
- Import packages and assets stored locally on your machine.
- Check for updates to packages from the Hotglue tool and then download and import them automatically.

## Limitations

- Does not resolve dependencies. If a package requires another separate package to operate normally then this tool will not automatically import the dependency for you.
- Suffers from GitHub rate limiting. This can be worked around by using a GitHub developer application but this can only go so far.
- Updating a package will replace all of the configuration macros you have changed. This is inconvenient but, to be fair, is no worse than doing the upgrade manually.
- Downloading packages from itch.io is unreliable.
- The UI is ugly, let's be honest. READMEs and other formatted documents are displayed as raw text which is often hard to read.
