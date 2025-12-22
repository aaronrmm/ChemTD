extends MultiMeshInstance2D
class_name MultiMeshParticleRenderer

@export var radius: float = 2.0
@export var color: Color = Color(1.0, 0.2, 0.2)

func _ready() -> void:
	# Set up a simple quad mesh for each particle instance
	if multimesh == null:
		multimesh = MultiMesh.new()

	var mesh := QuadMesh.new()
	mesh.size = Vector2(radius * 2.0, radius * 2.0)
	multimesh.mesh = mesh

	# Basic material so we can tint the instances
	var mat := ShaderMaterial.new()
	mat.shader = load("res://temp/particle_shader.gdshader")
	mat.set_shader_parameter("color", color)
	material = mat


func set_positions(positions: PackedVector2Array) -> void:
	if positions.is_empty():
		multimesh.instance_count = 0
		return

	# Resize instance buffer if needed
	if multimesh.instance_count != positions.size():
		multimesh.instance_count = positions.size()

	# Update transforms for each instance
	var count := positions.size()
	for i in count:
		var xf := Transform2D.IDENTITY
		xf.origin = positions[i]
		multimesh.set_instance_transform_2d(i, xf)
