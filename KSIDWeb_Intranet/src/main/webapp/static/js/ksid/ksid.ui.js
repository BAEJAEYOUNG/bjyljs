/****************************************************************
    설명:  ksid namespace

    수정일         수정자        수정내용
    ------------------------------------------------------
    2015-01-14     배재영        초기작성
    ------------------------------------------------------
****************************************************************/

/**
 * ksid namespace
 */


ksid.ui = {};


ksid.ui.popMessage = function (errorMessage) {
    var strHtml = '<div id="popup"'
                + '     class="ui-loader ui-overlay-shadow ui-body-a ui-corner-all"'
                + '     style="width: 300px; text-align: center;">'
                + ' <h3 style="padding: 10px;">' + errorMessage + '</h3>'
                + '</div>';

    $(strHtml).css({
        "display": "block",
        "opacity": 0.96,
        "left": $(window).scrollLeft() + ($(window).width() / 2) - 150,
        "top": $(window).scrollTop() + ($(window).height() * 0.5)
    }).appendTo('body').delay(1000).fadeOut(800,
            function () {
                $(this).remove();
            });
};
// confirm 메시지 박스 띄우기
ksid.ui.showQMsg = function (msg, callbackFunc) {
    $.msgBox({
        title: "메시지",
        content: msg,
        type: "confirm",
        buttons: [{
            value: "예"
        }, {
            value: "아니요"
        }],
        success: callbackFunc
    });
};

/***************************************************************************
 * Name     : ksid.ui.buildDatePicker
 * Desc     : DatePicker 생성
 * @param   : el - input tag object or id
 * @returns : void
 * @author  : 배재영
 * @since   : 2012.09.10
 ***************************************************************************/
ksid.ui.buildDatePicker = function(el) {
    if(!el) {
        return;
    }
    var el = typeof(el) == "string" ? document.getElementById(el) : el;
    var focusListener = function() {
        el.value = el.value.split("-").join("");
        el.select();
    };
    var blurListener = function() {
        if(ksid.date.isDate(el.value)) {
            var value = el.value.split("-").join("");
            el.value = value.substring(0,4) + "-" + value.substring(4,6) + "-" + value.substring(6,8);
        }
    };
    $(el).bind("focus", focusListener);
    $(el).bind("blur", blurListener);

    $.datepicker.setDefaults($.datepicker.regional['ko']);
    $(el).datepicker({
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        showOn: "button",
        buttonImage: "/resources/_img/common/btn_calendar.gif",
//      buttonImage: "/resources/images/btn_calendar.gif",
        buttonImageOnly: true,
        autoSize: true,
        dateFormat: 'yy-mm-dd'  //기본 포멧
    });
};

ksid.ui.buildDatePickerMonth = function(el) {
    if(!el) {
        return;
    }
    var el = typeof(el) == "string" ? document.getElementById(el) : el;
    var focusListener = function() {
        el.value = el.value.split("-").join("");
        el.select();
    };
    var blurListener = function() {
        if(ksid.date.isDate(el.value)) {
            var value = el.value.split("-").join("");
            el.value = value.substring(0,4)+ value.substring(4,6);
        }
    };
    $(el).bind("focus", focusListener);
    $(el).bind("blur", blurListener);

    $.datepicker.setDefaults($.datepicker.regional['ko']);
    $(el).datepicker({
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        showOn: "button",
        buttonImage: "/resources/images/btn_calendar.gif",
        buttonImageOnly: true,
        autoSize: true,
        dateFormat: 'yymm'  //기본 포멧
    });
};


/***************************************************************************
 * Name     : ksid.ui.openWindow
 * Desc     : window popup
 * @param   : url
 *            name
 *            width
 *            height
 *            opts - option object
 * @returns : void
 * @author  : 배재영
 * @since   : 2012.09.10
 ***************************************************************************/
