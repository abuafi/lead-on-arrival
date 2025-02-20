extends Camera2D
class_name GameCamera

var following: Player = null
var target_x: float = 0

const CAMERA_SPEED: float  = 2.
func _physics_process(delta):
    if is_instance_valid(following):
        target_x = following.global_position.x
    global_position.x = lerp(
        global_position.x, 
        target_x,
        delta * CAMERA_SPEED
    )