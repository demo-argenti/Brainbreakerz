class_name Prefs
extends Object
## Global storage of current player preferences.
## Does not need to be another autoload if we keep everything static.
## TODO user profiles.

static var volume : Dictionary[String,float] = {
	"master"    : 1.0,
	"music"     : 1.0,
	"sfx"       : 1.0,
	"hitsounds" : 1.0
}
static var binds # TODO
const FILEPATH = "user://prefs"

static func setup() -> void:
	var cfg = ConfigFile.new()
	if cfg.load(FILEPATH) != OK:
		print("no config?")
		return
	volume.master    = cfg.get_value("volume","master",   1.0)
	volume.music     = cfg.get_value("volume","music",    1.0)
	volume.sfx       = cfg.get_value("volume","sfx",      1.0)
	volume.hitsounds = cfg.get_value("volume","hitsounds",1.0)
	
	set_bus_volumes()
	
	Calibration.audio_latency         = cfg.get_value("calibration","audio",0.0)
	Calibration.visual_latency_offset = cfg.get_value("calibration","video",0.0)
	Calibration.has_done_calibration  = cfg.get_value("calibration","completed",false)


static func set_bus_volumes() -> void:
	var bus_names := []
	for i in AudioServer.bus_count:
		bus_names.append(AudioServer.get_bus_name(i).to_lower())
	for key in volume.keys():
		AudioServer.set_bus_volume_linear(bus_names.find(key), volume[key])


static func save() -> void:
	var cfg = ConfigFile.new()
	cfg.set_value("volume","master",   volume.master)
	cfg.set_value("volume","music",    volume.music)
	cfg.set_value("volume","sfx",      volume.sfx)
	cfg.set_value("volume","hitsounds",volume.hitsounds)
	cfg.set_value("calibration","audio",    Calibration.audio_latency)
	cfg.set_value("calibration","video",    Calibration.visual_latency_offset)
	cfg.set_value("calibration","completed",Calibration.has_done_calibration)
	cfg.save(FILEPATH)
