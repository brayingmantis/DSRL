extends Resource

class_name ai_resource

@export var ai_state: ai_states

enum ai_states {
	passive,
	hostile,
	fleeing,
	distracted,
}
