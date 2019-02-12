/***************************************************************************
 * Name     : ajax 확장 함수
 * Desc     :
 * @author  : 이경수
 * @since   : 2015.06.02
 ***************************************************************************/

/***************************************************************************
 * Name     : CommonJs.getPageSize
 * Desc     : grid 페이지 크기 설정시 쿠키에 저장된 값 반환
 * @param   : defaultSize
 *            cookieName
 * @returns : int
 * @author  : 이경수
 * @since   : 2012.09.10
 ***************************************************************************/

var cntMaxExcel     = 2500;
var cntOverExcel    = 300000;

var CommonJs = {};

CommonJs.getPageSize = function(defaultSize, cookieName) {
    try {
        var size = CommonJs.getCookie(cookieName);
        if(size) {
            size = parseInt(size);
            return size;
        }
    } catch(e) {
    }
    return defaultSize;
};

/***************************************************************************
 * Name     : doQueryDelLastPage
 * Desc     : 멀티셀렉트 그리드에서 마지막페이지 전체 선택 후
 *			  삭제시 첫 페이지를 호출 하기 위해 사용
 * @param   : gridId
 * @returns :
 * @author  : 이경수
 * @since   : 2012.10.23
 ***************************************************************************/
CommonJs.doQueryDelLastPage = function(gridId) {
    try {
        var $grid = $("#"+gridId);

        if($grid.jqGrid("getGridParam", "lastpage") == $grid.jqGrid("getGridParam", "page") && $("#cb_"+gridId).attr("checked") == "checked") {
            $grid.setGridParam({page: 1}).trigger("reloadGrid");
        } else {
            $grid.trigger("reloadGrid");
        }
    } catch(e) {
    }
};

/***************************************************************************
 * Name     : doQueryDelLastRow
 * Desc     : 멀티셀렉트 그리드에서 마지막페이지 전체 선택 후
 *			  삭제시 이전 페이지를 호출 하기 위해 사용
 * @param   : gridId
 * @returns :
 * @author  : 이경수
 * @since   : 2012.10.26
 ***************************************************************************/
CommonJs.doQueryDelLastRow = function(gridId) {
    try {
        var $grid = $("#"+gridId);

        if($grid.jqGrid("getGridParam", "lastpage") == $grid.jqGrid("getGridParam", "page") && $grid.jqGrid("getDataIDs").length <= 1 ) {
            $grid.setGridParam({page: $grid.jqGrid("getGridParam", "lastpage") - 1}).trigger("reloadGrid");
        } else {
            $grid.trigger("reloadGrid");
        }
    } catch(e) {
    }
};

CommonJs.setStatus = function(msg) {
    $("#page_status").html(msg);
};

CommonJs.clearStatus = function(msg) {
    $("#page_status").html('');
};

CommonJs.cardEnc = function(cardNo) {

    return cardNo;

};

CommonJs.htmlEnc = function(text) {

};

CommonJs.overExcelMsg = function(cnt) {

    return ksid.string.formatNumber(cntOverExcel) + " 건 이상의 자료(총 " + ksid.string.formatNumber(cnt) + " 건)입니다.<br /> 조회조건으로 더 상세히 검색해 주시기 바랍니다";

};

CommonJs.searchMsg = function(result) {

    if(result.resultCd == "00" && result.resultData.length < 1 ) {
        ksid.ui.alert("해당되는 데이터가 없습니다. ");
    }

};

CommonJs.setElementLanguage = function() {

    $("button").each(function(){

        if( ksid.json.containsKey(ksid.lan.button, $(this).text() ) == true ) {

            $(this).text( ksid.lan.button[$(this).text()] );

        }

    });

    $("span[name='title'],span[name='button']").each(function(){

        if( $(this).attr('name') == 'title' ) {

            $(this).text( ksid.lan.title[$(this).text()] );

        } else if( $(this).attr('name') == 'button' ) {

            $(this).text( ksid.lan.button[$(this).text()] );

        }

    });

    $("input,select,textarea,button,span,th,td").each(function(){

        if( $(this).attr("title") && $(this).attr("title") != "" ) {

            $(this).attr("title", ksid.lan.title[$(this).attr("title")] );

        }

    });

    $("select").each(function(){

        if( $(this).attr("overall") ) {

            if( ksid.json.containsKey(ksid.lan.overall, $(this).attr("overall")) == true ) {
                $(this).attr("overall", ksid.lan.overall[$(this).attr("overall")] );
            }

        }

    });

    $("dt[name='title']").each(function(){

        $(this).text( ksid.lan.title[$(this).text()] );

    });

};

