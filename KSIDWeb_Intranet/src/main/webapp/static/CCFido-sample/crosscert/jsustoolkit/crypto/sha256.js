(function(){function r(c){var p=c.jsustoolkitErrCode=c.jsustoolkitErrCode||{},d=c.sha256=c.sha256||{};c.md=c.md||{};c.md.algorithms=c.md.algorithms||{};c.md.sha256=c.md.algorithms.sha256=d;var n=null,k=!1,v=null,g=function(a,c,d){for(var e,b,f,n,h,l,k,g,p,m,s,q,t,u=d.length();64<=u;){for(h=0;16>h;++h)c[h]=d.getInt32();for(;64>h;++h)e=c[h-2],e=(e>>>17|e<<15)^(e>>>19|e<<13)^e>>>10,b=c[h-15],b=(b>>>7|b<<25)^(b>>>18|b<<14)^b>>>3,c[h]=e+c[h-7]+b+c[h-16]&4294967295;l=a.h0;k=a.h1;g=a.h2;p=a.h3;m=a.h4;s=a.h5;q=a.h6;t=a.h7;for(h=0;64>h;++h)e=(m>>>6|m<<26)^(m>>>11|m<<21)^(m>>>25|m<<7),f=q^m&(s^q),b=(l>>>2|l<<30)^(l>>>13|l<<19)^(l>>>22|l<<10),n=l&k|g&(l^k),e=t+e+f+v[h]+c[h],b+=n,t=q,q=s,s=m,m=p+e&4294967295,p=g,g=k,k=l,l=e+b&4294967295;a.h0=a.h0+l&4294967295;a.h1=a.h1+k&4294967295;a.h2=a.h2+g&4294967295;a.h3=a.h3+p&4294967295;a.h4=a.h4+m&4294967295;a.h5=a.h5+s&4294967295;a.h6=a.h6+q&4294967295;a.h7=a.h7+t&4294967295;u-=64}};d.create=function(){k||(n=String.fromCharCode(128),n+=c.util.fillString(String.fromCharCode(0),64),v=[1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298],k=!0);var a=null,d=c.util.createBuffer(),r=Array(64),e={algorithm:"sha256",blockLength:64,digestLength:32,messageLength:0,start:function(){e.messageLength=0;d=c.util.createBuffer();a={h0:1779033703,h1:3144134277,h2:1013904242,h3:2773480762,h4:1359893119,h5:2600822924,h6:528734635,h7:1541459225}}};e.start();e.update=function(b,f){if(null==b)throw{code:"102011",message:p["102011"]};"utf8"===f&&(b=c.util.encodeUtf8(b));e.messageLength+=b.length;d.putBytes(b);g(a,r,d);(2048<d.read||0===d.length())&&d.compact()};e.digest=function(){var b=e.messageLength,f=c.util.createBuffer();f.putBytes(d.bytes());f.putBytes(n.substr(0,64-(b+8)%64));f.putInt32(b>>>29&255);f.putInt32(b<<3&4294967295);b={h0:a.h0,h1:a.h1,h2:a.h2,h3:a.h3,h4:a.h4,h5:a.h5,h6:a.h6,h7:a.h7};g(b,r,f);f=c.util.createBuffer();f.putInt32(b.h0);f.putInt32(b.h1);f.putInt32(b.h2);f.putInt32(b.h3);f.putInt32(b.h4);f.putInt32(b.h5);f.putInt32(b.h6);f.putInt32(b.h7);return f};return e}}var w=["./util"],g=null;"function"!==typeof define&&("object"===typeof module&&module.exports?g=function(c,g){g(require,module)}:(crosscert=window.crosscert=window.crosscert||{},r(crosscert)));(g||"function"===typeof define)&&(g||define)(["require","module"].concat(w),function(c,g){g.exports=function(d){var g=w.map(function(d){return c(d)}).concat(r);d=d||{};d.defined=d.defined||{};if(d.defined.sha256)return d.sha256;d.defined.sha256=!0;for(var k=0;k<g.length;++k)g[k](d);return d.sha256}})})();