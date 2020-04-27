global ROAMING := A_AppData "\ChipysUtilityLibrary"
global INI_FILE_NAME := "config.ini"
global DEPS := DependencyManager.new()
global DEBUG := 0	
global global_hud_obj1 := NewHUD.new(".",1)
global global_hud_obj2 := NewHUD.new(". .",2)
global global_hud_obj3 := NewHUD.new(". . .",3)

;TODO build timer base threat manager
class TimerThreadTool {
	__new(){
		this.bound_obj_map := map()
		this.interval_map := map()
		this.target_client_map := map()
	}

	_add(){

	}

	_bind(){

	}

	start(){

	}

	stop(){

	}
}

; ;TODO add a check array for each entry to know if it's always active or only with ARK open
; class BindsManager {
; 	;tool for handling hotkeys
; 	;- functions include key conflict checks and gui to easily assign, save and load hotkeys

; 	__New(list_of_function, file_name:=0, target_client_title:="A"){
; 		; if !working_directory   ; 0 = use CUL's working dir in %appdata%
; 		; 	this.wd:= ROAMING 			
; 		; else if working_directory == 1  ;use running script's workingdir
; 		; 	this.wd:=A_WorkingDir
; 		; else 							;use custom working dir
; 		; 	this.wd:=working_directory

; 		if file_name  ;if has a custom file name use it
; 			this.fn:=file_name 		
; 		else   ;else use CUL's file name for inin
; 			this.fn:=INI_FILE_NAME

; 		this.functions := list_of_function				;used to create a list of functions to load and bind
; 		this.filter_title := target_client_title		;used to do conditional hotkeys
; 		this.keys := []
; 		this.keys.Length := this.functions.Length 		;defines functions array to match hotkey list
; 		this.gui_handle := []
; 		this._protected_keys := []
; 		this.auth:=0									;value to be filled later

; 		this._load_from_ini()
; 		this.bind_all_keys()
; 	}

; 	_save_to_ini(){
; 		;saves funtion and key lists to ini using global constant INI_FILE_NAME
; 		loop this.functions.Length{
; 			IniWrite(this.functions[A_Index], INI_FILE_NAME, "BindManager", "func" A_Index)
; 		}
; 		loop this.keys.Length{
; 			IniWrite(this.keys[A_Index], INI_FILE_NAME, "BindManager", "key" A_Index)
; 		}		
; 	}

; 	_load_from_ini(){
; 		;loads key list from ini using global constant INI_FILE_NAME
; 		loop this.functions.Length{
; 			this.keys[A_Index]:= iniread( INI_FILE_NAME, "BindManager", "key" A_Index)
; 		}		
; 	}

; 	_bind(key_name, func_name, situational:= 0){
; 		try{
; 			if !key_name{	;if keyname is non it means disable
; 				hotkey "if"
; 				Hotkey "~!#1", func_name, "off"
; 				Return 1	;return success as unbound
; 			}
; 			;if situational hotkey trigger only in app else set to always
; 			((situational)?(hotkey "ifwinactive", this.filter_title):(hotkey "if"))
; 			Hotkey key_name, func_name
; 			Return 1		;return success as bound
; 		}catch e{
; 			if ErrorLevel == 1 or e.Message == "Parameter #2 invalid."{
; 				MsgBox "Could not bind '" func_name "' to the [" key_name "] key.`r`n'" func_name "()' does not exist.", "Keybinding error!", 48
; 				Return 0
; 			}else if ErrorLevel == 2{
; 				MsgBox key_name " is not a valid hotkey recognized by this system", "Keybinding error!", 48
; 				Return 0
; 			}
; 			;Exception(Message , What, Extra) {file\line}
; 			MsgBox("err: " e.Message, "Keybinding error!", 48)
; 		}
; 	}

; 	bind_all_keys(){
; 		; static license_obj assuming it exists
; 		; if !this.auth{
; 		; 	if DEBUG
; 		; 		ToolTip "failed auth"
; 		; 	; Return
; 		; 	MsgBox "Please register C2 to enable key-binding"
; 		; 	Return 0				
; 		; }
; 		loop this.functions.Length{
; 			this._bind(this.keys[A_Index], this.functions[A_Index])
; 		}
; 	}

; 	gui_open(){
; 		this.gui := GUICreate(" -MinimizeBox","Keybind Manager")
; 		loop this.functions.Length{
; 			this.gui.Add("text", "xm" ,this.functions[A_Index])
; 			this.gui_handle.%this.functions[A_Index]% := this.gui.Add("hotkey", "xp+170  v" this.functions[A_Index], this.keys[A_Index])
; 			this.gui_handle.%this.functions[A_Index]%.OnEvent("change",(obj_of_event,*)=> this.on_change(obj_of_event))
; 		}
; 		this.gui_button_save := this.gui.add("button","xm","Save").OnEvent("click",(*)=> this.gui_save())
; 		this.gui_button_reset := this.gui.add("button","xp+150","Reset").OnEvent("click",(*)=> this.gui_reset())
; 		this.Gui.OnEvent("Escape", (*)=> this.gui_close())
; 		this.gui.OnEvent("Close", (*)=> this.gui_close()) 
; 		this.gui.show()
; 		Suspend "on" 	;to allow rebinding of hotkeys
; 	}

; 	gui_save(args*){
; 		Suspend "off"
; 		this.gui_data := this.gui.submit()
; 		loop this.functions.Length{
; 			this.keys[A_Index] := this.gui_data.%this.functions[A_Index]%
; 		}
; 		this._save_to_ini()
; 		this.bind_all_keys()
; 	}

; 	gui_close(){
; 		Suspend "off"
; 		this.gui.Destroy()
; 	}

; 	gui_reset(){
; 		this.keys := []
; 		this.keys.Length := this.functions.Length
; 		this.gui_close()
; 		This.gui_open()
; 	}

; 	on_change(obj_of_event){
; 		if this.does_conflict(obj_of_event.value){
; 			if DEBUG
; 				ToolTip obj_of_event.value " conflicts with "  this.does_conflict(obj_of_event.value)
; 		}
; 	}

; 	does_conflict(key_to_check){
; 		;checks for conflicts in existing keybinds or reserved hotkeys 
; 		;returns 0 if no conflicts
; 		;returns INT of coflicting index in the this.functions[] List
; 		;retunrn STRING if conflicting with reserved key
; 		if key_to_check == ""
; 			Return 0

; 		loop this._protected_keys.Length{
; 			if key_to_check == this._protected_keys[A_Index]{
; 				MsgBox key_to_check " is a reserved/protected key"
; 				Return this._protected_keys[A_Index]
; 			}
; 		}

; 		loop this.keys.Length{
; 			if key_to_check == this.keys[A_Index]{
; 				MsgBox key_to_check " is already assigned to " this.functions[A_Index] "`n`nBe careful with overlapping hotkeys"
; 				Return A_Index
; 			}
; 		}
; 		Return 0
; 	}
; }
; ;TODO Combind hot and settings managesr with sub class for each prob and just do array of settings
; class SettingsManager {
; 	__new(file_name:=0, custom_section:=0){
; 		; , working_directory:=0
; 		; if !working_directory   ; 0 = use CUL's working dir in %appdata%
; 		; 	this.wd:= ROAMING 			
; 		; else if working_directory == 1  ;use running script's workingdir
; 		; 	this.wd:=A_WorkingDir
; 		; else 							;use custom working dir
; 		; 	this.wd:=working_directory

; 		if file_name  ;if has a custom file name use it
; 			this.fn:=file_name 		
; 		else   ;else use CUL's file name for inin
; 			this.fn:=INI_FILE_NAME
; 		;sets default for custom section is != 0
; 		((custom_section)?(this.section:=custom_section):(this.section:="SettingsManager"))

; 		this.value := map()		;map of settings in dict/map form for easy of saving, loading, and recall
; 		this.map_alt := map()	;map that supports .value[] info about item's settings type
; 		this.map_clean := map()	;map that supports .value[] 1/0 about if ini should be cleaned if blank
; 		this.info := map()		;map that supports .value[] dict with info about the given setting
; 		this.default := map()	;map that supports .value[] dict with defaults to compare to
; 		this.load_all()
; 	}

; 	info(gui_obj){
; 		try{
; 			MsgBox this.info[substr(gui_obj.Name,5)], "About " gui_obj.Name 	;simple wrapper for info popup with key's info map data
; 		}catch e{
; 			;any exeption will result in default no-info-msgbox
; 			MsgBox "Sorry, no info avaliable for " substr(gui_obj.Name,5), "Missing Info"
; 		}
; 	}	

; 	gui_add(){
; 		;create a large window with all possible settings
; 		this.gui := GUICreate(" -MinimizeBox","Settings Manager")
; 		this.gui.Add("edit", "xm w95 vnewkey" ,"key")
; 		this.gui.Add("edit", "xp+100 w200 vnewvalue", "value")
; 		this.gui_button_save := this.gui.add("button","xm","Save").OnEvent("click",(*)=> this.gui_save_one())
; 		this.gui.show()
; 	}

; 	gui_open(){
; 		try			;checks if gui object exists and closes incase double opening
; 			this.gui.Destroy()

; 		;create a large window with all possible settings
; 		this.gui := GUICreate(" -MinimizeBox","Settings Manager")
; 		for key, value in this.value{			;loop for each setting in the obj map[]
; 			if InStr(key, "toggle")			;if it's a "toggle" setting skip it because it has a master
; 				Continue
; 			this.gui.Add("text", "xm" ,key)
; 			this.gui.Addbutton("xp+180 vinfo" key ,"?").onEvent("click", (gui_obj,*)=>this.info(gui_obj))
; 			if !this.map_alt.has(key)		;if this settings is NOT of "alt" type no normal string input
; 				this.gui.Add("edit", "xp+30 w200 v" key, value)
; 			else 							;else do more complex building
; 				if this.map_alt[key] = "checkbox"
; 					this.gui.Add(this.map_alt[key], "xp+30 w200 v" key " checked" value, "default: " this.default[key])
; 				else 
; 					this.gui.Add(this.map_alt[key], "xp+30 w200 v" key , value)
			
			
; 			if this.value.has("toggle_" key)   ;check if the map has a value
; 				this.gui.Add("Checkbox", "xp+230 vToggle_" key " checked" this.value["toggle_" key], "Enabled")
; 		}
; 		this.gui_button_save := this.gui.add("button","xm","Save").OnEvent("click",(*)=> this.gui_save())
; 		this.Gui.OnEvent("Escape", (*)=> this.gui_close())
; 		this.gui.OnEvent("Close", (*)=> this.gui_close()) 
; 		this.gui.show()
; 	}

; 	gui_save(args*){
; 		this.gui_data := this.gui.submit()	;dumps current state of GUI to an object
; 		for key, value in this.value{		;enumerates the entire dict as an easy way of not missing anything
; 			this.%value% := this.gui_data.%key%   ;sets the object's prob value
; 			this.value[key] := this.%value% 		;also sets the dict/map's value to be updated
; 		}
; 		this.save_all()
; 	}

; 	gui_save_one(){
; 		this.gui_data := this.gui.submit()	;dumps current state of GUI to an object
; 		this.value[this.gui_data.newkey] := this.gui_data.newvalue
; 		this.save_all()
; 	}

; 	gui_close(){
; 		this.gui.Destroy()
; 	}

; 	ini(key, delete_if_blank:=0, default_value:=0, non_string_type:=0, info:=''){
; 		this.default[key] := default_value
; 		this.value[key] := this._load(key, default_value, )	;loads value from ini if it doesn't exist it uses default value
; 		this.info[key] := info 								;sets the info str for this setting/key
; 		if non_string_type
; 			this.map_alt[key] := non_string_type
; 		if delete_if_blank
; 			this.map_clean[key] := delete_if_blank
; 	}

; 	_save(key,value){
; 		if this.map_clean.has(key) and this.default.has(key)	;if there is info for this item in ansillary arrays
; 			if value == this.default[key] and this.map_clean[key]{	;checks if this is both a to-clean setting and if it is still default
; 				IniDelete this.fn, this.section, Key
; 				Return
; 			}
; 		IniWrite Value,  this.fn, this.section, Key
; 	}

; 	_load(key, default_value:="", non_map:=0){
; 		temp_value := iniread(this.fn, this.section, key, default_value)
; 		if non_map								;to avoid loading this.str_of_keys into the dict/map for no reason
; 			Return
; 		;moved out of .load() v205 this.value[key] := temp_value  			;load value into dict/map
; 		Return temp_value

; 		; ;checks for if this settings has an associated toggle
; 		; has_toggle := iniread(this.fn, "SettingsManager", "toggle_" key, default_value)
; 		; if has_toggle
; 		; 	this.map_t[key] := has_toggle
; 	}	

; 	load_all(){
; 		this.str_of_keys := iniread(this.fn, "SettingsManager", "str_of_keys")	;manual read of expected items to load/read
; 		this.list_of_keys := strsplit(this.str_of_keys, "|") 					;splits string of keys into an ARRAY
; 		loop this.list_of_keys.Length{   									;loops for each item in the list, loading it's content
; 			key := this.list_of_keys[A_Index]								;set key 
; 			this.value[key] := this._load(key)							;load each entry
; 		}
; 	}

; 	save_all(){
; 		this.list_of_keys := []  		; used to save the "names" of variables to load back out on fresh boot
; 		this.str_of_keys :=""			; used to store the list of keys in a single string for saving
; 		for key, value in this.value{		; loop for each key-pair in the dict/map of settings
; 			this._save(key,value)
; 			this.list_of_keys.push(key)
; 		}

; 		loop this.list_of_keys.Length{    ;loops to concant all keys into a string for saving
; 			this.str_of_keys .= this.list_of_keys[A_Index]
; 			if A_Index < this.list_of_keys.Length 			;checks if this is the last entry
; 				this.str_of_keys .=  "|"					;if it isn't we add a delimiter
; 		}
; 		this._save("str_of_keys", this.str_of_keys)
; 	}
; }

