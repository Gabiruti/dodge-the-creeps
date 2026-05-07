extends RigidBody2D
signal init_buff(type: String)

var type = "starbuff"

func emit_buff():
	print("buff touch!")
	init_buff.emit(type)
	queue_free()
	
