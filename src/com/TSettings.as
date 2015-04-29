package com
{
	import mx.collections.ArrayCollection;
	
	
	[Bindable]
	public class TSettings
	{
		// Main
		public var ask_hide_on_close:Boolean = false;
		public var close_to_tray:Boolean = true;
		//public var maximize_after_login:Boolean = true;
		public var hide_tray_icon_while_maximized:Boolean = false;
		
		public var launch_with_windows:Boolean = true;
		
		//public var days_history:int = 0;
		//public var server_id_host:int = 0;
		
		/*
		
		// Menu
		public var menu_expand_single_child:Boolean = true;
		public var tree_expand_first_level:Boolean = true;
		public var tree_expand_all_on_search:Boolean = true;
		public var tree_open_on_single_click:Boolean = true;
		public var tree_open_duration:Number = 150;
		public var clear_searchfield_after_search:Boolean = true;
		
		// Menu Icons
		public var show_icons_text:Boolean = true;
		public var icon_size:Number = 24;
		public var tray_icon_color:String = 'red';
		*/
		
		
		// categories
		public const CAT_MAIN:String = 'Main';
		public const CAT_GUI:String = 'GUI';
		public const CAT_CONNECTION:String = 'Connection';
		public const CAT_LOG:String = 'Log';
		
		
		public var data:Array;
		
		
		public function assign(data:Array):void {
			this.data = data;
			
			if(data != null){
				for (var s:int=0; s<data.length; s++){
					if (this.hasOwnProperty(data[s].code)) {
						commitValue(data[s]);
					}
				}
			}
			else {
				throw new Error('data parameter is null on TSettings.assign()');
			}
		}
		
		private function commitValue(item:Object):void {
			switch(item.edittype){
				case 'int':
					this[item.code] = int(item.value);
					break;
				
				case 'text':
					this[item.code] = item.value;
					break;
				
				case 'boolean':
					this[item.code] = item.value.toString().toLowerCase() == 'true' || item.value.toString() == '1';
					break;
					
				default:
					this[item.code] = item.value;
			}
			
		}
	}
}