class ConfigEntry {
	__new(key,c_section,fn,c_type:=0,accessories:=0,default_value:=0,delete_if_blank:=0,info:=''){
		;value = base entry's value 
		;section = ini section 
		;type = main entry's value/input type 
		;accessories = array of flags for assisting options [checkbox/toggle]

		;defaults
		this.value := 0
		this.toggle := 0
		this.pipelist:= ""						;creates a pipe-separated-list for DropDownList

		;load values
		this.key := key
		this.section := c_section 								;ini section 
		this.fn := fn 											;file name of config ini
		((c_type)?(this.type:=c_type):(this.type:="edit"))
		this.default := default_value
		this.to_clean := delete_if_blank
		this.info := info

		this.acc := accessories
		this.has_toggle := 0		
		if type(this.acc) = "array"	{						;check if it's an array
			if this.type = "DropDownList" {					;if this entry is a list, the accessory is the data
				loop this.acc.Length{							;loop for all items in the list
					this.pipelist .= this.acc[A_Index]			;adds item
					if a_index < this.acc.Length 				;if this isn't the last item add a pipe
						this.pipelist .= "|"
				}		
			}else{ 											;all other types get default system
				loop this.acc.Length{							;loop for all accessories in array
					if instr(this.acc[A_Index],"*") 			;check if this item has '*' mean it's a default for the previous item
						this.has_%this.acc[A_Index-1]%_default := SubStr(this.acc[A_Index], 2 )
					else
						this.has_%this.acc[A_Index]% := 1
				}
			}
		}else if type(this.acc) = "string"{				;assumes it's to be used as is in list prop 
			this.pipelist:= this.acc					;creates a pipe-separated-list
		}
		this._load()
	}
	_save(){
		if this.value = this.default{						;if we have a value stored and it isn't the default
			if this.to_clean{								;if this is one to delete when it's the default value
				IniDelete this.fn, this.section, this.Key 	;clears ini value and key out 
				if type(this.acc) = "array"					;if accessories prop is array AKA multiple items
					for item in this.acc 					;loops for items in map
						IniDelete this.fn, this.section, this.Key "_" item	;clears ini for each item
				else 										;else just use as is
					IniDelete this.fn, this.section, this.Key "_" this.acc	;clears ini value and key out 
				Return 										;escapes and doesn't save a the value
			}
		}	
		;if we got this far then this should be a normal scenario and we should save the value
		IniWrite this.value, this.fn, this.section, this.key
		if this.hasprop("has_toggle_default")
			IniWrite this.toggle, this.fn, this.section, this.key "_toggle"
	}

	_load(){
		this.value := iniread(this.fn, this.section, this.key, this.default)		;load key's value from ini
		;check if there is a default present for for the toggle accessory
		if this.hasprop("has_toggle_default")
			this.toggle := iniread(this.fn, this.section, this.key "_toggle", this.has_toggle_default )		;load key's toggle state from ini
	}	

	ToString(){
		try
			Return "ConfigEntry(k:" this.key  ")(v:" this.value ")"
		catch
			return "ConfigEntry(ERROR key type =" type(this.key) " v=" type(this.value) ")"
	}
}

class ConfigManagerTool {
	__new(file_name:=0, custom_section:=0, client_name:=0){

		;sets default for custom section is != 0
		((file_name)?(this.fn:=file_name):(this.fn:=INI_FILE_NAME))					;accepts custom name or uses normal
		((custom_section)?(this.section:=custom_section):(this.section:="ConfigManager"))
		((client_name)?(this.client_name:=client_name):(this.client_name:=WinActive("A")))
		this.gui_size_limit_height := 20

		this.c := map()		;map of settings in dict/map form for easy of saving, loading, and recall
		this.c2 := map()	;secondary map of settings in dict/map form for easy of saving, loading, and recall
		this._protected_keys := []	;list of currently used keys
		this.section_alt := this.section "_alt"

		this.load_all()
	}

	info(gui_obj, assist:=""){
		try{
			MsgBox this.c%assist%[substr(gui_obj.Name,5)].info, "About " gui_obj.Name 	;simple wrapper for info popup with key's info map data
		}catch e{
			;any exeption will result in default no-info-msgbox
			MsgBox "Sorry, no info avaliable for " substr(gui_obj.Name,5), "Missing Info"
		}
	}	

	_unbind(key_name,func_name:=""){
		try{
			; if DEBUG
			; 	ToolTip "unbind " key_name " from doing " func_name
			Hotkey key_name, "off"
		}
	}
	
	_bind(key_name, func_name, always_on:= 0){
		try{
			if !key_name{	;if keyname is non it means disable
				hotkey "if"
				Hotkey "~!#1", func_name, "off"
				Return 1	;return success as unbound
			}

			if DEBUG 
				MsgBox "binding " key_name " to " func_name " always: " always_on
			;if always_on hotkey trigger only in app else set to always

			hotkey "ifwinactive", this.client_name		;make all hotkeys only work IN-CLIENT only by default
			if always_on 								;if we indicate to always work, only then do we clear the inf
				hotkey "if" 							;set hotkey to always work

			Hotkey key_name, func_name
			Return 1		;return success as bound
		}catch e{
			if ErrorLevel == 1 or e.Message == "Parameter #2 invalid."{
				MsgBox "Could not bind '" func_name "' to the [" key_name "] key.`r`n'" func_name "()' does not exist.", "Keybinding error!", 48
				Return 0
			}else if ErrorLevel == 2{
				MsgBox key_name " is not a valid hotkey recognized by this system", "Keybinding error!", 48
				Return 0
			}
			;Exception(Message , What, Extra) {file\line}
			MsgBox("err: " e.Message, "Keybinding error!", 48)
		}
	}

	bind_all_keys(){ ;discontinuted
		for key, obj in this.c{
			try{
				if obj.type = "hotkey"
					this._bind(obj.value, key, obj.toggle)
			}catch e{
				CULErrorHandler.new(e,"Encounterd possible faulty/old ini keybind entry: '" key "' will now attempt to heal the error")
				IniDelete this.fn, this.section , key
			}
		}
	}

	gui_add(){
		;create a large window with all possible settings
		this.gui := GUICreate(" -MinimizeBox","Settings Manager")
		this.gui.Add("edit", "xm w95 vnewkey" ,"key")
		this.gui.Add("edit", "xp+100 w200 vnewvalue", "value")
		this.gui_button_save := this.gui.add("button","xm","Save").OnEvent("click",(*)=> this.gui_save_one())
		this.gui.show()
	}

	gui_open(){	
		Suspend "on"
		try			;checks if gui object exists and closes incase double opening
			this.gui.Destroy()

		try{
			;create a large window with all possible settings
			this.gui := GUICreate(" -MinimizeBox",this.section)
			for key, obj in this.c2{				;loop for each setting in the obj map[]
				;title
				this.gui.Add("text", "xm", strUpper(StrReplace(key, "_" , " "),"T"))

				;help/discription buttons
				this.gui.Addbutton("xp+180 vinfo" key,"?").onEvent("click", (gui_obj,*)=>this.info(gui_obj,"2"))

				;main value item 
				if obj.type = "checkbox"
					this.gui.Add(obj.type, "xp+30 w200 v" key " checked" obj.value, "default: " obj.default)
				if obj.type = "edit" or obj.type = "hotkey"
					this.gui.Add(obj.type, "xp+30 w200 v" key, obj.value)
				if obj.type = "DropDownList"{
					temp:= this.gui.Add(obj.type, "lowercase altsubmit xp+30 w200 v" key " choose" obj.value, "none||" obj.pipelist)
					temp.OnEvent("change",(obj_of_event,*)=> this.gui_apply_preset(obj_of_event))
				}

				;add ons 
				if obj.has_toggle
					this.gui.Add("Checkbox", "xp+230 v" key "_toggle checked" obj.toggle, "Enabled")
			}

			;now add normal items
			for key, obj in this.c{				;loop for each setting in the obj map[]

				;checks if entry in ini is something we know whwat to do with our how to handle
				if type(obj) != "ConfigEntry"{	;no longer treating as an error by just a text field
					; msgbox "Encounterd possible faulty/old ini setting entry: '" key "' and will now attempt to self-correct"
					; IniDelete this.fn, this.section , key
					if DEBUG 
						msgbox "Encounterd possible faulty/old ini setting entry: '" key "' NEEDS TO BE REMOVED FROM config.ini"
					Continue
				}

				;title
				this.gui.Add("text", "xm", strUpper(StrReplace(key, "_" , " "),"T"))			

				if DEBUG 
					tooltip "gui_open`nkey: " string(key) "`nobj: " string(obj)

				;help/discription buttons
				this.gui.Addbutton("xp+180 vinfo" key,"?").onEvent("click", (gui_obj,*)=>this.info(gui_obj))

				;main value item 
				if obj.type = "edit" 
					this.gui.Add(obj.type, "xp+30 w200 v" key, obj.value)			
				if obj.type = "checkbox"
					this.gui.Add(obj.type, "xp+30 w200 v" key " checked" obj.value, "default: " obj.default)
				if obj.type = "hotkey"
					this.gui.Add(obj.type, "xp+30 w200 v" key, obj.value).OnEvent("change",(obj_of_event,*)=> this.on_change(obj_of_event))

				;add ons 
				if obj.has_toggle
					this.gui.Add("Checkbox", "xp+230 v" key "_toggle checked" obj.toggle, "Enabled")
			}

			this.gui_button_save := this.gui.add("button","xm","Save").OnEvent("click",(*)=> this.gui_save())
			this.gui_button_reset := this.gui.add("button","xp+150","Reset").OnEvent("click",(*)=> this.gui_reset())		
			this.Gui.OnEvent("Escape", (*)=> this.gui_close())
			this.gui.OnEvent("Close", (*)=> this.gui_close()) 
			this.gui.show()
		}catch e{
			CULErrorHandler.new(e,"UNKNOWN gui error opening '" this.section "' section ' (key is at bottom of this msg)")
		}
	}

	gui_save(args*){
		Suspend "off"
		this.gui_data := this.gui.submit()					;dumps current state of GUI to an object
		for key, value in this.gui_data.OwnProps(){			;enumerates the entire dict as an easy way of not missing anything

			;skips toggle accessories
			if instr(key,"_toggle")
				Continue

			;case special cases in map "c2"
			if this.c2.has(key){
				this.c2[key].value := value 
				disp("skipping " key)
				Continue
			}
			
			;hotkey unbind before assigning a new value to be bound
			if this.c[key].type = "hotkey" {								;if this is a hotkey
				if this.c[key].value != value or this.c[key].toggle != this.gui_data.%key%_toggle{
					this._unbind(this.c[key].value)								;unbind previous value(key)
					if value {													;if there is a new value from gui, bind it
						this._bind(value, key, this.gui_data.%key%_toggle)			
					}
				}
			}

			;checks if there is an accessories that needs updating
			if this.c[key].has_toggle								
				this.c[key].toggle := this.gui_data.%key%_toggle 
			;base functionality of applying variable's value
			this.c[key].value := value
		}

		this.save_all()
		; this.bind_all_keys()
	}

