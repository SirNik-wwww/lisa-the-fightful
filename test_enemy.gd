extends Area2D

var may_interect : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_body_entered(_body: Node2D) -> void:
	$"../CharacterBody2D/Label".visible = true
	may_interect = true

func _on_body_exited(_body: Node2D) -> void:
	$"../CharacterBody2D/Label".visible = false
	may_interect = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and may_interect == true:
		print("sdasdasdasdasd")
