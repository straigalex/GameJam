extends Node3D

var sim = preload("res://gamescene/sim.tscn")

var tiles:Dictionary[Vector2i, ViewportTexture]

func _ready():
	var x = -120
	var y = -120
	while(x < 120):
		while(y < 120):
			var simuli = sim.instantiate()
			add_child(simuli)
			simuli.owner = self
			simuli.global_position.x = x + 10
			simuli.global_position.z = y + 10
			simuli.update_camera()
			tiles.set(Vector2i(x+10,y+10),simuli.simtex)
			y += 20
		y = -120
		x += 20
	
	GameState.TILES = tiles
	
#	var simuli = sim.instantiate()
#	add_child(simuli)
#	simuli.owner = self
#	simuli.global_position.x = 30
#	simuli.global_position.z = 30
#	simuli.update_camera()
#	tiles.set(Vector2i(30,30),simuli.simtex)
