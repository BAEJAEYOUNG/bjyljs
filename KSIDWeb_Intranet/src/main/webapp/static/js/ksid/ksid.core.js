ksid.core = {};

/***************************************************************************
 * Name     : ksid.core.getCookie
 * Desc     : 쿠키값 읽기
 * @param   : name - 쿠키이름
 * @returns : string
 * @author  : 배재영
 * @since   : 2012.09.10
 ***************************************************************************/
ksid.core.getCookie = function(name) {
    var cookie = document.cookie;
    var value = null;
    if(cookie.length > 0) {
        var start = cookie.indexOf(name+"=", 0);
        if(start != -1) {
            var end = cookie.indexOf(";", start);
            if(end == -1) {
                end = cookie.length;
            }
            value = decodeURIComponent(cookie.substring(start+name.length+1, end));
        }
    }
    return value;
};

/***************************************************************************
 * Name     : ksid.core.setCookie
 * Desc     : 쿠키값 설정
 * @param   : name - 쿠키이름
 *            value - 쿠기값
 *            expireDay - 활성일
 *            path
 * @returns : void
 * @author  : 배재영
 * @since   : 2012.09.10
 ***************************************************************************/
ksid.core.setCookie = function(name, value, expireDays, path) {
    var str = name + "=" + encodeURIComponent(value) + ";";
    var expireDate = new Date();
    if(expireDays) {
        expireDate.setDate(expireDate.getDate() + parseInt(expireDays));
        str += "expires=" + expireDate.toGMTString() + ";";
    }
    if(path) {
        str += "path=" + path + ";";
    }
    document.cookie = str;
};