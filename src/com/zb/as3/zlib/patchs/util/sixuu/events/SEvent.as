package com.zb.as3.zlib.patchs.util.sixuu.events{
	import flash.events.Event;
	import flash.filesystem.File;
	
	public dynamic class SEvent extends Event{
		static public const COMPLETE:String="complete"
		static public const FILE_DOWN_COMPLETE:String="fileDownComplete"
		public var file:File;
		public function SEvent(type:String) {
			super(type)
		}

	}
	
}
