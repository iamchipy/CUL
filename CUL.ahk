global ROAMING := A_AppData "\ChipysUtilityLibrary"
global DEPS := DependencyManager.new()

class NewHUD {
	; allows for display of single lines of text on screen bot-right
	__New(txt:="sample of text to display", index:=1){
		this.i := Integer(index)
		this.gui_obj := GUICreate("+LastFound +AlwaysOnTop -caption +disabled +ToolWindow",this.i)
		this.gui_obj.setfont("c00FF00 s20", "Verdana")				;incase of missing font
		this.gui_obj.setfont("c00FF00 s24 bold", "Droid Sans Mono")		;incase of missing font
		this.gui_obj.setfont("c00FF00 s24 bold", "Inconsolata-Bold")	    ;incase of missing font
		this.gui_obj.BackColor := "000000"
		WinSetTransColor("000000")
		this.txt_obj := this.gui_obj.add("text","xm ym", txt)
		
		this.display(txt)
	}

	display(text_to_display){
		LocalWidth := This.calc_width(text_to_display)
		LX:=A_ScreenWidth - LocalWidth - 100
		LY:=A_ScreenHeight  - 100 - (50*this.i)
		
		this.txt_obj.value := text_to_display
		this.txt_obj.move("w" LocalWidth )

		this.gui_obj.show("NoActivate autosize" " x" LX " y" LY)
	}

	calc_width(sample_str){
		FontWidth := 24
		LMargin := 2
		Return (StrLen(sample_str) * FontWidth + LMargin)
	}	

	hide(){
		this.gui_obj.hide()
	}
}

class Tool {
	class area_drag {
		__new(){
			this.area_coords:=0
			this.capture()
		}

		capture(){
			current_working_dir := A_ROAMING
			this.area_coords := capture_image_region(ROAMING "\temp_area")
		}
	}

	class Highlight {
		__New(id, coords, gui_color:="00FF00", duration:=500, show_tile:=0, coord_mode_to_use:="Screen", crosshair_size:=2){
			; a general tool to simplify debugging and display of locations on the screen
			; with either a point or an area as acceptible in puts
			;
			; id STRNG - is the unique name for this highlight
			; coords ARRAY - can be either 1 or 2 coordinate pairs if [array] form
			; *color STRNG - of hex 6digit type
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

			; dumping params
			this.id := id
			this.coords := coords
			this.duration := duration
			this.show_tile := show_tile
			this.gui_color := gui_color
			this.coord_mode_to_use := coord_mode_to_use
			; this.show := ObjBindMethod(this, this.type) TODO learn todo this without "func_obj.call()"
			
			;static vars for now (possible add to params)
			
			this.ch_b := crosshair_size					;buffer size around pixel
			this.ch_b2 := this.ch_b*3						
			this.ch_p := 1						;pixel size should stay 1 but just for calc
			this.ch_s := this.ch_b*2+this.ch_p  ; giving you "dot" number of pixels on either side of the clicked pixel
			this.ch_l := this.ch_b2*4


			;props for guis and deletions
			this.color_tile := ""
			this.gui_handles := [1,2,3,4,5,6]
			; this.gui_ids := []
			this.hide_timer := objbindmethod(this, "hide")
		}

		_start_timer(){
			if this.duration == 0
				Return  ; meaning permanent display or manual hiding
			;handles positive timer number so it never activates twice
			if this.duration > 0
				this.duration := 0-this.duration
			;handles timer start and resets(TODO add reset somehow/ refresh timer)
			SetTimer this.hide_timer, this.duration
		}

		_construct_crosshair_element(i,x,y,w,h,is_tile:=0){
			this.gui_handles[i] := GuiCreate("+toolwindow +AlwaysOnTop -Caption +Disabled +LastFound")
			if is_tile
				this.gui_handles[i].BackColor := PixelGetColor(this.x, this.coords[2])
			else
				this.gui_handles[i].BackColor := this.gui_color
			
			this.gui_handles[i].show(" x" x " y" y " w" w " h" h   " NoActivate")

			;check if it's an area type and then make it transparent ish
			if this.type == "area"
				WinSetTransparent(50, this.gui_handles[i])

		}

