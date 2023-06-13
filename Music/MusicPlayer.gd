extends AudioStreamPlayer

# filepath to directory containing songs ya wanna play
@export var directory_path = "res://Music/Opening/"
var dir = DirAccess.open(directory_path)

# array of music files in directory
var files

# reference to loaded file for next section of song in queue
var next



# Called when the node enters the scene tree for the first time.
func _ready():
	# when section is finished, advance to next section
	finished.connect(advance_section)
	
	# if directory is good, get clean files and play
	if dir:
		files = dir.get_files()
		clean_files()
		start_song()
	else:
		print("Unable to open directory  ", directory_path)

# set files to new array of strings of filenames of type .wav, .mp3, or .ogg
func clean_files():
	var cleaned = []
	for i in files:
		if i.ends_with(".wav") or i.ends_with(".mp3") or i.ends_with(".ogg"):
			cleaned.append(i)
	files = cleaned

# FOR TESTING PURPOSES ONLY
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		print("Advancing")
		advance_section()

# start the song
func start_song():
	next = load(directory_path + files[0]) # initialize next
	play_next() # play

# plays the next section of the song in queue
func play_next():
	print("Now playing : ", files[0])
	set_stream(next) # set stream and play
	play()
	files.remove_at(0) # remove from queue
	
	if (len(files) > 0): # start loading next now if exists
		next = load(directory_path + files[0]) 

# advance to the next section of the song
func advance_section():
	if len(files) != 0:
		play_next()
