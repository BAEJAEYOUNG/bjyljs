<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 관리자정보 json
var newJson1 = {};

// 관리자리스트 grid
var grid1 = null;
var tabs1_grid1 = null;
var tabs2_grid1 = null;
var tabs3_grid1 = null;

/*****************************************************
 * 함수명 : ready
 * 설명   : onload 함수
 *****************************************************/
$(document).ready(function() {
});

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    $('#tabs').tabs({
        onAdd : function(title, index) {
        }
        , onSelect : function(title, index) {
        }
        , onUnselect : function(title, index) {
        }
        , onBeforeClose : function(title, index) {
        }
        , onClose : function(title, index) {
        }
        , onUpdate : function(title, index) {
        }
    });

    // 관리자리스트 그리드 생성
    var colModel = [];
    colModel.push({label: '관리자구분', name: 'adminType', hidden: true});
    colModel.push({label: '성별', name: 'sex', hidden: true});
    colModel.push({label: '국적', name: 'nation', hidden: true});
    colModel.push({label: '서비스제공자코드', name: 'spCd', hidden: true});
    colModel.push({label: '등록자', name: 'regId', hidden: true});
    colModel.push({label: '변경자', name: 'chgId', hidden: true});
    colModel.push({label: '서비스제공자명', name: 'spNm', width:100});
    colModel.push({label: '관리자아이디', name: 'adminId', format: 'string' , width:100});
    colModel.push({label: '관리자비밀번호', name: 'adminPw', format: 'string' , width:100});
    colModel.push({label: '관리자명', name: 'adminNm', width:100});
    colModel.push({label: '휴대폰번호', name: 'hpNo', format: 'tel_no' , width:100});
    colModel.push({label: '이메일', name: 'email', width:150});
    colModel.push({label: '성별', name: 'sexNm', width:50});
    colModel.push({label: '국적', name: 'nationNm', width:100});
    colModel.push({label: '사용여부', name: 'useYnNm', width:60});
    colModel.push({label: '인증서DN', name: 'certDn', format: 'string' , width:200});
    colModel.push({label: '등록자', name: 'regNm', format: 'string' , width:100});
    colModel.push({label: '등록일시', name: 'regDtm', format: 'dttm' , width:150});
    colModel.push({label: '변경자', name: 'chgNm', format: 'string' , width:100});
    colModel.push({label: '변경일시', name: 'chgDtm', format: 'dttm' , width:150});

    var gridProp = {};
    //gridProp.url = "${pageContext.request.contextPath}/admin/system/manager/list";
    //gridProp.datatype = "json";
    gridProp.colModel = colModel;
    /*gridProp.jsonReader = {
          repeatitems : false
        , root : function (obj) {
            return obj.resultData;
        }
    }*/
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    };

    //관리자리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    $("#grid1").setGridHeight(160, true);

    // 관리자리스트 그리드 생성
    colModel = [];
    colModel.push({label: '관리자구분', name: 'adminType', hidden: true});
    colModel.push({label: '성별', name: 'sex', hidden: true});
    colModel.push({label: '국적', name: 'nation', hidden: true});
    colModel.push({label: '서비스제공자코드', name: 'spCd', hidden: true});
    colModel.push({label: '등록자', name: 'regId', hidden: true});
    colModel.push({label: '변경자', name: 'chgId', hidden: true});
    colModel.push({label: '서비스제공자명1', name: 'spNm', width:100});
    colModel.push({label: '관리자아이디', name: 'adminId', format: 'string' , width:100});
    colModel.push({label: '관리자비밀번호', name: 'adminPw', format: 'string' , width:100});
    colModel.push({label: '관리자명', name: 'adminNm', width:100});
    colModel.push({label: '휴대폰번호', name: 'hpNo', format: 'tel_no' , width:100});
    colModel.push({label: '이메일', name: 'email', width:150});
    colModel.push({label: '성별', name: 'sexNm', width:50});
    colModel.push({label: '국적', name: 'nationNm', width:100});
    colModel.push({label: '사용여부', name: 'useYnNm', width:60});
    colModel.push({label: '인증서DN', name: 'certDn', format: 'string' , width:200});
    colModel.push({label: '등록자', name: 'regNm', format: 'string' , width:100});
    colModel.push({label: '등록일시', name: 'regDtm', format: 'dttm' , width:150});
    colModel.push({label: '변경자', name: 'chgNm', format: 'string' , width:100});
    colModel.push({label: '변경일시', name: 'chgDtm', format: 'dttm' , width:150});

    gridProp = {};
    //gridProp.url = "${pageContext.request.contextPath}/admin/system/manager/list";
    //gridProp.datatype = "json";
    gridProp.colModel = colModel;
    /*gridProp.jsonReader = {
          repeatitems : false
        , root : function (obj) {
            return obj.resultData;
        }
    }*/
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    };

    //관리자리스트 그리드 생성
    tabs1_grid1 = new ksid.grid("tabs1_grid1", gridProp);
    tabs1_grid1.loadGrid();

    // 관리자리스트 그리드 생성
    colModel = [];
    colModel.push({label: '관리자구분', name: 'adminType', hidden: true});
    colModel.push({label: '성별', name: 'sex', hidden: true});
    colModel.push({label: '국적', name: 'nation', hidden: true});
    colModel.push({label: '서비스제공자코드', name: 'spCd', hidden: true});
    colModel.push({label: '등록자', name: 'regId', hidden: true});
    colModel.push({label: '변경자', name: 'chgId', hidden: true});
    colModel.push({label: '서비스제공자명2', name: 'spNm', width:100});
    colModel.push({label: '관리자아이디', name: 'adminId', format: 'string' , width:100});
    colModel.push({label: '관리자비밀번호', name: 'adminPw', format: 'string' , width:100});
    colModel.push({label: '관리자명', name: 'adminNm', width:100});
    colModel.push({label: '휴대폰번호', name: 'hpNo', format: 'tel_no' , width:100});
    colModel.push({label: '이메일', name: 'email', width:150});
    colModel.push({label: '성별', name: 'sexNm', width:50});
    colModel.push({label: '국적', name: 'nationNm', width:100});
    colModel.push({label: '사용여부', name: 'useYnNm', width:60});
    colModel.push({label: '인증서DN', name: 'certDn', format: 'string' , width:200});
    colModel.push({label: '등록자', name: 'regNm', format: 'string' , width:100});
    colModel.push({label: '등록일시', name: 'regDtm', format: 'dttm' , width:150});
    colModel.push({label: '변경자', name: 'chgNm', format: 'string' , width:100});
    colModel.push({label: '변경일시', name: 'chgDtm', format: 'dttm' , width:150});

    gridProp = {};
    //gridProp.url = "${pageContext.request.contextPath}/admin/system/manager/list";
    //gridProp.datatype = "json";
    gridProp.colModel = colModel;
    /*gridProp.jsonReader = {
          repeatitems : false
        , root : function (obj) {
            return obj.resultData;
        }
    }*/
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    };

    //관리자리스트 그리드 생성
    tabs2_grid1 = new ksid.grid("tabs2_grid1", gridProp);
    tabs2_grid1.loadGrid();

    // 관리자리스트 그리드 생성
    colModel = [];
    colModel.push({label: '관리자구분', name: 'adminType', hidden: true});
    colModel.push({label: '성별', name: 'sex', hidden: true});
    colModel.push({label: '국적', name: 'nation', hidden: true});
    colModel.push({label: '서비스제공자코드', name: 'spCd', hidden: true});
    colModel.push({label: '등록자', name: 'regId', hidden: true});
    colModel.push({label: '변경자', name: 'chgId', hidden: true});
    colModel.push({label: '서비스제공자명3', name: 'spNm', width:100});
    colModel.push({label: '관리자아이디', name: 'adminId', format: 'string' , width:100});
    colModel.push({label: '관리자비밀번호', name: 'adminPw', format: 'string' , width:100});
    colModel.push({label: '관리자명', name: 'adminNm', width:100});
    colModel.push({label: '휴대폰번호', name: 'hpNo', format: 'tel_no' , width:100});
    colModel.push({label: '이메일', name: 'email', width:150});
    colModel.push({label: '성별', name: 'sexNm', width:50});
    colModel.push({label: '국적', name: 'nationNm', width:100});
    colModel.push({label: '사용여부', name: 'useYnNm', width:60});
    colModel.push({label: '인증서DN', name: 'certDn', format: 'string' , width:200});
    colModel.push({label: '등록자', name: 'regNm', format: 'string' , width:100});
    colModel.push({label: '등록일시', name: 'regDtm', format: 'dttm' , width:150});
    colModel.push({label: '변경자', name: 'chgNm', format: 'string' , width:100});
    colModel.push({label: '변경일시', name: 'chgDtm', format: 'dttm' , width:150});

    gridProp = {};
    //gridProp.url = "${pageContext.request.contextPath}/admin/system/manager/list";
    //gridProp.datatype = "json";
    gridProp.colModel = colModel;
    /*gridProp.jsonReader = {
          repeatitems : false
        , root : function (obj) {
            return obj.resultData;
        }
    }*/
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    };

    //관리자리스트 그리드 생성
    tabs3_grid1 = new ksid.grid("tabs3_grid1", gridProp);
    tabs3_grid1.loadGrid();
}

