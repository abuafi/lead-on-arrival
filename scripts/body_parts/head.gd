extends Node2D
class_name Head

func set_rotation_angle(angle_to_target: float):
    var head_angle = snapped(angle_to_target, PI/4)
    global_rotation = head_angle