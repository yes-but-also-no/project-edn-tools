# tools

These are the tools I have used most frequently to work with the game client.

### project state

This code is provided as-is, with no warranty. It is not being actively maintained. If you have any questions, please
reach out to me and I will do my best to answer them if I have time.

If you are interested in maintaining this project, please let me know.

## l2encdec

The most important tool. This lets us decrypt and re-encrypt the exteel files.

The two protocol versions used are 111 for unreal files and 414 for configuration files. When encoding or decoding 414, the -t flag must be used.

## dd

A windows version of dd, used by the CLIENT-remove-game-guard.bat file to patch it

## iidking

A tool for patching the import tables of exe's and dll's. This is uses to include the edn_gf.dll patch without needing to inject it every time.

# scripts

## patching process

__NOTE:__ This patching process is based on version __2.2.4.26301__ of the game. If you are trying to patch a different version, you will need to skip the script from step 2 and manually patch the encryption keys and game guard location, as well as finding the offsets for the patcher and rebuilding edn_gf.dll prior to step 4

__NOTE:__ When the term *game install folder* is used, it refers to the root folder of the game, that contains the folders "System", "Mutmap", etc.

1. __BACKUP__ your game install. For the most part the scripts are non destructive and back a lot up, but you should always be safe

2. Run *CLIENT-remove-game-guard.bat* on the Exteel.exe binary. It is located in \System. Press yes to allow patcher.exe to access it, and yes again until the script completes

3. Run *CLIENT-decrypt-all-files.bat* on the game install folder. This will decrypt all of the files and save them into the same folder as the script, under a folder called *GameDecrypted*

- This is where you can make modifications to the game files. If you are going to be running locally, head into \System\localization.ini and change the key *Region_US* server address's and ports to match your server config.

4. Grab the patch dll (edn_gf.dll) from iidking and copy it into \System in the game install folder. Then run iidking.exe, press "Pick a File", and select __GF.dll__. Next press the "Pick DLL(s)" button and choose __edn_gf.dll__. Select the entry in the popup window and press "Add Them!". Finally, press "Add Them!" on the main window.

5. Run *CLIENT-encrypt-all-files.bat* on the __game install folder__. Not the GameDecrypted folder!. This will create a new folder called *GameEncrypted*, copy all of your __decrypted__ files into it, re-hash the binary and GF.dll files from the game install folder, and finally re-encrypt everything.

6. Copy all of the files from *GameEncrypted* back into your game install folder, selecting yes to replace files.

7. Test! If all went well, running Exteel.exe should launch without GameGuard and connect directly to your server

## server file extraction

If you are only interested in running a server, this process is much simpler. Just drag the __game install folder__ onto the *SERVER-extract-maps-poo.bat* script and it will generate a *Config* folder with all of the decrypted poo files and maps, ready to be placed into the server.


## individual scripts

- SERVER-extract-maps-poo.bat: This script will extract all map and configuration files from the client that are needed to run the server. Execute it from the command line or drag the game install directory onto it. The target for this script MUST be the root directory of the game that contains the folders "Maps" and "Mutmap"

- CLIENT-remove-game-guard.bat: This script will perform two patches on the game binary. The first will use an existing tool to change the file encryption key, since once we re-sign the files, we cannot use the original key. The second will patch out the instruction that loads gameguard.

- CLIENT-decrypt-all-files.bat: This script will decrypt all files from the game client and save them as copies in a new directory. This works on both the original, unmodified game, as well as a re-encrypted client

- CLIENT-encrypt-all-files.bat: This script will re-encrypt a set of decrypted files using the default l2encdec key. It will also re-hash GF.dll and Exteel.exe and update their hashes in the version.ini file.

## legal
Every effort has been made to comply with all laws and regulations. This project is an original creation, 
distributed free of charge. 

It contains no copyrighted files or code. It does not function without the game files, which are NOT included. 
In order for it to function, the user must legally acquire these files.

Donations are not accepted. 

The sole intent of this project is to provide players a chance to enjoy a long dead game from their childhood. 

If there are any legal concerns, please reach out to me on github and I will be happy to comply in any way required.