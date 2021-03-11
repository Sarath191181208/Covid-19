extends ColorRect

	
var random = RandomNumberGenerator.new()
var questions = [
	{"question" : " what si your name","answer1":"sarath","answer2":"balbalbal","correctanswer":"1"},
	#question 1 ends and seperated by a coma
	{"question" : "what siame","answer1":"sarath","answer2":"balbalbal","correctanswer":"1"},	
	#question 2 ends and seperated by a coma
	{"question" : "what si your name","answer1":"srath","answer2":"balbalbal","correctanswer":"1"},
	#last element doesnt have a coma
]
func _ready():
	get_tree().paused = true
	random.randomize()
	var random_number = random.randf_range(0,2)
	$question.text = questions[random_number]["question"]
	$answeButtons/answer1.text = questions[random_number]["answer1"]
	$answeButtons/answer2.text = questions[random_number]["answer2"]
	for answer in $answeButtons.get_children():
		answer.connect('pressed',self,'check_answer',[answer.name,random_number])
func check_answer(answer,random_number):
	if int(answer) == int(questions[random_number]["correctanswer"]) :
		Global.coins += 5
	else :
		pass
	queue_free()
	get_tree().paused = false