CommonJs.getMenuLanguage = function(asMenuNm) {

    return ( ksid.json.containsKey( ksid.lan.menu, asMenuNm ) == true ) ? ksid.lan.menu[asMenuNm] : asMenuNm;

};

CommonJs.setMsgLanguage = function(asMsg) {

    return asMsg;//( ksid.json.containsKey( ksid.lan.msg, asMsg ) == true ) ? ksid.lan.msg[asMsg] : asMsg;

};

CommonJs.setMenuLanguage = function(asMenuNm) {

    if( ksid.language == "kr" ) {

        return asMenuNm;

    } else {

        if( asMenuNm ) {

            return ksid.lan.menu[asMenuNm];

        } else {

            $("span[name='menu']").each(function(){

                $(this).text( ksid.lan.menu[$(this).text()] );

            });

        }

    }
};

(function( $ ){

    /**
     *
     */
    $.fn.initialize = function() {

    }

    $.fn.ksid = {};
    $.fn.ksid.jqGrid = {};
    $.fn.ksid.jqGrid.pre = function(grid) {

    }
    $.fn.ksid.jqGrid.post = function(grid) {
        $.fn.ksid.jqGrid.resize(grid);
    }

    $.fn.ksid.jqGrid.resize = function(grid) {

        var gridId = $(grid).attr("id");

        if (!$.isEmptyObject(gridId)) {
            if ("false" === $("#" + gridId).attr("resize")) {
                return;
            }
            var next = $("#gbox_" + gridId).next();
            var height = 0;
            var pagerHeight = 0;
            var headerRows = $("#gbox_" + gridId + " [role=rowheader]").length;
            var footerHeight = $("#gbox_" + gridId + " .ui-jqgrid-sdiv").height();

            if (undefined === footerHeight) {
                footerHeight = 0;
            };

            if ($(next).hasClass("pager")) {
                next = $(next).next();
                pagerHeight = 10 + 18;
            }

            if (next.length > 0) {
                height = next.offset().top - $("#gbox_" + gridId).offset().top - 43 - pagerHeight;
                height = height - (22 * (headerRows - 1)) - footerHeight;
                $("#" + gridId).setGridHeight(height, true);
            } else {
                var dialog = $(grid).parents(".dialog");
                var easyuiTabs = $(grid).parents(".easyui-tabs");

                if (dialog.length > 0) {
                    height = $("div.dialog.panel-body").height() - $("#gbox_" + gridId).position().top - pagerHeight;
                    height = height - (22 * (headerRows - 1)) - footerHeight;
                    $("#" + gridId).setGridHeight(height, true);
                } else if (easyuiTabs.length > 0) {
                    if (headerRows > 1 && !$("#gbox_" + gridId + " .ui-jqgrid-bdiv").hasClass("[class^='grid-header-rows']")) {
                        $("#gbox_" + gridId + " .ui-jqgrid-bdiv").addClass("grid-header-rows" + headerRows)
                    }
                } else {
                    next = $(".layout-status");

                    if (next.length > 0) {
                        height = next.offset().top - $("#gbox_" + gridId).offset().top - 43 - pagerHeight;
                        height = height - (22 * (headerRows - 1)) - footerHeight;
                        $("#" + gridId).setGridHeight(height, true);
                    }
                }
            }
        }

    }
    $.fn.ksid.tabs = {};
    $.fn.ksid.tabs.pre = function(tabs) {

    }
    $.fn.ksid.tabs.post = function(tabs) {
        $.fn.ksid.tabs.resize(tabs);
    }

    $.fn.ksid.tabs.resize = function(tabs) {
        var tabsId = $(tabs).attr("id");

        if (!$.isEmptyObject(tabsId)) {
            if ("false" === $("#" + tabsId).attr("resize")) {
                return;
            }
            var next = $("#" + tabsId).next();
            var height = 0;

            if (next.length > 0) {
                height = next.offset().top - $("#" + tabsId).offset().top - 43;
                //height = next.offset().top - $("#" + tabsId).offset().top - $("#" + tabsId).position().top - 43 - 29;
            } else {
                var dialog = $(tabs).parents(".dialog");

                if (dialog.length > 0) {
                    height = $("div.dialog.panel-body").height() - $("#" + tabsId).position().top;
                } else {
                    next = $(".layout-status");
                    height = next.offset().top - $("#" + tabsId).offset().top - 43;
                    //height = next.offset().top - $("#" + tabsId).offset().top - $("#" + tabsId).position().top - 43 - 29;
                }
            }

            //console.log("-------------height::", height);

            $("#" + tabsId).find(".tabs-panels").css('height', height);
        }
    }

    $(window).resize(function() {
        $.map($("div.easyui-tabs:visible"), function(tabs) {
            $.fn.ksid.tabs.resize(tabs);
        });
        $.map($("table.ui-jqgrid-btable:visible"), function(grid) {
            $.fn.ksid.jqGrid.resize(grid);
        });
    });

    var oriJqGrid = $.fn.jqGrid;

    var binder = function(pin) {
        $.fn.jqGrid = oriJqGrid;
        if ("string" !== typeof pin) {
            $.fn.ksid.jqGrid.pre(this);
        }
        var obj = $.fn.jqGrid.apply(this, arguments);
        if ("string" !== typeof pin) {
            $.fn.ksid.jqGrid.post(this);
        } else {
            if ("setGroupHeaders" == pin) {
                $.fn.ksid.jqGrid.post(this);
            }
        }
        $.fn.jqGrid = binder;

        return obj;
    }

    $.fn.jqGrid = binder;

    var oriTabs = $.fn.tabs;

    var tabBinder = function(options, param) {
        $.fn.tabs = oriTabs;
        if ("string" !== typeof options) {
            $.fn.ksid.tabs.pre(this);
        }
        var obj = $.fn.tabs.apply(this, arguments);
        if ("string" !== typeof options) {
            $.fn.ksid.tabs.post(this);
        }
        $.fn.tabs = tabBinder;

        return obj;
    }

    $.fn.tabs = tabBinder;

    /*
    $.extend($.fn.tabs.defaults, {
        onSelect : function(title, index) {
            alert(title);
        }
    });
    */

/*
    var binder = function(pin) {
       $.fn.jqGrid = oriJqGrid;

       var obj = $.fn.jqGrid.apply(this, arguments);
       $.fn.jqGrid = binder;
       alert(pin);

       return obj;
    }

    $.fn.jqGrid = binder;*/

    /*
    var oriAppend = $.fn.append;

    $.fn.append = function () {
        return oriAppend.apply(this, arguments).trigger("append");
    };
    */

})( jQuery );


