extends CharacterEntity
class_name Enemy

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var detection_area: DetectionArea = $Body/Head/DetectionArea

const SPEED: float = 150.0

func _ready():
    add_to_group(&"hostile")
    detection_area.player_detected.connect(_on_player_detected)

var target_position: Vector2 :
    set(p): nav.target_position = p
    get(): return nav.target_position
var target_player: Player :
    set(p):
        if p == target_player: return
        if is_instance_valid(target_player):
            target_player.moved.disconnect(_on_target_player_moved)
        if is_instance_valid(p):
            p.moved.connect(_on_target_player_moved)
            target_position = p.global_position
        target_player = p

func _on_player_detected(player_detected: Player):
    target_player = player_detected

func _on_target_player_moved(player_position: Vector2):
    target_position = player_position

func _physics_process(_delta):
    if is_targeting(): body.set_target_position_global(target_position, _delta)

    var dir: Vector2 = nav.get_next_path_position() - global_position
    velocity = dir.normalized() * SPEED
    body.set_velocity(velocity)
    
    apply_forces()

func is_targeting() -> bool:
    return target_position and (
        is_instance_valid(target_player) or \
        not target_position.is_equal_approx(position)
    )