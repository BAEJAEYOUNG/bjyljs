/****************************************************************
    파일명: ksid.debug.js
    설명:  ksid debug js
        
    수정일         수정자        수정내용
    ------------------------------------------------------
    2015-01-14     배재영        초기작성 
    ------------------------------------------------------
****************************************************************/

ksid.debug = {};

/**
 * map type object 를 alert 로 화면에 print 한다.
 * 사용법 : ksid.debug.printObj(대상 object);
 * 		  ksid.debug.printObj(대상 object, 제목);
 */
ksid.debug.printObj	= function(obj, title) {

	if(typeof(obj) == 'string') {
		return ksid.debug.printObj(title, obj);
	}
	
    var printStr	= "";
    
    if (title) {
    	printStr += "--------------------------------------------\n";
    	printStr += title;
    	printStr += "\n--------------------------------------------\n";
    }
    
    if(!obj) {
        printStr += "해당 맵은 null 입니다";
    } else {
		for (var key in obj) {
			printStr += "" + key + " = " + obj[key];
			printStr += "\n";
		}
    }
    
    alert(printStr);
};

/**
 * array 타입을 화면에 print
 */
ksid.debug.printArray = function(array, title) {
	
	if(typeof(array) == 'string') {
		ksid.debug.printArray(title, array);
	}
	
    var printStr = "";

    if (title) {
        printStr += "--------------------------------------------\n";
        printStr += title;
        printStr += "\n--------------------------------------------\n";
    }

    if(!array) {
        
        printStr += "해당 배열은 null 입니다";
        
    } else {
        for (var i = 0; i < array.length; i++) {
            printStr += "[" + i + "] : " + array[i];

            if (i < array.length - 1)
                printStr += "\n";
        }
    }
    alert(printStr);
    
};

/**
 * array>map type object 를 alert 로 화면에 print 한다.
 * 사용법 : ksid.debug.array_map(대상 array);
 */
ksid.debug.printArrayObj = function() {
	
    var printStr = "";
    var array = null;
    var map = null;
    
    if (typeof (arguments[0]) == "string") {
        printStr += "--------------------------------------------\n";
        printStr += arguments[0];
        printStr += "\n--------------------------------------------\n";
        
        array = arguments[1];
    } else {
        array = arguments[0];
    }
    
    if(array == null) {
    	
        printStr += "해당 배열은 null 입니다";
    	
    } else {
    	
        for (var i = 0; i < array.length; i++) {
            printStr += "===== [" + i + "] =====\n";
            map = array[i];
            
            for (var ls_key in map) {
                printStr += "" + ls_key + "=" + map[ls_key] + ",";
            }
            
            printStr = printStr.substr(0, printStr.length - 1);
            printStr += "\n";
        }
    
    }
    alert(printStr);
	
};

/**
 * map > array > map type object 를 alert 로 화면에 print 한다.
 * 사용법 : ksid.debug.map_array_map(대상 map);
 */
ksid.debug.printObjArrayObj	= function() {
	
    var printStr = "";
    var map = null;
    var map2 = null;
    
    if (typeof (arguments[0]) == "string") {
        printStr += "--------------------------------------------\n";
        printStr += arguments[0];
        printStr += "\n--------------------------------------------\n";
        
        map = arguments[1];
    } else
        map = arguments[0];
    
    if(map == null) {
    	
        printStr += "해당 맵은 null 입니다";
    	
    } else {
    	
        var array = null;
        
        for (var ls_key in map) {
            printStr += "### KEY = " + ls_key
            printStr += "\n";
            array = map[ls_key];
            for (var i = 0; i < array.length; i++) {
                printStr += "[" + i + "] => ";
                map2 = array[i];
                for (var ls_key2 in map2) {
                    printStr += "" + ls_key2 + "=" + map2[ls_key2] + ",";
                }
                
                printStr += "\n";
            }
        }
    	
    }
    
    alert(printStr);
	
};

/**
 * map > array > map
 */
//ksid.debug.code2 = function() {
//    
//    var printStr = "";
//    var map = null;
//    var map2 = null;
//    
//    if (typeof (arguments[0]) == "string") {
//        printStr += "--------------------------------------------\n";
//        printStr += arguments[0];
//        printStr += "\n--------------------------------------------\n";
//        
//        map = arguments[1];
//    } else
//        map = arguments[0];
//    
//    if(map == null) {
//        
//        printStr += "해당 맵은 null 입니다";
//        
//    } else {
//        
//        var array = null;
//        
//        for (var ls_key in map) {
//            
//            printStr += "### KEY = " + ls_key
//            printStr += "\n";
//            
//            for (var ls_key2 in map[ls_key]) {
//                
//                printStr += "### KEY = " + ls_key + " > KEY2 = " + ls_key2
//                printStr += "\n";
//                array = map[ls_key][ls_key2];
//                for (var i = 0; i < array.length; i++) {
//                    printStr += "[" + i + "] => ";
//                    map2 = array[i];
//                    for (var ls_key3 in map2) {
//                        printStr += "" + ls_key3 + "=" + map2[ls_key3] + ",";
//                    }
//                    
//                    printStr += "\n";
//                }
//                
//            }
//            
//            printStr += "\n";
//            
//        }
//        
//    }
//    
//    alert(printStr);
//    
//};

