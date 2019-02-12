/***************************************************************************
 * Name     : ajax 관련 함수
 * Desc     :
 * @author  : 배재영
 * @since   : 2015.07.07
 ***************************************************************************/

ksid.net = {};


/***************************************************************************
 * Function Name : ajax
 * Description : 데이터 조회/저장/수정/삭제 용 기본 ajax 호출
 * 				 일반: .ajax("get_s160_code_list.do", {"code_cd": "USE_YN"}, function(loadData) {...});
 * 				 에러콜백: .ajax("get_s160_code_list.do", {"code_cd": "USE_YN"}, function(loadData) {...}, function(x, e) {...});
 * 				 alert미사용: .ajax("get_s160_code_list.do", {"code_cd": "USE_YN"}, function(loadData) {...}, null, true);
 * parameters : url, params, callback, exceptionCallback, blockAlert
 * return : {"resultCd", "resultMsg", "resultData"}
 ***************************************************************************/
ksid.net.ajax = function (url, params, callback, options) {

//    console.log(url);

//	ksid.debug.printObj(params, 'params');
    //다국어
    if(params==null){
        params = {"language": ksid.language};
    } else {
        params.language = ksid.language;
    }

    var defaultOptions = {
        url: url,
        type: "POST",
        dataType: "json",
        data: params,
        beforeSend : function(xmlHttpRequest){
            xmlHttpRequest.setRequestHeader("AJAX", "true"); // ajax 호출을  header에 기록
        },
        success:function(loadData,textStatus) {
//            console.log("-----------------loadData::", loadData);

            //00성공, 99실패
            if(loadData.resultCd == "00") {
                if(callback) {
                    callback(loadData);
                }
            } else if ("98" == loadData.resultCd) {
                location.href = "/login";
            } else {
                try {
                    CommonJs.setStatus(loadData.resultMsg);
                } catch (e) {}

                if(callback) {
                    callback(loadData);
                }
            }
        },
        error:function(x,e){
            ksid.net.alertErrorStatus(x.status, e);
        }
    };
    if(options) {
        ksid.json.mergeObject(defaultOptions, options);
    }

    $.ajax(defaultOptions);
};

ksid.net.ajaxMulti = function(url, params, callback) {
    ksid.net.ajax( url, params, callback, {contentType:"application/json; charset=UTF-8"} );
}

ksid.net.sjax = function( url, params, callback ) {
    ksid.net.ajax( url, params, callback, {async : false} );
}

ksid.net.file = function(params, callBackFunc, options) {

    ksid.net.ajax( '/file/updDataMulti', params, callBackFunc, options);

}

/***************************************************************************
 * Function Name : ajaxJqGrid
 * Description : jqgrid 조회 용 ajax 조회 성공 후 자동으로 bind처리 및 loadmask 처리
 * 				, server 오류 시 loadmask hide 처리
 * parameters : gridId, url, params, callback
 * return : {"resultCd", "resultMsg", "resultData"}
 ***************************************************************************/
ksid.net.ajaxJqGrid = function (jqGrid, url, params, callback) {

    jqGrid.showLoading();

    ksid.net.ajax(url, params, function(result) {

        jqGrid.hideLoading();

//	    alert("result.resultCd = " + result.resultCd);
        if(result.resultCd == "00") {
            jqGrid.bindGrid(result.resultData);

            if(callback) {
                callback(result);
            }

        } else {
            ksid.ui.alert( "조회 중 오류가 발생했습니다.");
        }

    }, function(x, e) {
        jqGrid.hideLoading();
    }, true);
};

/***************************************************************************
 * Function Name : ajaxCombo
 * Description : url과 파라미터로 json Array 조회하여 combo bind
 * 				combo element에 json형태의 arryay를 옵션으로 생성한다.
 * 				combo의 attribute에 overall로 문자를 추가하면 overall이 ""값으로 추가됨
 * 				combo의 attribute에 selected_value로 값을 지정하면 해당 값 selected
 * parameters : comboElement, url: 반환값이 {code_id: "", code_nm: ""}, params: {code_grp_id: ""}
 * return :
 ***************************************************************************/
ksid.net.ajaxCombo = function(combo, url, params, callback) {
    ksid.net.sjax(url, params, function(result) {
        if(result.resultCd == "00") {
            ksid.ui.bindCombo(combo, result.resultData);
        }
        if(callback) {
            callback(result);
        }
    });
};

ksid.net.ajaxExcel = function(url, fileNm, params, oGrid) {

    if(params==null){
        params = {"language": ksid.language};
    } else {
        params.language = ksid.language;
    }

    var excelGroupHeader = ksid.net.getExcelGroupHeader(oGrid);

    if(typeof url == "undefined") {
        ksid.ui.alert("url(호출서비스명)은 필수항목 입니다.");
        return;
    }

    if(typeof fileNm == "undefined") {
        ksid.ui.alert( "fileNm(파일명)은 필수항목 입니다.");
        return;
    }

    if(typeof params == "undefined") {
        ksid.ui.alert( "파라미터는 필수항목 입니다.");
        return;
    }

    if(typeof oGrid == "undefined") {
        ksid.ui.alert( "grid는 필수항목 입니다.");
        return;
    }

    var excelParams = {};
    excelParams.fileNm = ksid.net.getExcelFileNm(fileNm);
    excelParams.param = params;
    excelParams.colModel = oGrid.getExcelColModel();
    if( excelGroupHeader != null ) {
        excelParams.groupHeader = JSON.stringify(excelGroupHeader);
    }

    ksid.ui.confirm(fileNm + " 엑셀파일을 다운로드 하시겠습니까?", function() {

        $("#form_excel").attr("action", url);
        $("#form_excel input[name=params]").val(encodeURIComponent(JSON.stringify(excelParams)));
        $("#form_excel").submit();

    });

};

