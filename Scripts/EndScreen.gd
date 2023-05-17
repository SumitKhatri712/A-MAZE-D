extends Node2D

func _on_Quit_pressed() -> void:
	AudioManager.play("Click Sound")
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().quit()

func _on_Back_pressed() -> void:
	AudioManager.play("Click Sound")
	SceneChanger.change_scene("res://Maps/Map Scenes/TitleScreen.tscn")
