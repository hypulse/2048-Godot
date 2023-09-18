extends Node2D

const tile = preload("res://Scenes/Tile.tscn")
const SIZE = 4
var board: Array = []


func _ready():
	resetBoard()


func _process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		moveTiles(Vector2.LEFT)
	elif Input.is_action_just_pressed("ui_right"):
		moveTiles(Vector2.RIGHT)
	elif Input.is_action_just_pressed("ui_up"):
		moveTiles(Vector2.UP)
	elif Input.is_action_just_pressed("ui_down"):
		moveTiles(Vector2.DOWN)


func resetBoard():
	# fill board with 0
	for i in range(SIZE):
		board.append([])
		for j in range(SIZE):
			board[i].append(0)

	# add 2 random tiles
	addRandomTile()
	addRandomTile()

	# update graphic
	drawGraphic()


func addRandomTile():
	var emptySpaces = []

	# save empty space coordinates
	for row in range(SIZE):
		for col in range(SIZE):
			if board[row][col] == 0:
				emptySpaces.append(Vector2(row, col))

	if emptySpaces.size() > 0:
		var target = emptySpaces[randi() % emptySpaces.size()]
		var number = 2 if randf() < 0.9 else 4
		board[target.x][target.y] = number


func mergeTilesToLeft(line: Array) -> Array:
	var mergedLine = []
	for i in range(SIZE):
		mergedLine.append(0)

	var prevNum = -1
	var targetIndex = 0

	for i in range(SIZE):
		if line[i] != 0:
			if prevNum == -1:
				prevNum = line[i]
			else:
				if prevNum == line[i]:
					mergedLine[targetIndex] = prevNum * 2
					prevNum = -1
				else:
					mergedLine[targetIndex] = prevNum
					prevNum = line[i]
				targetIndex += 1

	if prevNum != -1:
		mergedLine[targetIndex] = prevNum

	return mergedLine


func mergeBoardToLeft():
	for i in range(SIZE):
		board[i] = mergeTilesToLeft(board[i])


func moveTiles(direction: Vector2):
	if direction == Vector2.LEFT:
		mergeBoardToLeft()
	elif direction == Vector2.RIGHT:
		rotateBoardClockwise(2)
		mergeBoardToLeft()
		rotateBoardClockwise(2)
		pass
	elif direction == Vector2.UP:
		rotateBoardClockwise(3)
		mergeBoardToLeft()
		rotateBoardClockwise(1)
		pass
	elif direction == Vector2.DOWN:
		rotateBoardClockwise(1)
		mergeBoardToLeft()
		rotateBoardClockwise(3)
		pass

	if isFull():
		var isGameOver = true
		for i in range(SIZE):
			for j in range(SIZE):
				if j < SIZE - 1 and board[i][j] == board[i][j + 1]:
					isGameOver = false
					break
				if i < SIZE - 1 and board[i][j] == board[i + 1][j]:
					isGameOver = false
					break
		if isGameOver:
			print("Game Over")
	else:
		addRandomTile()

	drawGraphic()


func rotateBoardClockwise(times: int):
	for i in range(times):
		var rotatedBoard = []
		for j in range(SIZE):
			var newRow = []
			for k in range(SIZE):
				newRow.append(board[k][j])
			newRow.reverse()
			rotatedBoard.append(newRow)

		board = rotatedBoard


func isFull() -> bool:
	for i in range(SIZE):
		for j in range(SIZE):
			if board[i][j] == 0:
				return false
	return true


func drawGraphic():
	# remove all tiles instances
	for i in range(get_node("Tiles").get_child_count()):
		get_node("Tiles").get_child(i).queue_free()

	for row in range(SIZE):
		for col in range(SIZE):
			if board[row][col] != 0:
				var newTile = tile.instantiate()
				newTile.value = board[row][col]
				newTile.position = Vector2(col * 32, row * 32)
				get_node("Tiles").add_child(newTile)

	for i in range(SIZE):
		print(board[i])
	print("----------------")
