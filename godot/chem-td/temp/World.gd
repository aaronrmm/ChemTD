extends Node2D
class_name World

@export var particle_scene: PackedScene
@export var force_field: ForceField

@export var initial_particle_count: int = 40
@export var spawn_radius: float = 300.0
@export var particle_mass: float = 1.0

@onready var particles_container: Node = $Particles
@onready var core: Node2D = $Core
@onready var renderer = $ParticleRenderer
@onready var stats_label: Label = $StatsLabel

var positions: PackedVector2Array = PackedVector2Array()
var velocities: PackedVector2Array = PackedVector2Array()
var forces: PackedVector2Array = PackedVector2Array()

# physics-FPS tracking
var physics_frame_count: int = 0
var total_physics_time: float = 0.0
var frame_counter := 0

func _ready() -> void:
	if force_field is CenterAttractorForce:
		(force_field as CenterAttractorForce).center = core.global_position

	_init_arrays(initial_particle_count)
	_spawn_particles()



func _init_arrays(count: int) -> void:
	positions.resize(count)
	velocities.resize(count)
	forces.resize(count)

	for i in count:
		positions[i] = Vector2.ZERO
		velocities[i] = Vector2.ZERO
		forces[i] = Vector2.ZERO


func _spawn_particles() -> void:
	var center_pos := core.global_position

	for i in positions.size():
		var angle := randf() * TAU
		var r := spawn_radius * (0.5 + randf() * 0.5)  # between 0.5R and R
		var offset := Vector2.RIGHT.rotated(angle) * r
		positions[i] = center_pos + offset

		velocities[i] = Vector2(
			randf_range(-50.0, 50.0),
			randf_range(-50.0, 50.0)
		)


func _physics_process(delta: float) -> void:
	# --- physics FPS tracking ---
	physics_frame_count += 1
	total_physics_time += delta
	var avg_fps : float = physics_frame_count / max(total_physics_time, 0.0001)
	if is_instance_valid(stats_label):
		var render_fps := Engine.get_frames_per_second()
		stats_label.text = "FPS: %.1f  Particles: %d" % [render_fps, positions.size()]

	# --- simulation systems ---
	apply_forces(delta)
	_integrate(delta)
	
	# --- draw once per physics step ---
	frame_counter += 1
	if frame_counter % 1 == 0:
		renderer.set_positions(positions)


func apply_forces(delta: float) -> void:
	if force_field == null:
		return
		
	var count := positions.size()
	for i in count:
		var F := force_field.get_force(positions[i], velocities[i], delta)
		forces[i] = F


func _integrate(delta: float) -> void:
	if particle_mass <= 0.0:
		return

	var inv_mass := 1.0 / particle_mass
	var count := positions.size()
	for i in count:
		var a := forces[i] * inv_mass
		velocities[i] += a * delta
		positions[i] += velocities[i] * delta
		forces[i] = Vector2.ZERO
