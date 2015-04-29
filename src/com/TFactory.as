
package com
{
	
	
	import dialogs.choiceDialog;
	import dialogs.confirmDialog;
	import dialogs.dateDialog;
	import dialogs.inputDialog;
	import dialogs.messageDialog;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.FlexGlobals;

	//import mx.managers.PopUpManager;
	
	[Event(name="showDialog", type="flash.events.Event")]
	[Event(name="hideDialog", type="flash.events.Event")]

	[Bindable]	
	public class TFactory extends EventDispatcher {
		
		//public var Images:TImages;
		public var Settings:TSettings;
		//public var Security:TSecurity;
		//public var Lookups:TLookups;
		//public var Text:TTexts;
		
		
		//message
		private var _dlgMessage:messageDialog;
		
		//ok-cancel
		private var _dlgConfirm:confirmDialog;
		private var _okHandlerFunction:Function;
		private var _cancelHandlerFunction:Function;
		
		//yes-no-cancel
		private var _dlgChoice:choiceDialog;
		private var _Choise1Function:Function;
		private var _Choise2Function:Function;
		private var _cancelChoiseFunction:Function;
		
		//input
		private var _dlgInput:inputDialog;
		private var _inputHandlerFunction:Function;
		
		//date
		private var _dlgDate:dateDialog;
		private var _dateHandlerFunction:Function;
		
		
		public function TFactory() {
			//Images = new TImages;
			Settings = new TSettings;
			//Security = new TSecurity;
			//Lookups = new TLookups;
			//Text = new TTexts;
			
		}
		
		public function clear():void {
			//Images = new TImages;
			Settings = new TSettings;
			//Security = new TSecurity;
			//Text = new TTexts;
		}
		
		private var messages:ArrayCollection = new ArrayCollection;
		
		/* Message 'OK' */
		public function Message(message:String, title:String = 'Message', type:String = 'INFO'): void {
			
			messages.addItem({message: message, title: title, type: type});
			
			if(_dlgMessage == null){
				_dlgMessage = new messageDialog;
				_dlgMessage.Factory = this;
				
				_dlgMessage.open(true);
				_dlgMessage.addEventListener('confirmation', onMsgConfirm, false, 0, true);
			}
			
			showMsg();
		}
		
		private function showMsg():void {
			dispatchEvent(new Event('showDialog'));
			
			_dlgMessage.nativeWindow.x = (FlexGlobals.topLevelApplication.width  - _dlgMessage.width )/2;
			_dlgMessage.nativeWindow.y = (FlexGlobals.topLevelApplication.height - _dlgMessage.height)/2;
			
			
			_dlgMessage.aTitle = messages[0].title;
			_dlgMessage.aMessage = messages[0].message;
			_dlgMessage.aType = messages[0].type;
			_dlgMessage.reset();
			
		}
		
		private function onMsgConfirm(event:Event):void {
			messages.removeItemAt(0);
			if(messages.length > 0){
				showMsg();
			}
			else {
				dispatchEvent(new Event('hideDialog'));
			}
		}
		
		
		/* ErrorMessage 'OK' */
		public function Error(message:String, title:String = 'Error'): void {
			Message(message, title, 'error');
		}
		
		
		/* Message 'OK','Cancel' */
		public function MsgOkCancel(message:String, title:String, okHandler:Function, cancelHandler:Function = null): void {
			dispatchEvent(new Event('showDialog'));
			_okHandlerFunction = okHandler;
			_cancelHandlerFunction = cancelHandler;
			
			if(_dlgConfirm == null){
				_dlgConfirm = new confirmDialog;
				_dlgConfirm.Factory = this;
				
				_dlgConfirm.open(true);
			}
			
			_dlgConfirm.nativeWindow.x = (FlexGlobals.topLevelApplication.width  - _dlgConfirm.width )/2;
			_dlgConfirm.nativeWindow.y = (FlexGlobals.topLevelApplication.height - _dlgConfirm.height)/2;
			
			_dlgConfirm.aTitle = title;
			_dlgConfirm.aMessage = message;
			_dlgConfirm.aType = 'help';
			_dlgConfirm.reset();
			
			_dlgConfirm.addEventListener('okEvent', okHandlerInternal, false, 0.0, true);
			_dlgConfirm.addEventListener('cancelEvent', cancelHandlerInternal, false, 0.0, true);
		}
		private function okHandlerInternal(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgConfirm.removeEventListener('okEvent', okHandlerInternal);
			_dlgConfirm.removeEventListener('cancelEvent', cancelHandlerInternal);
			_okHandlerFunction(event);
		}
		private function cancelHandlerInternal(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgConfirm.removeEventListener('okEvent', okHandlerInternal);
			_dlgConfirm.removeEventListener('cancelEvent', cancelHandlerInternal);
			if(_cancelHandlerFunction != null) _cancelHandlerFunction(event);
		}
		
		
		
		/* Message 'Yes','No','Cancel' */
		public function MsgChoice(message:String, title:String, 
			choise1Prompt:String, choise1Handler:Function, 
			choise2Prompt:String, choise2Handler:Function, 
			cancelHandler:Function=null
		):void {
			dispatchEvent(new Event('showDialog'));
			_Choise1Function = choise1Handler;
			_Choise2Function = choise2Handler;
			_cancelChoiseFunction = cancelHandler;
			
			if(_dlgChoice == null){
				_dlgChoice = new choiceDialog;
				_dlgChoice.Factory = this;
				
				_dlgChoice.open(true);
			}
			
			_dlgChoice.nativeWindow.x = (FlexGlobals.topLevelApplication.width  - _dlgChoice.width )/2;
			_dlgChoice.nativeWindow.y = (FlexGlobals.topLevelApplication.height - _dlgChoice.height)/2;
			
			_dlgChoice.aTitle = title;
			_dlgChoice.aMessage = message;
			
			_dlgChoice.aChoise1 = choise1Prompt != null && choise1Prompt != '' ? choise1Prompt : 'Yes';
			_dlgChoice.aChoise2 = choise2Prompt != null && choise2Prompt != '' ? choise2Prompt : 'No';
			
			_dlgChoice.aType = 'help';
			_dlgChoice.reset();
			
			_dlgChoice.addEventListener('choice1Event', internal_choise1Handler, false, 0.0, true);
			_dlgChoice.addEventListener('choice2Event', internal_choise2Handler, false, 0.0, true);
			_dlgChoice.addEventListener('cancelEvent', internal_cancelHandler, false, 0.0, true);
		}
		private function internal_choise1Handler(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgChoice.removeEventListener('choice1Event', internal_choise1Handler);
			_dlgChoice.removeEventListener('choice2Event', internal_choise2Handler);
			_dlgChoice.removeEventListener('cancelEvent', internal_cancelHandler);
			if(_Choise1Function != null)	_Choise1Function(event);
		}
		private function internal_choise2Handler(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgChoice.removeEventListener('choice1Event', internal_cancelHandler);
			_dlgChoice.removeEventListener('choice2Event', internal_choise2Handler);
			_dlgChoice.removeEventListener('cancelEvent', internal_cancelHandler);
			if(_Choise2Function != null)	_Choise2Function(event);
		}
		private function internal_cancelHandler(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgChoice.removeEventListener('choice1Event', internal_cancelHandler);
			_dlgChoice.removeEventListener('choice2Event', internal_choise2Handler);
			_dlgChoice.removeEventListener('cancelEvent', internal_cancelHandler);
			if(_cancelChoiseFunction != null)	_cancelChoiseFunction(event);
		}
		
		
		
		public function MsgInput(message:String, title:String, inputHandler:Function, previousValue:String=''): void {
			dispatchEvent(new Event('showDialog'));
			_inputHandlerFunction = inputHandler;
			
			if(_dlgInput == null){
				_dlgInput = new inputDialog;
				_dlgInput.Factory = this;
				
				_dlgInput.open(true);
			}
			
			_dlgInput.nativeWindow.x = (FlexGlobals.topLevelApplication.width  - _dlgInput.width )/2;
			_dlgInput.nativeWindow.y = (FlexGlobals.topLevelApplication.height - _dlgInput.height)/2;
			
			_dlgInput.aTitle = title;
			_dlgInput.aMessage = message;
			_dlgInput.edt.text = previousValue;
			_dlgInput.aType = 'help';
			_dlgInput.reset();
			
			_dlgInput.addEventListener('okEvent', inputOkHandlerInternal, false, 0.0, true);
			_dlgInput.addEventListener('cancelEvent', inputCancelHandlerInternal, false, 0.0, true);
		}
		private function inputOkHandlerInternal(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgInput.removeEventListener('okEvent', inputOkHandlerInternal);
			_dlgInput.removeEventListener('cancelEvent', inputCancelHandlerInternal);
			_inputHandlerFunction(event);
		}
		private function inputCancelHandlerInternal(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgInput.removeEventListener('okEvent', inputOkHandlerInternal);
			_dlgInput.removeEventListener('cancelEvent', inputCancelHandlerInternal);
			//_inputHandlerFunction(event);
		}
		
		
		
		/*public function MsgSelectDate(message:String, title:String, dateHandler:Function): void {
			_dateHandlerFunction = dateHandler;
			
			PopUpManager.addPopUp(_dlgDate, DisplayObject(Application.application), true, null);
			_dlgDate.aTitle = title;
			_dlgDate.aMessage = message;
			//_dlgInput.edt.text = previousValue;
			_dlgDate.aType = 'help';
			PopUpManager.centerPopUp(_dlgDate);
			_dlgDate.reset();
			
			_dlgDate.addEventListener('okEvent', dateHandlerInternal, false, 0.0, true);
		}
		private function dateHandlerInternal(event:Event):void {
			_dlgDate.removeEventListener('okEvent', dateHandlerInternal);
			_dateHandlerFunction(event);
		}*/
		
		
		
		
		public function setDialogToFront():void {
			if(_dlgChoice	!= null	&& _dlgChoice.visible	) _dlgChoice.regetFocus();
			if(_dlgConfirm	!= null	&& _dlgConfirm.visible	) _dlgConfirm.regetFocus();
			if(_dlgInput	!= null	&& _dlgInput.visible	) _dlgInput.regetFocus();
			if(_dlgMessage	!= null	&& _dlgMessage.visible	) _dlgMessage.regetFocus();
		}
		
		public function closeDialogs():void {
			if(_dlgChoice	!= null) _dlgChoice.stage.nativeWindow.close();
			if(_dlgConfirm	!= null) _dlgConfirm.stage.nativeWindow.close();
			if(_dlgInput	!= null) _dlgInput.stage.nativeWindow.close();
			if(_dlgMessage	!= null) _dlgMessage.stage.nativeWindow.close();
		}
		

		
		public function formatHour(d:Date):String {
			var ret:String = '';
			ret += d.hours < 10 ? '0'+d.hours : d.hours;
			ret += ':';
			ret += d.minutes < 10 ? '0'+d.minutes : d.minutes;
			ret += ':';
			ret += d.seconds < 10 ? '0'+d.seconds : d.seconds;
			
			return ret;
		}

		private var monthNamesShort:Array = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
		
		private var dayNames:Array = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
		
		/**
		 * Takes a date and format string and returns a date formatted acoording to the string.
		 * Possible formatting values are:
		 * 	yyyy : fullYear
		 * 	yy : last 2 digits of fullYear
		 * 	dd	: date with pre-zero
		 * 	day : dayname
		 * 	month : short month name
		 * 	mm	: month with pre-zero
		 * 	hh : hour with pre-zero
		 * 	mi: minutes with pre-zero
		 * 	ss: seconds with pre-zero
		 * 	ms : milliseconds with pre-zeros
		 * 
		 * All other characters will remain!
		 * 
		 * //If you'd like to type a letter which is a formatting code, or a backslash, just escape it with a backslash
		 * //e.g. dd becomes \dd, \ becomes \\
		 */
		public function formatDate(d:Date, format:String = 'yyyy/mm/dd'/*, addGoodies:Boolean = false*/ ):String {
			var ret:String = format;
			if(d == null) ret = '';
			else {
				
				//years
				ret = ret.split('yyyy')	.join(	d.fullYear	);
				ret = ret.split('yy')	.join(	d.fullYear.toString().substr(2)	);
				
				//days
				ret = ret.split('dd')	.join(	d.date < 10 ? '0'+d.date : d.date	);
				ret = ret.split('day')	.join(	dayNames[d.day] );
				
				//months
				ret = ret.split('month').join(	monthNamesShort[d.month] );
				ret = ret.split('mm')	.join(	(1+d.month) < 10 ? '0'+(1+d.month) : (1+d.month)	);
				
				//hours
				ret = ret.split('hh').join(	d.hours < 10 ? '0'+d.hours : d.hours );
				
				//minutes
				ret = ret.split('mi').join(	d.minutes < 10 ? '0'+d.minutes : d.minutes	);
				
				//seconds
				ret = ret.split('ss').join(	d.seconds < 10 ? '0'+d.seconds : d.seconds	);
				
				//milliseconds
				var mills:String = '00'+d.milliseconds;
				mills = mills.substr(mills.length-3);
				ret = ret.split('ms').join(	mills );
				
				
				/*if(addGoodies){
					var today:Date = new Date;
					if( today.fullYear == d.fullYear && today.month == d.month ){//this month
						switch(today.date - d.date){
							case 0:	//today
								ret += ' (today)';
								break;
							case 1:	//yesterday
								ret += ' (yesterday)';
								break;
							case -1://tomorrow
								ret += ' (tomorrow)';
								break;
							default:
						}
						
					}
					else if( d.month == 11 && d.date == 25 ){//christmas
						ret += ' (Christmas)';
					}
				}*/
			}
			return ret;
		}
		
		
		/**
		 * Takes a Number as file size and format string and returns a formatted file size acoording to the string.
		 * Possible formatting values are:
		 * bb:		b, kb, mb, gb, ...
		 * Bb:		B, Kb, Mb, Gb, ...
		 * bib:		b, kib, mib, gib, ...
		 * Bib:		B, Kib, Mib, Gib, ...
		 * x: 		1, 10, 100, ..
		 * x.x:		1.0, 10.2, 102.4, ..
		 * x.xx:	1.02, 10.24, 102.48, ..
		 * 
		 * All other characters will remain!
		 */
		public function formatFileSize(s:Number, format:String = 'x.x Bb'):String {
			if(format == '') format = 'x.x Bb';
			var ret:String = format;
			if(isNaN(s)) ret = '-.- B';
			else {
				
				var bb:Array	= ['b', 'kb',  'mb',  'gb',  'tb',  'pb',  'eb' ];
				var Bb:Array	= ['B', 'Kb',  'Mb',  'Gb',  'Tb',  'Pb',  'Eb' ];
				var bib:Array	= ['b', 'kib', 'mib', 'gib', 'tib', 'pib', 'eib'];
				var Bib:Array	= ['B', 'Kib', 'Mib', 'Gib', 'Tib', 'Pib', 'Eib'];
				
				var s_divided:Number = s;
				var index:int = 0;
				
				while(s_divided > 1024 && index < bb.length-1){
					s_divided = s_divided / 1024;
					index++;
				}
				
				ret = ret.split('x.xx').join( s_divided.toFixed(2) );
				ret = ret.split('x.x').join( s_divided.toFixed(1) );
				ret = ret.split('x').join( s_divided.toFixed(0) );
				
				ret = ret.split('bb').join( bb[index] );
				ret = ret.split('Bb').join( Bb[index] );
				ret = ret.split('bib').join( bib[index] );
				ret = ret.split('Bib').join( Bib[index] );
				
			}
			return ret;
		}
		
		/* helper functions */

		/* label functions */

		public function labelDateColumn(item:Object, col:DataGridColumn):String {
			return (item != null && col != null) ? formatDate(item[col.dataField]) : '';
		}
		
		public function labelDateTimeColumn(item:Object, col:DataGridColumn):String {
			return (item != null && col != null) ? formatDate(item[col.dataField], 'yyyy/mm/dd hh:mi:ss') : '';
		}
		
		public function labelFilesizeColumn(item:Object, col:DataGridColumn):String {
			return (item != null && col != null) ? formatFileSize( Number(item[col.dataField]) ) : '';
		}
		
		public function labelCategoryAxis(categoryValue:Object, previousCategoryValue:Object, axis:* /*CategoryAxis*/, categoryItem:Object):String {
			return formatDate(categoryValue as Date, 'hh:mi:ss');
		}
		
	}
}
