package hxPEngine.ui.util;

import hxd.fs.Convert;

#if (sys || nodejs)
class ConvertFBX2HMDNew extends Convert {

	public function new() {
		super("fbx", "hmd");
	}

    override function convert() {

    }

	public function modify(data:hxd.fmt.hmd.Data) {
		var fbx = try hxd.fmt.fbx.Parser.parse(srcBytes) catch( e : Dynamic ) throw Std.string(e) + " in " + srcPath;
		var hmdout = new hxd.fmt.fbx.HMDOut(srcPath);
		if( params != null ) {
			if( params.normals )
				hmdout.generateNormals = true;
			if( params.precise ) {
				hmdout.highPrecision = true;
				hmdout.fourBonesByVertex = true;
			}
			if( params.maxBones != null)
				hmdout.maxBonesPerSkin = params.maxBones;
			if ( params.tangents != null)
				hmdout.generateTangents = true;
		}
		hmdout.load(fbx);
		var isAnim = StringTools.startsWith(originalFilename, "Anim_") || originalFilename.toLowerCase().indexOf("_anim_") > 0;
		var hmd = hmdout.toHMD(null, !isAnim);
        // modify it
        hmd.materials = data.materials;
		var out = new haxe.io.BytesOutput();
		new hxd.fmt.hmd.Writer(out).write(hmd);
		save(out.getBytes());
	}

	static var _ = Convert.register(new ConvertFBX2HMD());

}
#end