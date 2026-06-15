class_name ChartDef extends Resource

const Lane = Global.Lane

@export var difficulty := "Normal"
@export var mapper := ""
# TODO can this not just be a 2D array?
@export var notes : Dictionary = {  "track_1": [],
									"track_2": [],
									"track_3": []  }
## Override any top-level property from the SongDef. Including the audio file!
@export var overrides := {}

# we're just throwing away the metadata. put this in songdef later
static func pull_charts_from_file(filename:String) -> Array[ChartDef]:
	var charts : Array[ChartDef] = []
	var source_charts : Array
	
	if filename.ends_with(".sm"):
		var reader := SM_Reader.new()
		reader.filename = filename.split("/")[-1].trim_suffix(".sm") # lol. lmao
		print(reader.filename)
		reader.set_file()
		reader.read_file()
		source_charts = reader.charts # we don't even need to duplicate it?????
		reader.free()
	elif filename.ends_with(".json"):
		var f = FileAccess.open(filename,FileAccess.READ)
		var e = FileAccess.get_open_error()
		if e:
			print(error_string(e))
			return []
		var json : Dictionary = JSON.parse_string(f.get_as_text())
		assert(json.has("charts"))
		source_charts = json["charts"]
		f.close()
	
	for chart_dict in source_charts: charts.append(ChartDef.from_dict(chart_dict))
	return charts

# this sucks (we make it static and pass in a chart so we can use it in tool mode)
static func to_dict(chart:ChartDef) -> Dictionary:
	var out := {}
	for prop in chart.get_script().get_script_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			out.set(prop.name,chart.get(prop.name))
	return out


static func from_dict(dict:Dictionary) -> ChartDef:
	var chart = ChartDef.new()
	# should we warn if one of these keys is missing?
	chart.difficulty = dict.get("difficulty")
	
	chart.notes = dict.get("notes",{    # charts from SMReader have a flat structure
		"track_1": dict.get("track_1"), # godot constructs this dict before
		"track_2": dict.get("track_2"), # checking whether dict.notes exists
		"track_3": dict.get("track_3"), # therefore we have to use get-or-null
	})
	chart.overrides  = dict.get("overrides",{})
	return chart
