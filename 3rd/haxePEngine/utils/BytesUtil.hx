package haxePEngine.utils;

import haxe.io.Encoding;

class BytesUtil {

	public static function readUnsignedShort(ba:haxe.io.BytesInput):Int {
        
        var ch1 = ba.readByte() & 0xff;
        var ch2 = ba.readByte() & 0xff;

        if (ba.bigEndian == false)
        {
            return (ch2 << 8) + ch1;
        }
        else
        {
            return (ch1 << 8) | ch2;
        }
    }

    public static function readUTF(ba:haxe.io.BytesInput):String {
        var bytesCount = readUnsignedShort(ba);
        return ba.readString(bytesCount, Encoding.UTF8);
    }
}