extends Node
class_name BehaviourNode

signal passed(node: BehaviourNode)
signal failed(node: BehaviourNode)
signal post_finish(node: BehaviourNode)

var active: bool = false
var entity: CharacterEntity

func setup(_entity: CharacterEntity):
    self.entity = _entity
    passed.connect(finish)
    failed.connect(finish)

func finish(node: BehaviourNode):
    post_finish.emit(node)

func node_passed():
    passed.emit(self)
    exit()

func node_failed():
    failed.emit(self)
    exit()

func bt_physics_process(_delta: float) -> void:
    pass

func bt_next() -> BehaviourNode:
    return null

var entered: bool = false

func enter() -> void:
    entered = true

func exit() -> void: 
    entered = false