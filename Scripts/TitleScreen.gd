extends Control

onready var animation = $SceneChanger/AnimationPlayer

func _ready() -> void:
	print(SaveNLoad.loadSave())

func _on_Play_pressed() -> void:
	AudioManager.play("Click Sound")
	Globals.go_next_stage()


func _on_Setting_pressed() -> void:
	AudioManager.play("Click Sound")
	animation.play("Fade")
	yield(animation, "animation_finished")
	var newPausedState = not get_tree().paused
	get_tree().paused = newPausedState
	$CanvasLayer/Settings.visible = newPausedState
	$CanvasLayer/Settings/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer2/Home.visible = false
	animation.play_backwards("Fade")
	yield(animation, "animation_finished")


func _on_Help_pressed() -> void:
	AudioManager.play("Click Sound")
	SceneChanger.change_scene("res://Maps/Map Scenes/HelpScreen.tscn")


func _on_Continue_pressed() -> void:
	var data = SaveNLoad.loadSave()
	var keysPicked = data["Keys Picked"]
	var levelNumber = data["Levels Cleared"][-1]
#	var levelNumber = data["Current Level"]
#	if data["Current Level"] < 1:
#		levelNumber = Globals.LevelNumber
#		Globals.LevelNumber += 1
	var x = data["x"]
	var y = data["y"]
	var keysToRemove = data["KeysToRemove"]
	var playerSkin = Globals.currentPlayerSkin
	AudioManager.play("Click Sound")
	SceneChanger.continueLastSave(levelNumber, keysPicked, x, y, keysToRemove, playerSkin)
	Globals.LevelNumber += 1
