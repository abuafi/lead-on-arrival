extends Node2D
class_name Pickup

@export var pickup_resource: PackedPickup

@onready var pickup_area: Area2D = $PickupArea
@onready var sprite: Sprite2D = $Sprite

const PICKUP_SCENE: PackedScene = preload("res://scenes/base_pickup.tscn")

static func from_packed(packed: PackedPickup) -> Pickup:
    var pickup: Pickup = PICKUP_SCENE.instantiate()
    pickup.pickup_resource = packed
    return pickup

func _ready():
    sprite.texture = pickup_resource.pickup_texture
    pickup_area.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body: Node2D):
    if body is Player:
        var player: Player = body
        pickup_resource.on_pickup(player)
        queue_free()
