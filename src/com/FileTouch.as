package com
{
    import __AS3__.vec.Vector;
    
    import flash.desktop.NativeProcess;
    import flash.desktop.NativeProcessStartupInfo;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.NativeProcessExitEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    
    import utils.FormatUtils;
    
    public class FileTouch extends Sprite
    {
        public var process:NativeProcess;

        public function FileTouch()
        {
            if(NativeProcess.isSupported)
            {
                //setupAndLaunch();
            }
            else
            {
                trace("NativeProcess not supported.");
            }
        }
        
        public function setupAndLaunch(file:File, dateModified:Date):void
        {     
            var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            var nativeApp:File = File.applicationDirectory.resolvePath("native/FileTouch.exe");
            nativeProcessStartupInfo.executable = nativeApp;
			nativeProcessStartupInfo.workingDirectory = file.parent;

            var processArgs:Vector.<String> = new Vector.<String>();
            processArgs[0] = "/W";
            processArgs[1] = "/D";
            processArgs[2] = FormatUtils.formatDate(dateModified, 'mm-dd-yyyy');
            processArgs[3] = "/T";
            processArgs[4] = FormatUtils.formatDate(dateModified, 'hh:mi:ss');
            processArgs[5] = file.nativePath;
            nativeProcessStartupInfo.arguments = processArgs;

            process = new NativeProcess();
            process.start(nativeProcessStartupInfo);
            process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
            process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
            process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
            process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
            process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
        }

        public function onOutputData(event:ProgressEvent):void
        {
            trace("Got: ", process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)); 
        }
        
        public function onErrorData(event:ProgressEvent):void
        {
            trace("ERROR -", process.standardError.readUTFBytes(process.standardError.bytesAvailable)); 
        }
        
        public function onExit(event:NativeProcessExitEvent):void
        {
            trace("Process exited with ", event.exitCode);
        }
        
        public function onIOError(event:IOErrorEvent):void
        {
             trace(event.toString());
        }
    }
}