	gui_save_one(){
		this.gui_data := this.gui.submit()	;dumps current state of GUI to an object
		; this.value[this.gui_data.newkey] := this.gui_data.newvalue
		; this.save_all()
		this._save(this.gui_data.newkey,this.gui_data.newvalue)
	}

	gui_close(){
		Suspend "off"
		this.gui.Destroy()
	}

	gui_reset(){
		if MsgBox( "Are you sure you want to reset ALL saved data?",,1+48+256) != "OK"
			Return
		this.gui_close()
		for key, obj in this.c
			obj.value := ""
		This.gui_open()
	}

	gui_apply_preset(obj_of_event){
		if DEBUG
			MsgBox this.c2["preset"].value "->" obj_of_event.value "(" obj_of_event.Text ")"

		;sets preset map entry's value
		this.c2["preset"].value := obj_of_event.value

		for key, obj in this.c{				;loop for all options
			obj.value := 0					;start by making all unchecked as a base
			if obj_of_event.value = 1		;handles the 'none' preset
				Continue
			if key != obj_of_event.Text 	;then if text isn't the preset item's match 
				obj.value := 1				;check all items not matching
		}

		;new reboot the gui for an easy way to apply preset
		this.gui_close()
		this.gui_open()		
	}

	on_change(obj_of_event){
		if this.does_conflict(obj_of_event.value){
			if DEBUG
				ToolTip obj_of_event.value " conflicts with "  this.does_conflict(obj_of_event.value)
		}
	}

	does_conflict(key_to_check){
		;checks for conflicts in existing keybinds or reserved hotkeys 
		;returns 0 if no conflicts
		;returns INT of coflicting index in the this.functions[] List
		;retunrn STRING if conflicting with reserved key
		if key_to_check == ""
			Return 0

		loop this._protected_keys.Length{
			if key_to_check == this._protected_keys[A_Index]{
				MsgBox key_to_check " is a reserved/protected key"
				Return this._protected_keys[A_Index]
			}
		}

		for key, obj in this.c{
			if key_to_check == obj.value{
				MsgBox key_to_check " is already assigned to " key "`n`nBe careful with overlapping hotkeys"
				Return A_Index
			}
		}
		Return 0
	}

	wrong_type_handler(key, value := 0, alt_map:=""){
		if DEBUG
			ToolTip "WTH:`nhas: " this.c%alt_map%.has(key) " `nkey: " string(key) "(" type(key) ")`nvalue: " string(value) "(" type(value) ")"  , , 500, 5
		
		if !alt_map{
			if !this.c.has(key){
				this.c[key] := ConfigEntry.New(key, this.section, this.fn)
				if DEBUG
					ToolTip "WTH:`NEW: " this.c.has(key) " `nkey: " string(key) "(" type(key) ")`nvalue: " string(value) "(" type(value) ")"  , , 600, 6
			}
		}else{
			if !this.c2.has(key){
				this.c2[key] := ConfigEntry.New(key, this.section, this.fn)
				if DEBUG
					ToolTip "WTH:`NEW-alt: " this.c2.has(key) " `nkey: " string(key) "(" type(key) ")`nvalue: " string(value) "(" type(value) ")"  , , 600, 6
			}			
		}
	}

	ini(key, delete_if_blank:=0, default_value:=0, ctr_type:="edit", info:='',accessories:=0){
		if ctr_type = "DropDownList"{
			this.c2[key]:=ConfigEntry.New(	key,
											this.section_alt,
											this.fn,
											ctr_type,
											accessories,
											default_value,
											delete_if_blank,
											info)
		}else{
			this.c[key]:=ConfigEntry.New(	key,
											this.section,
											this.fn,
											ctr_type,
											accessories,
											default_value,
											delete_if_blank,
											info)
		}
	}

	load_all(){
		;reads section from ini
		temp_read := iniread(this.fn, this.section)	
		;now build map with values from string 
		lines_array := StrSplit(temp_read, ["`n"])			;split each line in string 
		for l in lines_array{								;loop for each line
			pairs_array := StrSplit(l, "=")					;split pair
			if instr(pairs_array[1], "_toggle")				;checks if it's an accessory and skips it
				Continue
			this.wrong_type_handler(pairs_array[1], pairs_array[2])
			this.c[pairs_array[1]].value := pairs_array[2]
			;this.c[pairs_array[1]] := pairs_array[2]	;fills in the values of the map
			if debug
				tooltip "line:`n" l "`n`n" pairs_array[1] " +> " pairs_array[2]
		}
	}

	save_all(){
		for key, obj in this.c{			; loop through enitre map and tell each to save it's self
			obj._save()
		}
		for key, obj in this.c2{			; loop through enitre map and tell each to save it's self	
			obj._save()
		}		
	}

	_save(key, value){
		this.wrong_type_handler(key, value)
		this.c[key].value := value	
		this.c[key]._save()
	}

	_load(){
		;not used yet
		MsgBox "not using _LOAD please update "
	}
}

class NewHUD {
	hud_index_array := []

	; allows for display of single lines of text on screen bot-right
	__New(txt:="sample of text to display", index:=1, display_time:=5000){
		this.hide_timer := objbindmethod(this, "hide")
		if display_time > 0
			display_time := 0-display_time
		this.display_time:= display_time
		; hud_index_array.push() incomplete idea
		this._create(index)
		if txt
			this.display(txt)
	}

	_create(index){
		this.i := Integer(index)
		this.gui_obj := GUICreate("+LastFound `+AlwaysOnTop -caption +disabled +ToolWindow",this.i)
		this.gui_obj.setfont("c00FF00 s20", "Verdana")				;incase of missing font
		this.gui_obj.setfont("c00FF00 s24 bold", "Droid Sans Mono")		;incase of missing font
		this.gui_obj.setfont("c00FF00 s24 bold", "Inconsolata-Bold")	    ;incase of missing font
		this.gui_obj.BackColor := "000000"
		WinSetTransColor("000000")
		this.txt_obj := this.gui_obj.add("text","xm ym RIGHT", txt)
	}

	display(text_to_display, display_time:=5000){
		LocalWidth := This._calc_width(text_to_display)
		LX:=A_ScreenWidth - LocalWidth - 100
		LY:=A_ScreenHeight  - 100 - (50*this.i)
		
		this.txt_obj.Visible := 0 
		this.txt_obj.value := text_to_display
		this.txt_obj.move("w" LocalWidth )
		this.txt_obj.Visible := 1

		this.gui_obj.show("NoActivate autosize" " x" LX " y" LY)
	

		;allows for adjustment of display time for every update or defaults to time given when instantiated 
		if display_time != 5000{
			SetTimer this.hide_timer, display_time
		}else {
			SetTimer this.hide_timer, this.display_time
		}
	}

	_calc_width(sample_str){
		FontWidth := 20
		LMargin := 2
		Return (StrLen(sample_str) * FontWidth + LMargin)
	}	

	hide(){
		this.gui_obj.hide()
	}
}

class Tool {
	class Mouse {
		__init(){
			;sets basic vars so that the obj has those prop later
		    this.x1 := 0
		    this.y1 := 0
		    this.x2 := 0
		    this.y2 := 0	
		    this.color:=""
		    this.coord_mode_to_use:=""
		}

		_capture_next(key_press, function){
			;allows you to capture the next click
			Hotkey(key_press, function, "on")
		}

		_screen_to_prop(coords){ 	;copies coords into client's properties
		    this.sx1 := coords[1] 	;fill prop info from results for partent caller to use
		    this.sy1 := coords[2] 	;fill prop info from results for partent caller to use
			if coords.length == 2 	;returns if only 2 coords are needed
				Return			    
		    this.sx2 := coords[3] 	;fill prop info from results for partent caller to use
		    this.sy2 := coords[4]	;fill prop info from results for partent caller to use   
		}	
		_screen_to_client(coords){	;take current screen/window info and converts to client coodemode from screen
			WinGetClientPos X, Y, Width, Height, "A"	;use active window, assuming it's the right one
			this.x := x
			this.y := y
			this.w := width
			this.h := height

			; MsgBox "client " x ":" y "   " width "x" height "`n" coords[1] ":" coords[2] "`n" coords[1]-x ":" coords[2]-y

		    this.cx1 := coords[1]-x 	;fill prop info from results for partent caller to use
		    this.cy1 := coords[2]-y 	;fill prop info from results for partent caller to use
			if coords.length == 2 	;returns if only 2 coords are needed
				Return			    
		    this.cx2 := coords[3]-x 	;fill prop info from results for partent caller to use
		    this.cy2 := coords[4]-y	;fill prop info from results for partent caller to use   
		}

		class Pixel extends Tool.Mouse {
			__new(target_window){
				this._capture_next("LButton",(*)=>this.get())
				WinActivate target_window						;set client window (what ever app you are wroking in active)	
				this.done:=0

			}

			get(){
				; ToolTip "STARTING pixel"

				MouseGetPos x1, y1
				this.color := PixelGetColor(x1, y1, "alt")
				; ToolTip this.color 
				this.info := Tool.highlight.new("temp_pixel", [x1,y1], this.color,,1)
				this.info.show()
			    this.x1 := x1
			    this.y1 := y1
			    this.done := 1
				Hotkey("Lbutton", (*)=> this.drag(), "off")
				Return this.color
			}
		}

		class Area extends Tool.Mouse {
			__new(target_window){
				this._capture_next("LButton",(*)=>this.drag())
				WinActivate target_window						;set client window (what ever app you are wroking in active)
				this.done:=0
			}

			drag(){
				;displays and records info about the area "drug" on screen
			    MouseGetPos x1, y1 	;get starting click
			    this.display_obj := tool.highlight.new("dragzone", [x1, y1 ,x1+2, y1+2 ],"EEEEEE",0)

			    while GetKeyState("LButton", "p"){	;while mouse is clicked keep updating the gui for drag effect
			        MouseGetPos x2, y2
			        ToolTip x1 ", " y1 "`n" Abs(x1-x2) " x " Abs(y1-y2)
			        this.display_obj.move([x1,y1,x2,y2])
			        Sleep 10
			    }
			    ToolTip
			    this._screen_to_prop([x1,y1,x2,y2])
			    this._screen_to_client([x1,y1,x2,y2])
			    this.done := 1	;confirm that the process has finished

			    this.display_obj.hide()		;hide the live display so the confirm SHOW_COORDS can take over
			    Hotkey("Lbutton", (*)=> this.drag(), "off")
			}
		}
	}

	class Highlight {
		__New(_id, coords, colour:=0, duration:=1500, show_tile:=0, crosshair_size:=2){
			; a general tool to simplify debugging and display of locations on the screen
			; with either a point or an area as acceptable in puts
			;
			; id STRNG - is the unique name for this highlight
			; coords ARRAY - can be either 1 or 2 coordinate pairs in [array] form THESE MUST BE SCREEN COORDMODE
			; *colour STRNG - of hex 6digit type or ARRAY which would be first colour of tile and then gui crosshair color
			; *duration INT - length in MS to display 
			; *show_tile BOOL - 1/0 true/false if you want to see tile of the color at the coords for point
			; *coordmode STRING - a string of AHK's CoordMode options (window/screen/other)

			;handling of defaults and variations
			if coords.Length == 2{
				this.type := "point"
			}else if coords.Length == 4{
				this.type := "area"		
			}else{
				MsgBox "The highlight tool only accepts coordinate pairs (1-point or 2-area) in array form "
				Return 0
			}

			;handles colour's options    [blank need to have a default]
			if !colour{
				this.target_color := 0		;set to ZERO so that it selects the colour tile of visible
				this.gui_color := "00ff00"	;set a default color for the gui elements
			}else if type(colour) == "Array" {		;if it's of array type, we've been given both colors so jsut plug in
				this.target_color := colour[1]
				this.gui_color := colour[2]	
			}else{								;to handle a single color being fed in and gives a default gui color, unless gui is AREA
				this.target_color := colour
				this.gui_color := "00ff00"
				if this.Type == "area"
					this.gui_color := colour
			}


			; dumping params
			this.trans_amount:= 20
			this.id := _id
			this.hrid := _id
			this.coords := coords
			this.duration := duration
			this.show_tile := show_tile

			;static vars for now (possible add to params)
			this.ch_b := crosshair_size					;buffer size around pixel
			this.ch_b2 := this.ch_b*3						
			this.ch_p := 1						;pixel size should stay 1 but just for calc
			this.ch_s := this.ch_b*2+this.ch_p  ; giving you "dot" number of pixels on either side of the clicked pixel
			this.ch_l := this.ch_b2*4

			;props for guis and deletions
			this.color_tile := ""
			this.gui_handles := [1,2,3,4,5,6]
			this.moving := 0			;used to tell contructer if it should creat a gui or just use old handles
			; this.gui_ids := []
			this.hide_timer := objbindmethod(this, "hide")
		}

