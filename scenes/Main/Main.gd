extends Node

export(PackedScene) var mob_scene
var score
var high_score
var velocity = Vector2(0.0, 500.0)
var last_mob_position

func _ready():
	load_game()
	randomize()

func reset_props():
	$MobTimer.wait_time = 1.6
	velocity = Vector2(0.0, 500.0)
	$ParallaxBackground.speed = 200

func game_over():
	save_game()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	reset_props()
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	var mob_possibles_to_spawn = [193.0, 398.0]
	mob_spawn_location.offset = mob_possibles_to_spawn[randi() % mob_possibles_to_spawn.size()]
	
	mob.position = mob_spawn_location.position
	
	if(score % 10 == 0):
		if(velocity.y < 1500.0):
			velocity.y += 100.0
		if($MobTimer.wait_time > 0.5):
			$MobTimer.wait_time -= 0.15
		if($ParallaxBackground.speed < 1100):
			$ParallaxBackground.speed += 100
		mob.position = last_mob_position

	mob.linear_velocity = velocity
	last_mob_position = mob.position
	add_child(mob)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func save_game():
	if(score > high_score):
		var save = File.new()
		save.open("user://save.cfg", File.WRITE)
		save.store_line(String(score))
		save.close()

func load_game():
	var cfgFile = File.new()
	if not cfgFile.file_exists("user://save.cfg"):
		save_game()
		return
	cfgFile.open("user://save.cfg", File.READ)
	high_score =  int(cfgFile.get_as_text())
	$HUD.update_score(high_score)
