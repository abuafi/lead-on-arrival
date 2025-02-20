extends Camera2D
class_name GameCamera

var following: Player = null

const CAMERA_SPEED: float  = 2.
func _physics_process(delta):
    if is_instance_valid(following):
        global_position.x = lerp(
            global_position.x, 
            following.global_position.x,
            delta * CAMERA_SPEED
        )