		_start_timer(){
			if this.duration == 0
				Return  ; meaning permanent display or manual hiding
			;handles positive timer number so it never activates twice
			if this.duration > 0
				this.duration := 0-this.duration

			; if DEBUG
			; 	tooltip "setting timer for '" this.hrid "' of type [" this.type "]`n" this.coords[1] ":" this.coords[2] 				
			;handles timer start and resets(TODO add reset somehow/ refresh timer)
			SetTimer this.hide_timer, this.duration
		}

		_construct_crosshair_element(i,x,y,w,h,is_tile:=0){
			if !this.moving					;checks if it needs to create gui or if we are moving AKA been created before
				this.gui_handles[i] := GuiCreate("+toolwindow +AlwaysOnTop -Caption +Disabled +LastFound")
			
			if is_tile{						;handles colours for tiles, non-tiles(gui) and auto color pick from point if no color
				if this.target_color		;if target color defined (AKA not defaulted to 0)
					this.gui_handles[i].BackColor := this.target_color
				else
					this.gui_handles[i].BackColor := PixelGetColor(this.coords[1], this.coords[2])				
			}else{							; if not tile then use GUI color
				this.gui_handles[i].BackColor := this.gui_color
			}

				
			this.gui_handles[i].show(" x" x " y" y " w" w " h" h   " NoActivate")
			;check if it's an area type and then make it transparent ish
			if this.type == "area"
				WinSetTransparent(this.trans_amount, this.gui_handles[i])
		}

		move(new_coords,duration:=-1){
			this.coords := new_coords
			this.show(duration)		
			this.moving := 1
		}

		show(duration:=-1){
			if duration != -1
				this.duration := duration
			if duration != 0
				this._start_timer()	
			; process display of coords for a point
			if this.type == "point"{
				;a debugging dot for crosshair precision 
				; i,x,y,w,h,is_tile:=0
				this._construct_crosshair_element(1,this.coords[1]-this.ch_b, this.coords[2]-this.ch_b2-this.ch_l, this.ch_s,this.ch_l)
				this._construct_crosshair_element(2,this.coords[1]+this.ch_b2+this.ch_p, this.coords[2]-this.ch_b, this.ch_l,this.ch_s)
				this._construct_crosshair_element(3,this.coords[1]-this.ch_b, this.coords[2]+this.ch_b2+this.ch_p, this.ch_s,this.ch_l)
				this._construct_crosshair_element(4,this.coords[1]-this.ch_b2-this.ch_l, this.coords[2]-this.ch_b, this.ch_l,this.ch_s)

				if this.show_tile
					this._construct_crosshair_element(5,this.coords[1]+this.ch_l+this.ch_b, this.coords[2]-this.ch_l*2, this.ch_l, this.ch_l, this.show_tile)
			}
			if this.type == "area"{
				this._construct_crosshair_element(6,this.coords[1], this.coords[2], this.coords[3]-this.coords[1], this.coords[4]-this.coords[2])
			}

			this.moving := 0
		}

		hide(){
			; if debug
			; 	tooltip "hiding ->" this.id,,, 2
			;handles issues of many timers being called on the smae gui
			if this.type == "area" {
				this.gui_handles[6].Destroy()
				Return
			}
			if this.show_tile
				this.gui_handles[5].Destroy()
			this.gui_handles[1].Destroy()
			this.gui_handles[2].Destroy()
			this.gui_handles[3].Destroy()
			this.gui_handles[4].Destroy()
		}
	}
}

class Action {
	__New(frequency:=1000, key_to_press:="1") {
		if frequency == 0
			this.disabled := 1
		else
			this.disabled := 0

		if frequency < 200
			this.freq:= frequency*1000
		else
			this.freq := frequency

		this.last_tick := 0	
		this.key := key_to_press
		this.x := 0
		this.y := 0			
		Return this
	}

	is_due() {
		if this.disabled
			Return 0
		If(this.last_tick+this.freq <a_tickcount)
			return 1
		Return 0
	}

	payload() {
		send this.key
	}

	update_last_tick(){
		this.last_tick := a_tickcount	
	}

	do() {
		if(this.is_due())
		{
			this.payload()
			this.update_last_tick()
			disp(this.key)
			return 1
		}
		return 0
	}

	class Moose extends Action{
		bump(min:=5, max:=50){
			disp("bumping mouse " )
			;determin direction of movment
			x_change := random(min,max)
			y_change := random(min,max)
			if this.x>0
				x_change := 0 - x_change
			if this.y>0
				y_change := 0 - y_change
			this.x += x_change
			this.y += y_change

			MouseMove(x_change, y_change, 100, "Relative")
		}
	}
}

class ScenarioDetector {
	__init(){
		;define variables that will get saved or need defaults
		this.coord_mode_to_use := "Screen"
		this.prop := Map()							;all saved properties are now in this map for easy of saving
		this.prop["x_ref"] := 1920					;resolution client at time of search-area setup
		this.prop["y_ref"] := 1080 					;resolution client at time of search-area setup
		this.prop["x_win"] := A_ScreenWidth			;width of client (default assumes fullscreen)
		this.prop["y_win"] := A_ScreenHeight 		;hieght of client (default assumes fullscreen)		
		this.prop["x_off"] := 0					;coordinate representing the origin of the client window (offset + coord should = screen pixel)
		this.prop["y_off"] := 0					;coordinate representing the origin of the client window (offset + coord should = screen pixel)

		this.prop["x"] := 0		;x of (last) found location of scenario
		this.prop["y"] := 0		;y of (last) found location of scenario
		this.prop["x1"] := 0	;x of first (upper left) coord for area to search [based on client coordmode]
		this.prop["y1"] := 0	;y of first (upper left) coord for area to search [based on client coordmode]
		this.prop["x2"] := 0 	;x of second (lower right) coord for area to search [based on client coordmode]
		this.prop["y2"] := 0	;x of second (lower right) coord for area to search [based on client coordmode]

		;live properties used for manipulation and based on SCREEN for gui/hud accuracy
		this.x := 0		;x of (last) found location of scenario
		this.y := 0		;y of (last) found location of scenario
		this.x1 := 0	;x of first (upper left) coord for area to search [based on SCREEN coordmode]
		this.y1 := 0	;y of first (upper left) coord for area to search [based on SCREEN coordmode]
		this.x2 := 0 	;x of second (lower right) coord for area to search [based on SCREEN coordmode]
		this.y2 := 0	;x of second (lower right) coord for area to search [based on SCREEN coordmode]		

		;define blank variable that might be used by class or child classes 
		this.color_mark := "00FF00"
		this.prop["color_target"] := "FFFFFF"
		this.hide_timer := objbindmethod(this, "hide_coords")
		this.display_time := 500					;default time for search box to show
		this.last_coords := 0
		this.coords:=0
		this.showing_search_area := 0
		this.mode := "base"
		this.tile_flag:= 0
		this.area_flag:=0
		this.last_seen := 0
		this.age := 0
		this.sub_count := 0
		this.force_reselection := 0

		;init blank values for GUI ids/obj so that we don't doup guis
		this.m_n_id := 0
		this.m_s_id := 0
		this.m_e_id := 0
		this.m_w_id := 0
		this.tile_id := 0
		this.search_area_gui_obj_id:=0
		this.m_n := 0
		this.m_s := 0
		this.m_e := 0
		this.m_w := 0
		this.tile := 0
	}

	show_coords(length_to_show:=1000, live_mode:=0){
		if live_mode
		    this.last_coords := this.is_present()
		if this.last_coords != 0 {					;AKA it is present, no display it's top left pix or location
			; if DEBUG
			; 	ToolTip "last found for '" this.hrid "' is " this.x ":" this.y
			this.hud_obj := tool.highlight.new(this.id, [this.x, this.y], this.prop["color_target"], length_to_show, this.tile_flag)
			this.hud_obj.show()
			Return
		}
		if this.type == "pixel"{					;if not visible show crosshair where pixel is expected
			; if DEBUG
			; 	ToolTip "last found for '" this.hrid "' is missing, but this hsouldn't ever trigger " this.last_coords[1] ":" this.last_coords[2]
			this.hud_obj := tool.highlight.new(	this.id, 
												[this.x, this.y],
												this.prop["color_target"], 
												length_to_show, 
												this.tile_flag)
			this.hud_obj.show()
			Return
		}
		if this.type == "image" or this.type == "pixel_ext" {  ;show area searched 
			; if DEBUG
			; 	ToolTip "no last found for '" this.hrid "'`nDisplaying zone: " this.x1 ":" this.y1 " " this.x2 ":" this.y2
			this.hud_obj := tool.highlight.new(	this.id, 
												[this.x1, this.y1, this.x2, this.y2], 
												this.color_mark, 
												length_to_show, 
												this.tile_flag)
			this.hud_obj.show()
			Return
		}
		if this.type == "cluster" { ; if type is cluster we gotta feed it subpixel1's coords for search area
			this.hud_obj := tool.highlight.new(	this.id, 
												[this.sub_pixel[1].x1, this.sub_pixel[1].y1, this.sub_pixel[1].x2, this.sub_pixel[1].y2], 
												this.color_mark, 
												length_to_show,
												this.tile_flag)
			this.hud_obj.show()
			Return			
		}
	}

	is_present(variation:=-1, visual:=1, length_to_show:=250, refine_array:=0){
		this.last_coords := 0  ; reset to avoid false positive
		if variation <0
			variation := this.tol

		if refine_array  ;refine_array if you want to make changes -> [[win-x,win-y],[win-w,win-h]]
			this._refine_coords(refine_array)

		if this.type = "image" {	
			this.last_coords := find_image(this.file_name,
										   this.x1,
										   this.y1,
										   this.x2,
										   this.y2,
										   variation,
										   this.scale)
			if this.last_coords != 0
			{
				this.x := this.last_coords[1]
				this.y := this.last_coords[2]
				this.update_last_seen()
				if DEBUG or visual
					this.show_coords(length_to_show)	
				Return 1
			}
			if DEBUG and visual
				this.show_coords(length_to_show)				
			Return 0
		}

		if this.type = "pixel_ext" {
			this.mode := "pixel_ext"
			if(PixelSearch(x, y, this.x1, this.y1, this.x2,this.y2, this.prop["color_target"], variation)) {
				this.last_coords := [x, y]
				this.x := x
				this.y := y
				this.update_last_seen()
				if DEBUG or visual
					this.show_coords(length_to_show)					
				Return 1
			}
			if DEBUG and visual
				this.show_coords(length_to_show)				
			Return 0
		}

		if this.type = "pixel"{
			r := 2
			if(PixelSearch(x,y,this.x-r,this.y-r,this.x+r,this.y+r,this.prop["color_target"],variation)){
				this.last_coords := [x, y]
				this.x := x
				this.y := y	
				this.update_last_seen()			
				if DEBUG or visual
					this.show_coords(length_to_show)					
				Return 1
			}
			if DEBUG and visual
				this.show_coords(length_to_show)				
			Return 0		
		}

		if this.type = "cluster"{
			loop this.sub_count{															;loop for each sub pixel in cluster
				i:= A_Index
				if this.sub_pixel[i].is_present(){											;if current pixel is present
					this.sub_pixel[i].show_coords()											; show it's location
					if this.mode == 1
						this.sub_pixel[i+1].update_coords(	[this.sub_pixel[1].x-this.range,	; update the search area for next pixel (mode=1)
															 this.sub_pixel[1].y-this.range,
															 this.sub_pixel[1].y+this.range,
															 this.sub_pixel[1].y+this.range])
					if this.mode == 2
						this.sub_pixel[i+1].update_coords(	[this.sub_pixel[i].x-this.range,	; update the search area for next pixel (mode=2)
															 this.sub_pixel[i].y-this.range,
															 this.sub_pixel[i].y+this.range,
															 this.sub_pixel[i].y+this.range])
				}else{
					if DEBUG and visual
						this.show_coords(length_to_show)	
					Return 0 ; sub_pixel i isn't present we failed to see full cluster so exit 
				}
			}
			Return 1	;if we made it this far, we must have found all cluster pixels and thus scenario is present
		}
	}	

