extends Node

var key = preload("res://Scenes/Key.tscn")
var keyPos = []
var keysArray = []
var size = keyPos.size()
 
func getPosAndRemove():
	for nodes in get_tree().get_nodes_in_group("Keys"):
		Globals.keysToRemove.append(nodes)
		keysArray.append(nodes.get_name())
		keyPos.append(nodes.get_global_position())
		nodes.queue_free()
	return [keysArray, keyPos]

func spawnKeys():
	for x in range(0, size):
		if keysArray.size() <= x:
			var spawnKey = key.instance()
			spawnKey.position = keyPos[x]
			spawnKey.set_name(keysArray[x])
			get_tree().get_root().call_deferred("add child", spawnKey)
			keysArray.pop_front(spawnKey)
		elif keysArray[x] == null:
			var spawnKey = key.instance()
			spawnKey.position = keyPos[x]
			spawnKey.set_name(keysArray[x])
			get_tree().get_root().call_deferred("add child", spawnKey)
			keysArray[x] = spawnKey

