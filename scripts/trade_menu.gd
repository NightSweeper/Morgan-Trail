extends ColorRect

@export var town_inv: ItemList
@export var shop_list: ItemList

var update := true
var item : ItemBase = null
var max_amount := 0
var selling_amount := 0

var buy_list = []
var gold_amount = 0
var shopListUpdate : bool = false

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	
	$location.text = Global.town.townName
	$time.text = "Time: " + Global.getTime()
	
	if update:
		$tradelist2/gold_amount2.text = "You have " + str(Global.gold) + " gold"
		updateInv()
		update = false
	
	if item:
		$item_view/itemName.text = item.itemName
		$item_view/itemDescr.text = item.itemDesc
	else:
		
		$item_view/itemName.text = "None"
		$item_view/itemDescr.text = ""
	
	if shopListUpdate:
		updateShopList()
	
func updateInv():
	town_inv.clear()
	for i in Global.town.itemsSell.keys():
			town_inv.add_item(i + " x" + str(Global.town.itemsSell[i][1]))

func updateShopList():
	
	$tradelist2/gold_amount2.text = "You have " + str(Global.gold) + " gold"
	shop_list.clear()
	for i in buy_list:
		shop_list.add_item(i[0].itemName + " x"  + str(i[1]), null, false)
	
	gold_amount = 0
	for i in buy_list:
		gold_amount += i[0].itemCost * i[1]
	
	$tradelist2/gold_amount.text = "Amount: " + str(gold_amount)

func _on_line_edit_text_changed(new_text: String) -> void:
	print(new_text)


func _on_item_list_item_selected(index: int) -> void:
	$item_view/buy.show()
	$item_view/LineEdit.show()
	$item_view/Label.show()
	item = Global.town.itemsSell[Global.town.itemsSell.keys()[index]][0]
	print(Global.town.itemsSell.keys()[index])
	max_amount = Global.town.itemsSell[Global.town.itemsSell.keys()[index]][1]
	print(max_amount)


func _on_buy_pressed() -> void:
	
	
	$item_view/Label2.hide()
	var have = false
	var index = 0
	if $item_view/LineEdit.text.is_valid_int() and int($item_view/LineEdit.text) <= max_amount:
		for i in buy_list:
			if item == i[0]:
				have = true
				break
			index += 1
		if have:
			buy_list.set(index, [item, int($item_view/LineEdit.text)])
		else:
			buy_list.append([item, int($item_view/LineEdit.text)])
		shopListUpdate = true
		$item_view/LineEdit.clear()
	else:
		print("Not valid amount!")
		$item_view/Label2.show()
	


func _on_button_pressed() -> void:
	
	for i in buy_list:
		for j in i[1]:
			if i[0].itemName != "Ration":
				Global.inv.append(i[0].duplicate(true))
			else:
				Global.food += 10
	
	buy_list.clear()
	shopListUpdate = true
	Global.gold -= gold_amount
	print(Global.inv)


func _on_exit_pressed() -> void:
	Global.inTradeMenu = false
