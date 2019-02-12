/****************************************************************
    설명: json 관련
        사용 시 json3.min.js import가 선행 되어야 한다.
    수정일         수정자        수정내용
    ------------------------------------------------------
    2015-01-14     배재영        초기작성
    ------------------------------------------------------
****************************************************************/


ksid.json = {};


/**
 * object copy
 * @param json
 */
ksid.json.cloneObject = function(json) {
    return JSON.parse(JSON.stringify(json));
};

/**
 * target object 에 object 병합
 */
ksid.json.mergeObject = function(targetObj, sourceObj) {
    for (var key in sourceObj) {
        targetObj[key] = sourceObj[key];
    }
};

/**
 * 대상 arra 에 해당 값이 존재하는지 여부 반환
 * @param ao_array
 * @param as_val
 */
ksid.json.containsArrayValue = function(array, val) {
    var containsYn = false;

    for (var i = 0; i < array.length; i++) {
        if( array[i] == val ) {
            containsYn = true;

            break;
        }
    }

    return containsYn;
};

/**
 * 대상 맵에 해당 키가 존재하는지 여부 반환
 * @param ao_map
 * @param as_key
 */
ksid.json.containsKey = function(obj, findKey) {
    var containsYn = false;

    for (var key in obj) {
        if (key == findKey) {
            containsYn = true;

            break;
        }
    }

    return containsYn;
};

ksid.json.dialogProp = {

    modal: true,
    resizable: false,
    show: "fadeIn",
    hide: "fadeOut",
    close: false

};

