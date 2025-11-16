extends Marker3D

var hmap:ViewportTexture

func get_water_height(height_map:Image,offset:Vector2i) -> float:
	var ex = global_position.x - (offset.x - 20)
	var zed = global_position.z - (offset.y - 20)
	var X = ex * 12.5
	var Y = zed * 12.5
	if(X >= 0 && X <= 500 && Y >= 0 && Y <= 500):
		var h = height_map.get_pixel(X,Y).r
		return h
	return 0
	
	

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
