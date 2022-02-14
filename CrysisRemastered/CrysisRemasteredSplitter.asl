state("CrysisRemastered")
{
	bool bSkip: "CrysisRemastered.exe", 0x23FA7E0, 0x598, 0x8; // skip cut-scenes where you can't move
	bool bCinematics: "CrysisRemastered.exe", 0x23FA7E0, 0x5F8, 0x8; // Cinematics, overlaps with Loading Screens?
	string23 mission : "CrysisRemastered.exe", 0x7DE8560, 0x100, 0x20, 0x48, 0x10, 0x34; // Level
	byte bLoading : "CrysisRemastered.exe", 0x7E93BC0, 0x18, 0xB90, 0x18, 0x0; // Loading screens
	byte bPause: "CrysisRemastered.exe", 0x7F5E820, 0x10, 0x78, 0x730, 0x38, 0xFD4; // Pause
	byte bStart: "CrysisRemastered.exe", 0x7EEFBD8, 0x80, 0x30, 0x15D8;
	//byte End: "CrysisRemastered.exe", ; // The End
}

init
{
//    refreshRate = 1; // verify debug msgs
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
		if (old.bStart == 6 & current.bStart == 7 & current.mission == "island") 
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
		if (old.mission != current.mission) 
			return true;

		// Split at the end of Endgame instead of Cave
//		if (current.mission == "endgame" & current.End == 1 & old.End == 0)
//			return true;
	}
}

reset
{

}
isLoading
{

	if (settings["cinematicsremover"]) 
	{
		if (current.bSkip == true & current.mission!="rescue")
		{
			print ("Skip removed");
			return true;
		}
		if (current.bCinematics == true) 
		{
			print ("Cinematics Removed");
			return true;
		}
	}
	if (settings["loadremover"]) {
		if (current.bLoading == 1)
		{
			print ("Loading Removed");
			return true;
		}
	}	
	if (settings["pauseremover"]) {
		if (current.bPause == 1)
		{
			print ("Pause Removed");
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