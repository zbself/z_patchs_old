package com.zb.as3.zlib.patchs.util.sixuu.events{
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class SErrorEvent extends Event{
		static public const ERROR:String="error"
		public var errorType:String="error"
		public var file:File;
		public function SErrorEvent(type:String) {
			super(type)
		}

	}
	
}
