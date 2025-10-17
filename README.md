<img width="332" height="323" alt="SEGS Launcher" src="https://github.com/user-attachments/assets/f781b513-5f0b-48d1-a73b-1ba562b09f80" />

# SEGS Launcher and Custom Client

*NOTE* : Currently, this is just the Launcher. The client development will begin soon after a stable working engine is available. 


## SEGS Launcher

### Build Instructions
- Clone repro into folder: 
```git clone https://github.com/Segs/Segs-Client.git```

- Create build folder and __cd__ into that folder
- Create the make files and run

```
$> cmake ..
$> make
```

The finished application should be now in your __out__/ folder that was created inside your build folder. 
Running the application will generate the SEGSLauncher.conf file. Location of the config file will vary depending on your OS Platform. The format of the file is a .ini format. Best practice is for all changes to config to be managed from within Launcher. In the event you do need access to the config file their locations are below.

- Linux: /home/{username}/.config/SEGS/SEGSLauncher.conf
- Windows: Saved in Windows Registry at HKEY_CURRENT_USER\Software\Cryptic\SEGS 
- Mac: /Users/{username}/Library/Preferences/io.segs.SEGSLauncher.plist

## SEGS Client
Client development will begin soon after a stable working engine is available.

