extends Control
class_name GameOver

@onready var return_to_menu_button: Button = $PanelContainer/VBoxContainer/Menu

var ui: GameUI

func _ready():
    return_to_menu_button.pressed.connect(return_to_menu)

func return_to_menu():
    var new_ui = GameUI.UI_SCENE.instantiate()
    var root: Node = ui.get_parent()
    root.remove_child(ui)
    root.add_child(new_ui)
    ui.queue_free()
    root.get_tree().paused = false