ksid.ui.openWindow = function(url, name, width, height, opts) {
    //open 시 기본옵션
    var options = {toolbar:0, directories:0, status:0, menubar:0, scrollbars:0, resizable:1};

    options.width = width;
    options.height = height;

    //수정옵션이 존재하면 처리
    if(opts) {
        //기본옵션에 신규옵션 설정
        for(var opt in opts) {
            options[opt] = opts[opt];
        }
    }

    // top 이 지정되지 않았으면 센터
    if(!options.top) {
        options.top = $(window).height()/2 - height/2;
    }

    //left 이 지정되지 않았으면 센터
    if(!options.left) {
        options.left = $(window).width()/2 - width/2;
    }

    //최종옵션문자열 생성
    var strOpts = "";
    for(var opt in options) {
        if(options[opt] != null) {
            strOpts += opt+"="+options[opt]+",";
        }
    }
    strOpts = strOpts.substring(0, strOpts.length-1);
//    alert(strOpts);
    return window.open(url, name, strOpts);
};

/***************************************************************************
 * Name     : ksid.ui.Progressbar
 * Desc     : progress bar
 * @param   :
 * @returns :
 * @author  : 배재영
 * @since   : 2012.09.10
 ***************************************************************************/
ksid.ui.Progressbar = {
        timer: null,
        interval:100,
        bar:0,
        dialog:null,
        progressbar:null,
        start: function(progressbar, dialog) {
            if(this.progressbar == null) {
                this.progressbar = $( progressbar );
                this.progressbar.progressbar({ value: 0 });
            }
            if(this.dialog == null && dialog) {
                this.dialog = $(dialog);
                dialog.dialog({
                    disabled: false,
                    autoOpen: false,     // 다이얼로그 창이 자동으로 보이게 하는지의 여부 설정.
                    closeOnEscape: false,    // ESC키를 눌렀을때 다이얼로그 박스를 닫을것인지의 설정. 설정하지않으면 기본 true로써 닫히게된다.
                    height: 60,    // 창의 높이 설정. 기본 auto.
                    width: 300,    // 창의 넓이 설정. 기본 auto.
                    modal: true,     // 모달창으로서 사용할지의 여부 설정. 마스크레이어가 자동 설정된다.
                    resizable: false,    // 리사이징 가능 여부.
//                  show: "slide",     // 창을 오픈할때의 효과 지정. 여러가지 효과를 지정할 수 있다.
//                  hide: "slide",     // 다이얼로그가 닫길때의 효과 설정.
                    stack: false     // 여러개의 창을 띄울때 마지막에 띄운 창이 다른 창위에 쌓여서 보이게 할지의 여부 설정.
                }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();
            }
            if(this.timer != null) {
                clearInterval(this.timer);
            }
            this.timer = setInterval(function() {
                ksid.ui.Progressbar.bar += 2;

                if(ksid.ui.Progressbar.bar > 0) {
                    ksid.ui.Progressbar.bar = ksid.ui.Progressbar.bar%100;
                }
                $(progressbar).progressbar("value", ksid.ui.Progressbar.bar);
            }, this.interval);
            if(this.dialog != null) {
                this.dialog.dialog("open");
            }
        },
        stop:function() {
            if(this.timer != null) {
                clearInterval(this.timer);
            }
            if(this.dialog != null) {
                this.dialog.dialog("close");
            }
        }
};


/***************************************************************************
 * Name     : ksid.ui.getLayoutOptions
 * Desc     : UI.layout 의 기본옵션에 추가옵션 설정하여 반환
 * @param   : options - layout options
 * @returns : new options
 * @author  : 배재영
 * @since   : 2012.09.10
 ***************************************************************************/
ksid.ui.getLayoutOptions = function(options) {
    var opts = {
            applyDemoStyles: false,
            size: "auto", // 각 영역(pane) 사이즈 : auto(컨텐츠 자동 맞춤)
            north__size: "65",
            east__size: "0",
//          west__size: "150",
             south__size: "0",
             spacing_open: 0, // 각 RESIZER-BARS 오픈 상태 사이즈
             spacing_closed: 0,  // 각 RESIZER-BARS 닫힘 상태 사이즈
             west__spacing_open: 10,  // 왼편(west) RESIZER-BARS 오픈 상태 사이즈 재정의
             west__spacing_closed: 6,  // 왼편(west) RESIZER-BARS 닫힘 상태 사이즈 재정의
             togglerLength_open: 80,    // WIDTH of toggler on north/south edges - HEIGHT on east/west edges
             togglerLength_closed: "100%", // "100%" OR -1 = full height
             north__resizable: false,
             north__closable: false,
             west__resizable: true,
             west__closable: true,
             center__resizable:true,
             center__closable: false
//          showErrorMessages:  false
//          center__onresize: "innerLayout.resizeAll"
//          , center: {
//              onresize: function() {
//                  //$("#list1").setGridWidth($(".ui-layout-center").width());
//              }
//          }
    };

    if(options) {
        for(opt in options) {
            opts[opt] = options[opt];
        }
    }
    return opts;
};

/***************************************************************************
 * Name     : ksid.ui.buildLayout
 * Desc     : 화면 공통 UI.layout을 설정
 * @param   : options - layout options
 * @returns : void
 * @author  : 배재영
 * @since   : 2012.09.10
 ***************************************************************************/
ksid.ui.buildLayout = function(options) {
    var layout = $('body').layout(ksid.ui.getLayoutOptions(options));
//  var tit = $(".lmenu_close");
//  if(tit.get(0)) {
//      layout.addPinBtn(tit, "west");
//  }
//  $(".ui-layout-toggler-west-open").css("background-color", "#483d8b");
    $(".ui-layout-west").css("border-top", "1px solid #d4d4d4");
    $(".ui-layout-west").css("border-right", "1px solid #d4d4d4");
    $(".ui-layout-east").css("border-top", "1px solid #d4d4d4");
    $(".ui-layout-east").css("border-left", "1px solid #d4d4d4");
    $(".ui-layout-center").css("border-left", "1px solid #d4d4d4");
    $(".ui-layout-center").css("border-right", "1px solid #d4d4d4");
    $(".ui-layout-center").css("border-top", "1px solid #d4d4d4");
//  layout.hide("east");
    layout.hide("south");
    //.sizePane("west", 150)
    return layout;
};

/***************************************************************************
 * Function Name : getTabIndex
 * Description : 탭 index 가져오기
 * parameters :
 * return : tab index
 ***************************************************************************/
ksid.ui.getTabIndex = function(tabsId, srcId) {
    var index=-1;
    var i = 0, tbH = $(tabsId).find("li a");
    var lntb=tbH.length;

    if(lntb>0){
        for(i=0;i<lntb;i++){
            o=tbH[i];
            if(o.href.search(srcId)>0){
                index=i;
            }
        }
    }

    return index;
};

/***************************************************************************
 * Function Name : closeTab
 * Description : 탭 닫기
 * parameters :
 * return :
 ***************************************************************************/
ksid.ui.closeTab = function () {
//  $('#hdnActiveId').val(menuCode);
    var tabId = parent.document.getElementById("hdnActiveId").value;
//  var parentSrc = parent.document.getElementById(activeId).src;
//  var parentSrc = parent.document.getElementById(window.name).src;
//  var pos1 = parentSrc.lastIndexOf("/")+1;
//  var pos2 = parentSrc.length;

//  var tabId = parentSrc.substr(pos1, pos2);

    parent.Tabs_Del(tabId);
};



/**
 * @package : resources/js/ksid/ksid.ui.js
 * @author : ksid-BJY
 * @dage : 2015. 8. 4. 오후 1:35:12
 * @method : ksid.ui.alert
 * @param content
 * @사용법 : ksid.ui.alert("메세지");
 * @주의사항 :
 */
ksid.ui.alert = function( content, callbackFunc ) {

//    alert(content.replace(/<br\s*[\/]?>/gi, "\n").replace(/(<([^>]+)>)/gi, ""));
//    if(typeof callbackFunc == "function") {
//        callbackFunc();
//    }
    $.alert(content, callbackFunc);

};

/***************************************************************************
 * Function Name : jAlert
 * Description : jquery ui 의 massage 창
 * parameters : title, content
 * return :
 ***************************************************************************/
ksid.ui.jAlert = function (title, content, callback, h) {

    var jTitle      = ksid.localization.string(title);
    var jContent    = ksid.localization.string(content);

    var sConf       = ksid.localization.string("확인");

    $( ".dialog:ui-dialog" ).dialog( "destroy" );

    $("<div class='dialog' title='"+jTitle+"'>"+
            "<span class='ui-icon ui-icon-circle-check' style='float:left; margin:0 7px 50px 0;'></span>"+
            jContent+"</div>").dialog({
        modal: true,
        width: 400,
        minHeight: 200,
        height: h,
        buttons: {
            "OK": function() {
                $( this ).dialog( "close" );

                if(callback) {
                    callback();
                }
            }
        }
    });

};

/**  **/
ksid.ui.confirm = function( content, callbackConfirm, callbackCancel, h) {

    $.confirm(content, function( bOk ){

        if(bOk) {
            if(callbackConfirm) {
                callbackConfirm();
            }
        } else {
            if(callbackCancel) {
                callbackCancel();
            }
        }

    });

//    if( confirm(content.replace(/<br\s*[\/]?>/gi, "\n")) == true ) {
//
//        if(typeof callbackConfirm == "function") {
//            callbackConfirm();
//        }
//
//    } else {
//
//        if(typeof callbackCancel == "function") {
//            callbackCancel();
//        }
//
//    }

//    ksid.ui.jConfirm('Confirm', content, callbackConfirm, callbackCancel);

};


/***************************************************************************
 * Function Name : jConfirm
 * Description : jquery ui 의 massage 창
 * parameters : title, content
 * return :
 ***************************************************************************/
ksid.ui.jConfirm = function (title, content, callbackConfirm, callbackCancel, h) {
    if( typeof callbackCancel == "number" ) {
        h = callbackCancel;
    }

    $( ".dialog:ui-dialog" ).dialog( "destroy" );

    $("<div class='dialog' title='"+title+"'>"+
            "<span class='ui-icon ui-icon-circle-check' style='float:left; margin:0 7px 50px 0;'></span>"+
            content+"</div>").dialog({
                modal: true,
                minHeight: 200,
                width: 500,
                height: h,
                buttons: {
                    "OK" : function() {
                        $( this ).dialog( "close" );
                        if(callbackConfirm) {
                            callbackConfirm();
                        }
                    },
                    "CANCEL": function() {
                        $( this ).dialog( "close" );
                        if(callbackCancel) {
                            callbackCancel();
                        }
                    }
                }
            });

};

/***************************************************************************
 * Function Name : bindCombo
 * Description : combo와 json Array bind
 *              combo element에 json형태의 arryay를 옵션으로 생성한다.
 *              combo의 attribute에 overall로 문자를 추가하면 overall이 ""값으로 추가됨
 *              combo의 attribute에 selected_value로 값을 지정하면 해당 값 selected
 * parameters : comboElement, jsonArray [{code_id: "", codeNm: ""}]
 * return :
 ***************************************************************************/
ksid.ui.bindCombo = function(combo, optionList, textonly) {

    //console.log('$(combo).attr("codeGroupCd")', $(combo).attr("codeGroupCd"));


    if( $(combo).attr("codeGroupCd") == "year" ) {
        optionList = ksid.json.cloneObject(yearList);
        textonly = true;
    } else if( $(combo).attr("codeGroupCd") == "yyyy_mm" ) {
        optionList = ksid.json.cloneObject(ymList);
        textonly = true;
    } else  if( $(combo).attr("codeGroupCd") == "sQuarter" ) {
        optionList = ksid.json.cloneObject(sQuarterDtList);
        textonly = true;
    } else  if( $(combo).attr("codeGroupCd") == "eQuarter" ) {
        optionList = ksid.json.cloneObject(eQuarterDtList);
        textonly = true;
    }

    //옵션추가전 기존설정된 옵션삭제
    $(combo).find("option").remove();

    //기본옵션이 존재하면 첫번째에 옵션추가
    var overall = $(combo).attr("overall");
    if(overall) {
        $(combo).append("<option value=''>" + overall + "</option>");
    }
    var selectedValue = $(combo).attr("selected_value");

    //option 추가
    for(var i = 0; i < optionList.length; i++) {
        var option = optionList[i];
//      alert( selectedValue + ' == ' + option.codeCd );
        var selected = (selectedValue == option.codeCd) ? "selected" : "";
        var selectText = (textonly == true) ? option.codeNm : (option.codeNm == null) ? option.codeCd : option.codeNm; //option.codeCd + " - " + option.codeNm;
        $(combo).append("<option value='" + option.codeCd + "' " + selected + "> " + selectText + "</option>");
    }

    //선택된 옵션이 없고 overall이 존재하면 overall선택
    if( !selectedValue && overall ) {
        $(combo).val("");
    }

    //숨김옵션값이 존재하면 해당 option들 숨김처리
    var hideOpts = $(combo).attr("hide_opts");
    if(hideOpts) {
        var hideValues = hideOpts.split(',');
        for ( var i = 0; i < hideValues.length; i++) {
            $(combo).find("option[value='" + hideValues[i] + "']").remove();
        }
    }

};

var spinnerVisible = false;
function showProgress() {
    if($("#loadingSpinner").length < 1)
        $("body").append('<div id="loadingSpinner"></div>');
    if (!spinnerVisible) {
        $("div#loadingSpinner").fadeIn("fast");
        spinnerVisible = true;
    }
};
function hideProgress() {
    if (spinnerVisible) {
        var spinner = $("div#loadingSpinner");
//       spinner.stop();
        spinner.fadeOut("fast");
        spinnerVisible = false;
    }
};

/***************************************************************************
 * Function Name : dialogHandler
 * Description : dialogi, height, width로 생성
 * 포함 method : popup() 팝업 open
 *               closePopup() 팝업 close
 *               setForm(form) action(팝업화면url)을 포함한 폼 설정
 *               setUrl(url) url(팝업화면url) 설정
 * parameters : dialogId, height, width
 * return :
 ***************************************************************************/
var dialogHandler = function (dialogId, option){
    this.dialogId = dialogId;
    this.dialog = document.getElementById(dialogId);
    this.queryForm = null;
    this.queryUrl = null;

    /** 팝업 open **/
    this.popup = function(){

        /** 팝업 리스너 생성 **/
        $(this.dialog).dialog(option);

        if(this.queryForm != null){
            var target = "iframe"+this.dialogId;
            var html = '<iframe name="'+target+'" style="min-width:100px !important; width:100%; height:100%;" frameborder=0 ></iframe>';
            this.dialog.innerHTML = html;
            this.queryForm.target = target;
            this.queryForm.submit();
        }else if(this.queryUrl != null){
            var html = '<iframe src="'+this.queryUrl+'" style="min-width:100px !important;width:100%; height:100%;" frameborder=0></iframe>';
            this.dialog.innerHTML = html;

        }else{
//          alert('호출 할 소스에 대한 설정이 없습니다.');
            return;
        }

        //$( "#popup:ui-dialog" ).dialog( "destroy" );
        $(this.dialog).dialog( "open" );
        $(".ui-dialog-titlebar").addClass("pop_head");
    };

    /** form 설정 action(팝업화면url) 설정된 폼 사용해야 함 **/
    this.setForm = function (form){
        this.queryForm = form;
    };

    /** url(팝업화면url) 설정 **/
    this.setUrl = function (url){
        this.queryUrl = url;
    };

    /** 팝업 close **/
    this.closePopup = function (){
        $(this.dialog).dialog("close");
    };


};