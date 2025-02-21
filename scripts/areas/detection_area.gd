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
    raycast.force_raycast_update()
    var first_collider: Object = raycast.get_collider()
    if first_collider == player_in_area:
        detected = true
        player_detected.emit(player_in_area)
    else: detected = false