extends CharacterEntity
class_name Player

const SPEED = 300.0

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