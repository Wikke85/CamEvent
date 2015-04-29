package com
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.core.IFlexDisplayObject;
	
	[Event(type="flash.events.Event", name="change")]
	
	public class SimpleMotionDetection extends EventDispatcher
	{
		/**
		 * @private
		 * We're using a single Point object for the 0,0 point, since we need to pass that to the
		 * call to BitmapData.threshold down in the compareSnapshots() function. Instantiating a Point 
		 * object once should be faster than creating a new one every time.
		 */
		private var regPoint:Point;
		
		public function SimpleMotionDetection()
		{
			super();
			
			//create our 0,0 point that we'll use in compareSnapshots()
			regPoint = new Point(0,0);
		}
		
		/**
		 * If true, the motion detection will start immediately when the source property is set. If false,
		 * you will have to manually call startDetecting() to start the detection.
		 */
		public var autoStart:Boolean = true;
		
		/**
		 * @private
		 */
		private var _source:IBitmapDrawable;
		
		[Bindable]
		/**
		 * The visual item for which we're detecting motion. This needs to be an IBitmapDrawable object, which means
		 * pretty much any UI component in your application. The obvious choice is to use a VideoDisplay that shows a
		 * webcam.
		 */
		public function get source():IBitmapDrawable {
			return _source;
		}
		
		/**
		 * @private
		 */
		public function set source(value:IBitmapDrawable):void {
			_source = value;
			
			if(autoStart) {
				startDetecting();
			}
		}
		
		/**
		 * @private
		 */
		private var _sampleRate:Number = 1;
		
		/**
		 * The delay between samplings, in milliseconds.
		 */
		public function get sampleRate():Number {
			return _sampleRate;
		}
		
		/**
		 * @private
		 */
		public function set sampleRate(value:Number):void {
			_sampleRate = value;
			
			if(timer != null) {
				timer.delay = _sampleRate;
			}
		}
		
		public function startDetecting():void {
			if(timer == null) {
				timer = new Timer(_sampleRate, 0);
				timer.addEventListener(TimerEvent.TIMER, timerEventHandler);
			}
			
			timer.start();
		}
		
		public function stopDetecting():void {
			if(timer != null && timer.running) {
				timer.stop();
			}
		}
		
		/**
		 * @private
		 */
		private function timerEventHandler(event:TimerEvent):void {
			compareSnapshots();
		}
		
		/**
		 * @private
		 * We use a Timer to continuously run the comparison of one snapshot to the next. 
		 */
		private var timer:Timer;
		
		/**
		 * @private
		 */
		private var _percentChange:Number = 0;
		
		[Bindable(event="change")]
		/**
		 * The percentage of the pixels that changed from the previous snapshot to the current snapshot. 0 would indicate
		 * no change, while 1 would mean all pixels were different.
		 */
		public function get percentChange():Number {
			return _percentChange;
		}
		
		/**
		 * @private
		 * To keep track of the last snapshot we took.
		 */
		public var lastSnapshot:BitmapData;
		
		/**
		 * @private
		 * This function takes a bitmap snapshot of the source object and compares it with the last snapshot that
		 * it took. We get a count of the number of pixels that changed, and then we use that to determine a change
		 * percentage, which is what we use for detecting motion.
		 */
		public function compareSnapshots():void {
			var newBitmapData:BitmapData;
			
			var width:Number;
			var height:Number;
			
			/**
			 * This code is taken right out of the ImageSnapshot class. I didn't want the whole
			 * ImageSnapshot functionality though, and I wanted this comparison function to run as fast as
			 * possible.
			 */
			if (_source is DisplayObject)
			{
				width = DisplayObject(source).width;
				height = DisplayObject(source).height;
			}
			else if (_source is BitmapData)
			{
				width = BitmapData(source).width;
				height = BitmapData(source).height;
			}
			else if (_source is IFlexDisplayObject)
			{
				width = IFlexDisplayObject(source).width;
				height = IFlexDisplayObject(source).height;
			}
			
			// Bitmaps can be fussy every once in a while if the object you're trying to draw isn't ready
			// so this just wraps the draw method in a try/cath block. Kind of a lazy solution, but whatever. 
			try {
				newBitmapData = new BitmapData(width, height, true, 0);
				newBitmapData.draw(_source);
			} 
			catch(e:Error) {
				return;
			}
			
			
			if(lastSnapshot) {
				//make a copy of the bitmap and draw it onto the last one using the DIFFERENCE blend mode
				var clone:BitmapData = newBitmapData.clone();
				clone.draw(lastSnapshot, null, null, BlendMode.DIFFERENCE);
				
				//now we do some magic thresholding to get the number of pixels that changed
				var pixels:Number = clone.threshold(clone,clone.rect, regPoint,"<",0xff111111,0x00ff0000, 0xffffffff, false); // default
				//var pixels:Number = clone.threshold(clone,clone.rect, regPoint,"<",0xffffffff,0x00ff0000, 0xffffffff, false);
				//var pixels:Number = clone.threshold(clone,clone.rect, regPoint,"!=",0x01010101,0x00ff0000, 0xffffffff, false);
				
				var totalPixels:Number = clone.width*clone.height;
				
				//we figure out the number of changed pixels relative to the total number of pixels, which gives
				//us a nice percentage. This percentage is what we use as our 'motion detection' indicator
				var newPercent:Number = (totalPixels-pixels)/totalPixels;
				
				//we dispatch a change event if the percentages have changed. I chose to ignore 0 change, cause I think that's better
				if(newPercent != _percentChange && newPercent != 0) {
					_percentChange = newPercent;
					dispatchEvent(new Event(Event.CHANGE));
				}
				
				//make sure we get rid of the temp bitmaps we were using
				clone.dispose();
				lastSnapshot.dispose();
			}
			
			lastSnapshot = newBitmapData;
		}
		
		
	}
}