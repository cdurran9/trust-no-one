extends Node

signal player_observation_changed(is_observed : bool)

var observing_player: Array[Node3D] = []

func register(method: Callable):
	player_observation_changed.connect(method)
	
func add_observer(observer: Node3D):
	if observing_player.has(observer): return
	var was_unobserved := observing_player.size() == 0
	observing_player.append(observer)
	if was_unobserved: player_observation_changed.emit(true)
	print("Added {observer}, and player is now {observed}".format({
		"observer": observer,
		"observed": "observed" if observing_player.size() > 0 else "not observed"
	}))
	
func remove_observer(observer: Node3D):
	if not observing_player.has(observer): return
	var was_observed := observing_player.size() > 0
	observing_player.erase(observer)
	if was_observed and observing_player.size() == 0:
		player_observation_changed.emit(false)
	print("Removed {observer}, and player is now {observed}".format({
		"observer": observer,
		"observed": "observed" if observing_player.size() > 0 else "not observed"
	}))
