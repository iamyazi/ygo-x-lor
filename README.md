## What is YGOxLOR?

YGOxLOR is a Yu-Gi-Oh! custom card expansion built into 'Project Ignis - EDOPRO'. With over 150 newly designed and scripted cards with their own format, the expansion features 9 new archtypes inspired directly from Riot Games's Legends of Runeterra (hence the name YGOxLOR)! With a simple one-time setup, you can get access to updates automatically and play against your friends online using YGOxLOR's custom game server.

(Please note that as of 2024, the server is down, and online play is inaccessible via the server. You can still play vs your friends online via a P2P connection with applications such as Hamachi)


## How to set up the game to play with others using the YGO x LOR cards:

### 1. Download Project Ignis: EDOPro either from their Discord at https://discord.gg/ygopro-percy -OR- from either of the download links below (updated as of December 24th, 2022)

Windows: https://github.com/ProjectIgnis/edopro-assets/releases/download/40.0.3/ProjectIgnis-EDOPro-40.0.3-windows-installer.exe  
MacOS: https://github.com/ProjectIgnis/edopro-assets/releases/download/40.0.3/ProjectIgnis-EDOPro-40.0.3-macOS.pkg 

### 2. Add the YGO x LOR cards to your version of EDOPro:  
  a. Navigate to your game files. They are in a folder named ProjectIgnis in the location where you installed the game.
  b. Open the config folder.  
  c. Right-click the configs file, then open with a text editor such as Notepad.  
  d. Add the YGO x LOR cards repo to your version of EDOPro by copying the following and pasting it inside "repos":  

        ,{
            "url": "https://github.com/iamyazi/ygo-x-lor.git",
            "repo_name": "runeterra",
            "repo_path": "./repositories/ygo-x-lor",
            "has_core": true,
            "core_path": "bin",
            "data_path": "",
            "script_path": "script",
            "lflist_path": "lflists",
            "should_update": true,
            "should_read": true
        }
   
### 3. Add the YGO x LOR server to your version of EDOPro by copying the following and pasting it inside "servers": 

        ,{
            "name": "YGO x LOR",
            "address": "18.196.239.198",
            "duelport": 7911,
            "roomaddress": "18.196.239.198",
            "roomlistport": 7922
        }

### 4. Check if everything is set up correctly by launching the game after you've done steps 1, 2, 3:  
  a. Click on Repositories at the top left and check if 'runeterra' says 100%.  
  b. From the Main Menu, click on Decks and select 'Runeterra' from the Ban List drop-down, then select 'Allowed' from the Limit drop-down, then click Search. You should then see the YGO x LOR cards in your client.  
  c. From the Main Menu, click on Servers, then select 'YGO x LOR' from the Server drop-down. If you get no errors, you're good to go!  
   
 
## How to play with others using YGO x LOR cards:

1. Make sure you have a deck that abides by the Runeterra banlist in your client.   
2. Go to Servers and select the 'YGO x LOR' server from the drop-down Server menu.   
3. Host/Join a game!  
