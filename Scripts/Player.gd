extends KinematicBody2D

var velocity = Vector2(0, 0)
var joystickVel = Vector2(0, 0)
const Friction = 5000
const Acceleration = 5000
const MaxSpeed = 120
var Direction = "Left"

onready var joystick = get_node("/root/World/CanvasLayer/Control/Joystick")
onready var animationPlayer =  $AnimationPlayer

#onready var animationTree = $AnimationTree
#onready var animationState = animationTree.get("parameters/playback")

func _process(delta: float) -> void:
	$Sprite.texture = load(Globals.currentPlayerSkin)

func _physics_process(delta):
	#all * deltas are to stop speed from going overboard
	var inputVec = Vector2(0, 0)
	var joystickValue = joystick.get_value()
	inputVec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#Decreses the speed while going Daigonally
	inputVec = inputVec.normalized()

	if inputVec.x > 0 or joystickValue > Vector2(0, 0):
		get_node( "Sprite" ).set_flip_h( false )
	elif inputVec.x < 0 or joystickValue < Vector2(0, 0):
		get_node( "Sprite" ).set_flip_h( true )

	if inputVec != Vector2(0, 0) or joystickValue != Vector2(0, 0):
		animationPlayer.play("Walk")
#		animationTree.set("parameters/Idle/blend_position", inputVec)
#		animationTree.set("parameters/Walk/blend_position", inputVec)
#		animationState.travel("Walk")

		#Add Acceleration
		velocity += inputVec * Acceleration * delta
		joystickVel += joystickValue * Acceleration * delta

		#Stop it from going over max speed
		velocity = velocity.clamped(MaxSpeed)
		joystickVel = joystickVel.clamped(MaxSpeed)
	else:
#		animationState.travel("Idle")
		animationPlayer.play("Idle")

		#Add Friction
		velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
		joystickVel = joystickVel.move_toward(Vector2.ZERO, Friction * delta)

	velocity = move_and_slide(velocity)
	joystickVel = move_and_slide(joystickVel)


func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.name == "KeyArea":
		Globals.pickedKeyCount += 1
		AudioManager.play("PickUp")
