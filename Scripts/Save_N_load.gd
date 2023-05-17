extends Node

var savePath = "user://save.json"
var defaultData = {
		"Music Volume" : AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")),
		"SFX Volume" : AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")),
		"Current Level" : 1,
		"Keys Picked" : 0,
		"Levels Cleared" : Globals.levelCleared,
		"x" : -520,
		"y" : 315,
		"KeysToRemove" : null,
		"Current Sprite" : "res://Player/Golem.png",
	}

func _ready() -> void:
	loadSave()

func defaultSave():
	var file = File.new()
	var error = file.open_encrypted_with_pass(savePath, File.WRITE, "Fdsa4321")
	if error == OK:
		file.store_line(to_json(defaultData))
		file.close()
	else:
		print(error)


func changeSave():
	get_tree().call_group("Golem", "save")
	var data = Globals.savedData
	var file = File.new()
	var error = file.open_encrypted_with_pass(savePath, File.WRITE, "Fdsa4321")
#	var error = file.open(savePath, File.WRITE)
	if error == OK:
#		file.store_var(data)
		file.store_line(to_json(data))
		file.close()
	else:
		print(error)
	print(Globals.savedData)

func loadSave():
	var file = File.new()
	if file.file_exists(savePath):
		var error = file.open_encrypted_with_pass(savePath, File.READ, "Fdsa4321")
	#	var error = file.open(savePath, File.READ)
		if error == OK:
			var save = parse_json(file.get_line())
			file.close()
			if save.has("Current Level"):
				var mVolume = save["Music Volume"]
				var sVolume = save["SFX Volume"]
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), mVolume)
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sVolume)
				Globals.currentPlayerSkin = save["Current Sprite"]
				return save
			else:
				return defaultData
		else:
			print(error)
	else:
		print("NO FILE FOUND")
		print("Creating a save file")
		defaultSave()
