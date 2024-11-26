/*
 * DO NOT REMOVE THIS NOTICE
 *
 * PROJECT:   JavascriptDecoder
 * VERSION:   1.0.0
 * COPYRIGHT: (c) 2004 Cezary Tomczak
 * LINK:      http://gosu.pl/dhtml/JavascriptDecoder.html
 * LICENSE:   GPL
 */

function JavascriptColorizer() {
    this.color = {
        "keyword":   "#0000FF",
        "object":    "#FF0000",
        "quotation": "#FF00FF",
        "comment":   "#008000"
    }

    this.s = ""; // code to colorize
    this.i = 0;
    this.len = 0;

    this.ret = ""; // colorized code
    this.lastWord = ""; // last alphanumeric word
    this.lastWordArchive = ""; // lastWord is kept here as long as we encounter tabs or spaces
    this.nextChar = "";
    this.prevChar = "";

    this.colorize = function() {
        this.len = this.s.length;
        while (this.i < this.len) {
            var c = this.s.charAt(this.i);
            if (this.len - 1 == this.i) {
                this.nextChar = "";
            } else {
                this.nextChar = this.s.charAt(this.i + 1);
            }
            switch (c) {
                case "'":
                case '"':
                    this.quotation(c);
                    break;
                case "/":
                    if ("/" == this.nextChar) {
                        this.lineComment();
                    } else if ("*" == this.nextChar) {
                        this.comment();
                    } else {
                        this.slash();
                    }
                    break;
                default:
                    if (/\w/.test(c)) {
                        this.lastWord += c;
                        this.lastWordArchive = "";
                    } else {
                        if (this.lastWord) {
                            this.word();
                            if (" " == c || "\t" == c) {
                                this.lastWordArchive = this.lastWord;
                            }
                        }
                        if (" " != c && "\t" != c) {
                            this.lastWordArchive = "";
                        }
                        this.lastWord = "";
                        this.ret += c;
                    }
                    break;
            }
            this.prevChar = c;
            this.i++;
        }
        this.ret += this.lastWord;
        return this.ret;
    }

    this.quotation = function(quotation) {
        var s = quotation;
        var escaped = false;
        while (this.i < this.len - 1) {
            this.i++;
            var c = this.s.charAt(this.i);
            if ("\\" == c) {
                escaped = (escaped ? false : true);
            }
            s += c;
            if (c == quotation) {
                if (!escaped) {
                    break;
                }
            }
            if ("\\" != c) {
                escaped = false;
            }
        }
        this.ret += '<font color="'+this.color.quotation+'">' + s + '</font>';
    }

    this.lineComment = function() {
        var s = "//";
        this.i++;
        while (this.i < this.len - 1) {
            this.i++;
            var c = this.s.charAt(this.i);
            s += c;
            if ("\n" == c) {
                break;
            }
        }
        this.ret += '<font color="'+this.color.comment+'">' + s + '</font>';
    }

    this.comment = function() {
        var s = "/*";
        this.i++;
        var c = "";
        var prevC = "";
        while (this.i < this.len - 1) {
            this.i++;
            prevC = c;
            c = this.s.charAt(this.i);
            s += c;
            if ("/" == c && "*" == prevC) {
                break;
            }
        }
        this.ret += '<font color="'+this.color.comment+'">' + s + '</font>';
    }

    this.slash = function() {
        if (!(this.lastWordArchive || "*" == this.prevChar)) {
            var s = "/";
            var escaped = false;
            while (this.i < this.len - 1) {
                this.i++;
                var c = this.s.charAt(this.i);
                if ("\\" == c) {
                    escaped = (escaped ? false : true);
                }
                s += c;
                if ("/" == c) {
                    if (!escaped) {
                        break;
                    }
                }
                if ("\\" != c) {
                    escaped = false;
                }
            }
            this.ret += s;
        } else {
            this.ret += "/";
        }
    }

    this.word = function() {
        if (this.lastWord && this.keywords.indexOf(this.lastWord) != -1) {
            this.ret += '<font color="'+this.color.keyword+'">' + this.lastWord + '</font>';
        } else if (this.lastWord && this.objects.indexOf(this.lastWord) != -1) {
            this.ret += '<font color="'+this.color.object+'">' + this.lastWord + '</font>';
        } else {
            this.ret += this.lastWord;
        }
    }

    this.keywords = ["abstract", "boolean", "break", "byte", "case", "catch", "char", "class",
        "const", "continue", "default", "delete", "do", "double", "else", "extends", "false",
        "final", "finally", "float", "for", "function", "goto", "if", "implements", "import",
        "in", "instanceof", "int", "interface", "long", "native", "new", "null", "package",
        "private", "protected", "public", "return", "short", "static", "super", "switch",
        "synchronized", "this", "throw", "throws", "transient", "true", "try", "typeof", "var",
        "void", "while", "with"];

    this.objects = ["Anchor", "anchors", "Applet", "applets", "Area", "Array", "Button", "Checkbox",
        "Date", "document", "FileUpload", "Form", "forms", "Frame", "frames", "Hidden", "history",
        "Image", "images", "Link", "links", "Area", "location", "Math", "MimeType", "mimeTypes",
        "navigator", "options", "Password", "Plugin", "plugins", "Radio", "Reset", "Select",
        "String", "Submit", "Text", "Textarea", "window"];
}