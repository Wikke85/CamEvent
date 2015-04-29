package utils
{
	
	
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	
	public class FileUtils
	{
		
		
		
		public static function readDirectory(directory:File, target:ArrayCollection, recursive:Boolean = false, includeDirectories:Boolean = false):void {
			var tmp:ArrayCollection = new ArrayCollection(directory.getDirectoryListing());
			for(var i:int=0; i<tmp.length; i++){
				if((tmp[i] as File).name != '.' && (tmp[i] as File).name != '..'){
					if(!(tmp[i] as File).isDirectory || ((tmp[i] as File).isDirectory && includeDirectories)){
						target.addItem(tmp[i]);
					}
					if(recursive && (tmp[i] as File).isDirectory){
						readDirectory(tmp[i], target, recursive);
					}
				}
			}
		}
		
		
		public static function filterModifiedAfter(fileList:ArrayCollection, date:Date, excludeDirectories:Boolean = true):ArrayCollection {
			var values:ArrayCollection = new ArrayCollection;
			var dateNum:Number = Number(FormatUtils.formatDate(date, 'yyyymmddhhmiss'));
			
			for(var i:int=0; i<fileList.length; i++){
				if( 
					(
						excludeDirectories && !(fileList[i] as File).isDirectory
						||
						!excludeDirectories
					)
					&&
					Number(FormatUtils.formatDate((fileList[i] as File).modificationDate, 'yyyymmddhhmiss')) > dateNum 
				){
					values.addItem(fileList[i]);
				}
			}
			return values;
		}
		
		
		/**
		 * This string contains all the characters which are forbidden
		 * */
		public static const forbiddenChars:String = '<>:"/\\\\|?*';
		
		
	}
}