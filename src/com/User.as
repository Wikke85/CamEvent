package com
{
	import com.ViewObject;
	
	[Bindable]
	public class User extends ViewObject
	{
		public function User(data:Object=null)
		{
			super(data);
		}
		
		public var id_host:int = -1;
		public var hostname:String = '';
		
		
	}
	
}
