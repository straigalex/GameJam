extends Marker3D

var hmap:ViewportTexture

func get_water_height(height_map:Image) -> float:
	var ex = global_position.x + 10
	var zed = global_position.z + 10
	var X = ex * 25
	var Y = zed * 25
	var h = height_map.get_pixel(X,Y).r
	return h
	

#func _process(time):
	
#	var img = hmap.get_image()
#	
#	var ex = global_position.x + 10
#	var zed = global_position.z + 10
#	
#	var X = ex * 25
#	var Y = zed * 25
#	
#	var h = img.get_pixel(X,Y).r
#	
#	print(h)
#	pass
