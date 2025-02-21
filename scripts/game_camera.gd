extends Camera2D
class_name GameCamera

var following: Player = null
var target_x: float = 0

const CAMERA_SPEED: float  = 2.
const CAMERA_OFFSET: int = 50
func _physics_process(delta):
    if is_instance_valid(following):
        target_x = following.global_position.x
    global_position.x = lerp(
        global_position.x, 
        target_x,
        delta * CAMERA_SPEED
    )
    var camera_width_half: int = int(get_viewport().get_visible_rect().size.x / 2)
    var x_pos: int = int(global_position.x) - camera_width_half
    if x_pos > limit_left + CAMERA_OFFSET:
        limit_left = x_pos
