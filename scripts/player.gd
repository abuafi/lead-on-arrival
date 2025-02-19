extends CharacterBody2D
class_name Player

const SPEED = 300.0

@onready var head: Head = $Body/Head
@onready var body: Body = $Body

signal moved(position: Vector2)

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

    apply_forces()

func apply_forces():
    if moved.get_connections().size() > 0:
        var prev_position: Vector2 = position
        move_and_slide()
        if not prev_position.is_equal_approx(position):
            moved.emit(position)
    else: move_and_slide()