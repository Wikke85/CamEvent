package com
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
/**
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @author elimak - http://blog.elimak.com
 * 
 */
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	public class ChunkUpload extends EventDispatcher {
		
		private var _file		: File;
		private var _fileStream	: FileStream;
		private var _partSize	: Number;
		private var _chunkIndex	: Number;
		private var _chunks		: Number;
		private var _loader		: URLLoader;
		private var _id			: Number;
		
		private var _baseUrl:String;
		
		public function ChunkUpload(file:File, url:String, maxChunkSizeKb:Number = 100):void {
			super();
			
			this._file = file;
			this._baseUrl = url;
			
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handleUploadChunkCompleted, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			
			_fileStream = new FileStream;
			_fileStream.open(_file, FileMode.READ);
			
			_id = (new Date()).time; // make the file unique
			_chunkIndex = 0;
			_chunks = 1;
			
			_partSize = _file.size;
			// determine chunksize until smaller than 100Kb
			while(_partSize > maxChunkSizeKb * 1024){
				_partSize = Math.ceil(_partSize / 2);
				_chunks *= 2;
			}
			
			uploadingChunkedFiles();
			
		}
		
		private function handleUploadChunkCompleted(e:Event):void {
			var data:XML = new XML("<data>" + _loader.data + "</data>");
			
			if (data.result){
				_chunkIndex++;
				
				if (_chunkIndex < _chunks){
					uploadingChunkedFiles();
					dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _file.size / _chunks * (_chunkIndex+1), _file.size));
				}
				else {
					_fileStream.close();
					//dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _file.size, _file.size));
					dispatchEvent(new Event(Event.COMPLETE, false, false));
				}
				trace("progress -- " + _chunkIndex + " / " + _chunks);
				
			}
			else {
				_fileStream.close();
				
				dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, data.error, _chunkIndex));
				trace("An error occured while uploading the chunk " + _chunkIndex + " " + data.error);
			}
		}
		
		private function onIOError(e:ErrorEvent):void {
			trace("An error occured while uploading the chunk " + _chunkIndex + ", " + e);
			_fileStream.close();
		}
		
		
		private function uploadingChunkedFiles():void {
			
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var url:String = _baseUrl;
			if(url.indexOf('?') == -1){
				url += "?";
			}
			else {
				url += "&";
			}
			url += "chunk=" + _chunkIndex;
			
			url += "&id=" + _id;
			url += "&last=" + (_chunkIndex == _chunks - 1);
			
			var bytes:ByteArray = new ByteArray();
			_fileStream.readBytes(bytes, 0, _chunkIndex == _chunks - 1 ? 0 : _partSize);
			
			var urlRequest:URLRequest = new URLRequest(url);
			urlRequest.requestHeaders.push(header);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = bytes;
			
			_loader.load(urlRequest);
		}
		
		public function close():void {
			if(_loader != null){
				try {
					_loader.close();
				}
				catch(e:Error){
					
				}
			}
			if(_fileStream != null){
				try {
					_fileStream.close();
				}
				catch(e:Error){
					
				}
			}
		}
	}
}