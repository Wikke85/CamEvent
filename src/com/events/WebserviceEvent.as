package com.events
{
	import flash.events.Event;
	
	
	public class WebserviceEvent extends Event
	{
		
		private var _datatype:String;
		private var _message:String;
		private var _data:Object;
		
		public static const TYPE_INFO:String = 'info';
		public static const TYPE_ERROR:String = 'error';
		public static const TYPE_JSONERROR:String = 'jsonerror';
		public static const TYPE_DATA:String = 'data';
		
		public function WebserviceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, datatype:String='data', message:String='', data:Object=null)
		{
			super(type, bubbles, cancelable);
			_datatype = datatype;
			_message = message;
			_data = data;
		}
		
		public function get datatype():String {
			return _datatype;
		}
		
		public function get message():String {
			return _message;
		}
		
		public function get data():Object {
			return _data;
		}
		/*
		public function get dataArray():Array {
			return _data is Array ? _data as Array : null;
		}
		*/
	}
	
}