	_refine_coords(refine_array:=0){ ;update offset/win(refine_array) & 'live' with prop[]ratios+offset
		if !WinExist(this.client_name){
			disp(this.hrid " could not find ARK window")			;STATIC
			Return
		}
		; refine_array -> [[win-x,win-y],[win-w,win-h]]
		if !refine_array{					;if we weren't info try get it from client window
			WinGetClientPos X, Y, Width, Height, this.client_name	
			refine_array := [[X,Y],[Width,height]]	
		}

		this.update_offset(refine_array[1])		;update the object's current offset prop (to be saved)
		this.update_win(refine_array[2])		;update the object's current window dimentions prop (to be saved)

		;new system (scaler for ark ui)
		;converts client coords (sample) to client coords current res
		normalized_array := coords_normalize_array(	[this.prop["x1"],this.prop["y1"],this.prop["x2"],this.prop["y2"]],
													[this.prop["x_ref"],this.prop["y_ref"]],
													refine_array[2])
		this.x1 := normalized_array[1] + this.prop["x_off"]
		this.y1 := normalized_array[2] + this.prop["y_off"]
		this.x2 := normalized_array[3] + this.prop["x_off"]
		this.y2 := normalized_array[4] + this.prop["y_off"]	
	}

	_client_to_screen(coord_pair){
		if coord_pair.Length == 2
			Return [coord_pair[1]+this.prop["x_off"],coord_pair[2]+this.prop["y_off"]] 
		if coord_pair.Length == 4
			Return [coord_pair[1]+this.prop["x_off"],coord_pair[2]+this.prop["y_off"],coord_pair[3]+this.prop["x_off"],coord_pair[4]+this.prop["y_off"]] 			
	}

	_wipe(){
		;wipe entire save section, likely to force reselections of stuff
		Inidelete(A_WorkingDir "/" INI_FILE_NAME, this.id)
		sleep 100
	}

	_save_prop(prop_name){
		IniWrite(this.prop[prop_name], A_WorkingDir "/" INI_FILE_NAME, this.id, prop_name)
		; if DEBUG 
		; 	ToolTip "ScenarioDetector " this.type " saving " this.%prop_name% " to:`n" A_WorkingDir "/" INI_FILE_NAME
	}

	_load_prop(prop_name){
		temp := iniread(INI_FILE_NAME, this.id, prop_name, "KEY_ERROR")
		if DEBUG
			ToolTip "loading ini for '" this.hrid "'`n" temp " of type " type(temp) " into " prop_name
		if temp == "KEY_ERROR"
			throw { message: "KEY_ERROR", what: prop_name, extra: "key '" prop_name "' for '" this.hrid "' not found in ini file"}
		this.prop[prop_name] := temp
	}

	save_all(){
		;alias for save to be consistant with other objs 
		this.save()
	}

	save(){
		this._save_prop("color_target")
		; this._save_prop("sub_count") not needed
		this._save_prop("x")
		this._save_prop("y")
		this._save_prop("x1")
		this._save_prop("y1")
		this._save_prop("x2")
		this._save_prop("y2")	

		this._save_prop("x_ref")
		this._save_prop("y_ref")
		this._save_prop("x_win")
		this._save_prop("y_win")
		this._save_prop("x_off")
		this._save_prop("y_off")	
	}	

	load(use_static_coords:=0){
		if DEBUG
			ToolTip this.hrid " loading..." this.hrid
		;try load search area
		if !use_static_coords{	;use_static_coords is for a hardcoded area or pixel (not recommended)
			try{	;try block with silent catch for option properties
				this._load_prop("color_target")
				this._load_prop("x_ref")
				this._load_prop("y_ref")
				this._load_prop("x_win")
				this._load_prop("y_win")
				this._load_prop("x_off")
				this._load_prop("y_off")
				this._load_prop("x")
				this._load_prop("y")
			}
			try{	;try block for values that aren't optional 
				if this.force_reselection{
					this.force_reselection :=0 
					throw exception("KEY_ERROR", this.hrid "force_reselection image", " ")
				}
				if this.prop["x2"]	 	;if no coords given then we should try load previous user input
					Return
				if this.prop["x"] and this.type == "pixel"	;if no coords given then we should try load previous user input
					Return					
				this._load_prop("x1")			;load x1 -used in pixel/ext/img
				this._load_prop("y1")			;load y1 -used in pixel/ext/img
				if this.area_flag{				;if this.area_flag we know it's ext/img only
					this._load_prop("x2")		;load x2 -used in ext/img to define zone end
					this._load_prop("y2")		;load y2 -used in ext/img to define zone end
				}
				if this.type == "ext"{			;for pix.ext we are interested in loading last seen
					;load last seen TODO
				}	
			}catch e{
				if e.message == "KEY_ERROR"{	;KEY_ERROR is a custom err thrown when no value found for key
					if DEBUG 
						ToolTip e.extra " => " e.message
					if this.type == "pixel" or this.type == "pixel_ext"{
						disp("No config detected, please select a pixel for '" this.hrid "' now.",,,0)
						this.picker("pixel")
					}
					if this.area_flag and !this.prop["x2"]{
						disp("No config detected, please drag-select an area for '" this.hrid "' now.",,,0)
						this.picker("area")
					}
				}
			}
		}
	}	

	update_last_seen(){
		this.last_seen := A_TickCount
		this.save()
	}

	update_coords(coords:=0){		;used to update the search range of this(instance) manually (or [prop+offset]->live)
		if !coords{
			this.x1 := this.prop["x1"] + this.prop["x_off"]
			this.y1 := this.prop["y1"] + this.prop["y_off"]
			this.x2 := this.prop["x2"] + this.prop["x_off"]
			this.y2 := this.prop["y2"] + this.prop["y_off"]
			Return
		}
		this.prop["x1"] := coords[1]
		this.prop["y1"] := coords[2]
		if coords.Length < 4
			Return
		this.prop["x2"] := coords[3]
		this.prop["y2"] := coords[4]
	}

	update_offset(coords){ 		;used to update the offset/origin of client window
		this.prop["x_off"] := coords[1]
		this.prop["y_off"] := coords[2]
	}

	update_win(dimentions){		;used to update client window dimentions 
		this.prop["x_win"] := dimentions[1]
		this.prop["y_win"] := dimentions[2]
	}

	get_age(){
		this.age := a_tickcount - this.last_seen
		Return this.age
	}

	picker(mode:="pixel"){

		if mode == "pixel"{
			this._grab_pixel_info()
		}
		if mode == "area"{
			this._grab_area_info()
		}			
	}

	_grab_area_info(){
		temp := tool.mouse.area.new(this.client_name) 	
		while !temp.done
			sleep 100
		this.update_coords([temp.cx1,temp.cy1,temp.cx2,temp.cy2]) ;copy results into props (client mode)
		this.prop["x_ref"] := temp.w 		;copy in the results from screen drag 	window info
		this.prop["y_ref"] := temp.h 		;copy in the results from screen drag 	window info

		this._refine_coords([[temp.x,temp.y],[temp.w,temp.h]])	;feed getclientpos stuff from temp so we don't do it twice

		disp("'" this.hrid "' area selected")
		this.show_coords()
		this.save_all()

		; if DEBUG
		; 	ToolTip "received " temp.x1 ":" temp.y1 " to " temp.x2 ":" temp.y2
	}

	_grab_pixel_info(){
		temp := tool.mouse.pixel.new(this.client_name)
		while !temp.done
			sleep 100
		this.prop["x"] := temp.x1
		this.prop["y"] := temp.y1
		this.prop["color_target"] := temp.color

		disp("'" this.hrid "' pixel selected")
		this.save_all()
		; if DEBUG
		; 	ToolTip "received " temp.x1 ":" temp.y1 " -> " temp.color
	}

	class Img extends ScenarioDetector{
		__New(file_name, coords:=0, LocalTol:=50, client_name:=0) {
			;handles defaults
			if type(coords) == "String"
				coords := this._translate_zone(coords)
			if type(coords) == "Array"{
				this.prop["x1"] := coords[1]
				this.prop["y1"] := coords[2]
				this.prop["x2"] := coords[3]
				this.prop["y2"] := coords[4]
			}	

			if client_name{
				this.client_name:=client_name
			}else{
				this.client_name:= "AHK_exe " WinGetProcessName("A")
			}

			this.file_name := file_name
			this.id := StrSplit(file_name , ".")[1]
			this.hrid := this.id
			this.tol := LocalTol
			this.type := "image"
			this.area_flag := 1


			this.load()		;load info from ini file
			this._refine_coords()	;take loaded info and translate into coords used for SCREEN based stuff

			try{
				; MsgBox FileExist( a_workingdir this.file_name) "`n" this.file_name
				if !FileExist(a_workingdir this.file_name)
					throw exception("Missing image", this.file_name " NOT FOUND", a_workingdir this.file_name)
				this.imagetool := imagetool.new()									;build obj for image tool
				this.dimentions := this.imagetool.get_image_size(this.file_name)	;gets the x and y size of the image for scaling 			
				if !this.dimentions 
					throw exception("Trouble getting dimentions for " this.file_name, a_workingdir this.file_name, a_workingdir this.file_name)
				this.scale := this.imagetool.rescaler( 	this.dimentions,	; rescale(img_dimentions, ref_dimentions, win_dimentions)
														[this.prop["x_ref"],this.prop["y_ref"]],
														[this.prop["x_win"],this.prop["y_win"]]) 
			}catch e{
				temp := CULErrorHandler.New(e,"Error trying to get dimentions. `n`nPlease try menu>dev-mode>verify_all to redownload possible missing files.")
			}
								
		}

		capture_new_sample(){
			capture_image_region(this.file_name)
		}
	}
	
	class Pix extends ScenarioDetector{
		__New(identifier, coords:=False, tol := 2, force_reselection:=0, client_name:=0, known_info:=0, target_color:=0){
			;handles defaults not in use
			if type(coords) == "String"
				coords := this._translate_zone(coords)
			if type(coords) == "Array"{
				this.prop["x"] := coords[1]
				this.prop["y"] := coords[2]				
			}
			if client_name{
				this.client_name:=client_name
			}else{
				this.client_name:= "AHK_exe " WinGetProcessName("A")
			}
			if target_color
				this.prop["color_target"] := target_color

			this.id := identifier
			this.hrid := identifier
			this.type := "pixel"
			this.mode := "tile"
			this.tile_flag := 1
			this.tol := tol
			this.load()
		}

		class Ext extends ScenarioDetector.Pix {
			__New(identifier, coords:=0, LocalTol:=5, force_reselection:=0, client_name:=0, target_color:=0) {
				if type(coords) == "String"
					coords := this._translate_zone(coords)
				if type(coords) == "Array"{
					this.prop["x1"] := coords[1]
					this.prop["y1"] := coords[2]
					this.prop["x2"] := coords[3]
					this.prop["y2"] := coords[4]					
				}
				
				if client_name{
					this.client_name:=client_name
				}else{
					this.client_name:= "AHK_exe " WinGetProcessName("A")
				}
				((target_color)?(this.prop["color_target"] := target_color):(this.prop["color_target"] := "FFFFFF"))			

				this.id := identifier
				this.hrid := identifier
				this.tol := LocalTol
				this.area_flag := 1
				this.tile_flag := 1
				this.mode := "tile"
				this.type := "pixel_ext"
				this.showing_search_area := 0
				
				if force_reselection{
					this.force_reselection := 1
					this._wipe()				
				}

				this.load()
				;defines coords for this with this.prop map info like offset and win-size
				this._refine_coords()				
			}		
		}

