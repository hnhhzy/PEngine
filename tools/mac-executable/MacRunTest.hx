import sys.FileSystem;

class MacRunTest {
	static function main() {
		// BASEDIR=$(dirname "$0")
		// cd "$BASEDIR"
		// export DYLD_LIBRARY_PATH=../Frameworks
		// ./
		var path = Sys.programPath();
		path = path.substr(0, path.lastIndexOf("/") + 1);
		trace("Run", path);
		var DYLD_LIBRARY_PATH = path;
		Sys.putEnv("DYLD_LIBRARY_PATH", DYLD_LIBRARY_PATH);
		trace("DYLD_LIBRARY_PATH=", DYLD_LIBRARY_PATH);
		Sys.setCwd(path);
		#if hl_command
		for (file in FileSystem.readDirectory("./")) {
			if (StringTools.endsWith(file, ".hl")) {
				trace("启动", file);
				Sys.command("export DYLD_LIBRARY_PATH=" + DYLD_LIBRARY_PATH + "\n" + "hl ./" + file);
				break;
			}
		}
		#else
		Sys.command("export DYLD_LIBRARY_PATH=" + DYLD_LIBRARY_PATH + "\n" + "./hl");
		#end
	}
}
