extends Resource
class_name ForceField

## Base class for all force fields.
## Override get_force() in subclasses.

func get_force(position: Vector2, velocity: Vector2, delta: float) -> Vector2:
	return Vector2.ZERO
