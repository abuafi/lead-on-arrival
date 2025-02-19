extends RigidBody2D
class_name Bullet

@onready var trail: Line2D = $Trail
@onready var nav: NavigationAgent2D = $NavigationAgent2D

var velocity: Vector2

class PIDControl:
    var k_p: float = 10.
    var k_i: float = 0.1
    var k_d: float = 0.5
    var i: float = 0.
    var d: float = 0.
    var last_error: float =  0.

    func step(error: float, delta: float):
        i += error * delta
        d = (error - last_error) / delta
        last_error = error
        return (error * k_p) + (i * k_i) + (d * k_d)

var angular_pid: PIDControl = PIDControl.new()
var linear_pid: PIDControl = PIDControl.new()

func _physics_process(_delta):
    if is_instance_valid(target_entity):
        target_position = target_entity.global_position
        
    var target: Vector2 = nav.get_next_path_position() - global_position
    var dir: Vector2 = target.normalized()
    var angle_target: float = atan2(dir.y, dir.x) + PI/2
    var forward_vector: Vector2 = Vector2.UP.rotated(rotation)
    var linear_error = target.length()
    var angular_error = angle_difference(rotation, angle_target)

    var angular: float = angular_pid.step(angular_error, _delta)
    angular = clamp(angular, -TAU, TAU)
    rotation += angular * _delta

    var linear: float = linear_pid.step(linear_error, _delta)
    print(linear)
    linear = clamp(linear, 0, 500)
    move_and_collide(forward_vector * linear * _delta)

var target_position: Vector2 :
    set(p): nav.target_position = p
    get(): return nav.target_position
var target_entity: CharacterEntity :
    set(p):
        if p == target_entity: return
        if is_instance_valid(p):
            target_position = p.global_position
        target_entity = p

func set_target(target: CharacterEntity):
    target_entity = target
