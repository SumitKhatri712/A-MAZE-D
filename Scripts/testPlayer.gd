extends KinematicBody2D

onready var joystick = get_node("/root/World/CanvasLayer/Joystick")
var velocity = Vector2(0, 0)
onready var animationPlayer =  $AnimationPlayer

func _process(delta: float) -> void:
	velocity = 100
	var joystickValue = joystick.get_value()
	move_and_slide(velocity * joystickValue)

	if joystickValue > Vector2(0, 0):
		get_node( "Sprite" ).set_flip_h( false )
	elif joystickValue < Vector2(0, 0):
		get_node( "Sprite" ).set_flip_h( true )

	if joystickValue != Vector2(0, 0):
		animationPlayer.play("Walk")
	else:
		animationPlayer.play("Idle")
