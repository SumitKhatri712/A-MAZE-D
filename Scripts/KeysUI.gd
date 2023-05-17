extends Control

onready var keyPicked = $HBoxContainer3/HBoxContainer/PanelContainer/KeysPicked
onready var keyNotPicked = $HBoxContainer3/HBoxContainer/PanelContainer/KeysNotPicked
onready var animation = $AnimationPlayer
onready var _animation = $Setting/AnimationPlayer
onready var black = $Black
onready var totalkeyCount = get_tree().get_nodes_in_group("Keys").size()

func _ready() -> void:
	keyPicked.visible = false

func _process(_delta: float) -> void:
	if Globals.pickedKeyCount != 0:
		keyPicked.visible = true
	if keyPicked != null:
		keyPicked.rect_size.x = Globals.pickedKeyCount * 20
	if keyNotPicked != null:
		keyNotPicked.rect_size.x = totalkeyCount * 20

func _on_Settings_pressed() -> void:
	AudioManager.play("Click Sound")
	_animation.play("UI_fade")
#	yield(_animation, "animation_finished")
	animation.play("UI_fade")
	yield(animation, "animation_finished")
	var newPausedState = not get_tree().paused
	get_tree().paused = newPausedState
	$Setting.visible = newPausedState
	_animation.play_backwards("UI_fade")
	yield(_animation, "animation_finished")
	animation.play_backwards("UI_fade")
	yield(animation, "animation_finished")

