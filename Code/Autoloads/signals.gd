extends Node

# Debug 
signal DebugUpdateBoxText(player_id:int, id:String, text:String)
signal DebugToggleGodMode(target:String)
signal DebugPrint(text:String)
signal DebugDisplayInfo(player_id:int, display:bool)


# to be changed later
signal SpawnPlayer(player_data:PlayerData)