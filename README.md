# tools

These are the tools I have used most frequently to work with the game client.

## l2encdec

The most important tool. This lets us decrypt and re-encrypt the exteel files.

Make sure to always use the -t flag and when encoding, -e 414. All of the client files have been decoded and
re-encoded with the default l2encdec RSA key. The binary has also been patched to use this key.

## scripts

- SERVER-extract-maps-poo.bat: This script will extract all map and configuration files from the client that are needed to run the server. Execute it from the command line or drag the game install directory onto it. The target for this script MUST be the root directory of the game that contains the folders "Maps" and "Mutmap"