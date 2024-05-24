package haxePEngine.ui.component.base.utils;
import haxe.io.Bytes;
import haxe.io.Encoding;

class ByteArray extends haxe.io.BytesInput {
    public function readInt() : Int {
        return this.readInt32();
    }

    public function toBytes() : haxe.io.Bytes {
        //var str:String = haxe.Serializer.run(this.b);
        //var bytes:Bytes = haxe.Unserializer.run(str);
        //return bytes;
        //Bytes.ofData(this.b);
        return Bytes.ofData(new haxe.io.BytesData(this.b,this.length));
    }

    public function clear():Void
    {
        position = 0;
    }

	public function readUnsignedShort():Int {
        
        var ch1 = this.readByte() & 0xff;
        var ch2 = this.readByte() & 0xff;

        if (this.bigEndian == false)
        {
            return (ch2 << 8) + ch1;
        }
        else
        {
            return (ch1 << 8) | ch2;
        }
    }

    public function readUTF():String {
        var bytesCount = this.readUnsignedShort();
        return this.readString(bytesCount, Encoding.UTF8);
    }

	public function readUTFBytes(length:Int):String {
        return this.readString(length, Encoding.UTF8);
    }

}