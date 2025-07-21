extends Node

var iOrder := []
var iReal := []
var iSprites := []
var currentTurn := 0
var round := 0

var text = ""
var mode = 0
var inUI = false
var tooltip := false
var tooltip_char = null
var tooltip_type = "None"
var ai_move = false
var aiInPlay = false


func nextTurn():
	
	
	if currentTurn >= iReal.size():
		currentTurn = 0
		for i in iReal:
			i[1].resetMovement()
	else:
		currentTurn += 1
		if currentTurn < iReal.size() and iSprites[currentTurn] == null:
			currentTurn += 1
			ai_move = false
			aiInPlay = false
	
	if currentTurn >= iReal.size():
		currentTurn = 0
		for i in iReal:
			i[1].resetMovement()

	if iReal[currentTurn][1].isenemy:
		ai_move = true
		aiInPlay = true
	
	

func initiativeOrder():
	
	for i in iOrder:
		i[0].setUp
		var init = i[0].returnRoll("Dexterity")
		iReal.append([init, i[0], i[1]])
		
	
	iReal.sort_custom(func(a, b): return a[0] > b[0])
	
	
	if iReal[currentTurn][1] as MobBase:
		ai_move = true
		aiInPlay = true
		
	