		show(duration:=-1){
			if duration != -1
				this.duration := duration
			;debug-ToolTip this.duration
			this._start_timer()	
			; process display of coords for a point
			if this.type == "point"{
				;a debugging dot for crosshair precision 
				;this._construct_crosshair_element(5,this.coords[1],this.coords[2], 1,1)
				this._construct_crosshair_element(1,this.coords[1]-this.ch_b, this.coords[2]-this.ch_b2-this.ch_l, this.ch_s,this.ch_l)
				this._construct_crosshair_element(2,this.coords[1]+this.ch_b2+this.ch_p, this.coords[2]-this.ch_b, this.ch_l,this.ch_s)
				this._construct_crosshair_element(3,this.coords[1]-this.ch_b, this.coords[2]+this.ch_b2+this.ch_p, this.ch_s,this.ch_l)
				this._construct_crosshair_element(4,this.coords[1]-this.ch_b2-this.ch_l, this.coords[2]-this.ch_b, this.ch_l,this.ch_s)

				if this.show_tile
					this._construct_crosshair_element(5,this.coords[1]+(2*(x_size+dot)), this.coords[2]-(2*(y_size+(4*dot))), 2*y_size, 2*x_size, 1)
			}
			if this.type == "area"{
				this._construct_crosshair_element(6,this.coords[1], this.coords[2], this.coords[3]-this.coords[1], this.coords[4]-this.coords[2])
			}
		}