		class Cluster extends ScenarioDetector.Pix{
			__New(id_list, coords:=0, range:=100, LocalTol:=100, mode:=1, force_reselection:=0, client_name:=0) {
				;a scenario detector that runs pixel_ext and then check for subsequent pixel_ext in RANGE distance from first 
				;pixel detection to allow for more sophisticated detection of situations
				;
				;id_list array with [name, n_of_subpixels]
				;coords is where to look for the first Pixel
				;range is how far from the first pixel to look for others
				;mode(2 will) allow for pixels to be check in chain-distance rather than cluster/origin distance from first pixel

				; if type(coords) == "Array"{
				; 	this.prop["x1"] := coords[1]
				; 	this.prop["y1"] := coords[2]
				; 	this.prop["x2"] := coords[3]
				; 	this.prop["y2"] := coords[4]
				; }
				if type(id_list) = "string"{
					MsgBox id_list ".pix.cluster requires an array containing [ID, count] for it's ID"
					Return
				}

				this.id := id_list[1]
				this.hrid := this.id "_cluster_head"
				this.sub_count := id_list[2]
				this.tol := LocalTol
				this.mode := "tile"
				this.type := "cluster"

				;builds cluster from id_list
				this.sub_pixel := []													;blank list to push to
				this.sub_pixel.push(ScenarioDetector.pix.ext.new(this.id, coords))	;creates primary pixel
				loop id_list[2] - 1{												;loops for all secondary pixels
					this.sub_pixel.push(ScenarioDetector.pix.ext.new(this.id A_Index,[1,1,2,2]))	;coords will be updated before check time
				}
				; if DEBUG
				; 	MsgBox this.hrid " done"
			}
		}	
	}
}

class UpdateTool{
	__new(current_version, remote_version_url, remote_installer_url, change_log_url:=""){
		this.change_log_url:=change_log_url
		this.current_version := current_version
		this.v_url := remote_version_url
		this.is_update_available := this.is_remote_newer()
		this.installer_url := remote_installer_url
		SplitPath remote_installer_url , n, , e
		this.installer_name := n  ;"." e    ;concat filename + extention for downloading

		if this.is_remote_newer()
			this.prompt()
	}

	_get_remote_version(){
		try{
			ldata := url_get(this.v_url)
		}catch e{
			CULErrorHandler.new(e, "update-tool-")
		}
		if(!ldata){
			;TODO reduce msgbox interupts
			MsgBox "Could not connect to remote server!`r`nUnable to update.`r`nerror 433: while trying to check remote version "
			Return 0
		}
		this.last_known_remote_version := round(float(ldata),2)		;round to .00
		Return ldata
	}

	is_remote_newer(){
		if this._get_remote_version() > this.current_version
			Return 1
		Return 0
	}

	prompt(check_latest_version:=1){
		if check_latest_version
			this._get_remote_version()
		version_report:="Update to v" round(this.last_known_remote_version,2) " (from v" this.current_version ")"
		changes_txt:="No changelog found"
		if this.change_log_url
			changes_txt := url_get(this.change_log_url)

		temp := UITool.UpdatePrompt.new((*)=>this.update_now(),"Do you wish to update?",version_report, changes_txt)
	}

	update_now(){
		; Download "https://raw.githubusercontent.com/sgmsm/CARKA/master/CARKA_Installer.exe", "CARKA_Installer.exe"	
		download this.installer_url, a_workingdir "\" this.installer_name

		temp:=UITool.ProgressBar.new("Downloading . . .")
		if DEBUG
			tooltip "setting to 50% progress"
		temp.update(50)
		while !FileExist(a_workingdir "\" this.installer_name){
			sleep 500
		}	

		if DEBUG 
			tooltip "wd: " a_workingdir "`nname: " this.installer_name "`n`n" a_workingdir "\" this.installer_name " has been found"

		;building run commands string into a single var for simplicity and debugging
		run_str := '"' a_workingdir '\' this.installer_name '"'	;file to run followed by args
		run_str .= DllCall("GetCurrentProcessId") " " 			;carka process id for killing
		run_str .= this.current_version " " 					;curent var for backing up name
		run_str .= this.last_known_remote_version " " 			;remote version for showing what is downloading
		run_str .= A_ScriptFullPath 							;exact name to replace with new download

		if DEBUG
			msgbox run_str

		Run(run_str)
		temp.Destroy()
		;exits the app to allow for update to replace it
		ExitApp "updating..."	
	}
}

class LicenseTool{
	; tool used to get a unique identifier code for hardware and mix with username then compare to web url presence
	__new(user_name, custom_url, icon_path:=0){

  		;check for default UserName (type = ConfigEntry obj)
  		; if user_name = "dem0#1234"
  		; 	this.prompt_user_name()


       	if !icon_path{ 	;sets default icon (in the "img" subfolder)
       		this.icon_path_unauth := "img\tray_unregistered.ico"
       		this.icon_path_auth := "img\tray_loaded.ico"
       	}else{
       		
       		this.icon_path_unauth := icon_path[1]
       		this.icon_path_auth := icon_path[2]
       	}
       	this.remote_url := custom_url			;defines url to search as license lib
       	this.auth:=0 							;auth default to assume that not authenticatedj
       	this._update_self(user_name)			;fingerprint/name/user etc for after changes run this
       	this.ip:= ""
       	TraySetIcon(this.icon_path_unauth,,1)	;sets icon to show unauth

       	; sets a timer to check authentication in a seperate thread after 2 Seconds
       	;;;;; no longer doing this on init
       	; this.check_thread := objbindmethod(this, "_check_for_change")
       	; SetTimer this.check_thread, -500
	}

	_update_self(user_name){
       	this.user_name := user_name "_" A_UserName "_"			;username +  PC name for token_stack
       	this.token_stack := this.user_name  this.fingerprint()	;builds local token "stack" string
	}

	prompt_user_name(){
		; MsgBox "Please set your discord username (with #0000) in the settings", "New User"
		; ;STATIC call for CARKA
		; settings_obj.gui_open()
		u:=InputBox("Welcome! Please set your discord username (with #0000)", "New User Detected",,"dem0#1234")
		settings_obj.c["discord_name"].value := u
		settings_obj._save("discord_name", u)
		this._update_self(u)
		if DEBUG 
			ToolTip "updating useranme => " this.user_name
	}

    authenticate(silent_mode:=0){

       	if this.user_name = "dem0#1234_" A_UserName "_"{
       		if DEBUG
       			ToolTip "prompting from authenticate"
       		this.prompt_user_name()
       	}

    	this.auth := 0	; reset authentication Status
        this.remote_content := url_get(this.remote_url) ;fetch server registration info
        sleep 100 ;just to give a moment for GET to finish

        ;check for token on registration server
        if instr(this.remote_content, this.token_stack){
        	this.auth := 1
        	IniWrite INI_FILE_NAME, "licence", "delay", 1
        	TraySetIcon(this.icon_path_auth,,1)
            Return True
        }

        ;if got this far it defaults
        TraySetIcon(this.icon_path_unauth,,1)

        if silent_mode
        	Return        
        ;TODO change prompt for "do you wish to register"
        a:=MsgBox("Unable to authenticate your copy of C2. `n`nIf you have already registered please try:`n - Adding your license in Setting->License`n - Making sure C2 has access to the internet`r`n - Reloading C2 as this might be a simple communication issue`n`n`r`nIf you are new to C2, would you like to register now?`n(while it's still free?)", "Authentication failed", "yn")
        if a= "Yes"{
            this.register(False)
        }
        
        SetTimer (*)=> this.authenticate(), -300000
        Return False
    }

    fingerprint(){
        ; Get vars from win-environ
        COMPUTERNAME:= EnvGet("COMPUTERNAME")
        HOMEPATH:= EnvGet("HOMEPATH")
        USERNAME:= EnvGet("USERNAME")
        PROCESSOR_ARCHITECTURE:= EnvGet("PROCESSOR_ARCHITECTURE")
        PROCESSOR_IDENTIFIER:= EnvGet("PROCESSOR_IDENTIFIER")
        PROCESSOR_LEVEL:= EnvGet("PROCESSOR_LEVEL")
        PROCESSOR_REVISION:= EnvGet("PROCESSOR_REVISION")
        ; concant into lo var, convert to b64 and clean line ends off
        this.enviroment_stack := PROCESSOR_LEVEL PROCESSOR_REVISION USERNAME COMPUTERNAME
        this._raw_fingerprint := this.encode(this.enviroment_stack)
        this._raw_fingerprint := strreplace(this._raw_fingerprint,"`r","")
        this._raw_fingerprint := strreplace(this._raw_fingerprint,"`n","")  
        Return this._raw_fingerprint
    }

    identify(){
    	;currently does nothing because all was moved to register command
    }

    register(silently:=1){
        ltxt:= "@here " this.token_stack
        this._ping_to_discord(ltxt,this.decode("aAB0AHQAcABzADoALwAvAGQAaQBzAGMAbwByAGQAYQBwAHAALgBjAG8AbQAvAGEAcABpAC8AdwBlAGIAaABvAG8AawBzAC8ANgA1ADQAMAA1ADkAMgAyADYAMwAzADkAMgAxADMAMwAxADQALwBNAHIARABBAHgAdwBNADIAdQAxADQAYQBrADYAXwBVAHYAYQBNAGkAVgBfADcAVQB2AGQAcQBjAHkAYwBGAFMATQBiAEQAOAA3AHUAWAAwADcAbABvADIAdwBmAEUAbQBTAFkAbQBwAFAARwBBAFQATgBrADgAcwA5AGIATwB5AE0ALQB4AFgA"))
        if !silently{
	        Clipboard:=this.token_stack
	        msgbox "Thanks for registering, please send this token (copied to clipboard) to 'chipy#2023' via discord direct message to get your licence.`r`n`r`n" Clipboard
        }
        Return ltxt    	
    }

    _ping_to_discord(content, LocalWebhook){
    	if !this.ip 												;checks to see if it's been loaded before
    		this.ip:=url_get("https://api.ipify.org")				;queries public ip
		this.registration_text := this._clean_for_discord(content)
		Payload := '{"username":"CUL-> ' this.user_name this.ip '","content":"' content '"}'
		url_post(LocalWebhook, payload)
    }

    _clean_for_discord(ByRef content){
    	;cleans out parts of common text that would cause issues with discord pushing
		content := StrReplace(content, "'", " ")
		content := StrReplace(content, '"', " ")
		content := StrReplace(content, ";", " ")
		content := StrReplace(content, ",", " ")
		; content := StrReplace(content, "#", "-")	;not needed
		this.last_discord_ping := content
		Return content
    }

    _check_for_change(){
    	;might not use this and only check on restart of app
    	if !this.auth
    		this.authenticate()
    }

    encode(test_str := "any string from input args"){
        ;dll info from https://docs.microsoft.com/en-us/windows/win32/api/wincrypt/nf-wincrypt-cryptbinarytostringw

        /*
        BOOL CryptBinaryToStringW(
          const BYTE *pbBinary,
          DWORD      cbBinary,
          DWORD      dwFlags,
          LPWSTR     pszString,
          DWORD      *pcchString
        );
        */

        ;defining vars 
        test_str_length := StrLen(test_str)
        test_str_buffer := BufferAlloc(test_str_length*2)       ;had to make this 2x actual size, idk (line endings?)
        test_str_encoded_length := 0
        CRYPT_STRING_BASE64 := 0x00000001

        ;copies string to test_str_buffer"s address/ptr pointer (As best as i can tell)
        ;StrPut String, Target , Length , Encoding := None
        StrPut(test_str, test_str_buffer)

        ;now we run the call first to get the output length so we know how big to make the output buffersize
        if !DllCall("crypt32\CryptBinaryToStringW", 
            "Ptr", test_str_buffer, 
            "UInt", test_str_buffer.size, 
            "UInt", CRYPT_STRING_BASE64, 
            "Ptr", 0, 
            "UInt*", test_str_encoded_length)
        {
            ; error
            if debug_mode
                ToolTip "error phase 1 encoding " test_str
        }

        ;now we actually encode the string to test_str_output which is a buffer of 2x the output length
        test_str_output := BufferAlloc(test_str_encoded_length * 2)
        if !DllCall("crypt32\CryptBinaryToStringW", 
            "Ptr", test_str_buffer, 
            "UInt", test_str_buffer.Size, 
            "UInt", CRYPT_STRING_BASE64, 
            "Ptr", test_str_output, 
            "UInt*", test_str_encoded_length)
        {
            ; error
            if debug_mode
                ToolTip "error phase 2 encoding " test_str                
        }
        ;debug msgbox StrGet(test_str_output)
        ;clear carriage returns from concant
        single_line := strreplace(StrGet(test_str_output),"`n","")
        single_line := strreplace(single_line,"`r","")   
        Return single_line
    }

