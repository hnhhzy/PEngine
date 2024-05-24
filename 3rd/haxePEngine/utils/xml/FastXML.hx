package haxePEngine.utils.xml;

private abstract NodeAccess(Xml) from Xml {
	@:op(a.b)
	public function resolve(name:String):FastXML {
		var x = this.elementsNamed(name).next();
		if (x == null) {
			return null;
		}
		return new FastXML(x);
	}
}

private abstract AttribAccess(Xml) from Xml {
	@:op(a.b)
	public function resolve(name:String):String {
		if (this.nodeType == Xml.Document)
			return null;
		var v = this.get(name);
		if (v == null)
			return null;
		return v;
	}

	@:op(a.b)
	function _hx_set(name:String, value:String):String {
		if (this.nodeType == Xml.Document)
			throw "Cannot access document attribute " + name;
		this.set(name, value);
		return value;
	}
}

private abstract HasAttribAccess(Xml) from Xml {
	@:op(a.b)
	public function resolve(name:String):Bool {
		if (this.nodeType == Xml.Document)
			throw "Cannot access document attribute " + name;
		return this.exists(name);
	}
}

private abstract HasNodeAccess(Xml) from Xml {
	@:op(a.b)
	public function resolve(name:String):Bool {
		return this.elementsNamed(name).hasNext();
	}
}

private abstract NodeListAccess(Xml) from Xml {
	@:op(a.b)
	public function resolve(name:String):FastXMLList {
		var l = new Array();
		for (x in this.elementsNamed(name))
			l.push(new FastXML(x));
		return new FastXMLList(l);
	}
}

/**
	The `haxe.xml.Access` API helps providing a fast dot-syntax access to the
	most common `Xml` methods.
**/
abstract FastXML(Xml) {
	public var x(get, never):Xml;

	public inline function get_x()
		return this;

	/**
		The name of the current element. This is the same as `Xml.nodeName`.
	**/
	public var name(get, never):String;

	inline function get_name() {
		return if (this.nodeType == Xml.Document) "Document" else this.nodeName;
	}

	/**
		The inner PCDATA or CDATA of the node.

		An exception is thrown if there is no data or if there not only data
		but also other nodes.
	**/
	public var innerData(get, never):String;

	/**
		The XML string built with all the sub nodes, excluding the current one.
	**/
	public var innerHTML(get, never):String;

	/**
		Access to the first sub element with the given name.

		An exception is thrown if the element doesn't exists.
		Use `hasNode` to check the existence of a node.

		```haxe
		var access = new FastXML(Xml.parse("<user><name>John</name></user>"));
		var user = access.node.user;
		var name = user.node.name;
		trace(name.innerData); // John

		// Uncaught Error: Document is missing element password
		var password = user.node.password;
		```
	**/
	public var node(get, never):NodeAccess;

	inline function get_node():NodeAccess
		return x;

	/**
		Access to the List of elements with the given name.
		```haxe
		var fast = new haxe.xml.Access(Xml.parse("
			<users>
				<user name='John'/>
				<user name='Andy'/>
				<user name='Dan'/>
			</users>"
		));

		var users = fast.node.users;
		for (user in users.nodes.user) {
			trace(user.att.name);
		}
		```
	**/
	public var nodes(get, never):NodeListAccess;

	inline function get_nodes():NodeListAccess
		return this;

	/**
		Access to a given attribute.

		An exception is thrown if the attribute doesn't exists.
		Use `has` to check the existence of an attribute.

		```haxe
		var f = new haxe.xml.Access(Xml.parse("<user name='Mark'></user>"));
		var user = f.node.user;
		if (user.has.name) {
			trace(user.att.name); // Mark
		}
		```
	**/
	public var att(get, never):AttribAccess;

	inline function get_att():AttribAccess
		return this;

	/**
		Check the existence of an attribute with the given name.
	**/
	public var has(get, never):HasAttribAccess;

	inline function get_has():HasAttribAccess
		return this;

	/**
		Check the existence of a sub node with the given name.

		```haxe
		var f = new haxe.xml.Access(Xml.parse("<user><age>31</age></user>"));
		var user = f.node.user;
		if (user.hasNode.age) {
			trace(user.node.age.innerData); // 31
		}
		```
	**/
	public var hasNode(get, never):HasNodeAccess;

	inline function get_hasNode():HasNodeAccess
		return x;

	/**
		The list of all sub-elements which are the nodes with type `Xml.Element`.
	**/
	public var elements(get, never):Iterator<FastXML>;

	inline function get_elements():Iterator<FastXML>
		return cast this.elements();

	public inline function new(x:Xml) {
		if (x.nodeType != Xml.Document && x.nodeType != Xml.Element)
			throw "Invalid nodeType " + x.nodeType;
		this = x;
	}

	function get_innerData() {
		var it = this.iterator();
		if (!it.hasNext())
			throw name + " does not have data";
		var v = it.next();
		if (it.hasNext()) {
			var n = it.next();
			// handle <spaces>CDATA<spaces>
			if (v.nodeType == Xml.PCData && n.nodeType == Xml.CData && StringTools.trim(v.nodeValue) == "") {
				if (!it.hasNext())
					return n.nodeValue;
				var n2 = it.next();
				if (n2.nodeType == Xml.PCData && StringTools.trim(n2.nodeValue) == "" && !it.hasNext())
					return n.nodeValue;
			}
			throw name + " does not only have data";
		}
		if (v.nodeType != Xml.PCData && v.nodeType != Xml.CData)
			throw name + " does not have data";
		return v.nodeValue;
	}

	function get_innerHTML() {
		var s = new StringBuf();
		for (x in this)
			s.add(x.toString());
		return s.toString();
	}

    public static function parse(s:String):FastXML {
        return new FastXML(Xml.parse(s));
    }

    public function descendants(name:String = "*") : FastXMLList {
        var a = new Array<FastXML>();
        for(e in x.elements()) {
            if(e.nodeName == name || name == "*") {
                a.push(new FastXML(e));
            } else {
                var fx = new FastXML(e);
                a = a.concat(fx.descendants(name).getArray());
            }
        }
        return new FastXMLList(a);
    }

    public function toString() : String {
        return x.toString();
    }
}
