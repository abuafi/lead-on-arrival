extends Node2D
class_name Door

@onready var sprite_lower: Sprite2D = $DoorLower
@onready var sprite_upper: Sprite2D = $DoorUpper
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var player: AnimationPlayer = $AnimationPlayer
@onready var left: Area2D = $Left
@onready var right: Area2D = $Right

signal player_passed_left(player: Player)
signal player_passed_right(player: Player)

func open():
    player.play(&"open")

func close():
    player.play(&"close")

func enable_collision():
    if static_body.get_parent() == self: return
    add_child(static_body)

func disable_collision():
    if not is_instance_valid(static_body.get_parent()): return
    remove_child(static_body)

func _ready():
    right.body_entered.connect(_on_body_passed_right)
    left.body_entered.connect(_on_body_passed_left)

func _on_body_passed_right(body: Node2D):
    if body is Player:
        player_passed_right.emit(body)

func _on_body_passed_left(body: Node2D):
    if body is Player:
        player_passed_left.emit(body)