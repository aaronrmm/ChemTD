extends Node2D
class_name ParticleRenderer

var positions: PackedVector2Array = PackedVector2Array()

@export var radius: float = 2.0
@export var color: Color = Color(1.0, 0.2, 0.2)

func _draw() -> void:
	# Draw a circle for each particle
	for pos in positions:
		draw_circle(to_local(pos), radius, color)

func set_positions(new_positions: PackedVector2Array) -> void:
	positions = new_positions
	#queue_redraw()
