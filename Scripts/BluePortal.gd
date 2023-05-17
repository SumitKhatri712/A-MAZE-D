extends StaticBody2D

export var previosScenePath = ""
onready var confirmBox = $CanvasLayer/Control

func _on_Area2D_area_entered(area: Area2D) -> void:
	AudioManager.play("PopUp")
	var newPausedState = not get_tree().paused
	get_tree().paused = newPausedState
	confirmBox.visible = newPausedState

func _on_Yes_pressed() -> void:
	var newPausedState = not get_tree().paused
	AudioManager.play("Click Sound")
	AudioManager.play("Portal")
	Globals.LevelNumber -= 1
	SceneChanger.change_scene(previosScenePath)
	confirmBox.visible = newPausedState
	get_tree().paused = newPausedState

func _on_No_pressed() -> void:
	AudioManager.play("Click Sound")
	var newPausedState = not get_tree().paused
	get_tree().paused = newPausedState
	confirmBox.visible = newPausedState