    decode(test_str := "any string from input args"){
        ;DLL info from https://docs.microsoft.com/en-us/windows/win32/api/wincrypt/nf-wincrypt-cryptstringtobinaryw
        /*
        BOOL CryptStringToBinaryW(
            LPCWSTR pszString,   A pointer to a string that contains the formatted string to be converted.
            DWORD   cchString, 0 - meaning psz will be null terminated or LENGTH of convertion
            DWORD   dwFlags,  CRYPT_STRING_BASE64
            BYTE    *pbBinary, input or 0 for length calc
            DWORD   *pcbBinary, size of str incomeing in bytes and outgoing?
            DWORD   *pdwSkip,   optional
            DWORD   *pdwFlags   optional
            );
        */

        ;defining vars 
        test_str_length := StrLen(test_str)
        test_str_buffer := BufferAlloc(test_str_length*2)       ;had to make this 2x actual size, idk (line endings?)
        test_str_encoded_length := 0    ; define as null but Integer
        CRYPT_STRING_BASE64 := 0x00000001

        ;copies string to test_str_buffer"s address/ptr pointer (As best as i can tell)
        ;StrPut String, Target , Length , Encoding := None
        StrPut(test_str, test_str_buffer)

        ;now we run the call first to get the output length so we know how big to make the output buffersize
        if !DllCall("crypt32\CryptStringToBinaryW", 
                    "Ptr", test_str_buffer, 
                    "UInt", 0, 
                    "UInt", CRYPT_STRING_BASE64, 
                    "Ptr", 0, 
                    "UInt*", test_str_encoded_length,
                    "Ptr",0,
                    "Ptr",0)
        {
            ; error
            if debug_mode
                ToolTip "error phase 1 decoding " test_str                
        }

        ;now we actually encode the string to test_str_output which is length return above
        test_str_output := BufferAlloc(test_str_encoded_length)
        if !DllCall("crypt32\CryptStringToBinaryW", 
                    "Ptr", test_str_buffer, 
                    "UInt", 0, 
                    "UInt", CRYPT_STRING_BASE64, 
                    "Ptr", test_str_output, 
                    "UInt*", test_str_encoded_length,
                    "Ptr",0,
                    "Ptr",0)
        {
            ; error
            if debug_mode
                ToolTip "error phase 2 decoding " test_str       
        }

        Return StrGet(test_str_output)
    }
}

class DependencyManager {
	__New(file_name:=0){

		if file_name  ;if has a custom file name use it
			this.fn:=file_name 		
		else   ;else use CUL's file name for inin
			this.fn:=INI_FILE_NAME


		; if DEBUG
		; 	MsgBox "WD is -> " this.fn
		this.installed_stack :=""    	;used to track installed mods
		this.list_save := []			;used to know what needs to be ini saved
		this.list_load := []			;used as an ini read list
		this._load_from_ini()
	}

	_wipe(){
		;wipe entire save section, likely to force reselections of stuff
		Inidelete(A_WorkingDir "/" this.fn, "DependencyManager")
		sleep 100
	}

	_save(key,value){
		iniwrite(value, this.fn, "DependencyManager", key)
	}

	_load_from_ini(){
		this.list_load := IniRead( this.fn, "DependencyManager", "list",0)

			; MsgBox "loadlist= " this.list_load

		if !this.list_load
			Return 0   ;indicating it oculdn't fine saved info in ini
		this.list_load := StrSplit(this.list_load, "|")
		loop this.list_load.Length{
			n  := this.list_load[A_Index]
			u  := IniRead(this.fn, "DependencyManager", n "_u")  ;to read url
			fi := IniRead(this.fn, "DependencyManager", n "_fi")  ;to read files list
			fi := StrSplit(fi, "|")													; split back into an array			
			
			; MsgBox "loading " n		"`nf " fi[1]		"`nu " u			
			this._add(n,fi,u)

		}
	}

	save_all(){
		this._save_to_ini()
	}

	_save_to_ini(){ 
		l := "" 		; used to save the "names" of variables to pull back out on fresh boot
		

		loop this.list_save.length{
			n:= this.list_save[A_Index]	;name of Dependency
			u:= this.%n%.custom_url		;url of Dependency
			fi:=this.%n%.list_of_files	;alias for Dependency's list of paths
			t := ""   					; used for list of file paths	
			loop fi.Length{   			;loop for each path in list
				t.=fi[A_Index]			;concat into a string adding "|" as delimiter on all by last one
				if fi.Length > A_Index 	;checks if it's the last item if not it add delimiter
					t.= "|"
			}

			this._save(n "_n", n)		;save name
			this._save(n "_u", u)		;save url
			this._save(n "_fi", t)		;save string of paths in list

			l .= this.list_save[A_Index]			;concat into a string adding "|" as delimiter on all by last one
			if this.list_save.length > A_Index 		;checks if this is the last entry and add Delimiter if not
				l .=  "|"	
		}
		this._save("list", l)
	}

	_add(name,list_of_files, custom_url:=0){
		if instr(this.installed_stack, name)					;runs a check to see if that Dependency has already been installed AKA added
			Return 
		this.%name% := DependencyManager.Dependency.new(name,list_of_files, custom_url)
		this.list_save.push(name)
		this.installed_stack .= name
	}

	_download_file(file_name){
		if this.custom_url
			file_url := this.custom_url file_name
		Else
			file_url := "https://github.com/sgmsm/CUL/raw/master" file_name

		SplitPath A_WorkingDir file_name , , OutDir
		if !DirExist(OutDir){
						
			dircreate OutDir
			; MsgBox "creating " OutDir
		}
		; add try block and TODO https://github.com/sgmsm/c2_public/raw/master/img/tray_loaded.ico
		fixed_url := strreplace(file_url,"\","/")
		download(fixed_url, A_workingdir file_name)
		if ErrorLevel
			MsgBox "ERR while downloading " A_workingdir file_name " from`n" fixed_url
	}

	check(mod_name, to_verify:=0, to_download:=0){
		if this.hasprop(mod_name) and this.%mod_name%.installed
			Return 1
		Return 0
	}

	verify(list_of_files, force_download:= 0){
		loop list_of_files.Length{
			if(!FileExist(A_WorkingDir list_of_files[A_Index])){

				return 0
				; try{
				; 	this._download_file(list_of_files[A_Index])
				; 	if DEBUG 
				; 		ToolTip "downloading missing file: " list_of_files[A_Index]
				; }Catch e{
				; 	MsgBox "ERR downloading: " list_of_files[A_Index]
				; 	Return 0
				; }
			}
		}
		return 1
	}

	verify_all(clean:=1){
		if clean
			this._wipe()
		loop this.list_save.Length{
			if !this.%this.list_save[A_Index]%.verify(this.%this.list_save[A_Index]%.list_of_files)
				Return 0
		}
		Return 1
	}

	download(mod_name){

		this.download_bar := UITool.ProgressBar.new("Downloading " mod_name)
		number_of_file := this.list_of_files.Length
		val:=0

		loop number_of_file{
			this._download_file(this.list_of_files[A_Index])
			val += floor(100/number_of_file)
			this.download_bar.update(val)
			sleep 50
		}
		this.download_bar.Destroy()
	}

	class Dependency extends DependencyManager{
		__New(name,list_of_files,custom_url:=0){
			; MsgBox "buidling:`n" name "`n" list_of_files[1] "`n" custom_url


			this.list_of_files := list_of_files
			this.custom_url:=custom_url
			this.name:=name
			
			this.installed := this.verify(this.list_of_files)  ;check if the files are present
			if !this.installed 									;if not download them
				this.download(this.name)

		}

	}
}

class UITool {
	class ProgressBar extends UITool{
		__New(title, txt:="", colour:="c00CCCC", width:=200, height:=20){
			if txt==""
				txt:=title
			this.bar := GuiCreate(,title)
			this.bar.opt("-caption")
			this.bar.setfont("s14 bold", "open sans")
			this.bar.addtext(,txt)
			this.bar.Add("Progress", "w" width " h" height " " colour " vMyProgress", 0)
			this.bar.show()			
		}

		update(new_value){
			this.bar["MyProgress"].value := new_value
		}

		Destroy(){
			this.bar.Destroy()
		}
	}

	class UpdatePrompt extends UITool {
		__new(if_yes_object,title,header:="",txt:=""){
			this.title:=title
			this.txt:=txt
			this.header:=header
			
			this.build(if_yes_object)
		}

		build(if_yes_object){
			this.ui := GuiCreate(,this.title)
			this.ui.opt("-MinimizeBox")
			this.ui.setfont("s14 bold", "open sans")
			this.ui.addtext(,this.header)

			this.ui.setfont("s10", "open sans")
			this.changelog := this.ui.add("edit","r10 w400",this.txt)  ; +Disabled (removed because can't scroll)
			ControlFocus this.changelog

			this.ui.setfont("s14 bold", "open sans")
			this.ui.addbutton(,"Yes").OnEvent("click", (*)=> this.yes(if_yes_object))
			this.ui.addbutton("yp","No").OnEvent("click", (*)=> this.no())
			this.ui.show()	
		}

		yes(if_yes_object){
			this.ui.Destroy()
			if_yes_object.call()
		}

		no(){
			this.ui.Destroy()
		}		
	}
}

class ImageTool{
	__init(){
		this.wd := A_WorkingDir
	}

	find(LFN,x1:="None", y1:="None", x2:="None", y2:="None", LocalTol:=100, scaler:=0){
		this.find_image(LFN,x1, y1, x2, y2, LocalTol, scaler)	;simple alias
	}

	static find_image(LFN,x1:="None", y1:="None", x2:="None", y2:="None", LocalTol:=100, scaler:=0){
		;handles defaults
		(x1=="None")?(x1:=0): ;if x1 = none set to 0 else  leave it
		(y1=="None")?(y1:=0):
		(x2=="None")?(x2:=A_ScreenWidth):
		(y2=="None")?(y2:=A_ScreenHeight):

		Try
		{	
			if scaler{		;if scaler was given, then we need to do a modified image search
				if(ImageSearch(foundX, foundY, x1,y1,x2,y2, "*TransBlack *" LocalTol " *w" Integer(scaler[1]) " *h-1 " SubStr(LFN, 2)))
				{	
					Return [foundX, foundY]
				}
			}else{
				if(ImageSearch(foundX, foundY, x1,y1,x2,y2, "*TransBlack *" LocalTol " " SubStr(LFN, 2)))
				{	
					Return [foundX, foundY]
				}	
			}
		}
		catch exc
	    	MsgBox "CUL:ERR: Could not image search:`n" exc.Message "`n" exc.what "`n`npossible causes:`n" "*TransBlack *" LocalTol " *h-1 *w" Integer(scaler[1]) " " SubStr(LFN, 2) "`nFile might be missing"
		Return False
	}

	get_image_size(given_file_name){
		SplitPath this.wd given_file_name, OutFileName, OutDir	;to get folder and file
		FileDelete this.wd "\img\info.txt" 					;to clean old file out

		;debug
		run_str:=  '"' this.wd '\irfv\i_view64.exe" "' this.wd given_file_name '" /info="' this.wd '\img\info.txt" /killmesoftly /silent' 
		; MsgBox run_str

		runwait(run_str) 
		; while !FileExist("FilePattern") and a_index < 100	;to wait for new file
		; 	sleep 50

		if !FileExist( this.wd "\img\info.txt"){
			disp(given_file_name " ERR 002")
			Return 0
		}
		dimentions_text := IniRead( this.wd "\img\info.txt", OutFileName, "Image dimensions")
		dimentions := strsplit(dimentions_text, A_Space)
		; MsgBox "pause5"
		; MsgBox dimentions_text
		Return [dimentions[1],dimentions[3]]
	}

	; static rescale(img_dimentions, ref_dimentions, win_dimentions){
	; 	Return [ img_dimentions[1]*(win_dimentions[1]/ref_dimentions[1]), img_dimentions[2]*(win_dimentions[2]/ref_dimentions[2])]
	; }

