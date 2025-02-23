extends Control
class_name MainMenu

@onready var ui: GameUI = $".."
@onready var start_game_button: Button = $Margins/Menu/Buttons/Start
@onready var how_to_play_button: Button = $Margins/Menu/Buttons/HowToPlay
@onready var how_to_play: Control = $HowToPlay
@onready var how_to_play_close_button: Button = $HowToPlay/MarginContainer/PanelContainer/VBoxContainer/ButtonMargins/Button

func _ready():
    start_game_button.pressed.connect(ui.start_game)
    how_to_play_button.pressed.connect(open_how_to_play)
    how_to_play_close_button.pressed.connect(close_how_to_play)

func fade_off():
    var tween: Tween = create_tween()
    tween.tween_property(
        self,
        ^"modulate:a",
        0, 1.)
    tween.tween_callback(hide)

func open_how_to_play():
    how_to_play.show()

func close_how_to_play():
    how_to_play.hide()