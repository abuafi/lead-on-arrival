@tool
extends CollisionPolygon2D
class_name ConeShape2D

@export var cone_angle: float = PI/2
@export var cone_distance: float = 100
@export var subdivisions: int = 10

@export var apply: bool :
    set(_v):
        apply_shape()

func apply_shape():
    var shape = PackedVector2Array()
    shape.append(Vector2(0, 0))
    var angle: float = cone_angle / 2
    var arc_x = sin(angle) * cone_distance
    var arc_y = cos(angle) * cone_distance
    shape.append(Vector2( arc_x, arc_y))
    var angle_step: float = cone_angle / subdivisions 
    for i in range(subdivisions):
        angle -= angle_step
        arc_x = sin(angle) * cone_distance
        arc_y = cos(angle) * cone_distance
        shape.append(Vector2( arc_x, arc_y))

    polygon = shape

func _ready():
    apply_shape()
