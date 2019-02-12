(function(){function s(g){var l=g.jsustoolkitErrCode=g.jsustoolkitErrCode||{},c=g.asn1=g.asn1||{};c.Class={UNIVERSAL:0,APPLICATION:64,CONTEXT_SPECIFIC:128,PRIVATE:192};c.Type={NONE:0,BOOLEAN:1,INTEGER:2,BITSTRING:3,OCTETSTRING:4,NULL:5,OID:6,ODESC:7,EXTERNAL:8,REAL:9,ENUMERATED:10,EMBEDDED:11,UTF8:12,ROID:13,SEQUENCE:16,SET:17,PRINTABLESTRING:19,IA5STRING:22,UTCTIME:23,GENERALIZEDTIME:24,BMPSTRING:30};c.create=function(a,d,h,b){if(b.constructor==Array){for(var c=[],f=0;f<b.length;++f)void 0!==b[f]&&c.push(b[f]);b=c}return{tagClass:a,type:d,constructed:h,composed:h||b.constructor==Array,value:b}};var r=function(a){var d=a.getByte();return 128==d?void 0:d&128?a.getInt((d&127)<<3):d};c.fromDer=function(a){if(null==a||"undefined"==typeof a)throw{code:"110005",message:l["110005"]};a.constructor==String&&(a=g.util.createBuffer(a));if(2>a.length())throw{code:"110001",message:l["110001"]+"(bytes:"+a.length()+")"};var d=a.getByte(),h=d&192,b=d&31,e=r(a);if(a.length()<e)throw{code:"110002",message:l["110002"]+"(detail:"+a.length()+" < "+e+")"};var f,p=32==(d&32);f=p;if(!f&&h===c.Class.UNIVERSAL&&b===c.Type.BITSTRING&&1<e){var k=a.read;if(0===a.getByte()&&(d=a.getByte(),d&=192,d===c.Class.UNIVERSAL||d===c.Class.CONTEXT_SPECIFIC))try{if(f=r(a)===e-(a.read-k))++k,--e}catch(u){throw{code:"110003",message:l["110003"]};}a.read=k}if(f)if(f=[],void 0===e)for(;;){if(a.bytes(2)===String.fromCharCode(0,0)){a.getBytes(2);break}f.push(c.fromDer(a))}else for(k=a.length();0<e;)f.push(c.fromDer(a)),e-=k-a.length(),k=a.length();else{if(void 0===e)throw{code:"110004",message:l["110004"]};if(b===c.Type.BMPSTRING)for(f="",k=0;k<e;k+=2)f+=String.fromCharCode(a.getInt16());else f=a.getBytes(e)}return c.create(h,b,p,f)};c.toDer=function(a){var d=g.util.createBuffer(),h=a.tagClass|a.type,b=g.util.createBuffer();if(a.composed){a.constructed?h|=32:b.putByte(0);for(var e=0;e<a.value.length;++e)void 0!==a.value[e]&&b.putBuffer(c.toDer(a.value[e]))}else if(a.type===c.Type.BMPSTRING)for(e=0;e<a.value.length;++e)b.putInt16(a.value.charCodeAt(e));else b.putBytes(a.value);d.putByte(h);if(127>=b.length())d.putByte(b.length()&127);else{e=b.length();a="";do a+=String.fromCharCode(e&255),e>>>=8;while(0<e);d.putByte(a.length|128);for(e=a.length-1;0<=e;--e)d.putByte(a.charCodeAt(e))}d.putBuffer(b);return d};c.oidToDer=function(a){a=a.split(".");var d=g.util.createBuffer();d.putByte(40*parseInt(a[0],10)+parseInt(a[1],10));for(var c,b,e,f,p=2;p<a.length;++p){c=!0;b=[];e=parseInt(a[p],10);do f=e&127,e>>>=7,c||(f|=128),b.push(f),c=!1;while(0<e);for(c=b.length-1;0<=c;--c)d.putByte(b[c])}return d};c.derToOid=function(a){var d;a.constructor==String&&(a=g.util.createBuffer(a));var c=a.getByte();d=Math.floor(c/40)+"."+c%40;for(var b=0;0<a.length();)c=a.getByte(),b<<=7,c&128?b+=c&127:(d+="."+(b+c),b=0);return d};c.utcTimeToDate=function(a){var d=new Date,c=parseInt(a.substr(0,2),10),c=50<=c?1900+c:2E3+c,b=parseInt(a.substr(2,2),10)-1,e=parseInt(a.substr(4,2),10),f=parseInt(a.substr(6,2),10),p=parseInt(a.substr(8,2),10),k=0;if(11<a.length){var g=a.charAt(10),m=10;"+"!==g&&"-"!==g&&(k=parseInt(a.substr(10,2),10),m+=2)}d.setUTCFullYear(c,b,e);d.setUTCHours(f,p,k,0);m&&(g=a.charAt(m),"+"===g||"-"===g)&&(c=parseInt(a.substr(m+1,2),10),a=parseInt(a.substr(m+4,2),10),a=6E4*(60*c+a),"+"===g?d.setTime(+d-a):d.setTime(+d+a));return d};c.generalizedTimeToDate=function(a){var d=new Date,c=parseInt(a.substr(0,4),10),b=parseInt(a.substr(4,2),10)-1,e=parseInt(a.substr(6,2),10),f=parseInt(a.substr(8,2),10),g=parseInt(a.substr(10,2),10),k=parseInt(a.substr(12,2),10),l=0,m=0,r=!1;"Z"==a.charAt(a.length-1)&&(r=!0);var n=a.length-5,q=a.charAt(n);if("+"===q||"-"===q)m=parseInt(a.substr(n+1,2),10),n=parseInt(a.substr(n+4,2),10),m=6E4*(60*m+n),"+"===q&&(m*=-1),r=!0;"."==a.charAt(14)&&(l=1E3*parseFloat(a.substr(14),10));r?(d.setUTCFullYear(c,b,e),d.setUTCHours(f,g,k,l),d.setTime(+d+m)):(d.setFullYear(c,b,e),d.setHours(f,g,k,l));return d};c.dateToUtcTime=function(a){var d="",c=[];c.push((""+a.getUTCFullYear()).substr(2));c.push(""+(a.getUTCMonth()+1));c.push(""+a.getUTCDate());c.push(""+a.getUTCHours());c.push(""+a.getUTCMinutes());c.push(""+a.getUTCSeconds());for(a=0;a<c.length;++a)2>c[a].length&&(d+="0"),d+=c[a];return d+"Z"};c.dateToGeneralizedTime=function(a){var c="",h=[];h.push(""+a.getUTCFullYear());h.push(""+(a.getUTCMonth()+1));h.push(""+a.getUTCDate());h.push(""+a.getUTCHours());h.push(""+a.getUTCMinutes());h.push(""+a.getUTCSeconds());for(a=0;a<h.length;++a)0==a?4>h[a].length&&(c+="0"):2>h[a].length&&(c+="0"),c+=h[a];return c+"Z"};c.validate=function(a,d,h,b){var e=!1;if(a.tagClass!==d.tagClass&&"undefined"!==typeof d.tagClass||a.type!==d.type&&"undefined"!==typeof d.type)b&&(a.tagClass!==d.tagClass&&b.push("["+d.name+'] Expected tag class "'+d.tagClass+'", got "'+a.tagClass+'"'),a.type!==d.type&&b.push("["+d.name+'] Expected type "'+d.type+'", got "'+a.type+'"'));else if(a.constructed===d.constructed||"undefined"===typeof d.constructed){e=!0;if(d.value&&d.value.constructor==Array)for(var f=0,g=0;e&&g<d.value.length;++g)e=d.value[g].optional||!1,a.value[f]&&((e=c.validate(a.value[f],d.value[g],h,b))?++f:d.value[g].optional&&(e=!0)),!e&&b&&b.push("["+d.name+'] Tag class "'+d.tagClass+'", type "'+d.type+'" expected value length "'+d.value.length+'", got "'+a.value.length+'"');e&&h&&(d.capture&&(h[d.capture]=a.value),d.captureAsn1&&(h[d.captureAsn1]=a))}else b&&b.push("["+d.name+'] Expected constructed "'+d.constructed+'", got "'+a.constructed+'"');return e};var n=/[^\\u0000-\\u00ff]/;c.prettyPrint=function(a,d,h){var b="";d=d||0;h=h||2;0<d&&(b+="\n");for(var e="",f=0;f<d*h;++f)e+=" ";b+=e+"Tag: ";switch(a.tagClass){case c.Class.UNIVERSAL:b+="Universal:";break;case c.Class.APPLICATION:b+="Application:";break;case c.Class.CONTEXT_SPECIFIC:b+="Context-Specific:";break;case c.Class.PRIVATE:b+="Private:"}if(a.tagClass===c.Class.UNIVERSAL)switch(b+=a.type,a.type){case c.Type.NONE:b+=" (None)";break;case c.Type.BOOLEAN:b+=" (Boolean)";break;case c.Type.BITSTRING:b+=" (Bit string)";break;case c.Type.INTEGER:b+=" (Integer)";break;case c.Type.OCTETSTRING:b+=" (Octet string)";break;case c.Type.NULL:b+=" (Null)";break;case c.Type.OID:b+=" (Object Identifier)";break;case c.Type.ODESC:b+=" (Object Descriptor)";break;case c.Type.EXTERNAL:b+=" (External or Instance of)";break;case c.Type.REAL:b+=" (Real)";break;case c.Type.ENUMERATED:b+=" (Enumerated)";break;case c.Type.EMBEDDED:b+=" (Embedded PDV)";break;case c.Type.UTF8:b+=" (UTF8)";break;case c.Type.ROID:b+=" (Relative Object Identifier)";break;case c.Type.SEQUENCE:b+=" (Sequence)";break;case c.Type.SET:b+=" (Set)";break;case c.Type.PRINTABLESTRING:b+=" (Printable String)";break;case c.Type.IA5String:b+=" (IA5String (ASCII))";break;case c.Type.UTCTIME:b+=" (UTC time)";break;case c.Type.GENERALIZEDTIME:b+=" (Generalized time)";break;case c.Type.BMPSTRING:b+=" (BMP String)"}else b+=a.type;b=b+"\n"+(e+"Constructed: "+a.constructed+"\n");if(a.composed){for(var l=0,k="",f=0;f<a.value.length;++f)void 0!==a.value[f]&&(l+=1,k+=c.prettyPrint(a.value[f],d+1,h),f+1<a.value.length&&(k+=","));b+=e+"Sub values: "+l+k}else b+=e+"Value: ",a.type===c.Type.OID?(a=c.derToOid(a.value),b+=a,g.pki&&g.pki.oids&&a in g.pki.oids&&(b+=" ("+g.pki.oids[a]+")")):b=n.test(a.value)?b+("0x"+g.util.createBuffer(a.value,"utf8").toHex()):0===a.value.length?b+"[null]":b+a.value;return b}}var t=["./util","./oids","./jsustoolkitErrCode"],q=null;"function"!==typeof define&&("object"===typeof module&&module.exports?q=function(g,l){l(require,module)}:(crosscert=window.crosscert=window.crosscert||{},s(crosscert)));(q||"function"===typeof define)&&(q||define)(["require","module"].concat(t),function(g,l){l.exports=function(c){var l=t.map(function(a){return g(a)}).concat(s);c=c||{};c.defined=c.defined||{};if(c.defined.asn1)return c.asn1;c.defined.asn1=!0;for(var n=0;n<l.length;++n)l[n](c);return c.asn1}})})();