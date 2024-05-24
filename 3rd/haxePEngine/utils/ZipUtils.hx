package haxePEngine.utils;

import haxe.io.Bytes;

class ZipUtils {
    	/**
	 * 解压zip的加密文件
	 * @param data - 
	 * @return Bytes
	 */
     public static function decompress(data:Bytes):Bytes {
		var inf = new haxe.zip.InflateImpl(new haxe.io.BytesInput(data), false, false);
        var output = new haxe.io.BytesBuffer();
        var bufsize = 1024*1024;
        var buf = haxe.io.Bytes.alloc(bufsize);
        while( true ) {
            var len = inf.readBytes(buf,0,bufsize);
            output.addBytes(buf,0,len);
            if( len < bufsize ) {
                break;
            }
        }
        return output.getBytes();
	}

    public static function readDescFile(entries:List<haxe.zip.Entry>, name:String):haxe.zip.Entry {
        for(_entry in entries) {
            if(_entry.fileName == name) {
                if(_entry.compressed) {        
                    _entry.compressed = false;
                    _entry.data = ZipUtils.decompress(_entry.data);
                    _entry.dataSize = _entry.data.length;
                }
                return _entry;
            }
        }
        return null;
    }

    public static function readResFile(entries:List<haxe.zip.Entry>, name:String):Bytes {
        for(_entry in entries) {
            if(_entry.fileName == name) {
                if(_entry.compressed) {        
                    _entry.compressed = false;
                    _entry.data = ZipUtils.decompress(_entry.data);
                    _entry.dataSize = _entry.data.length;
                }
                return _entry.data;
            }
        }
        return null;
    }
}