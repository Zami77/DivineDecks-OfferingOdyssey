extends Node

enum BgmPlaying { MAIN_MENU, MATCH, NONE }

var num_players = 16
var bus_master = "Master"
var bus_sound_effects = "SoundEffects"
var bus_music = "Music"

var bgm_player = AudioStreamPlayer.new()
var bgm_playing = BgmPlaying.NONE
var available_players = []  
var sfx_queue = []  

var rng = RandomNumberGenerator.new()

var costume_cat_completed = "res://costume_cats/costume_cat_sound_fx/LQ_Positive_Notification.wav"

var whoosh = [
	"res://src/common/sound_fx/card_sound_fx/FA_Whoosh_1_1.wav", 
	"res://src/common/sound_fx/card_sound_fx/FA_Whoosh_1_2.wav", 
	"res://src/common/sound_fx/card_sound_fx/FA_Whoosh_1_3.wav"
]

var button_press = "res://src/ui/default_button/FA_Confirm_Button_1_1.wav"
var button_hover = "res://src/ui/default_button/button_hover.wav"

var main_menu_songs = [
	"res://common/music/menu_theme.wav"
]

var match_songs = [
	"res://common/music/match_music.wav"
]

func _ready():
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available_players.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus_sound_effects
	
	bgm_player.bus = bus_music
	bgm_player.finished.connect(_on_bgm_player_finished)
	add_child(bgm_player)
		
	rng.randomize()

func _on_stream_finished(stream) -> void:
	stream.stop()
	available_players.append(stream)

func _on_bgm_player_finished():
	match bgm_playing:
		BgmPlaying.MAIN_MENU:
			bgm_playing = BgmPlaying.NONE
			play_menu_theme()
		BgmPlaying.MATCH:
			bgm_playing = BgmPlaying.NONE
			play_match_theme()

func play_bgm(sound_path):
	_fadeout_bgm()
	bgm_player.stream = load(sound_path)
	bgm_player.play()

func play_sfx(sound_path):
	sfx_queue.append(sound_path)

func play_match_theme() -> void:
	if bgm_playing == BgmPlaying.MATCH:
		return
	
	bgm_playing = BgmPlaying.MATCH
	play_bgm(match_songs[0])
	
func play_menu_theme() -> void:
	if bgm_playing == BgmPlaying.MAIN_MENU:
		return
	
	bgm_playing = BgmPlaying.MAIN_MENU
	play_bgm(main_menu_songs[0])
	
func _fadeout_bgm():
	bgm_player.stop()

func play_button_press() -> void:
	play_sfx(button_press)

func play_button_hover() -> void:
	play_sfx(button_hover)

func play_card_move() -> void:
	play_sfx(whoosh[rng.randi_range(0, len(whoosh) - 1)])

func _process(delta):
	if not sfx_queue.is_empty() and not available_players.is_empty():
		available_players[0].stream = load(sfx_queue.pop_front())
		available_players[0].play()
		available_players.pop_front()
