package com
{
	
	[Bindable]
	public class Share extends ViewObject
	{
		public function Share(data:Object=null, nameField:String="", dataField:String="")
		{
			super(data, nameField, dataField);
		}
		
		// share
		public var id_share:int = -1;
		public var name:String = '';
		public var info:String = '';
		public var server_directory:String = '';
		
		// share stats
		public var total_files:Number = NaN;
		public var total_filesize:Number = NaN;
		public var date_last_modified:Date;
		public var total_files_inactive:Number = NaN;
		public var total_filesize_inactive:Number = NaN;
		public var hosts_linked:Number = NaN;
		public var hosts_linked_inactive:Number = NaN;
		
		
		// host
		public var id_host_share:int = -1;
		public var local_directory:String = '';
		public var date_linked_since:Date;
		public var date_last_replicated:Date;
		
	// check:
		// auto run when started
		public var check_on_start:Boolean = false;			// check files when program launches
		// every x seconds, or ...
		public var check_period:int = -1;					// 0 is always checking (not recommended!) and -1 is disabled
		// ... when current day is in, and ...
		public var check_on_days:String = '';				// days of week, 0 is sunday
		// ... current hour is in, and ...
		public var check_on_hours:String = '';				// hours, 24h format
		// ... current minute is in
		public var check_on_minutes:String = '';			// minutes
		
		public var exclude_filename:String = '';			// (part of) filename to exclude (regular expressions possible, line separated)
		public var exclude_directory:String = '';			// (part of) path to exclude (regular expressions possible, line separated)
		public var exclude_extensions:String = '';			// extensions to exclude (spaces ignored, comma separated, no dot or asterisks needed)
		
		//public var compare_date_modified:Boolean = false;	// compare by date modified differences
		//public var compare_checksum:Boolean = false;		// compare by hash differences
		
		public var max_download_speed:int = -1;				// max download speed in kbps -  <= 0 for unlimited
		
		//public var cached_index:Boolean = true;				// get cached file index (database, mush faster) instead of actual one
		
		public var remove_empty_dirs:Boolean = true;
		
		
		// internal
		public var date_next_run:Date;
		
		
		public function get check_on():Date {
			var now:Date = new Date;
			var on:Date;
			on = new Date(now.fullYear, now.month, now.date, now.hours, now.minutes, 0, 0);
			
			var a:Array = [
				check_on_days.split(','),
				check_on_hours.split(','),
				check_on_minutes.split(',')
			];
			
			var i:int, j:int, from:int, to:int, n:int;
			
			for(i=0; i<a.length; i++){
				for(j=0; j<a[i].length; j++){
					a[i][j] = a[i][j].replace(/ /g, '');
					if(a[i][j] == '*'){
						if(i == 0){
							a[i][j] = '0-6';
						}
						else if(i == 1){
							a[i][j] = '0-23';
						}
						else if(i == 2){
							a[i][j] = '0-59';
						}
					}
					
					if(a[i][j].indexOf('-') > -1){
						from = a[i][j].split('-')[0];
						to = a[i][j].split('-')[1];
						a[i][j] = '';
						for(n=from; n<=to;n++){
							a[i][j] += (a[i][j] == '' ? '' : ',') + n;
						}
					}
				}
			}
			
			var sda:String = ','+a[0].join(',')+',';
			var sha:String = ','+a[1].join(',')+',';
			var sma:String = ','+a[2].join(',')+',';
			
			var match:Boolean;
			while(!match){
				on.minutes++;
				//on.minutes += 15;
				
				if(
					sda.indexOf(','+on.day+',') > -1
					&&
					sha.indexOf(','+on.hours+',') > -1
					&&
					sma.indexOf(','+on.minutes+',') > -1
				){
					
					match = true;
				}
				
				
			}
			
			
			return on;
		}
		
		
		override public function assign(data:Object, nameField:String='', dataField:String=''):void {
			var sp:Array, sp1:Array, sp2:Array; // splitted date - 2013-01-01 12:34:56
			if(data.hasOwnProperty('date_linked_since') && data.date_linked_since != '' && data.date_linked_since != null){
				sp = String(data.date_linked_since).split(' ');
				sp1 = sp[0].split('-');
				sp2 = sp[1].split(':');
				data.date_linked_since = new Date(sp1[0], sp1[1]-1, sp1[2], sp2[0], sp2[1], sp2[2]);
			}
			else {
				data.date_linked_since = null;
			}
			if(data.hasOwnProperty('date_last_replicated') && data.date_last_replicated != '' && data.date_last_replicated != null){
				sp = String(data.date_last_replicated).split(' ');
				sp1 = sp[0].split('-');
				sp2 = sp[1].split(':');
				data.date_last_replicated = new Date(sp1[0], sp1[1]-1, sp1[2], sp2[0], sp2[1], sp2[2]);
			}
			else {
				data.date_last_replicated = null;
			}
			if(data.hasOwnProperty('date_last_modified') && data.date_last_modified != '' && data.date_last_modified != null){
				sp = String(data.date_last_modified).split(' ');
				sp1 = sp[0].split('-');
				sp2 = sp[1].split(':');
				data.date_last_modified = new Date(sp1[0], sp1[1]-1, sp1[2], sp2[0], sp2[1], sp2[2]);
			}
			else {
				data.date_last_modified = null;
			}
			super.assign(data, nameField, dataField);
		}
		
	}
	
}
