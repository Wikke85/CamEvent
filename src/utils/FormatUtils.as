package utils
{
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.CurrencyFormatter;
	import mx.formatters.NumberFormatter;
	
	[Bindable]
	public class FormatUtils
	{
		public static var DATABASE_DATE:String = 'yyyy-mm-dd hh:mi:ss tz';
		public static var SHORT_DATE:String = 'dd/mm/yyyy';
		public static var LONG_DATE:String = 'dd/mm/yyyy hh:mi:ss';
		
		public function FormatUtils()
		{
		}
		
		/**
		 * returns a formatted representation of the hour parts of a given date if not null
		 * format = hh:mm:ss
		 * 
		 * for a more specific formatting, use the function 'formatDate' instead
		 * */
		[Bindable('render')]
		public static function formatHour(d:Date):String {
			var ret:String = '';
			if(d != null)
			{
				ret += d.hours < 10 ? '0'+d.hours : d.hours;
				ret += ':';
				ret += d.minutes < 10 ? '0'+d.minutes : d.minutes;
				ret += ':';
				ret += d.seconds < 10 ? '0'+d.seconds : d.seconds;
			}
			return ret;
		}
		
		
		/* data used for the formatDate function */
		private static var monthNamesShort:Array	= ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
		private static var monthNamesLong:Array		= ['January','February','March','April','May','June','July','August','Septembre','Octobre','Novembre','Decembre'];
		private static var dayNamesLong:Array	= ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
		private static var dayNamesShort:Array	= ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
		
		/**
		 * Takes a date and format string and returns a date formatted acoording to the string.
		 * Possible formatting values are (as specified in this class as constants):
		 * 	yyyy : fullYear
		 * 	yy : last 2 digits of fullYear
		 * 	dd	: date with pre-zero
		 *  ddd : short dayname (e.g. sun, mon, ...)
		 * 	day : long dayname (e.g. sunday, monday, ...)
		 * 	month : long month name
		 *  mmm	: short month name
		 * 	mm	: month with pre-zero
		 * 	hh : hour with pre-zero
		 * 	mi: minutes with pre-zero
		 * 	ss: seconds with pre-zero
		 * 	ms : milliseconds with pre-zeros
		 * 
		 * All other characters will remain!
		 * 
		 * for a quick hour format (e.g. hh:mi:ss), use the function 'formatHour' instead
		 * 
		 * when the date is null, the function returns the defaultString.
		 */
		[Bindable('render')]
		public static function formatDate(dateOrSeconds:Object, format:String = 'dd/mm/yyyy', defaultString:String=''):String {
			var ret:String = format;
			if(dateOrSeconds == null) ret = defaultString;
			else {
				
				var dtmp:Date;
				var isSeconds:Boolean = false;
				
				if(dateOrSeconds is Date){
					dtmp = dateOrSeconds as Date;
				}
				else {
					dtmp = new Date;
					dtmp.setHours(0, 0, 0, 0);
					dtmp.time = Number(dateOrSeconds) * 1000;
					isSeconds = true;
				}
				
				
				var fullMinutes:Boolean = false;
				// format like mi:ss
				if(ret.indexOf('hh') == -1 && ret.indexOf('mi') != -1){
					fullMinutes = true;
				}
				
				//years
				ret = ret.split('yyyy')	.join(	dtmp.fullYear );
				ret = ret.split('yy')	.join(	dtmp.fullYear.toString().substr(2) );
				
				//days
				// day name arrays must start with sunday, because the day is zero-indexed
				ret = ret.split('day')	.join(	dayNamesLong[dtmp.day] );
				ret = ret.split('ddd')	.join(	dayNamesShort[dtmp.day] );
				ret = ret.split('dd')	.join(	dtmp.date < 10 ? '0'+dtmp.date : dtmp.date );
				
				//months
				// months are zero-based, so the month nr can be entered in the array without changes
				ret = ret.split('month').join(	monthNamesLong[dtmp.month] );
				ret = ret.split('mmm')	.join(	monthNamesShort[dtmp.month] );
				ret = ret.split('mm')	.join(	(1+dtmp.month) < 10 ? '0'+(1+dtmp.month) : (1+dtmp.month) );
				
				// timezone offset
				ret = ret.split('tz')	.join(	dtmp.timezoneOffset / 60 );
				
				//hours
				if(!isSeconds){
					ret = ret.split('hh').join(	dtmp.hours < 10 ? '0'+dtmp.hours : dtmp.hours );
				}
				
				//minutes
				if(fullMinutes || isSeconds){
					var h:Number = 0;
					var m:Number = Math.floor(Number(dateOrSeconds) / 60);
					
					if( m > 60 && !fullMinutes){
						h = Math.floor(m / 60);
						m = Math.floor(m % 60);
					}
					else {
						
					}
					ret = ret.split('mi').join( (m < 10 ? '0' : '') +  m.toFixed(0).replace('.', '') );
					ret = ret.split('hh').join( h.toFixed(0).replace('.', '') );
					
				}
				else {
					ret = ret.split('mi').join(	dtmp.minutes < 10 ? '0'+dtmp.minutes : dtmp.minutes );
				}
				
				//seconds
				ret = ret.split('ss').join(	dtmp.seconds < 10 ? '0'+dtmp.seconds : dtmp.seconds );
				
				//milliseconds
				var mills:String = '00'+dtmp.milliseconds;
				mills = mills.substr(mills.length-3);
				ret = ret.split('ms').join(	mills );
				
			}
			return ret;
		}
		
		/*public const FULL_YEAR:String		= 'yyyy';
		public const YEAR_2_DIGITS:String	= 'yy';
		
		public const DATE_PREZERO:String	= 'dd';
		public const DATE_SHORT:String		= 'ddd';
		public const DATE_LONG:String		= 'day';
		
		public const MONTH_FULL:String		= 'month';
		public const MONTH_SHORT:String		= 'mmm';
		public const MONTH_PREZERO:String	= 'mm';
		
		public const HOUR_PREZERO:String			= 'hh';
		public const MINUTES_PREZERO:String			= 'mi';
		public const SECONDS_PREZERO:String			= 'ss';
		public const MILLISECONDS_PREZERO:String	= 'ms';*/
		 
		
		
		/**
		 * format a number as a fixed percentage:
		 * x	 -> 5
		 * x.x	 -> 5.0
		 * x.xx	 -> 5.01
		 * 
		 * */
		[Bindable('render')]
		public static function formatPercentage(v:Number, format:String = 'x.xx %'):String {
			var ret:String = format;
			if(isNaN(v)) ret = '';
			else {
				ret = ret.replace('x.xx',	v.toFixed(2));
				ret = ret.replace('x.x',	v.toFixed(1));
				ret = ret.replace('x',		v.toFixed(0));
			}
			return ret;
		}
		
		public static function labelPercentageColumn(item:Object, col:DataGridColumn):String {
			return formatPercentage( item[col.dataField], 'x %' );
		}
		
		public static function labelPercentage2Column(item:Object, col:DataGridColumn):String {
			return formatPercentage( item[col.dataField], 'x.xx %' );
		}
		
		public static function labelFloatColumn(item:Object, col:DataGridColumn):String {
			return formatPercentage( item[col.dataField], 'x.xx' );
		}
		
		
		/* label functions for datagrid columns */
		
		public static function labelDateColumn(item:Object, col:DataGridColumn):String {
			//if(isDataGridColumnXT(col)) return '';
			return (item != null && col != null) ? formatDate(item[col.dataField], 'dd/mm/yyyy') : '';
		}
		
		public static function labelDate(item:Object):String {
			return (item != null) ? formatDate(item.date) : '';
		}
		
		public static function labelDateTimeColumn(item:Object, col:DataGridColumn):String {
			//if(isDataGridColumnXT(col)) return '';
			return (item != null && col != null) ? formatDate(item[col.dataField], 'dd/mm/yyyy hh:mi:ss') : '';
		}
		
		
		public static function hourMinSecColumn(item:Object, col:DataGridColumn):String {
			//if(isDataGridColumnXT(col)) return '';
			return (item != null && col != null) ? formatDate(item[col.dataField], 'hh:mi:ss') : '';
		}
		
		public static function minSecColumn(item:Object, col:DataGridColumn):String {
			//if(isDataGridColumnXT(col)) return '';
			return (item != null && col != null) ? formatDate(item[col.dataField], 'mi:ss') : '';
		}
		
		
		
		
		
		private static var fmtCurrency:CurrencyFormatter;
		
		public static function labelCurrency(item:Object, alignSymbol:String='left'):String {
			initCurrencyFormatter(alignSymbol);
			return fmtCurrency.format( item );
		}
		
		public static function labelCurrencyColumn(item:Object, col:DataGridColumn):String {
			//if(isDataGridColumnXT(col)) return '';
			initCurrencyFormatter('none');
			return fmtCurrency.format( item[col.dataField] );
		}
		
		/* init the currency formatter when used the first time */
		private static function initCurrencyFormatter(alignSymbol:String='left'):void {
			if(fmtCurrency == null){
				fmtCurrency = new CurrencyFormatter;
				
				/*fmtCurrency.alignSymbol = "left";
				fmtCurrency.currencySymbol = "€ ";*/
				fmtCurrency.precision = 2;
				
				fmtCurrency.decimalSeparatorFrom = '.';
				fmtCurrency.decimalSeparatorTo = ',';
				fmtCurrency.thousandsSeparatorFrom = ',';
				fmtCurrency.thousandsSeparatorTo = '.';
			}
			
			if(alignSymbol == 'none'){
				fmtCurrency.currencySymbol = '';
			}
			else {
				fmtCurrency.alignSymbol = alignSymbol;
				fmtCurrency.currencySymbol = alignSymbol == 'left' ? '€ ' : ' €';
			}
		}
		
		
		private static var fmtNumber:NumberFormatter;
		
		public static function labelNumber(value:Number, precision:int):String {
			initNumberFormatter(precision);
			return fmtNumber.format( value );
		}
		
		public static function labelNumberColumn(item:Object, col:DataGridColumn):String {
			initNumberFormatter(0);
			return fmtNumber.format( item[col.dataField] );
		}
		
		/* init the currency formatter when used the first time */
		private static function initNumberFormatter(precision:int):void {
			if(fmtNumber == null){
				fmtNumber = new NumberFormatter;
				fmtNumber.decimalSeparatorFrom = '.';
				fmtNumber.decimalSeparatorTo = ',';
				fmtNumber.thousandsSeparatorFrom = ',';
				fmtNumber.thousandsSeparatorTo = '.';
			}
			fmtNumber.precision = precision;
		}
		
		
		
		/* check if datagridcolumn parameter is used as calculated column for totals-datagrid * /
		private static function isDataGridColumnXT(col:DataGridColumn):Boolean {
			if(col == null) return false;
			if(col is DataGridColumnXT){
				return DataGridColumnXT(col).isCalculated;
			}
			else {
				return false;
			}
		}*/
		
		
		
		/*public static function upperCaseFirst(value:String):String {
			return value.charAt(0).toUpperCase() + value.substr(1).toLowerCase();
		}
		
		public static function upperCaseSentence(value:String):String {
			value += value.indexOf('.') != -1 ? ' ' : '';
			var sentences:ArrayCollection = new ArrayCollection( value.split(RegExp('[.|!] ')) );
			
			for(var i:int=0; i<sentences.length; i++){
				sentences[i] = upperCaseFirst(sentences[i]);
			}
			
			return sentences.source.join('. ');
		}*/
		
		
		public static const sizes:Array = ['b', 'kB', 'MB', 'GB', 'TB'];
		public static const speeds:Array = ['bps', 'kbps', 'mbps', 'gbps', 'tbps'];
		
		public static function filesize(sizeInBytes:Number):String {
			var index:int = 0;
			while(sizeInBytes > 1024){
				sizeInBytes /= 1024;
				index++;
			}
			return sizeInBytes.toFixed(2) + ' ' + (sizes[index]);
		}
		
		
		
		public static function bitrate(sizeInBits:Number, precision:int = 0):String {
			var index:int = 0;
			while(sizeInBits > 1024){
				sizeInBits /= 1024;
				index++;
			}
			return sizeInBits.toFixed(precision) + ' ' + (speeds[index]);
		}
		
		public static function labelFilesizeColumn(item:Object, col:DataGridColumn):String {
			//if(isDataGridColumnXT(col)) return '';
			return filesize( item[col.dataField] );
		}
		
		
		
	}
}