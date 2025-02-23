extends Node2D
class_name Background

@onready var camera: GameCamera = $"../Camera2D"
@onready var background: TileMapLayer = $TileMapLayer
@onready var rails: Node2D = $Rails

var rail_pos: float = -500

@export var scrolling_speed: float = 2000.

const MAP_WIDTH: int = 297
const TILE_SIZE: int = 32
const WIDTH: int = MAP_WIDTH * TILE_SIZE

@onready var pos: float = position.x
func _process(delta: float) -> void:
    var view_width: float = get_viewport_rect().size.x / 2
    background.position.x -= scrolling_speed * delta
    rail_pos -= scrolling_speed * delta
    rails.position.x -= scrolling_speed * delta
    
    if background.position.x + WIDTH < camera.position.x - view_width:
        background.position.x += WIDTH
    while rail_pos < camera.position.x + view_width:
        add_rail()

const RAIL_TEXTURE: Resource = preload("res://resources/rail_texture.tres")
const RAIL_WIDTH: float = 64.
const MAX_RAILS = 30

func add_rail():
    var rail_sprite: Sprite2D
    if rails.get_child_count() < MAX_RAILS:
        rail_sprite = Sprite2D.new()
        rail_sprite.texture = RAIL_TEXTURE
        rails.add_child(rail_sprite)
    else: 
        rail_sprite = rails.get_child(0)
        rails.move_child(rail_sprite, -1)
    rail_pos += RAIL_WIDTH
    rail_sprite.global_position.x = rail_pos