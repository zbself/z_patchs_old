package com.zb.as3.zlib.patchs.core
{
	import flash.events.ProgressEvent;
	
	public class zPathProgressEvent extends ProgressEvent
	{
		/**		进度 */
		public static const PROGRESS:String = "progress";
		public function zPathProgressEvent(type:String, bytesLoaded:Number=0, bytesTotal:Number=0)
		{
			super(type, false, false, bytesLoaded, bytesTotal);
		}
	}
}