extends Node

var northaven = preload("res://scripts/resources/towns and landmarks/Northaven.tres")
var gensonPeak = preload("res://scripts/resources/towns and landmarks/Genson’s Peak.tres")
var compass = preload("res://scripts/resources/towns and landmarks/Compass Crossing.tres")

# Player Stuff
var gold = 1000
var food = 0 # rations 
var inv := []
var load_inv = false

const PROF_BONUS_LV1 = 2
const PROF_BONUS_LV2 = 3
const CHAR_HUNGER = 2 # 8 pounds per day so for 100 miles --> 80 pounds at 10 ml pace

var miles_total: int = 0

var speed_slow = 3
var speed_steady = 5
var speed_strenous = 7
var speed_grueling = 10
var current_speed = 5
var run: bool = false

var landmarks: Array = [gensonPeak, compass]
var inTown: bool = true
var inEquipMenu := false
var inTradeMenu := false
var inWagonMenu := false
var town: TownBase = northaven

# Time (time_day --> morning = 1, noon = 2, evening = 3)
var day = 100
var time_day = 1
var weather = 0 
# w_ = 0 -> clear
# w_ = 1 -> raining
# w_ = 2 -> muddy
# w_ = 3 -> foggy
# w_ = 4 -> snowing (?)

func add_items():
	inv.append(Catalog.battleaxe.duplicate(true))
	inv.append(Catalog.longsword.duplicate(true))
	inv.append(Catalog.shortsword.duplicate(true))
	inv.append(Catalog.torch.duplicate(true))
	inv.append(Catalog.shovel.duplicate(true))
	inv.append(Catalog.chain_mail.duplicate(true))
	inv.append(Catalog.leather_armor.duplicate(true))

func move():
	
	time_day += 1
	if (time_day == 4):
		time_day = 1
		day += 1
		food -= CHAR_HUNGER * 4
	else:
		miles_total += current_speed
	
	if landmarks[0].milesAway - miles_total <= 0:
		inTown = true
		town = landmarks[0]
		landmarks.pop_front()
		run = false
	else:
		EncounterManager.randomEncounterTick()

func getTime() -> String:
	
	var time: String = ""
	var found = false
	var temp_day = day
	var temp = day
	if (temp_day <= 31):
		time += "January "
		found = true
	temp_day -= 31
	if (temp_day <= 28 and found == false):
		time += "February "
		found = true
		temp -= 31
	temp_day -= 28
	if (temp_day <= 31 and found == false):
		time += "March "
		found = true
		temp -= 28 + 31
	temp_day -= 31
	if (temp_day <= 30 and found == false):
		time += "April "
		found = true
		temp -= 31 + 31 + 28
	temp_day -= 30
	if (temp_day <= 31 and found == false):
		time += "May "
		found = true
		temp -= 30 + 31 + 31 + 28
	temp_day -= 31
	if (temp_day <= 30 and found == false):
		time += "June "
		found = true
		temp -= 31 + 30 + 31 + 31 + 28
	temp_day -= 30
	if (temp_day <= 31 and found == false):
		time += "July "
		found = true
		temp -= 30 + 31 + 30 + 31 + 31 + 28
	temp_day -= 31
	if (temp_day <= 31 and found == false):
		time += "August "
		found = true
		temp -= 31 + 30 + 31 + 30 + 31 + 31 + 28
	temp_day -= 31
	if (temp_day <= 30 and found == false):
		time += "September "
		found = true
		temp -= 31 + 31 + 30 + 31 + 30 + 31 + 31 + 28
	temp_day -= 30
	if (temp_day <= 31 and found == false):
		time += "October "
		found = true
		temp -= 30 + 31 + 31 + 30 + 31 + 30 + 31 + 31 + 28
	temp_day -= 31
	if (temp_day <= 30 and found == false):
		time += "November "
		found = true
		temp -= 31 + 30 + 31 + 31 + 30 + 31 + 30 + 31 + 31 + 28
	temp_day -= 30
	if (temp_day <= 31 and found == false):
		time += "Decemeber "
		found = true
		temp -= 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30 + 31 + 31 + 28
	temp_day -= 31
	
	time = str(temp) + " " + time
	
	if (time_day == 1):
		time += "Morning"
	elif (time_day == 2):
		time += "Noon"
	elif (time_day == 3):
		time += "Evening"
		
	return time

func getSpeed() -> String:
	
	if current_speed == speed_slow:
		return "Slow"
	elif current_speed == speed_steady:
		return "Steady"
	elif current_speed == speed_strenous:
		return "Strenous"
	elif current_speed == speed_grueling:
		return "Grueling"
	else:
		return "Stopped"

func getWeather():
	if weather == 0:
		return "Clear"
	elif weather == 1:
		return "Raining"
	elif weather == 2:
		return "Muddy"
	elif weather == 3:
		return "Foggy"
	elif weather == 4:
		return "Snowing"
