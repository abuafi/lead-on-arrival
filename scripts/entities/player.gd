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

func die():
    # TODO add some delay
    var traincar: Traincar = get_current_traincar()
    traincar.reload_level()
    reparent(traincar.entity_container)
    global_position = last_safe_pos
    player_died.emit()

# Since this entity is not removed from the tree when it dies, we can play the 
# death sound without reparenting
func play_death_sound(_traincar: Traincar):
    death_sound.pitch_scale = randf_range(0.5, 1.5)
    death_sound.play()