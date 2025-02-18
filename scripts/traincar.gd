extends Node2D
class_name Traincar

@onready var world: World = $".."
@onready var entity_container: Node2D = $EntityContainer
@onready var play_area: Area2D = $PlayArea
@onready var play_area_shape: CollisionShape2D = $PlayArea/CollisionShape2D

func _ready():
    var pos: Vector2 = rand_point()
    const test_pickup: PackedPickup = preload("res://resources/gun_pickup.tres")
    var new_pickup: Pickup = Pickup.from_packed(test_pickup)
    new_pickup.position = pos 
    entity_container.add_child(new_pickup)

# Spawnable area shape in local coordinates
func spawnable_area() -> Rect2:
    var shape: RectangleShape2D = play_area_shape.shape
    return shape.get_rect()

func rand_point() -> Vector2: 
    var rect: Rect2i = Rect2i(spawnable_area())
    var x = randi_range(rect.position.x, rect.position.x + rect.size.x)
    var y = randi_range(rect.position.y, rect.position.y + rect.size.y)
    return position + Vector2(x,y)