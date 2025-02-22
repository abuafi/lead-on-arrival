extends CharacterEntity
class_name Player

const SPEED = 300.0

signal player_died()

func _physics_process(_delta: float) -> void:
    var to_mouse: Vector2 = get_local_mouse_position()
    body.set_target_position(to_mouse, _delta)

    var vec: Vector2 = Input.get_vector(
        &"move_left", 
        &"move_right", 
        &"move_up", 
        &"move_down")
    if vec:  velocity = vec * SPEED
    else:    
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.y = move_toward(velocity.y, 0, SPEED)

    body.set_velocity(velocity)
    apply_forces()

func setup_respawn(world: World):
    world.level_ready.connect(_on_level_ready)

var last_safe_pos: Vector2 = Vector2.ZERO
func _on_level_ready(_level: int):
    last_safe_pos = global_position

@onready var temp_collision_layer: int = collision_layer
func die():
    var traincar: Traincar = get_current_traincar()
    if collision_layer > 0:
        temp_collision_layer = collision_layer
    collision_layer = 0
    traincar.reload_level()
    reparent(traincar.entity_container)
    global_position = last_safe_pos
    traincar.level_active.connect(
        _on_reload_level_active,
        ConnectFlags.CONNECT_ONE_SHOT)
    player_died.emit()

func _on_reload_level_active():
    collision_layer = temp_collision_layer

# Since this entity is not removed from the tree when it dies, we can play the 
# death sound without reparenting
func play_death_sound(_traincar: Traincar):
    death_sound.pitch_scale = randf_range(0.5, 1.5)
    death_sound.play()

func _input(event: InputEvent):
    if event.is_action_pressed(&"reload"):
        var traincar: Traincar = get_current_traincar()
        if is_instance_valid(traincar):
            die()