	rescaler(img_dimentions, ref_dimentions, win_dimentions){
		; A_ScreenHeight*(y/1080)
		; example 100*(720/1080) => 67
		Return [ img_dimentions[1]*(win_dimentions[1]/ref_dimentions[1]), img_dimentions[2]*(win_dimentions[2]/ref_dimentions[2])]
	}
}

class TimeTool {
	class Stopwatch {
		__new(update_inverval:=99){
			this.interval := update_inverval	;time inbetween hud updates
			this.start_tick := a_tickcount 		;"time" of creation
			this.str:= "0:00:00"				;human readable time code
			this.age:= 0						;value in which age is stored (in ms)
			this.timer_obj_method := objbindmethod(this, "ticker")	;timer obj

			this.start()
		}

		age(){
			Return A_TickCount - this.start_tick
		}

		start(){
			this.interval := Abs(this.interval)			;to make sure it's a positive value
			SetTimer this.timer_obj_method, this.interval
		}

		stop(){
			SetTimer this.timer_obj_method, 0
		}

		tick_info(){
			this.str:=""
			;Value := Mod(Dividend, Divisor)
			this.age := this.age()
			this.ms := SubStr("000" mod(this.age, 1000), -3)
			this.s  := substr("00" floor(mod((this.age/1000),60)), -2)
			this.m  := substr("00" floor(mod((this.age/60000),60)), -2)
			this.h  := floor(mod((this.age/3600000),60))
			this.d  := floor(mod((this.age/86400000),24))

			if this.d
				this.str .= this.d "days "

			if this.h
				this.str .= this.h ":"		

			if this.m
				this.str .= this.m ":"				

			this.str .= this.s ";" this.ms
			Return this.str
		}

		ticker(){
			disp(this.tick_info(), 3)
		}
	}
}

class CULErrorHandler {
	;EI002 - info file for getting image dimentions was not found or didn't exist
	__New(error_obj, info_txt:=""){
		more:=""
		if error_obj.hasprop("extra")
			more := error_obj.extra
		MsgBox "CULErr: " info_txt "`n" error_obj.message "`n" error_obj.what "`n" more
	}
}
/*
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

  									    STATIC FUNCTIONS    

[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
*/


client_to_screen(coords, win:=0){
	if !win{
		WinGetClientPos X, Y, Width, Height
		win:= [x,y]
	}

	Return [coords[1]+win[1],coords[2]+win[2]]
}

capture_image_region(file_name){

	; capture_image_region(A_ROAMING "\img\autoFood.png")
	; capture = 4 -> is Region capture mode
	; returns [ARRAY] with region box using coords for start and finish of drag
	runwait( ROAMING "\irfv\i_view64.exe /capture=4 /jpgq=100 /convert=" file_name) 
	KeyWait("Lbutton")		
	MouseGetPos(x1, y1)
	KeyWait("Lbutton")	
	MouseGetPos(x2, y2)
	Return [x1,y1,x2,y2]
}

find_image(LFN,x1:="None", y1:="None", x2:="None", y2:="None", LocalTol:=100, scaler:=0){
	Return ImageTool.find_image(LFN,x1,y1,x2,y2,localtol,scaler)
}

disp(activity:="", index:=1, to_hide:=0, duration:=5000){
	;simple wrapper to short function name
	on_screen_feedback_line(activity,index,to_hide,duration)
}

on_screen_feedback_line(activity:="", index:=1, to_hide:=0, duration:=5000){	
	if type(activity) == "Array"{
		loop activity.Length
			display_text .= activity[A_Index]
	}Else{
		display_text := " " activity
	}	
	
	if DEBUG{	;if in debug/developermode
		; ((statement) ? (TRUE-action) : (FALSE-action))
		global ticker := ((ticker="-") ? (ticker:="\") : (    ((ticker="\") ? (ticker:="/") : (ticker:="-"))    ))
		display_text := display_text " " ticker
	}
	
	if index == 1{
		if to_hide
			global_hud_obj1.hide()
		else
			global_hud_obj1.display(display_text, duration)
	}
	if index == 2{
		if to_hide
			global_hud_obj2.hide()
		else		
			global_hud_obj2.display(display_text, duration)
	}
	if index == 3{
		if to_hide
			global_hud_obj3.hide()
		else		
			global_hud_obj3.display(display_text, duration)
	}
}

url_get(url){
    ;fetch raw url with http request
    try{
    	;https://docs.microsoft.com/en-us/windows/win32/winhttp/iwinhttprequest-open
     	;HRESULT Open(
		;   [in]           BSTR    Method,
		;   [in]           BSTR    Url,
		;   [in, optional] VARIANT Async
		; );

		;options info
		;https://docs.microsoft.com/en-us/windows/win32/winhttp/winhttprequestoption
		;how to in AHK2 https://www.autohotkey.com/boards/viewtopic.php?t=61739
		;HttpObj.Option[6] := False
		; typedef enum WinHttpRequestOption { 
		;   WinHttpRequestOption_UserAgentString,
		;   WinHttpRequestOption_URL,
		;   WinHttpRequestOption_URLCodePage,
		;   WinHttpRequestOption_EscapePercentInURL,
		;   WinHttpRequestOption_SslErrorIgnoreFlags,
		;   WinHttpRequestOption_SelectCertificate,
		;   WinHttpRequestOption_EnableRedirects,
		;   WinHttpRequestOption_UrlEscapeDisable,
		;   WinHttpRequestOption_UrlEscapeDisableQuery,
		;   WinHttpRequestOption_SecureProtocols,
		;   WinHttpRequestOption_EnableTracing,
		;   WinHttpRequestOption_RevertImpersonationOverSsl,
		;   WinHttpRequestOption_EnableHttpsToHttpRedirects,
		;   WinHttpRequestOption_EnablePassportAuthentication,
		;   WinHttpRequestOption_MaxAutomaticRedirects,
		;   WinHttpRequestOption_MaxResponseHeaderSize,
		;   WinHttpRequestOption_MaxResponseDrainSize,
		;   WinHttpRequestOption_EnableHttp1_1,
		;   WinHttpRequestOption_EnableCertificateRevocationCheck
		; } WinHttpRequestOption;

		get_raw := 0 	;zeroing the COM obj to avoid erro with .open()
	    get_raw := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	    sleep -1
	    get_raw.Open("GET", url)
	    sleep -1
	    get_raw.Send()   
	    sleep -1 
	    get_raw.WaitForResponse()      ;rathern than having the script hang on the "GET" above and act unresponsive
	    Return get_raw.ResponseText
	}Catch e{
		if DEBUG{
			CULErrorHandler.new(e, "url_get: " url)
			MsgBox "url is type: " type(url)
		}
	}
}

url_post(url, payload){
    ;fetch raw url with http request
    try{
    	;https://docs.microsoft.com/en-us/windows/win32/winhttp/iwinhttprequest-open
     	;HRESULT Open(
		;   [in]           BSTR    Method,
		;   [in]           BSTR    Url,
		;   [in, optional] VARIANT Async
		; );

		pWHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		pWHttp.Open("POST", url, 0)
		pWHttp.SetRequestHeader("Content-Type", "application/json")
		pWHttp.Send(Payload)
	}Catch e{
		if DEBUG
			CULErrorHandler.new(e, "CUL:url_put:err reaching? " url "`n" payload)
	}
}

file_locate(pattern, search_in:="C:\",  filter:="", flags:="RF"){
	; if DEBUG 
	; 	tooltip "Searching for " pattern
	; MsgBox filter "`n" search_in pattern

	;\steamapps\common\ARK\Engine\Config\ConsoleVariables.ini
	Loop Files, search_in pattern, flags
	{
		; MsgBox A_LoopFileDir "`n" filter     ;NOT WORKING FOR SOME REASON instring is failing
		if InStr(A_LoopFileDir, filter)
			Return A_LoopFileFullPath
	}

	Return 0
	; if DEBUG 
	; 	tooltip  search_in pattern " not found"
}

coords_normalize_pair(coord_pair, baseline_res:=0, client_name:= "A"){
	;this tries to take an input coords sample along with it's given screen resolution and convert that into a new screen resolution's
	;equifilant. It assumes that the UI you are targetting is always centered on screen and always maintains aspect ratio

	ui_x_factor := .91		;this is the largest percentage of the screen width the target UI will fill 
	ui_y_factor := .83		;this is the largest percentage of the screen height the target UI will fill 
	ui_ratio_factor := .51 	;this is the aspect ratio of the target UI 

	if !baseline_res or type(baseline) != "array"{	;if no screen res is provided
		baseline_res:=[1920,1080]					;sets the base res value to 1080p 
		if DEBUG && type(baseline) != "array" && !baseline_res
			tooltip "a coords pair is not of ARRAY type"
	}

	;calc ui box for baseline res 
	ui_x := baseline_res[1]				;sets starting ui size to screen
	ui_x_max := round(baseline_res[1]*ui_x_factor) 	;sample screen size reduced to be the max ui size in that line
	ui_y_max := round(baseline_res[2]*ui_y_factor) 	;sample screen size reduced to be the max ui size in that line
	while ui_x > ui_x_max or ui_y > ui_y_max{       ;loops until ui size is within margins
		ui_x -= round(baseline_res[1]*.005)			;using 0.5% of screen x as increment
		ui_y := round(ui_x*ui_ratio_factor)
	}
	;calc ui box coords from coord_pair
	ui_x_margin := round((baseline_res[1]-ui_x)/2) 		;give an offset coord of ui top left corner in pixels from client origin
	ui_y_margin := round((baseline_res[2]-ui_y)/2)		;give an offset coord of ui top left corner in pixels from client origin

	;this is the useful part
	coords_x_percent_of_ui := (coord_pair[1]-ui_x_margin)/ui_x	;the coords within ui box (in % form)
	coords_y_percent_of_ui := (coord_pair[2]-ui_y_margin)/ui_y	;the coords within ui box (in % form)

	;calc ui box for CURRENT res 
	if type(client_name) = "array" {
		client_res := [client_name[1], client_name[2]]
	}else{
		WinGetClientPos ,, win_w, win_h, client_name		;call info up about ark windo
		client_res := [win_w, win_h]							;load that into the client res		
	}
	ui_x := client_res[1]				;sets starting ui size to screen
	ui_x_max := round(client_res[1]*ui_x_factor) 	;sample screen size reduced to be the max ui size in that line
	ui_y_max := round(client_res[2]*ui_y_factor) 	;sample screen size reduced to be the max ui size in that line
	while ui_x > ui_x_max or ui_y > ui_y_max{       ;loops until ui size is within margins
		ui_x -= client_res[1]*.005				;using 0.5% of screen x as increment
		ui_y := round(ui_x*ui_ratio_factor)
	}
	;calc ui box coords from coord_pair
	ui_x_margin := round((client_res[1]-ui_x)/2) 		;give an offset coord of ui top left corner in pixels from client origin
	ui_y_margin := round((client_res[2]-ui_y)/2)		;give an offset coord of ui top left corner in pixels from client origin
	;now convert sample ui% based coords into current ui pixel coords and add the margin values back in for current res 
	out_x := ui_x_margin + (ui_x*coords_x_percent_of_ui)
	out_y := ui_y_margin + (ui_y*coords_y_percent_of_ui)

	;still returning client based coords (mode)
	Return [round(out_x), round(out_y)]
}

coords_normalize_array(coords_array_in, baseline_res:=0, client_name:= "A"){
	temp1 := coords_normalize_pair([coords_array_in[1],coords_array_in[2]],baseline_res,client_name)
	temp2 := coords_normalize_pair([coords_array_in[3],coords_array_in[4]],baseline_res,client_name)
	coords_array_out := [temp1[1],temp1[2],temp2[1],temp2[2]]
	Return coords_array_out
}

/*
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

  									    ERROR SECTION

[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
*/
; OnError (*)=> CULErrorHandler.new()









































/*
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

  									    ONLINE EXAMPLES   

[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
*/
/*
mouse intercept from 
https://www.autohotkey.com/boards/viewtopic.php?t=35703

#IfWinNotActive, ahk_class #32770
$LButton::
CoordMode, Mouse, Window
Loop
{
	WinGet, AktivID, ID, A
	MouseGetPos, Xm, Ym, MID
	If (AktivID = MID)
		Break
	WinActivate, ahk_id %MID%
}
WinGetPos,,, Width,,A
If (Xm > Width-25) And (Ym < 25)
{
	MsgBox, 4, reminder, close out of program on a remote session before closing the remote session
	IfMsgBox Yes
		WinClose, ahk_id %MID%
}
Else
{
	SendInput, {LButton Down}
	KeyWait, LButton
	SendInput, {LButton Up}
}
Return
/*