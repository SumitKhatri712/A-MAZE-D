# Inspired by Gonkee's [_Godot 3: How to make a Joystick_](https://www.youtube.com/watch?v=uGyEP2LUFPg)

# Version V0.1.1

# Assumptions
# Joystick : Node2D -> Joystick.gd
# |-  Boundary : Sprite
# |-  Handle : TouchScreenButton

# Motivation
#  1. In original, if cursor started outside of boundary but goes within
#       boundary while being pressed, input was counted as soon as
#       event.position entered within boundary.
#  2. Readability/Access, and separation of function, it wasn't always clear
#       which part took care of what input event. I tried to separate it to make
#       it clearer to the reader so that it's easilly modifiable.
#  3. Extensibility, I tried to make this script work in as many places

# TODO
# - Some refactoring to make it nicer
# = Allow boundary to be an ellipse

extends Node2D

onready var boundary        : Sprite  = $Boundary
onready var boundary_scale  : Vector2 = boundary.global_scale
onready var boundary_center : Vector2 = boundary.global_position
onready var boundary_size   : Vector2 = boundary.texture.get_size() / 2 * Globals.joystickSize
# assumes boundary is a circle, not an ellipse, this is important because sprites can *not* be rectangular
onready var boundary_scalar : float = (boundary_scale.x + boundary_scale.y) / 2
onready var boundary_radius : float = (boundary_size.x  + boundary_size.y)  / 2
onready var boundary_scaled_radius : float = boundary_scalar * boundary_radius

onready var handle              : TouchScreenButton = $Boundary/Handle
onready var handle_radius       : float             = handle.shape.radius #* Globals.joystickSize
onready var handle_center       : Vector2           = Vector2(handle_radius, handle_radius)
onready var handle_global_scale : Vector2           = handle.global_scale



# Is the drag process ongoing?
var ongoing_drag_process : bool = false
# Is there dragging that I care about right now?
var ongoing_drag : int = -1

func get_handle_default_position() -> Vector2:
	return boundary_center

func set_handle_position(new_position) -> void:
	handle.position = new_position + handle_center * handle_global_scale * Globals.joystickSize

func set_handle_global_position(new_global_position) -> void:
	handle.global_position = new_global_position - handle_center * handle_global_scale# * Globals.joystickSize

func handle_relased() -> void:
	set_handle_global_position(get_handle_default_position())


func _ready() -> void:
	set_handle_global_position(get_handle_default_position())

func _process(_delta) -> void:
	if ongoing_drag_process and ongoing_drag == -1:
		handle_relased()
		ongoing_drag_process = false

func _input(event) -> void:
	if event is InputEventScreenTouch:
		if event.pressed: # Down
			# If not currently using any finger
			if not ongoing_drag_process and ongoing_drag == -1:
				var event_position_to_boundary_center : Vector2 = event.position - boundary_center
				var event_position_to_handle  : Vector2 = event.position - (handle.global_position + handle_center)
				var handle_to_boundary_center : Vector2 = (handle.global_position + handle_center) - boundary_center

				# If event is within the boundary
				if event_position_to_boundary_center.length() <= boundary_scaled_radius:
					set_handle_global_position(event.position)
					ongoing_drag_process = true
					ongoing_drag = event.index
				# or event within handle radius and handle is within boundary
				elif (
					event_position_to_handle.length() <= handle_radius and
					handle_to_boundary_center.length() <= boundary_scaled_radius
				):
					# Normalize event position so that it doesn't go further than the boundary by accident
					var normalized_event_position : Vector2 = \
						event_position_to_boundary_center.normalized() * boundary_scaled_radius + \
						boundary_center
					set_handle_global_position(normalized_event_position)
					ongoing_drag_process = true
					ongoing_drag = event.index
		else: # Up
			# _process is going to take care of setting ongoing_drag_process to false
			ongoing_drag = -1

	elif event is InputEventScreenDrag: # Movement
		if ongoing_drag_process and event.index == ongoing_drag:
			var event_position_to_boundary_center : Vector2 = event.position - boundary_center

			if event_position_to_boundary_center.length() > boundary_scaled_radius:
				# Normalize event position so that it specifically doesn't go outside of boundary
				var normalized_event_position : Vector2 = \
					event_position_to_boundary_center.normalized() * boundary_scaled_radius + \
					boundary_center
				set_handle_global_position(normalized_event_position)
			else:
				set_handle_global_position(event.position)

export(float, 0, 1) var threshold_min : float = 0.001

func get_raw_value() -> Vector2:
	var result := (handle.position + handle_center) / boundary_radius
	return Vector2.ZERO if result.length() <= threshold_min else result

func get_value() -> Vector2:
	return get_raw_value().normalized()
