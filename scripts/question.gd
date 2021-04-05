extends ColorRect

var questions = [
{"Question":"What is CORONA VIRUS ?","Answer1":"It is a Large Family of Virus","Answer2":"It belongs to family of Nido Virus","Answer3":"Both","CorrectAnswer":"Both"},

{"Question":"Official Name of CORONA virus ?","Answer1":"COVID-19","Answer2":"COVn-19","Answer3":"ConV-19","CorrectAnswer":"COVID-19"},

{"Question":"The first case of novel CORONA virus located in ?","Answer1":"Beijing","Answer2":"Shanghai","Answer3":"Wuhan","CorrectAnswer":"Wuhan"},

{"Question":"Mild symptoms of novel CORONA Virus","Answer1":"Fever","Answer2":"Shortness of breath","Answer3":"Both","CorrectAnswer":"Both"},

{"Question":"What happens to a person suffering from CORONA ?","Answer1":"80% Recover on their own","Answer2":"Less than 20% needs hospitilization","Answer3":"Both","CorrectAnswer":"Both"},

{"Question":"Which age group the COVID-19 spreads ?","Answer1":"Older people at high risk","Answer2":"Mild in children","Answer3":"Both","CorrectAnswer":"Both"},

{"Question":"How does CORONA virus transmit ?","Answer1":"Droplets due to sneeze/cough","Answer2":"Distance is less than 1 meter from infected person","Answer3":"Both","CorrectAnswer":"Both"},

{"Question":"From where CORONA virus got its name ?","Answer1":"Due to their crown - Like projections","Answer2":"Due to their leaf - Like projections","Answer3":"None","CorrectAnswer":"Due to their crown - Like projections"},

{"Question":"What are the precautions are need to be taken to protect from CORONA virus","Answer1":"Cover your nose and mouth when sneezing","Answer2":"Add more garlic into diet","Answer3":"Visit your doctor for Antibiotics ","CorrectAnswer":"Cover your nose and mouth when sneezing"},

{"Question":"How many minimum days are required to recover from COVID for healthy person","Answer1":"5 days","Answer2":"14 days","Answer3":"10 days","CorrectAnswer":"14 days"},

{"Question":"Which vitamin helps you to increase immunity ?","Answer1":"Vitamin- C","Answer2":"Vitamin- A","Answer3":"Vaitamin- K","CorrectAnswer":"Vaitamin- C"},

{"Question":"Which type of food increases immunity ?","Answer1":"Dry fruits & Helathy Vegetables","Answer2":"Junk Food","Answer3":"None","CorrectAnswer":"Dry fruits & Helathy Vegetables"}

]


var random = RandomNumberGenerator.new()

func _ready():
	get_tree().paused = true
	random.randomize()
	var random_number = random.randf_range(0,10)
	$question.text = questions[random_number]["Question"]
	$answeButtons/answer1.text = questions[random_number]["Answer1"]
	$answeButtons/answer2.text = questions[random_number]["Answer2"]
	$answeButtons/answer3.text = questions[random_number]["Answer3"]
	for answer in $answeButtons.get_children():
		answer.connect('pressed',self,'check_answer',[answer,random_number])
func check_answer(answer,random_number):
	if answer.text == questions[random_number]["CorrectAnswer"]:
		Global.coins += 2
		$correct.play()
	else :
		$incorrect.play()
	$correctAnswer.text = questions[random_number]["CorrectAnswer"]
	for answer in $answeButtons.get_children():
		if answer.text == questions[random_number]["CorrectAnswer"]:
			answer.disabled = true
			answer.hover = true
			
			pass
		else:
			answer.disabled = true
	$timer.start()

func _on_timer_timeout():
	queue_free()
	get_tree().paused = false
