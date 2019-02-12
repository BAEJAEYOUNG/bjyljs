/****************************************************************
    파일명: ksid.prop.js
    설명:  ksid prop js
        
    수정일         수정자        수정내용
    ------------------------------------------------------
    2015-01-14     배재영        초기작성 
    ------------------------------------------------------
****************************************************************/

// ksid prop namespace
ksid.file = {};

ksid.file.getFileExt = function(filePath) {
	
	var last = filePath.lastIndexOf('.');
	var ext = "";
	
	if( last > 0 ) {
		ext = filePath.substring( last+1 );
	}
	
	return ext.toLowerCase();
	
};

ksid.file.checkExcelFile = function( filePath ) {
	
	var ext = ksid.file.getFileExt(filePath);
	
	if( ext != "xls" && ext != "xlsx" ) {
		return false;
	} else {
		return true;
	} 
	
};




