ksid.net.ajaxExcelGrid = function(url, fileNm, oGrid) {

    var excelGroupHeader = ksid.net.getExcelGroupHeader(oGrid);

    if(typeof url == "undefined") {
        ksid.ui.alert("url(호출서비스명)은 필수항목 입니다.");
        return;
    }

    if(typeof fileNm == "undefined") {
        ksid.ui.alert( "fileNm(파일명)은 필수항목 입니다.");
        return;
    }

    if(typeof oGrid == "undefined") {
        ksid.ui.alert( "grid는 필수항목 입니다.");
        return;
    }

    var data = ( oGrid.rows == null ) ? [] : ksid.json.cloneObject(oGrid.rows);

    var excelModel = oGrid.getExcelColModel();

    // 하단 합계가 존재할 경우
    if(oGrid.prop.footerrow == true) {

        var footerData = {};

        $("#gview_"+oGrid.id).find(".ui-jqgrid-ftable td").each(function(index){
            var colName = ksid.string.replace($(this).attr('aria-describedby'), oGrid.id + '_' , '');
            var colValue = ksid.string.replace(ksid.string.trim($(this).text()), '&nbsp;', '');
            if(colValue != "합계" && colValue != '') {
                try {
                    colValue = ksid.number.toNumber(colValue)
                } catch (e) {}
            }
            for (var i = 0; i < excelModel.length; i++) {
                if( excelModel[i].name == colName ) {
                    footerData[colName] = colValue;
                }
            }
        });

        data.unshift(footerData);
    }


    excelParams = {};
    excelParams.fileNm = ksid.net.getExcelFileNm(fileNm);
    excelParams.colModel = excelModel;
    excelParams.data = data;
    if( excelGroupHeader != null ) {
        excelParams.groupHeader = JSON.stringify(excelGroupHeader);
    }

    ksid.ui.confirm(fileNm + " 엑셀파일을 다운로드 하시겠습니까?", function() {

        $("#form_excel").attr("action", url);
        $("#form_excel input[name=params]").val(encodeURIComponent(JSON.stringify(excelParams)));
        $("#form_excel").submit();

    });

};

ksid.net.getExcelFileNm = function(fileNm) {
    var dttm = new ksid.datetime().getDate('yyyymmddhhmiss');
    return fileNm + '_' + dttm;
}

ksid.net.getExcelGroupHeader = function( oGrid ) {
    var groupHeadersOptions = $("#" + oGrid.id + "").jqGrid("getGridParam", "groupHeader");
    var excelGroupHeader = null;

    if( groupHeadersOptions != null ) {
        excelGroupHeader = [];
        var arrGridModel = oGrid.getExcelColModel();
        for (var i = 0; i < groupHeadersOptions.groupHeaders.length; i++) {
            for (var j = 0; j < arrGridModel.length; j++) {
                if( groupHeadersOptions.groupHeaders[i].startColumnName == arrGridModel[j].name ) {
                    excelGroupHeader.push( [ 0, 0, j, j + groupHeadersOptions.groupHeaders[i].numberOfColumns - 1, groupHeadersOptions.groupHeaders[i].titleText] );
                }
            }
        }
    }

    return excelGroupHeader;
}

/***************************************************************************
 * Function Name : instanceOfXMLHttpRequest
 * Description : Ajax을 사용하기 위해  XMLHttpRequest를 브라우저 호환되게 반환한다.
 * parameters :
 * return : XMLHttpRequest
 ***************************************************************************/
ksid.net.instanceOfXMLHttpRequest = function() {
    var xmlhttp;
    if (window.XMLHttpRequest) {
        // code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp=new XMLHttpRequest();
    } else {
        // code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    return xmlhttp;
};

/***************************************************************************
 * Function Name : loadXMLHttpRequest
 * Description : XMLHttpRequest를 통해 받은 문서를 반환
 * parameters :
 * return : XMLHttpRequest
 ***************************************************************************/
ksid.net.loadXMLHttpRequest = function (method, url, async, asyncFunc) {
    var xmlhttp = ksid.net.instanceOfXMLHttpRequest();
    if(async) { //IE와 오페라에서는 동기방식도 onreadystatechange 발생
        //비동기 방식일 경우 응답받을 함수를 이벤트에 설정한다.
        xmlhttp.onreadystatechange = asyncFunc;
    }
    xmlhttp.open(method, url, false);
    xmlhttp.send(null);
    if(!async) {
        //동기 방식이면 결과를 반환
        return xmlhttp.responseText;
    }
};

/***************************************************************************
 * Name     : ksid.net.alertStatusMessage
 * Desc     : ajax 통신오류 메세지처리
 * @param   : status
 *            exception
 * @returns : void
 * @author  : 배재영
 * @since   : 2012.09.10
 ***************************************************************************/
ksid.net.alertErrorStatus = function(status, e) {
    if(status==0){
        alert('You are offline!!\n Please Check Your Network.');
    } else if(status==404){
        alert('Requested URL not found.');
    } else if(status==500){
        alert('Internel Server Error.');
    } else if(status==600){
        alert('Session Error.');

        if(parent) {
            if(parent.parent) {
                parent.parent.location.replace("/index.do");
            } else {
                parent.location.replace("/index.do");
            }
        } else {
            location.replace("/index.do");
        }
    } else if(e=='parsererror'){
        alert('Error.\nParsing JSON Request failed.');
    } else if(e=='timeout'){
        alert('Request Time out.');
    } else {
        alert('Transfer Error.');
    }
};
