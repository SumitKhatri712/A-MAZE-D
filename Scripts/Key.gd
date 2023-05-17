extends Node2D

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		Globals.keysToRemove.append(self.get_name())
		print(self.get_name())
		queue_free()
	else:
		pass
