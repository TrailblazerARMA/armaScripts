////////////////////////////////
//Cool Intel Script v1
//Author: Trailblazer
//Date: Dec2017
////////////////////////////////
//Free to use and share aslong as you leave the credits as they are. Please, do NOT claim to be the author.

//HOW TO USE:

//name your folder "folder1" or whatever you like but make sure you replace the name in the following code
//place the code below inside "folder1" init - editor ( but make sure you uncomment it first)

// folderID = [folder1,"open folder",  
// "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",  
// "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",  
// "_this distance _target < 3 && canOpen",  
// "_caller distance _target < 3",  
// {canOpen = true; publicVariable "canOpen"},  
// {},  
// {[(_this select 0)] execVM "intel.sqf";},   
// {},  
// [],  
// 1,  
// 0,  
// false,  
// false  
// ] remoteExec ["BIS_fnc_holdActionAdd", 0, folder1]; 

//Do NOT copy into init below this line
//EDIT THE SETTING BELOW TO YOUR LIKING
_mPic1 = "terminal.jpg";//set picture 1
_p1Txt = "This is my text example";//set picture 1 text
_mPic2 = "terminal.jpg";//set picture 2
_p2Txt = "This is my text example";// set picture 2 text
_intelTitle = "Top Secret Docs";// set intel diary title
_intelDescrip = "These Docs outline the enemies defenses";//set intel diary description
_pic1Offset = [0.3,0,0];//set picture 1 offset from the folder in the case it will appear 30cm to its right
_pic2Offset = [-0.3,0,0];//set picture 2 offset from the folder in the case it will appear 30cm to its left
_p1Dir = 90;//Set to 0 for landscape picture - picture 1
_p2Dir = 90;//Set to 0 for landscape picture - picture 2
_hLong = 5;//How long (in seconds) does it take for the "Take Intel" to appear; give it time so players "have to" read it first
//DO NOT EDIT BELOW THIS LINE
canOpen = false;//"open folder" action will no longer be visible
publicVariable "canOpen";
_folder = _this select 0;//grab the folder object
_intel1 = createVehicle ["Leaflet_05_New_F", (position _folder), [], 0, "NONE"];// creates picture 1
_intel2 = createVehicle ["Leaflet_05_New_F", (position _folder), [], 0, "NONE"];// creates picture 2
_intel1 attachTo [_folder, _pic1Offset];//attaches picture 1 close to the folder
_intel1 setDir _p1Dir;
_intel2 attachTo [_folder, _pic2Offset];//attaches picture 2 close to the folder
_intel2 setDir _p2Dir;
_actionID1 = [_intel1, _mPic1, _p1Txt] call bis_fnc_initInspectable;//turns picture 1 into an inspectable object
_actionID2 = [_intel2, _mPic2, _p2Txt] call bis_fnc_initInspectable;//turns picture 2 into an inspectable object
 sleep _hLong;
 nul = [_folder] call BIS_fnc_initIntelObject;
 //Set diary Picture here 
_folder setVariable ["RscAttributeDiaryRecord_texture",
//Path to picture
_mPic1,
true];
//Title and Description
[_folder,"RscAttributeDiaryRecord",
//[ Title, Description, "" ]
[_intelTitle,_intelDescrip,""]] call BIS_fnc_setServerVariable;
//Show intel to rest of the team
_folder setVariable ["recipients", west, true];
_folder setVariable ["RscAttributeOwners", [west], true];//Who can take the intel? WEST in the case
//Add intel object scripted event that systemchats to all clients when found and by who
[_folder,"IntelObjectFound",
	{
		params[ "", "_foundBy" ];
		private _msg = format[ "Intel Found by %1", name _foundBy ];
		_msg remoteExec["systemChat",0];
	}] call BIS_fnc_addScriptedEventHandler;
//while folder is alive (meaning the player hasnt picked it up yet, then do nothing and check back in 1 second)
while{alive _folder} do {sleep 1};
if(!alive _folder) exitWith {deleteVehicle _intel1; deleteVehicle _intel2;};// if the folder was taken then delete the pictures and exit