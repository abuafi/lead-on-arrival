# Chase the detected player.
extends BehaviourLeaf
class_name Debug 

@export var print_string: String

func enter():
    super.enter()
    print(print_string)
    node_passed()