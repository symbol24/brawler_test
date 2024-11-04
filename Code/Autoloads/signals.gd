extends Node

# Debug 
signal DebugUpdateBoxText(player_id:int, id:String, text:String)
signal DebugToggleGodMode(target:String)
signal DebugPrint(text:String)
signal DebugDisplayInfo(player_id:int, display:bool)


# Manager
signal StartMPM()


# Main Menu
signal PlayerReady(player_id:int, ready:bool)


# Multiplayer
signal MPMReady()
signal MPMAcceptInputs(accept:bool)


# Scene Manager
signal SceneLoadingComplete(level:Level)


# UI
signal ToggleLoadingScreen(display:bool)


# to be changed later
signal SpawnPlayer(player_data:PlayerData)