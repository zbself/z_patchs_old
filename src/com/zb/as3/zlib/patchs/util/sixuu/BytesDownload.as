package com.zb.as3.zlib.patchs.util.sixuu
{
	import com.zb.as3.zlib.patchs.util.sixuu.events.SErrorEvent;
	import com.zb.as3.zlib.patchs.util.sixuu.events.SEvent;
	import com.zb.as3.zlib.patchs.util.sixuu.events.SProgressEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;

	[Event(name = "progress",type = "com.sixuu.events.SProgressEvent")]
	[Event(name = "complete",type = "com.sixuu.events.SEvent")]
	[Event(name = "error",type = "com.sixuu.events.SErrorEvent")]
	public class BytesDownload extends EventDispatcher
	{

		public var fileLength:uint = 0;
		public var startPos:uint;
		public var endPos:uint;
		public var url:String;
		public var byteArray:ByteArray;
		private var lengthLoader:URLLoader;//用来获取文件长度
		private var pevt:SProgressEvent = new SProgressEvent("progress");
		private var cevt:SEvent = new SEvent("complete");
		private var bytesLoader:URLLoader;
		private var instance:BytesDownload;
		public function BytesDownload()
		{
			instance = this;
		}
		public function downLoad(_url:String,startPointPos:uint=0,endPointPos:uint=0):void
		{
			lengthLoader=new URLLoader();
			this.startPos = startPointPos;
			this.endPos = endPointPos;
			this.url = _url;
			lengthLoader.load(new URLRequest(_url));
			lengthLoader.addEventListener(ProgressEvent.PROGRESS,function getFileLength(e:ProgressEvent):void{
			  fileLength=e.bytesTotal;
			  endPointPos==0?instance.endPos=fileLength : endPointPos>=fileLength?endPos=fileLength : 0;
			  lengthLoader.close();
			  startLoadBody();
			  });
			lengthLoader.addEventListener(IOErrorEvent.IO_ERROR,function ioerr(e:IOErrorEvent):void{
			  var evt:SErrorEvent=new SErrorEvent("error");
			  evt.errorType="lengthLoaderIOError";
			  dispatchEvent(evt);
			});
		}
		private function startLoadBody():void
		{
			bytesLoader = new URLLoader;
			bytesLoader.dataFormat = URLLoaderDataFormat.BINARY;
			var req:URLRequest = new URLRequest(url);
			req.requestHeaders.push(new URLRequestHeader("Range","bytes="+startPos+"-"+endPos));
			bytesLoader.load(req);
			bytesLoader.addEventListener(ProgressEvent.PROGRESS,function onPro(e:ProgressEvent):void{
			  pevt=new SProgressEvent("progress");
			  pevt.bytesLoaded=e.bytesLoaded;
			  pevt.bytesTotal=e.bytesTotal;
//			  trace("load: "+e.bytesLoaded +" / "+pevt.bytesTotal);
			  dispatchEvent(pevt);
			 });
			bytesLoader.addEventListener(Event.COMPLETE,function onCom(e:Event):void{
			  cevt=new SEvent("complete")
			  instance.byteArray=bytesLoader.data;
//			  trace("load complete: "+instance.startPos,instance.endPos);
			  bytesLoader.close();
			  dispatchEvent(cevt);
			 });
			bytesLoader.addEventListener(IOErrorEvent.IO_ERROR,function onErr(e:IOErrorEvent):void{
			 var evt:SErrorEvent=new SErrorEvent("error");
			  evt.errorType="bytesLoaderIOError";
			  dispatchEvent(evt);
			  trace("rect load error");
			 });
		}
		public function cancel():void{
			if(bytesLoader!=null){
				try{
				bytesLoader.close();
				}catch(e:Error){
					//trace(e)
				}
			}
		}

	}

}