		hide(){
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

class SenarioDetector {
	__init(){
		this.color_mark := "00FF00"
		this.hide_timer := objbindmethod(this, "hide_coords")
		this.last_coords := 0
		this.showing_search_area := 0
		this.mode := "base"
		this.last_seen := 0
		this.age := 0

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

		this.x := 0
		this.y := 0
		this.x1 := 0
		this.y1 := 0
		this.x2 := 0
		this.y2 := 0
	}

	show_coords(length_to_show:=1000, special_mode:=0){
		if this.last_coords != 0 {
			;id, coords, gui_color:="00FF00", duration:=500, show_tile:=0, coord_mode_to_use:="Screen", crosshair_size:=2
			this.hud_obj := tool.highlight.new(this.id, [this.last_coords[1], this.last_coords[2]], this.color_mark, length_to_show)
			this.hud_obj.show()
			Return
		}
		if this.type == "image" {
			this.hud_obj := tool.highlight.new(this.id, [this.x1, this.y1, this.x2, this.y2], this.color_mark, length_to_show)
			this.hud_obj.show()
		}


		; 	;handles positive timer number so it never activates twice
		; if length_to_show > 0
		; 	length_to_show := 0-length_to_show
		; ;handles timer start and resets(TODO add reset somehow/ refresh timer)
		; if length_to_show{
		; 	SetTimer this.hide_timer, length_to_show
		; }		

		; ;checks if there is a coord to show
		; if this.last_coords == 0
		; {
		; 	if this.type == "image" or this.type == "pixel_ext"
		; 	{				
		; 		;debug ToolTip "showing " this.id " " this.type " debug"
		; 		this.showing_search_area := 1
		; 		if this.search_area_gui_obj_id == 0
		; 		{
		; 			this.search_area_gui_obj := GuiCreate("+toolwindow +AlwaysOnTop -Caption +Disabled +LastFound")
		; 			this.search_area_gui_obj.BackColor := this.color_mark
		; 			this.search_area_gui_obj_id := WinExist()
		; 		}	
		; 		this.search_area_gui_obj.show("h" (this.y2-this.y1) " w" (this.x2-this.x1) " x" this.x1 " y" this.y1 " NoActivate")
		; 		WinSetTransparent 50, this.search_area_gui_obj
		; 	}
		; 	Return 0
		; }

		; x_size := 15
		; y_size := 15
		; dot := 4

		; ; debug-ToolTip this.id " " this.x ":" this.y "  <showing"
		; if(this.m_n_id == 0){
		; 	this.m_n := GuiCreate("+toolwindow +AlwaysOnTop -Caption +Disabled +LastFound")
		; 	this.m_n_id := WinExist()	;store the ID of the lastfound window
		; 	this.m_n.BackColor := this.color_mark
		; }
		; this.m_n.show("h" y_size " w" dot " x" this.x " y" (this.y - (y_size+dot)) " NoActivate")

		; if(this.m_s_id == 0){
		; 	this.m_s := GuiCreate("+toolwindow +AlwaysOnTop -Caption +Disabled +LastFound")
		; 	this.m_s_id := WinExist()	;store the ID of the lastfound window
		; 	this.m_s.BackColor := this.color_mark		
		; }
		; this.m_s.show("h" y_size " w" dot " x" this.x " y" (this.y + dot*2) " NoActivate")	

		; if(this.m_e_id == 0){
		; 	this.m_e := GuiCreate("+toolwindow +AlwaysOnTop -Caption +Disabled +LastFound")
		; 	this.m_e_id := WinExist()	;store the ID of the lastfound window
		; 	this.m_e.BackColor := this.color_mark			
		; }
		; this.m_e.show("h" dot " w" x_size " x" (this.x+dot*2) " y" this.y " NoActivate")

		; if(this.m_w_id == 0){
		; 	this.m_w := GuiCreate("+toolwindow +AlwaysOnTop -Caption +Disabled +LastFound")
		; 	this.m_w_id := WinExist()	;store the ID of the lastfound window
		; 	this.m_w.BackColor := this.color_mark
		; }
		; this.m_w.show("h" dot " w" x_size " x" (this.x-(x_size+dot)) " y" this.y " NoActivate")	

		; if this.type == "pixel" or this.mode == "tile"
		; {
		; 	if(this.tile_id == 0){
		; 		this.tile := GuiCreate("+toolwindow +AlwaysOnTop -Caption +Disabled +LastFound")
		; 		this.tile_id := WinExist()	;store the ID of the lastfound window
		; 		this.tile.BackColor := this.color1
		; 	}		
		; 	this.tile.show("h" 2*y_size " w" 2*x_size " x" this.x+(2*(x_size+dot)) " y" this.y-(2*(y_size+(4*dot))) " NoActivate")
		; }



	}

	; hide_coords(){
	; 	;handles issues of many timers being called on the smae gui
	; 	if showing_search_area 
	; 	{
	; 		if this.type == "image" or this.type == "pixel_ext"
	; 		{
	; 			this.search_area_gui_obj.Destroy()
	; 			this.showing_search_area := 0
	; 			this.search_area_gui_obj_id := 0
	; 		}
	; 	}

	; 	if this.m_n_id == 0
	; 		Return
	; 	this.m_n.Destroy()
	; 	this.m_s.Destroy()
	; 	this.m_e.Destroy()
	; 	this.m_w.Destroy()	
	; 	this.m_n_id := 0
	; 	this.m_s_id := 0
	; 	this.m_e_id := 0
	; 	this.m_w_id := 0

	; 	if this.type == "pixel" or this.mode == "tile"
	; 	{
	; 		this.tile.Destroy()	
	; 		this.tile_id := 0	
	; 	}
	; }

	is_present(variation:=-1){
		if variation <0
			variation := this.tol

		this.last_coords := 0  ; reset to avoid false positive
		if this.type == "image" {
			this.last_coords := find_image(this.file_name,
										   this.x1,
										   this.y1,
										   this.x2,
										   this.y2,
										   variation)
			if this.last_coords != 0
			{
				this.x := this.last_coords[1]
				this.y := this.last_coords[2]
				this.update_last_seen()
				Return 1
			}
			Return 0
		}
		if this.type == "pixel_ext" {
			this.mode := "pixel_ext"
			if(PixelSearch(x,y,this.x1,this.y1,this.x2,this.y2,this.color1,this.tol)) {
				this.last_coords := [x, y]
				this.x := x
				this.y := y
				this.update_last_seen()
				Return 1
			}
			Return 0
		}

		if this.type == "pixel"{
			r := 2
			if(PixelSearch(x,y,this.x-r,this.y-r,this.x+r,this.y+r,this.color1,variation)){
				this.last_coords := [x, y]
				this.x := x
				this.y := y	
				this.update_last_seen()			
				Return 1
			}
			Return 0		
		}
	}			

	update_last_seen(){
		this.last_seen := A_TickCount
	}

	get_age(){
		this.age := a_tickcount - this.last_seen
		Return this.age
	}

	class Img extends SenarioDetector{
		__New(file_name, coords:=0, LocalTol:=100) {
			;handles defaults
			if !coords{
				coords[1] := 0
				coords[2] := 0
				coords[3] := A_ScreenWidth
				coords[4] := A_ScreenHeight
			}

			;debug ToolTip x2 " : " y2
			this.file_name := file_name
			this.id := StrSplit(file_name , ".")[1]
			this.x1 := coords[1]
			this.y1 := coords[2]
			this.x2 := coords[3]
			this.y2 := coords[4]
			this.tol := LocalTol

			this.type := "image"
			this.showing_search_area := 0

			if(!FileExist(file_name)){
				MsgBox "no file detected for " file_name "`r`nPlease select it now"
				this.capture_new_sample()
			}
		}

		capture_new_sample(){
			capture_image_region(this.file_name)
		}
	}
	

	class Pix extends senarioDetector{
		__New(identifier){
			this.color1 := "FFFFFF"
			this.id := identifier
			this.type := "pixel"

			try {
				this.load()
				this.show_coords(-1000)
			} Catch e {
				disp("No config detected, please select '" this.id "' pixel now.")
				this.picker()
			}
		}

		save(){
			IniWrite this.x, "cfg.ini", "Settings", this.id "x"
			IniWrite this.y, "cfg.ini", "Settings", this.id "y"
			IniWrite this.color1, "cfg.ini", "Settings", this.id "color1"
		}

		load(){
			this.x := integer(IniRead("cfg.ini", "Settings", this.id "x"))
			this.y := integer(IniRead("cfg.ini", "Settings", this.id "y"))
			this.color1 := IniRead("cfg.ini", "Settings", this.id "color1")
			this.last_coords := [this.x, this.y]
		}

		picker(){
			ToolTip "left click desired pixel"
			OutputVarX := 0
			OutputVarY := 0

			; TODO capture next click Hotkey "LButton", "do_nothing", "on"
			KeyWait "LButton", "D"
			KeyWait "LButton"
			; Hotkey "LButton", "Off"
			MouseGetPos(OutputVarX, OutputVarY)
			ToolTip
			

			; ToolTip OutputVarX . "," . OutputVarY
			this.x :=OutputVarX
			this.y :=OutputVarY
			this.color1 := PixelGetColor(this.x, this.y )

			this.show_coords(-1000)
			this.save()
		}

		class Ext extends SenarioDetector.pix {
			__New(identifier,coords:=0, LocalTol:=5) {
				;handles defaults
				if !coords{
					coords[1] := 0
					coords[2] := 0
					coords[3] := A_ScreenWidth
					coords[4] := A_ScreenHeight
				}

				this.x1 := coords[1]
				this.y1 := coords[2]
				this.x2 := coords[3]
				this.y2 := coords[4]
				this.tol := LocalTol

				this.type := "pixel_ext"
				this.showing_search_area := 0
				this.color1 := "FFFFFF"
				this.id := identifier

				try {
					this.load()
					this.mode := "tile"
					this.show_coords(-1000)
					
				} Catch e {
					disp("No config detected, please select '" this.id "' pixel now.")
					this.picker()
				}
			}		
		}	
	}
}

class DependencyManager {
	__New(){
		;incomplete system but being set up for future expansion into a lib tool
		this.IRFV := 0
		this.IRFV_files := ["\irfv\i_view64.exe",
							"\irfv\plugins\regioncapture.dll"]
		this.IRFV_folders :=	["\irfv\plugins"]
		this._create_folders(this.IRFV_folders)
	}
	_download_file(file_name){
		download("https://github.com/sgmsm/CUL/raw/master" file_name, ROAMING file_name)
	}
	_create_folders(array){
		loop array.Length{
			if !DirExist(ROAMING array[A_Index]){
				ToolTip ROAMING array[A_Index]
				DirCreate(ROAMING array[A_Index])
			}
		}
	}

	check(mod_name, to_verify:=0, to_download:=0){
		if this.hasprop(mod_name){
				if this.%mod_name% and !to_verify{
					Return 1
				}else if to_verify or to_download{
					this.verify(mod_name, to_download)
				}
			Return 0
		}
		MsgBox "it seems like you are searching for unknown mod: " mod_name
		Return 0
	}

	verify(mod_name, force_download:= 0){
		if force_download{
			this.download(mod_name)
			Return 1
		}

		loop this.%mod_name%_files.Length{
			if(!FileExist(ROAMING this.%mod_name%_files[A_Index])){
				try{
					this._download_file(this.%mod_name%_files[A_Index])
					ToolTip "downloading missing files for " mod_name " plugin"
				}Catch e{
					MsgBox "ERR downloading: " this.%mod_name%_files[A_Index]
					Return 0
				}
			}
		}
		return 1
	}

	download(mod_name){
		this.%mod_name% := 1  ; to save time in future we can jsut know it's been downloaded

		this.download_bar := GuiCreate(,"Downloading " mod_name)
		this.download_bar.opt("-caption")
		this.download_bar.setfont("s14 bold", "open sans")
		this.download_bar.addtext("","Downloading " mod_name)
		this.download_bar.Add("Progress", "w200 h20 c00CCCC vMyProgress", 0)
		this.download_bar.show()

		number_of_file := this.%mod_name%_files.Length

		loop number_of_file{
			this._download_file(this.%mod_name%_files[A_Index])
			this.download_bar["MyProgress"].Value += floor(100/number_of_file)
		}
		this.download_bar.Destroy()
	}
}


/*
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

  									    STATIC FUNCTIONS    

[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
*/


capture_image_region(file_name){
	DEPS.verify("IRFV")

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


find_image(LFN,x1:="None", y1:="None", x2:="None", y2:="None", LocalTol:=100){
	;handles defaults
	(x1=="None")?(x1:=0): ;if x1 = none set to 0 else  leave it
	(y1=="None")?(y1:=0):
	(x2=="None")?(x2:=A_ScreenWidth):
	(y2=="None")?(y2:=A_ScreenHeight):

	Try
	{
		if(ImageSearch(foundX, foundY, x1,y1,x2,y2, "*TransBlack *" LocalTol " " LFN))
		{	
			Return [foundX, foundY]
		}				
	}
	catch exc
    	MsgBox "CUL:ERR: Could not image search:`n" exc.Message
	Return False
}

disp(activity:="", index:=1){
	if activity==""
	{
		global_hud_obj.display("")
		global_hud_obj2.display("")
		global_hud_obj3.display("")
		Return
	}
	;base disp has been upgraded HUD.TXT.Notify(activity)
	; ((statment) ? (TRUE-action) : (FALSE-action))
	ticker := ((ticker="-") ? (ticker:="\") : (    ((ticker="\") ? (ticker:="/") : (ticker:="-"))    ))

	display_text := activity . " " . ticker
	if index == 1
		global_hud_obj.display(display_text)
	if index == 2
		global_hud_obj2.display(display_text)
	if index == 3
		global_hud_obj3.display(display_text)

}
/*
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

  									    KEYBIND HOOKS

[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
*/



















































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