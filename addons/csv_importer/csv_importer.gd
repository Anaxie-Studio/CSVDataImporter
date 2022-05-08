tool
extends EditorPlugin


var import_plugin


func _enter_tree():
    add_custom_type(
        "CSVData", "Resource",
        preload("res://addons/csv_importer/csv_data.gd"),
        null
    )
    
    import_plugin = preload("import_plugin.gd").new()
    add_import_plugin(import_plugin)


func _exit_tree():
    remove_import_plugin(import_plugin)
    remove_custom_type("CSVData")
    import_plugin = null
