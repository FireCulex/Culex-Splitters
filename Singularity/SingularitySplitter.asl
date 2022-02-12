state("Singularity")
{
	bool bSkip: "Singularity.exe", ; // skip cut-scenes where you can't move
	bool bCinematics: "Singularity.exe", ; // Cinematics, overlaps with Loading Screens?
	string23 mission : "Singularity.exe",  ; // Level
	byte bLoading : "Singularity.exe", ; // Loading screens
	byte bPause: "Singularity.exe", ; // Pause
	byte bStart: "Singularity.exe", ;
	//byte End: "Singularity.exe", ; // The End
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