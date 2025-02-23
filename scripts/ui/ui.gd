extends Control
class_name GameUI 

@onready var world_container: SubViewportContainer = $SubViewportContainer
@onready var world: World = $SubViewportContainer/SubViewport/World
@onready var camera: GameCamera = $SubViewportContainer/SubViewport/Camera2D
@onready var main_menu: MainMenu = $MainMenu
@onready var pause_panel: Pause = $Pause
@onready var life_counter: LifeCounter = $Lives
@onready var score: Score = $Score
@onready var game_over_panel: GameOver = $GameOver

const UI_SCENE: PackedScene = preload("res://scenes/ui.tscn")
var game_running: bool = false

func _ready():
    pause_panel.ui = self
    game_over_panel.ui = self
    open_main_menu()

func open_main_menu():
    camera.main_menu = true
    pass

func start_game():
    camera.main_menu = false
    world.start_game()
    main_menu.fade_off()

    life_counter.start_game(world)
    world.life_lost.connect(life_counter.on_life_lost)
    world.level_ready.connect(func(_arg): life_counter.add_life())
    life_counter.game_over.connect(_on_game_over)

    score.start_game()
    world.level_ready.connect(score.on_level_ready)
    world.life_lost.connect(score.on_level_reloaded)

    game_running = true

func _input(event: InputEvent) -> void:
    if not game_running: return
    if event.is_action_pressed(&"pause"):
        pause()

func pause():
    pause_panel.show()
    world.get_tree().paused = true

func _on_game_over():
    game_over_panel.show()
    score.save_high_score()
    world.get_tree().paused = true