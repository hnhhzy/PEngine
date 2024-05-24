package haxePEngine.ui.utils;


import haxe.zip.Entry;
import String;
import haxePEngine.ui.component.base.utils.ByteArray;
import haxePEngine.ui.component.base.utils.Endian;




class ZipReader
{
    private var _stream : ByteArray;
    private var _entries : Map<String, Entry>;
    public var entries(get, never) : Map<String, Entry>;
    
    public function new(ba : ByteArray)
    {
        // 待补
        _stream = ba;
        // _stream.endian = Endian.LITTLE_ENDIAN;
         _entries = new Map<String, Entry>();   

        readEntries();
    }

    private function get_entries():Map<String, Entry>
    {
        return _entries;
    }


    private function readEntries() : Void{
        var reader = new haxe.zip.Reader(_stream);
        _entries = new Map<String, Entry>();
        var listEntry:List<Entry> = reader.read();
        for(i in listEntry) {
            _entries.set(i.fileName, i);
        }

        // 待补
//         _stream.position = _stream.length - 22;
//         var buf : ByteArray = new ByteArray();
//         buf.endian = Endian.LITTLE_ENDIAN;
//         _stream.readBytes(buf, 0, 22);
//         buf.position = 10;
//         var entryCount : Int = buf.readUnsignedShort();
//         buf.position = 16;
//         _stream.position = buf.readUnsignedInt();
//         buf.clear();

//         for (i in 0...entryCount){
//             _stream.readBytes(buf, 0, 46);
//             buf.position = 28;
//             var len : Int = buf.readUnsignedShort();
//             var name : String = _stream.readUTFBytes(len);
//             var len2 : Int = buf.readUnsignedShort() + buf.readUnsignedShort();
//             _stream.position += len2;
//             var lastChar : String = name.charAt(name.length - 1);
//             if (lastChar == "/" || lastChar == "\\")
//                 continue;

//             name = name.split("\\").join("/");
// //            var regexp:EReg = new EReg("\\", "g");
// //            name = regexp.replace(name, "/");
//             var e : ZipEntry = new ZipEntry();
//             e.name = name;
//             buf.position = 10;
//             e.compress = buf.readUnsignedShort();
//             buf.position = 16;
//             e.crc = buf.readUnsignedInt();
//             e.size = buf.readUnsignedInt();
//             e.sourceSize = buf.readUnsignedInt();
//             buf.position = 42;
//             e.offset = buf.readUnsignedInt() + 30 + len;

//             _entries[name] = e;
//         }
    }
    
    /**
	 * 解压zip的加密文件
	 * @param data - 
	 * @return Bytes
	 */
     public function decompress(data:haxe.io.Bytes):haxe.io.Bytes {
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


    public function getEntryData(n : String) : ByteArray{
        var entry : Entry = _entries[n];
        if (entry == null) {
            return null;
        } else {
            if(entry.compressed) {
                entry.compressed = false;
                entry.data = decompress(entry.data);
                entry.dataSize = entry.data.length;
            }
            return new ByteArray(entry.data);
        }

        return null;
        // var entry : ZipEntry = _entries[n];
        // if (entry == null) 
        //     return null;
        
        // var ba : ByteArray = new ByteArray();
        // if (entry.size < 1)
        //     return ba;
        
        // _stream.position = entry.offset;
        // _stream.readBytes(ba, 0, entry.size);
        // if (entry.compress > 0)
        //     ba.inflate();
        
        // return ba;
    }
}



class ZipEntry
{
    public var name : String;
    public var offset : Int = 0;
    public var size : Int = 0;
    public var sourceSize : Int = 0;
    public var compress : Int = 0;
    public var crc : Int = 0;
    
    public function new()
    {
    }
}