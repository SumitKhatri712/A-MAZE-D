extends StaticBody2D

onready var totalkeyCount = get_tree().get_nodes_in_group("Keys").size()
export var NextScenePath = ""

func _on_Area2D_area_entered(_area: Area2D) -> void:
	if totalkeyCount == Globals.pickedKeyCount:
		AudioManager.play("Portal")
		Globals.savedData["KeysToRemove"] = null
#		Globals.go_next_stage()
		SceneChanger.change_scene(NextScenePath)
	else:
		print("NOT ENOUGH KEYS")
