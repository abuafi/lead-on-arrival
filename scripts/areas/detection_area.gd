extends Area2D 
class_name DetectionArea

@onready var raycast: RayCast2D = $RayCast2D

signal player_detected(player: Player)

var player_in_area: Player = null
var detected: bool = false

func seen() -> Player:
    if detected: return player_in_area
    else: return null

func _ready():
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
    if body is Player:
        player_in_area = body

func _on_body_exited(body: Node2D):
    if body is Player and body == player_in_area:
        player_in_area = null
        detected = false

func _physics_process(_delta: float):
    if not is_instance_valid(player_in_area): return
    raycast.target_position = player_in_area.global_position * global_transform
    if player_in_ray():
        detected = true
        player_detected.emit(player_in_area)
    else: detected = false

func player_in_ray() -> bool:
    raycast.force_raycast_update()
    var first_collider: Node2D = raycast.get_collider()
    if not is_instance_valid(first_collider): return false
    while first_collider.is_in_group(&"hostile") and first_collider is CollisionObject2D:
        raycast.add_exception(first_collider)
        raycast.force_raycast_update()
        first_collider = raycast.get_collider()
        if not is_instance_valid(first_collider): return false
    return first_collider == player_in_area
    