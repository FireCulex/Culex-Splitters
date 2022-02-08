state("Crysis3")
{
	byte bCinematics: "Crysis3.exe", 0x1B397E4, 0x50; // Cinematics
	int bypassSkip: "Crysis3.exe", 0x1CE1818, 0x6C; // 2nd Cinematics variable may be required
	string16 mission : "Crysis3.exe", 0x1CDFFB0, 0x14 ; // Level
	byte bLoading : "Crysis3.exe", 0x1CD71B4, 0x8, 0xD8; // Loading screens
	byte bPause: "Crysis3.exe", 0x1AEE05C, 0x270; // Paused? Currently overlaps with Loading Screens
	byte End: "Crysis3.exe", 0x1D0EA54, 0x30, 0x6A4; // The End
}

init
{
	vars.split = 0;
}

update
{
 
}

startup
{
	settings.Add("autotimer",false,"AutoStart Timer");
	settings.Add("autosplitter",true,"Autosplitter");
	settings.Add("loadremover",false,"Load Remover");
	settings.Add("cinematicsremover",false,"Cinematics Remover");
	settings.Add("pauseremover",false,"Pause Remover");
}

start
{ 
	if (settings["autotimer"]) {
		if (old.mission == "NoLevel" & current.mission == "jailbreak") 
		{
			vars.split = vars.split + 1;
		return true;
		}
	}
}

split
{
	if (settings["autosplitter"]) {

		// Split if there is a level change with exceptions to river2 and endgame as these levels include 2 maps
		if (old.mission != current.mission & current.mission!="NoLevel" & current.mission!="river2" & current.mission!="endgame") 
			return true;

		// Split at the end of Endgame instead of Cave
		if (current.mission == "endgame" & current.End == 1 & old.End == 0)
			return true;
	}
}

reset
{

}
isLoading
{

// Certain "Cinematics" require a 2nd variable "bypass" depending on map
	if (settings["cinematicsremover"]) 
	{
		if (current.bypassSkip != 257 & current.bCinematics == 1 || current.bCinematics == 2 || current.bCinematics == 1 & current.mission=="canyon" || current.bCinematics == 1 & current.mission=="swamp") 
		{
		print ("Cinematics Removed");
			return true;
		}
	}
	if (settings["loadremover"]) {
		if (current.bLoading == 1)
		{
	//		print ("Loading Removed");
			return true;
		}
	}	
	if (settings["pauseremover"]) {
		if (current.bPause == 1)
		{
		//	print ("Pause Removed");
			return true;
		}
	}
	
	if (settings["cinematicsremover"] || settings["loadremover"] || settings["pauseremover"]) {
		return false;
		}
}

exit
{
	// timer.IsGameTimePaused = true;
}