/*****************************************************
 * 함수명 : ready
 * 설명   : onload 함수
 *****************************************************/
$(document).ready(function() {

    if (true) {
        //return;
    }

    try {
        $.datepicker.setDefaults({
            dateFormat: 'yy-mm-dd',
            prevText: '이전 달',
            nextText: '다음 달',
            monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
            monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
            dayNames: ['일', '월', '화', '수', '목', '금', '토'],
            dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
            dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
            showMonthAfterYear: true,
            yearSuffix: '년'
        });


        $(".select2-selection--single").select2();

        $(document).css("body", "{'overflow-y':'scroll'}");

        //CommonJs.setElementLanguage();
        //CommonJs.setMenuLanguage();

        $(".contents-wrap").height($(window).height());

    } catch(e){}

    try {
        //각 element의 option 적용
        $("div[id$='-panel']").each(function() {
            ksid.form.applyFieldOption($(this).attr("id"), contextPath);
        });
    } catch (e) {
        // TODO: handle exception
    }

    /* 공통팝업창 존재시 esc 키 누를때 공통팝업창 닫기 */
    $(document).keyup(function(e) {
        if (e.keyCode == 27) {
           if(typeof(go_dialog_comm) != "undefined") {
               e.preventEvent();
               go_dialog_comm.close();
           }
        }
    });

});
