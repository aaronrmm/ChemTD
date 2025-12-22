extends Node2D
class_name Particle

@export var mass: float = 1.0
var velocity: Vector2 = Vector2.ZERO
var accumulated_force: Vector2 = Vector2.ZERO

@export var radius: float = 4.0
@export var color: Color = Color(1.0, 0.2, 0.2) # reddish

func _draw() -> void:
	# Draw a simple filled circle at the node's origin
	draw_circle(Vector2.ZERO, radius, color)


func update():
	draw.emit()
