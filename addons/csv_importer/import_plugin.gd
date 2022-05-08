tool
extends EditorImportPlugin


enum Presets {
    DEFAULT
}


func import(
    source_file: String, save_path: String, options: Dictionary,
    platform_variants: Array, gen_files: Array
) -> int:
    var csv_data: CSVData = CSVData.new()

    var file: File = File.new()
    var error = file.open(source_file, File.READ)
    if error != OK:
        return error

    var i: int = -1
    var header_line: PoolStringArray
    while true:
        i += 1

        if i == 0:
            header_line = file.get_csv_line()
            continue

        var line: PoolStringArray = file.get_csv_line()
        var object: Object = load(options["class_script_path"]).new()

        for j in header_line.size():
            object.set(header_line[j], line[j])

        csv_data.data[object.get(options["id_column_name"])] = object

        if file.eof_reached():
            break

    file.close()

    return ResourceSaver.save(
        "%s.%s" % [save_path, get_save_extension()], csv_data
    )


func get_preset_count() -> int:
    return Presets.size()


func get_import_options(preset: int) -> Array:
    match preset:
        Presets.DEFAULT:
            return [
                {
                    "name": "class_script_path",
                    "default_value": "",
                    "property_hint": PROPERTY_HINT_FILE
                },
                {
                    "name": "id_column_name",
                    "default_value": "id"
                }
            ]
        _:
            return []


func get_preset_name(preset: int) -> String:
    return Presets.keys()[preset]


func get_option_visibility(option: String, options: Dictionary) -> bool:
    return true


func get_importer_name():
    return "anaxie.object_csv"


func get_visible_name() -> String:
    return "Object CSV"


func get_recognized_extensions() -> Array:
    return ["csv"]


func get_save_extension() -> String:
    return "res"


func get_resource_type() -> String:
    return "Resource"
