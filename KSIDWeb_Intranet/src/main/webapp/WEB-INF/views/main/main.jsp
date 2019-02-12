<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>${config.pageTitle}</title>
<jsp:include page="${config.includePath}/css.jsp"/>
<script type="text/javascript">
var contextPath = "${contextPath}";
var cssPath = "${config.cssPath}";
var jsPath = "${config.jsPath}";
var imagePath = "${config.imagePath}";
</script>
<jsp:include page="${config.includePath}/js.jsp"/>

<style type="text/css">
    #mainTabs .tabs-inner {
        height:28px !important;
    }

    /* jquery 다이얼로그 닫기 버튼 없애기 */
    .ui-dialog-titlebar-close {
        visibility: hidden;
    }

    /* jquery datepicker css 변경 */
    .ui-datepicker select.ui-datepicker-year {width:60px;}
    .ui-datepicker select.ui-datepicker-month {width:55px;}
    .ui-datepicker { font-size:9pt; width:200px; }
    img.ui-datepicker-trigger {margin-left:5px;vertical-align:middle;cursor:default}

    /* jqgrid 버그 패치 */
    .ui-jqgrid .ui-jqgrid-bdiv div div
    {
        display:none;
    }

    /* 공통 ui css 변경 */
    .ui-widget-content {background:#ffffff;}
    .footrow {background:#e2ebfc;}
    .footrow td:first-child  {background:#e2ebfc;}

    table.ui-jqgrid-btable { height: 1px; }
</style>

<script type="text/javascript" charset="utf-8">

    jQuery.browser = {};
    (function () {
        jQuery.browser.msie = false;
        jQuery.browser.version = 0;
        if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
            jQuery.browser.msie = true;
            jQuery.browser.version = RegExp.$1;
        }
    })();

    var gParam = null;

    var menuL = [];
    var menuM = {};
    var menuS = {};

    var clickedMenuL = null;   // 대메뉴 clicked
    var clickedMenuM = null;   // 중메뉴 clicked

    var yearList = [];
    var ymList = [];                // select bind data 추가 - 조회년월
    var calendarYmList = [];        // select bind data 추가 - 일정년월
    var sQuarterDtList = [];          // 조회 시작 분기
    var eQuarterDtList = [];          // 조회 종료 분기
    var clickedMenuMId = null;      // 클릭된 중메뉴 id

    /*****************************************************
    * 함수명: 공통 처리 스크립트
    * 설명   :
    *****************************************************/
    $(document).ready(function() {

        // 윈도우 리사이즈 시 리사이즈 호출
        $(window).resize(function() {
            $('#mainTabs').tabs('resize');

            if ($(".tabs-scroller-left").css("display") == "none") {
                $(".tabs-first > a").focus();
            }
        });

        $.fn.menuLoad();

        var iYearStart = 2017;
        var iYearNow = (new Date).getFullYear();
        var iMonthNow = new Date().getMonth()+1;

        for( var i=iYearNow; i>=iYearStart; i-- ) {
            var objYear = {};
            objYear.codeCd = i;
            objYear.codeNm = i + '년';
            yearList.push(objYear);
        }

        for( var i=iYearNow; i>=iYearStart; i-- ) {
            var iMonthStart = 12;
            if( i == iYearNow ) {
                iMonthStart = iMonthNow;
            }
            for(var j=iMonthStart; j>=1; j--) {
                var objMon = {};
                objMon.codeCd = i + '' + ksid.string.lpad(j, 2, '0');
                objMon.codeNm = i + '년 ' + ksid.string.lpad(j, 2, '0') + '월';
                ymList.push(objMon);
            }
        }

        for( var i=iYearNow; i>=iYearStart; i-- ) {

            var iQuarterStart = 4;
            if( i == iYearNow ) {
                if( iMonthNow <= 3 ) {
                    iQuarterStart = 1;
                } else if( iMonthNow <= 6 ) {
                    iQuarterStart = 2;
                } else if( iMonthNow <= 9 ) {
                    iQuarterStart = 3;
                }
            }

            for(var j=iQuarterStart; j>=1; j--) {

                var sQuarterCd,eQuarterCd,quarterNm;

                if(j == 1) {
                    sQuarterCd = i + '0101';
                    eQuarterCd = i + '0331';
                    quarterNm = i + '년 1분기';
                } else if( j == 2 ) {
                    sQuarterCd = i + '0401';
                    eQuarterCd = i + '0630';
                    quarterNm = i + '년 2분기';
                } else if( j == 3 ) {
                    sQuarterCd = i + '0701';
                    eQuarterCd = i + '0931';
                    quarterNm = i + '년 3분기';
                } else {
                    sQuarterCd = i + '1001';
                    eQuarterCd = i + '1231';
                    quarterNm = i + '년 4분기';
                }

                var objSQuarter = {};
                objSQuarter.codeCd = sQuarterCd;
                objSQuarter.codeNm = quarterNm;

                var objEQuarter = {};
                objEQuarter.codeCd = eQuarterCd;
                objEQuarter.codeNm = quarterNm;

//                 console.log('objSQuarter', objSQuarter);
//                 console.log('objEQuarter', objEQuarter);

                sQuarterDtList.push(objSQuarter);
                eQuarterDtList.push(objEQuarter);
            }
        }

//         console.log('sQuarterDtList', sQuarterDtList);
//         console.log('eQuarterDtList', eQuarterDtList);

    });

    $.fn.menuLoad = function() {

        /**--------------------------------------------------
            메뉴 data 로딩 시작
        ----------------------------------------------------*/
        //$("#loginUser").text('<c:out value="${sessionScop.sessionUser.adminId}"/>');

        $.blockUI({
              message: '사용자 메뉴정보를 가져오는 중입니다.<br />잠시만 기다려 주세요...'
            , css: { "font-weight": "bold", "height": "80px", "color": "#000", "opacity": "1", "font-size": "10pt", "line-height": "1.8", "padding-top": "8px", "font-family": "굴림체" }
        });

        ksid.net.ajax("main/mainMenuList", null, function(result) {

            if(result.resultCd == "00") {
                var menuArray = ksid.json.cloneObject(result.resultData);

                for ( var i = 0; i < menuArray.length; i++) {
                    var menuData = menuArray[i];

                    // 대메뉴 ( 1차수 메뉴 )
                    if( ksid.number.toNumber(menuData.menuLvl) == 1 ) {
                        menuData.menuNm = menuData.menuNm
                        menuL.push(menuData);
                    } else if( ksid.number.toNumber(menuData.menuLvl) == 2 ) {
                        if( ksid.json.containsKey(menuM, menuData.refMenuId) == false ) {
                            menuM[menuData.refMenuId] = [];
                        }

                        menuM[menuData.refMenuId].push(menuData);
                    } else if( ksid.number.toNumber(menuData.menuLvl) == 3 ) {
                        if( ksid.json.containsKey(menuS, menuData.refMenuId) == false ) {
                            menuS[menuData.refMenuId] = [];
                        }

                        menuS[menuData.refMenuId].push(menuData);
                    }
                }

                setTimeout('loadMenu()', 1000);
            } else {
                ksid.ui.jAlert("메뉴를 가져오는중 오류가 발생했습니다.");
            }

            setTimeout('$.unblockUI()', 1000);
        });
    }

    function loadMenu() {

        $("#topMenu ul li").remove();

        // menuId:1, menuNm:매출관리
        for ( var i = 0; i < menuL.length; i++) {
            $("#topMenu ul").append('<li><a id="menuL_' + menuL[i].menuId + '" href="javascript:menuLClick(\'' + menuL[i].menuId + '\')"><span name="menu">' + menuL[i].menuNm + '</span></a></li>');
        }

        // 첫번째 대메뉴 클릭상태로
        menuLClick(menuL[0].menuId);

        //컨텐츠 사이즈 제어
        $('#leftMenuBar').BootSideMenu({
              side : "left"
            , autoClose : false
            , pushBody : false
            , width : ""
            , onTogglerClick: function () {
            }
            , onBeforeOpen: function () {
                //$(".tabs-panels").removeClass("layout-left-close");
                $(".layout-content").removeClass("layout-left-close");
                $(".layout-status").removeClass("layout-left-close");
                $(window).resize();
            }
            , onOpen: function () {
            }
            , onBeforeClose: function () {
                //$(".tabs-panels").addClass("layout-left-close");
                $(".layout-content").addClass("layout-left-close");
                $(".layout-status").addClass("layout-left-close");
                $(window).resize();
            }
            , onClose: function () {
            }
        });
    }

    // 대메뉴 클릭
    function menuLClick(menuId) {

        clickedMenuL = menuL[getMenuLIdx(menuId)];

        $('#topMenu ul li a').removeClass('on');        // 기존 대메뉴 click css 를 지운다

        $('#menuL_' + menuId ).addClass('on');      // 대메뉴 click css 적용

        $('#leftMenuTitle').html('<span name="menu" class="bold">' + clickedMenuL.menuNm + '</span>');

        $("#tree").children().remove();

        for ( var i = 0; i < menuM[menuId].length; i++) {
            if( menuM[menuId][i].menuNm == "구분자" ) {
                $("#tree").append('<li class="lnb_sperator"></li>');
            } else {
                $("#tree").append('<li><a title="' + menuM[menuId][i].execCmd + '" id="menu_m_' + menuM[menuId][i].menuId + '" href="#" class="easyui-linkbutton" onclick="addTab(\'' + menuM[menuId][i].menuId + '\',\'' + menuM[menuId][i].menuNm + '\',\'' + '${config.contextPath}' + menuM[menuId][i].execCmd + '\')"><span name="menu">' + menuM[menuId][i].menuNm + '</menu></a></li>');
            }
        }

        $("#tree").treeview();

        setMenuMClickedCss();

        CommonJs.setMenuLanguage();
    }

    // 대메뉴 id 로 index 가져오기
    function getMenuLIdx(menuId) {

        var returnIdx = 0;

        for (var i = 0; i < menuL.length; i++) {
            if (menuL[i].menuId == menuId.toString()) {
                returnIdx = i;
                break;
            }
        }

        return returnIdx;
    }

    //탭메뉴
    function addTab(menuId, title, url){
        $('.layout-content').load(url, params, function(responseText, textStatus, jqXHR) {

            if ($.isFunction(init)) {
                init();

                $(".location").find("span:eq(1)").text($("#leftMenuTitle").find("[name=menu]").text());
                $(".location").find("span:eq(2)").text(title);

                $("div[id$='-panel']").each(function() {
                    ksid.form.applyFieldOption($(this).attr("id"));
                });

                $(window).resize();
            }
        });

        if (true) {
            return;
        }

        clickedMenuMId = menuId;

        setMenuMClickedCss();

        if ($('#mainTabs').tabs('exists', title)){
            $('#mainTabs').tabs('select', title);
        } else {
            var content = '<div id="mainTab' + menuId + '" style="width:100%;height:100%;"></div>';
            $('#mainTabs').tabs('add', {
                  title : title
                , content : content
                , closable : true
            });

            var params = {};

            $('#mainTab' + menuId).load(url, params, function(responseText, textStatus, jqXHR) {
                init();
                $("div[id$='-panel']").each(function() {
                    ksid.form.applyFieldOption($(this).attr("id"));
                });
                $(window).resize();
            });
        }

        $('.tabs-header span.tabs-title').each(function(){
            $(this).parent().attr("title", getMenuMCmdExec($(this).text()));
        });
    }

    function setMenuMClickedCss() {

        if (true) {return;}
        $("#tree li a").removeClass("clickedMenu");
        $("#menu_m_" + clickedMenuMId).addClass("clickedMenu");

    }

    function closeAllTab() {

        $(".tabs-close").each(function() {
            $(this).click();
        });

        clickedMenuMId = null;
        setMenuMClickedCss();
    }

    function getMenuMCmdExec(title) {
        rtnVal = "";
        if( title == "Home" ) {
            rtnVal = "dashboard.do";
        } else {
            for ( var i = 0; i < menuL.length; i++) {

                var arrMenuM = menuM[menuL[i].menuId];

                for ( var j = 0; j < arrMenuM.length; j++) {
                    var ls_menu_nm = ( ksid.language == "kr" ) ? arrMenuM[j].menuNm : CommonJs.getMenuLanguage(arrMenuM[j].menuNm);
                    if( ls_menu_nm == title ) {
                        rtnVal = arrMenuM[j].execCmd;
                        break;
                    }
                }

            }
        }
        return rtnVal;
    }

    /*****************************************************
     * 함수명: 로그아웃
     * 설명   :
     *****************************************************/
     function logout() {
         location.replace("logout");
     }
</script>
</head>
<body style="overflow-x:hidden; overflow-y:hidden;">
<div class="layout-main">
    <div class="layout-top">
        <div class="logo">
            <span class="title bold"><a href="/" name="title">${config.pageTitle}</a></span>
        </div>
        <div id="topMenu" class="top-menu">
            <ul></ul>
            <!--
            <a class="btn_selectALl" href="javascript:closeAllTab();"><span name="button">전체 닫기</span></a>
             -->
        </div>
    </div>
    <div class="layout-body">
        <div id="leftMenuBar" class="layout-left">
            <div id="leftMenu" class="left-menu">
                <div class="login-info">
                    <div>
                        <strong id="loginUser">${sessionScope.sessionUser.adminId}</strong>
                        <span name="title">님 반갑습니다.</span>
                    </div>
                    <a href="javascript:logout()" class="btnLogout"><span name="button">로그아웃</span></a>
                </div>
                <div id="leftMenuTitle" class="left-menu-title"></div>
                <!-- lnb -->
                <div class="left-menu-link">
                    <div id="sidetree">
                        <ul id="tree"></ul>
                    </div>
                </div>
                <!-- lnb -->
            </div>
        </div>
        <div class="layout-content"></div>
        <!--
        <div id="mainTabs" class="main-tabs easyui-tabs"></div>
         -->
        <!-- 상태 메세지 s -->
        <div class="layout-status">
             <dl>
                <dt name="title">상태메세지</dt>
                <dd id="page_status"></dd>
            </dl>
        </div>
        <!--// 상태 메세지 e -->
    </div>
</div>
</body>
</html>
<jsp:include page="${config.includePath}/footer.jsp"/>
