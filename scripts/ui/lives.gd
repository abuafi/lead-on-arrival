extends HBoxContainer
class_name LifeCounter

const LIFE: PackedScene = preload("res://scenes/life_heart.tscn")

var num_lives: int 
var world: World

signal game_over()

func start_game(_world: World):
    self.world = _world
    var tween: Tween = create_tween()
    tween.tween_method(set_lives, 0, 10, 1.)

func set_lives(lives: int):
    if num_lives == lives: return 
    while num_lives < lives:
        add_life()

func add_life():
    if num_lives >= 20: return
    var heart: TextureRect = LIFE.instantiate()
    num_lives += 1
    add_child(heart)

func on_life_lost():
    if num_lives > 0 and get_child_count() > 0:
        num_lives -= 1
        remove_child(get_child(0))
    if num_lives == 0: game_over.emit()
