extends Node

onready var LevelNumber = 0
onready var TotalLevels = 5
onready var pickedKeyCount = 0
onready var defaultKeyCount = 0
var joystickSize = 0.6
signal sceneChanged()
var currentPlayerSkin = "res://Player/Golem.png"
var keysToRemove = []
var savedData = {}
var levelCleared = []

func _process(_delta: float) -> void:
	if LevelNumber < 0:
		LevelNumber = 0

func merge_dict(dest, source):
	for key in source:                     # go via all keys in source
		if dest.has(key):                  # we found matching key in dest
			var dest_value = dest[key]     # get value
			var source_value = source[key] # get value in the source dict
			if typeof(dest_value) == TYPE_DICTIONARY:
				if typeof(source_value) == TYPE_DICTIONARY:
					merge_dict(dest_value, source_value)
				else:
					dest[key] = source_value # override the dest value
			else:
				dest[key] = source_value     # add to dictionary
		else:
			dest[key] = source[key]          # just add value to the dest

func go_next_stage():
	print(keysToRemove)
	LevelNumber += 1
	if LevelNumber > levelCleared.size():
		levelCleared.append(LevelNumber)
	else:
		pass
	if LevelNumber < TotalLevels:
		SceneChanger.change_scene("res://Maps/Map Scenes/Level "+str(LevelNumber)+".tscn")
		emit_signal("sceneChanged")
		print(LevelNumber)
		SaveNLoad.changeSave()
	elif LevelNumber == TotalLevels:
		SceneChanger.change_scene("res://Maps/Map Scenes/EndScreen.tscn")
		SaveNLoad.defaultSave()

func reset():
	pickedKeyCount = defaultKeyCount

func skinChange(path):
	currentPlayerSkin = path

func find_node_by_name(root, name):
	if(root.get_name() == name): return root
	for child in root.get_children():
		if(child.get_name() == name):
			return child
		var found = find_node_by_name(child, name)
		if(found): return found
	return null

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_K) and just_pressed:
		pickedKeyCount += 1
		AudioManager.play("PickUp")
	if Input.is_key_pressed(KEY_N) and just_pressed:
		AudioManager.play("Portal")
		call_deferred("go_next_stage")
