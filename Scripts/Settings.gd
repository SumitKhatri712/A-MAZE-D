extends Control

var joystickSize = 0

onready var textures = [
	"res://Player/Golem.png",
	"res://Player/Golem_Ice.png",
	"res://Player/Golem_Metal.png",
	"res://Player/Golem_Green.png",
	"res://Player/Golem_Gold.png",

	"res://Player/Golem.png",
	"res://Player/Golem_Ice.png",
	"res://Player/Golem_Metal.png",
	"res://Player/Golem_Green.png",
	"res://Player/Golem_Gold.png"
]

onready var spritePath
onready var animation = $AnimationPlayer
onready var black = $Black

#Dont need these
#var blueTex
#var metalTex
#var greenTex
#var goldTex
#var deafultTex
#var currentSpriteTexture
#var spriteIndex = {
#	"defaultIndex" : "res://Player/Golem.png",
#	"blueIndex" : "res://Player/Golem_Ice.png",
#	"MetalIndex" : "res://Player/Golem_Metal.png",
#	"GreenIndex" : "res://Player/Golem_Green.png",
#	"goldIndex" : "res://Player/Golem_Gold.png"
#}

func _ready() -> void:
	var musicSlider = get_node("MarginContainer/VBoxContainer/VBoxContainer/Music/Music")
	var soundSlider = get_node("MarginContainer/VBoxContainer/VBoxContainer/SFX/SFX")
	var musicVolume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var soundVolume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	musicSlider.value = musicVolume
	soundSlider.value = soundVolume
	var saved = SaveNLoad.loadSave()
	$MarginContainer/VBoxContainer/HBoxContainer/Sprite.set_texture(load(Globals.currentPlayerSkin))

func _on_RightButton_pressed() -> void:
	AudioManager.play("Click Sound")
	spritePath = $MarginContainer/VBoxContainer/HBoxContainer/Sprite.texture.resource_path
	var x = textures.find(spritePath, 0)
	changeSkin(x+1)

func _on_LeftButton_pressed() -> void:
	AudioManager.play("Click Sound")
	spritePath = $MarginContainer/VBoxContainer/HBoxContainer/Sprite.texture.resource_path
	var x = textures.find(spritePath, 0)
	changeSkin(x-1)

func _on_Back_pressed() -> void:
	AudioManager.play("Click Sound")
	animation.play("UI_fade")
	yield(animation, "animation_finished")
#	SaveNLoad.changeSave()
	var newPausedState = not get_tree().paused
	get_tree().paused = newPausedState
	visible = newPausedState
	animation.play_backwards("UI_fade")
	yield(animation, "animation_finished")

func _on_Home_pressed() -> void:
	AudioManager.play("Click Sound")
	Globals.LevelNumber -= 1
	SaveNLoad.changeSave()
	SceneChanger.change_scene("res://Maps/Map Scenes/TitleScreen.tscn")
	get_tree().paused = not get_tree().paused

func _on_Quit_pressed() -> void:
	AudioManager.play("Click Sound")
	SaveNLoad.changeSave()
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().quit()

func _on_Joystick_value_changed(value: float) -> void:
	joystickSize = value
	Globals.joystickSize = value
	print(Globals.joystickSize)

func _on_Music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	Globals.savedData["Music Volume"] = value

func _on_SFX_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	Globals.savedData["SFX Volume"] = value

func changeSkin(index):
	var skin = load(textures[index])
	$MarginContainer/VBoxContainer/HBoxContainer/Sprite.set_texture(skin)
	get_tree().call_group("Golem", "setPlayerSkin", textures[index])
	Globals.skinChange(textures[index])

# Dont need this
#func changeSprite():
#	spritePath = $MarginContainer/VBoxContainer/HBoxContainer/Sprite.texture.resource_path
#	if spritePath == spriteIndex["defaultIndex"]:
#		goldTex = load(spriteIndex["goldIndex"])
#		currentSpriteTexture = $MarginContainer/VBoxContainer/HBoxContainer/Sprite.set_texture(goldTex)
#		Globals.skinChange(spriteIndex["goldIndex"])
#		get_tree().call_group("Golem", "setPlayerSkin", currentSpriteTexture)
#
#	elif spritePath == spriteIndex["goldIndex"]:
#		metalTex = load(spriteIndex["MetalIndex"])
#		currentSpriteTexture = $MarginContainer/VBoxContainer/HBoxContainer/Sprite.set_texture(metalTex)
#		Globals.skinChange(spriteIndex["MetalIndex"])
#		get_tree().call_group("Golem", "setPlayerSkin", currentSpriteTexture)
#
#	elif spritePath == spriteIndex["MetalIndex"]:
#		blueTex = load(spriteIndex["blueIndex"])
#		currentSpriteTexture = $MarginContainer/VBoxContainer/HBoxContainer/Sprite.set_texture(blueTex)
#		Globals.skinChange(spriteIndex["blueIndex"])
#		get_tree().call_group("Golem", "setPlayerSkin", currentSpriteTexture)
#
#	elif spritePath == spriteIndex["blueIndex"]:
#		greenTex = load(spriteIndex["GreenIndex"])
#		currentSpriteTexture = $MarginContainer/VBoxContainer/HBoxContainer/Sprite.set_texture(greenTex)
#		Globals.skinChange(spriteIndex["GreenIndex"])
#		get_tree().call_group("Golem", "setPlayerSkin", currentSpriteTexture)
#
#	else:
#		print("insideDefaultIndex")
#		deafultTex = load("res://Player/Golem.png")
#		currentSpriteTexture = $MarginContainer/VBoxContainer/HBoxContainer/Sprite.set_texture(deafultTex)
#		Globals.skinChange("res://Player/Golem.png")
#		get_tree().call_group("Golem", "setPlayerSkin", currentSpriteTexture)
