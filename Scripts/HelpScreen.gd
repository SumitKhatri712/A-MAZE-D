extends Control

func _on_Back_pressed() -> void:
	AudioManager.play("Click Sound")
	SceneChanger.change_scene("res://Maps/Map Scenes/TitleScreen.tscn")
