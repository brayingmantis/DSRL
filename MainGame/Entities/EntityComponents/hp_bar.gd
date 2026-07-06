extends ProgressBar
class_name HPBar

var change_value_tween: Tween
var opacity_tween: Tween

func _setup_hp_bar(max_val: float):
	value = max_val
	max_value = max_val
	$ProgressBar.value = max_val
	$ProgressBar.max_value = max_val

func change_value(new_value: float):
	
	value = new_value
	
	if change_value_tween:
		change_value_tween.kill()
	change_value_tween = create_tween()
	change_value_tween.tween_property($ProgressBar, "value", new_value, 0.35).set_trans(Tween.TRANS_SINE)