/*****************************************************
* 함수명: 관리자 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid("grid1"
                      , "${pageContext.request.contextPath}/admin/system/manager/list"
                      , params
                      , function(result) {

        //관리자 입력 폼 초기화
        doNew();

        if(resultMsg) {
            //CommonJs.setStatus(resultMsg);
        } else {
            //CommonJs.setStatus(  ksid.string.replace( CommonJs.setMsgLanguage("관리자 목록 <strong>{0}</strong>건이 조회 되었습니다."), "{0}", result.resultData.length ) );
            //CommonJs.searchMsg(result);
        }

    });

}
</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">시스템</span> > <span name="menu">관리자관리</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt><span name="title">관리자아이디/명</span></dt>
                <dd>
                    <input type="text" maxlength="3" name="admin_id" title="관리자아이디/명" class="style-input width110" command="doQuery()" />
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="W" onclick="doNew()">신규</button>
            <button type="button" class="style-btn" auth="W" onclick="doSave()">저장</button>
            <button type="button" class="style-btn" auth="D" onclick="doDelete()">삭제</button>
            <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button>
        </div>
        <!--// button bar  -->
    </div>

    <h3 class="style-title"><span name="title">메인 목록</span></h3>
    <!-- grid -->
    <table id="grid1" resize="false"></table>
    <!--// grid -->

    <h3 class="style-title"><span name="title">서브 목록</span></h3>
    <div id="tabs" class="easyui-tabs">
        <div title="테스트탭1">
            <table id="tabs1_grid1" resize="false"></table>
        </div>
        <div title="테스트탭2">
            <table id="tabs2_grid1" resize="false"></table>
        </div>
        <div title="테스트탭3">
            <table id="tabs3_grid1" resize="false"></table>
        </div>
    </div>

</div>
