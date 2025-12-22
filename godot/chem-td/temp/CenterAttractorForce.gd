extends ForceField
class_name CenterAttractorForce

@export var center: Vector2 = Vector2.ZERO
@export var strength: float = 50.0      # spring-ish
@export var max_force: float = 500.0    # clamp

func get_force(position: Vector2, velocity: Vector2, delta: float) -> Vector2:
	var dir: Vector2 = center - position
	var force: Vector2 = dir * strength
	if force.length() > max_force:
		force = force.normalized() * max_force
	return force
