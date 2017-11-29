# z_patchs

var patchs:Patchs = new Patchs();
  
patchs.addEventListener(zPathProgressEvent.PROGRESS,onProgressHandler);
  
patchs.addEventListener(zPathEvent.PATCH_COMPLETE,patchCompleteHandler);
  patchs.downloadBreakPoint("http://ldc.layabox.com/download/LayaAirAS3_1.7.6_beta.zip",100000,"","0.11",false,null,true,File.applicationDirectory,false);
  
function onProgressHandler(event:zPathProgressEvent):void
{
  trace(event.bytesLoaded+" / "+event.bytesTotal );
}

function patchCompleteHandler(event:zPathEvent):void
{
 trace(zZIP(event.eventData).stamp+" 更新完毕");
}
