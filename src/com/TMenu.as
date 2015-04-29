package com
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class TMenu extends NativeMenu
	{
		public var childrenList:ArrayCollection = new ArrayCollection;
		public var menuList:ArrayCollection = new ArrayCollection;
		
		public function TMenu(XMLMenuDefinition:XML)
		{
			super();
			childrenList = new ArrayCollection;
			addChildrenToMenu(this, XMLMenuDefinition.children());
		}
		
		public function addChildren(XMLMenuDefinition:XML):void 
		{
			addChildrenToMenu(this, XMLMenuDefinition.children());
		}

		private function addChildrenToMenu(menu:NativeMenu, children:XMLList):NativeMenuItem
		{
			var menuItem:NativeMenuItem;
			var submenu:NativeMenu;

			for each (var child:XML in children)
			{
				if (String(child.@label).length > 0)
				{
					menuItem = new NativeMenuItem(
						child.@label, 
						((child.hasOwnProperty('@isSeparator') && child.@isSeparator == true) || child.name() == 'Separator')
					);
				}
				else
				{
					menuItem = new NativeMenuItem(
						child.name(), 
						((child.hasOwnProperty('@isSeparator') && child.@isSeparator == true) || child.name() == 'Separator')
					);
					
				}
				
				menuItem.name = child.name();
				menuItem.enabled = (child.hasOwnProperty('@enabled') && child.@enabled == true) || !child.hasOwnProperty('@enabled');
				
				/*menuItem.keyEquivalentModifiers = [Keyboard.CONTROL, Keyboard.SHIFT];
				menuItem.keyEquivalent = String( (child.hasOwnProperty('@key') && child.@key != '') ? child.@key : '' );
				menuItem.mnemonicIndex = int( (child.hasOwnProperty('@index') && child.@index != '') ? child.@index : -1 );*/
				
				if (child.children().length() > 0)
				{
					menuItem.submenu = new NativeMenu();
					addChildrenToMenu(menuItem.submenu,child.children());
					
					menuList.addItem(menuItem);
				}
				else {//if item is menu, don't add to array
					menuItem.data = new Object;
					menuItem.data.action	= child.hasOwnProperty('@action')	? String(child.@action)		: null;
					menuItem.data.icon		= child.hasOwnProperty('@icon')		? String(child.@icon)		: null;
					menuItem.data.toolTip	= child.hasOwnProperty('@toolTip')	? String(child.@toolTip)	: null;
					
					childrenList.addItem(menuItem);
				}
				
				menu.addItem(menuItem);
			}
			return menuItem;
        }
        
		public function enableMenuByName(name:String, value:Boolean):Boolean {
			var succeeded:Boolean = false;
			for(var i:int=0; i<childrenList.length; i++){
				if(childrenList[i].name == name){
					childrenList[i].enabled = value;
				}
			}
			return succeeded;
		}
        
		public function getMenuItemByName(name:String):NativeMenuItem {
			var m:NativeMenuItem;
			for(var i:int=0; i<childrenList.length; i++){
				if(childrenList[i].name == name){
					m = childrenList[i];
					break;
				}
			}
			return m;
		}
		
		public function getMenuByName(name:String):NativeMenuItem {
			var m:NativeMenuItem;
			for(var i:int=0; i<menuList.length; i++){
				if(menuList[i].name == name){
					m = menuList[i];
					break;
				}
			}
			return m;
		}
		
		
	}
}

