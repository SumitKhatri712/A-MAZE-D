extends CanvasLayer

signal scene_changed()

var current_scene = null
onready var animation = $AnimationPlayer

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func continueLastSave(levelNumber, keysPicked, x, y, keysToRemove, playerSkin, delay=0.2):
	yield(get_tree().create_timer(delay), "timeout")
	animation.play("Fade")
	yield(animation, "animation_finished")
	call_deferred("goto_scene", "res://Maps/Map Scenes/Level "+str(levelNumber)+".tscn")
	yield(get_tree().create_timer(0.2), "timeout")

	Globals.pickedKeyCount = keysPicked
	get_tree().call_group("Golem", "setPlayerPos", x, y)
	get_tree().call_group("Golem", "setPlayerSkin", playerSkin)
#	if keysToRemove != null:
	for keys in keysToRemove:
		var node = Globals.find_node_by_name(get_tree().get_root(), keys)
		node.queue_free()
	animation.play_backwards("Fade")
	yield(animation, "animation_finished")

func change_scene(Path, delay = 0.2):
	yield(get_tree().create_timer(delay), "timeout")
	animation.play("Fade")
	yield(animation, "animation_finished")
	Globals.reset()
	get_node("/root/SceneChanger").call_deferred("goto_scene", Path)
	animation.play_backwards("Fade")
	yield(animation, "animation_finished")
	emit_signal("scene_changed")

func goto_scene(path):
	current_scene.free()
	current_scene = load(path).instance()
	get_tree().get_root().call_deferred("add_child", current_scene)
