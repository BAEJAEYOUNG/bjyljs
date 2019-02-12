/****************************************************************
0    파일명: ksid.form.js
    설명:  ksid form js

    수정일         수정자        수정내용
    ------------------------------------------------------
    2015-01-15     배재영        초기작성
    ------------------------------------------------------
****************************************************************/

// ksid form namespace
ksid.form = {};

/***************************************************************************
 * Function Name : flushPanel
 * Description : panelId안의 데이터를 json 형태로 반환
 * parameters : panelId
 * return : jsonData
 ***************************************************************************/
/**
 * 특정 form wrapper html element 내의 모든 input, select, textarea 엘리먼트의 name 과 value 를 lo_return object 에 담아서 return
 *
 * 사용법 : var lo_data = ksid.form.serialize_object('#top_search');
**/
ksid.form.flushPanel = function(panelId) {
    panelId = "#" + ksid.string.ltrim(panelId, "#");
    var jsonData = {};

    $(panelId + " input," + panelId + " select," + panelId + " textarea," + panelId + " span," + panelId + " th," + panelId + " td").each(function () {

        if($(this).attr("name")) {

            switch ($(this).prop("tagName").toUpperCase()) {
            case "INPUT":
                switch ($(this).attr("type").toUpperCase()) {
                    case "BUTTON":
                        break;
                    case "RADIO":
                        if ($(this).is(":checked")) {
                            jsonData[$(this).attr("name")] = $(this).val();
                        } else {
                            if(!jsonData[$(this).attr("name")]) {
                                jsonData[$(this).attr("name")] = "";
                            }
                        }
                        break;
                    case "CHECKBOX":
                        if ($(this).is(":checked")) {
                            if (ksid.json.containsKey(jsonData, $(this).attr("name")) == true) {
                                if( jsonData[$(this).attr("name")] != "" ) {
                                    jsonData[$(this).attr("name")] += ",";
                                }
                                jsonData[$(this).attr("name")] += $(this).val();
                            } else {
                                jsonData[$(this).attr("name")] = $(this).val();
                            }
                        } else {
                            // 단일 혹은 그룹체크에서 모두 체크가 안되었을경우 jsonData 에 항목이 누락되는걸 방지하기 위
                            if(!jsonData[$(this).attr("name")]) {
                                jsonData[$(this).attr("name")] = "";
                            }
                        }
                        break;
                    default:    // TEXT , HIDDEN , PASSWORD , BUTTON
                        switch ($(this).attr("format")) {
                            case "rate":
                                jsonData[$(this).attr("name")] = ksid.string.formatRate($(this).val());
                                break;
                            case "money":
                            case "number":
                                jsonData[$(this).attr("name")] = ksid.number.toNumber($(this).val());
                                break;
                            case "no":
                            case "tel_no":
                            case "biz_no":
                            case "zip_no":
                            case "card_no":
                            case "date":
                            case "ym":
                                jsonData[$(this).attr("name")] = ksid.string.forceNumber($(this).val());
                                break;
                            default:
                                jsonData[$(this).attr("name")] = ksid.string.htmlEnc($(this).val());
                                break;
                        }
                        break;
                }
                break;
            case "SELECT":
                jsonData[$(this).attr("name")] = $(this).val();
                break;
            case "TEXTAREA":
                jsonData[$(this).attr("name")] = ksid.string.htmlEnc($(this).val());
                break;
            case "SPAN":
            case "TH":
            case "TD":
                if (typeof ($(this).attr("name")) != "undefined") {
                    jsonData[$(this).attr("name")] = $(this).text();
                }
                break;
        }

        }

    });

    return jsonData;
};

/***************************************************************************
 * Function Name : bindPanel
 * Description : panelId안의 필드에 jsonData bind
 * parameters : panelId
 * 				jsonData
 * return :
 ***************************************************************************/
ksid.form.bindPanel = function(panelId, jsonData) {
    panelId = "#" + ksid.string.ltrim(panelId, "#");
    $(panelId + " input," + panelId + " textarea," + panelId + " select," + panelId + " span," + panelId + " td," + panelId + " th").each(function () {
        for(var key in jsonData) {
            if($(this).attr("name") == key.toLowerCase() || $(this).attr("name") == key) {
                switch ($(this).prop("tagName").toUpperCase()) {
                case "INPUT":
                    switch ($(this).attr("type").toUpperCase()) {
                        case "RADIO":
                            var lsVal = jsonData[key];
                            if (lsVal != "") {
                                $(panelId + " input:radio[name=" + key + "]:radio[value='" + jsonData[key] + "']").prop("checked", true);
                            }
                            break;
                        case "CHECKBOX":
                            $("input[name='"+$(this).attr("name")+"']").each(function () {
                                $(this).attr("checked", false);
                            });
                            var lsVal = jsonData[key];
                            if (lsVal) {
                                var lsrVal = lsVal.split(",");
                                for (var i = 0; i < lsrVal.length; i++) {
                                    $("input[name='"+$(this).attr("name")+"']").each(function () {
                                        if ($(this).val() == lsrVal[i]) {
                                            $(this).prop("checked", true);
                                        }
                                    });
                                }
                            }
                            break;
                        case "TEXT":
                            ksid.form.setElementByFormat($(this), jsonData[key]);
                            break;
                        default:
                            $(this).val(jsonData[key]);
                            break;
                    }
                    break;
                case "SELECT":
                    switch ($(this).attr("format")) {
                        case "ym":
                            $(this).val(ksid.string.forceNumber(jsonData[key])).trigger('change');
                            break;
                        default:
                            $(this).val(jsonData[key]).trigger('change');
                            break;
                    }
                case "TEXTAREA":
                    $(this).val(jsonData[key]);
                    break;
                case "SPAN":
                case "TH":
                case "TD":
                    ksid.form.setElementByFormatText($(this), jsonData[key]);
                    break;
                }
            }
        }
    });

};

// element format 에 따은 형식 값 세팅
ksid.form.setElementByFormat = function( jElem, value ) {

    switch (jElem.attr("format")) {
        case "rate": // 백분율 ( 100.00 )
            jElem.val(ksid.string.formatRate(value));
            break;
        case "money": // 통화 ( 123,456,788 )
            jElem.val(ksid.string.formatNumber(value));
            break;
        case "date": // 달력
            jElem.val(ksid.string.formatDate(value));
            break;
        case "ym": // 년월 ( yyyy-mm )
            jElem.val(ksid.string.formatYm(value));
            break;
        case "dttm": // 일시 (yyyy-mm-dd hh:mi:ss)
            jElem.val(ksid.string.formatDttm(value));
            break;
        case "number":
            jElem.val(ksid.number.toNumber(value));
            break;
        case "no":
            jElem.val(ksid.string.forceNumber(value));
            break;
        case "tel_no":
            jElem.val(ksid.string.formatTelNo(value));
            break;
        case "biz_no":
            jElem.val(ksid.string.formatBizNo(value));
            break;
        case "zip_no":
            jElem.val(ksid.string.formatZipNo(value));
            break;
        case "card_no":
            jElem.val(ksid.string.formatCardNo(value));
            break;
        default:
            jElem.val(value);
            break;
    }

};

//element format 에 따은 형식 값 세팅
ksid.form.setElementByFormatText = function( jElem, value ) {

    switch (jElem.attr("format")) {
        case "rate": // 백분율 ( 100.00 )
            jElem.text(ksid.string.formatRate(value));
            break;
        case "money": // 통화 ( 123,456,788 )
            jElem.text(ksid.string.formatNumber(value));
            break;
        case "date": // 달력
            jElem.text(ksid.string.formatDate(value));
            break;
        case "ym": // 년월 ( yyyy-mm )
            jElem.text(ksid.string.formatYm(value));
            break;
        case "dttm": //
            jElem.text(ksid.string.formatDttm(value));
            break;
        case "number":
            jElem.text(ksid.number.toNumber(value));
            break;
        case "no":
            jElem.text(ksid.string.forceNumber(value));
            break;
        case "tel_no":
            jElem.text(ksid.string.formatTelNo(value));
            break;
        case "biz_no":
            jElem.text(ksid.string.formatBizNo(value));
            break;
        case "zip_no":
            jElem.text(ksid.string.formatZipNo(value));
            break;
        case "card_no":
            jElem.text(ksid.string.formatCardNo(value));
            break;
        default:
            jElem.text(value);
            break;
    }

};

//I(기본스타일), U(반대)
//<input type="text" modestyle="enable|disable|show|hide" />
ksid.form.applyModeStyle = function(panelId, mode) {

    panelId = "#" + ksid.string.ltrim(panelId, "#");

    $(panelId + " input," + panelId + " textarea," + panelId + " select," + panelId + " button").each(function () {

        if( $(this).attr("modestyle") ) {

            var modeStyle = $(this).attr("modestyle");

            if(mode == "U") {

                if(modeStyle == "enable") {
                    $(this).attr("disabled",true);
                } else if(modeStyle == "disable") {
                    $(this).attr("disabled",false);
                } else if(modeStyle == "show") {
                    $(this).hide();
                } else if(modeStyle == "hide") {
                    $(this).show();
                }

            } else {

                if(modeStyle == "enable") {
                    $(this).attr("disabled",false);
                } else if(modeStyle == "disable") {
                    $(this).attr("disabled",true);
                } else if(modeStyle == "show") {
                    $(this).show();
                } else if(modeStyle == "hide") {
                    $(this).hide();
                }

            }

        }

    });

};

//alert("ksid.form.applyFieldOption");
var applyFieldOptionClickDate;
/***************************************************************************
 * Function Name : applyFieldOption
 * Description : field의 옵션 적용
 * parameters : panelId
 * return :
 ***************************************************************************/
ksid.form.applyFieldOption = function(panelId, contextRoot) {
    panelId = "#" + ksid.string.ltrim(panelId, "#");

//	$(panelId + " input[type=text]").bind("change paste keyup", function () {
//        $(this).attr("title", $(this).val());
//    });
    $(panelId + " input[type=text]").focusin(function () {
        if (!($(this).attr("readonly") == "readonly" || $(this).attr("readonly") == true)) {
            $(this).select();
        }
    });

    $(panelId + " select").each(function () {

        if( typeof( $(this).attr("to") ) != "undefined" ) {
            $(this).change(function() {
                var pVal = ksid.number.toNumber($(this).next().find('.select2-selection__rendered').text());
                var ls_date_from    = $(this).val();
                var ls_date_to      = $(panelId + " *[name=" + $(this).attr("to") + "]").val();
                if( ls_date_from.length < 6 || ls_date_to < 6) return;
                var li_date_from = ksid.number.toNumber(ls_date_from);
                var li_date_to = ksid.number.toNumber(ls_date_to);

                if( li_date_from > li_date_to ) {
                    alert( "조회시작은 조회종료 보다 작거나 같아야 합니다." );
                    $(this).val(pVal).trigger('change');
                    return;
                }
            });
        }
        if( typeof( $(this).attr("from") ) != "undefined" ) {
            var pVal = $(this).val();
            $(this).change(function() {
                var pVal = ksid.number.toNumber($(this).next().find('.select2-selection__rendered').text());
                $(this).attr("title", $(this).datepicker("option","buttonText"));
                var ls_date_from  = $(panelId + " *[name=" + $(this).attr("from") + "]").val();
                var ls_date_to    = $(this).val();
                if( ls_date_from.length < 6 || ls_date_to < 6) return;
                var li_date_from = ksid.number.toNumber(ls_date_from);
                var li_date_to = ksid.number.toNumber(ls_date_to);

                if( li_date_from > li_date_to ) {
                    alert( "조회종료는 조회시작 보다 작거나 같아야 합니다." );
                    $(this).val(pVal).trigger('change');
                    return;
                }
            });
        }
    });

    $(panelId + " input[type=TEXT]").each(function () {
        if (typeof ($(this).attr("format")) != "undefined") {
            switch ($(this).attr("format")) {
                case "rate": // 백분율
                    $(this).css({"text-align":"right"}).number(true,2);
                    $(this).blur(function () {
                        $(this).val(ksid.string.formatRate($(this).val()));
                    });
                    break;
                case "money": // 통화
                    $(this).css({"text-align":"right"}).keyup(function () {
                        $(this).val(ksid.string.formatNumber($(this).val()));
                    }).blur(function () {
                        $(this).val(ksid.string.formatNumber($(this).val()));
                    });
                    break;
                case "number": // 숫자
                    $(this).css({"text-align":"right"}).number(true);
                    $(this).keyup(function () {
                        $(this).val(ksid.number.toNumber($(this).val()));
                    }).blur(function () {
                        $(this).val(ksid.number.toNumber($(this).val()));
                    });
                    break;
                case "no": // 모든숫자
                    $(this).css({"text-align":"center"}).keyup(function () {
                        $(this).val(ksid.string.forceNumber($(this).val()));
                    }).blur(function () {
                        $(this).val(ksid.string.forceNumber($(this).val()));
                    });
                    break;
                case "tel_no": // 전화번호, 휴대폰 포함
                    $(this).keyup(function () {
                        $(this).val(ksid.string.formatTelNo($(this).val()));
                    }).blur(function () {
                        $(this).val(ksid.string.formatTelNo($(this).val()));
                    });
                    break;
                case "biz_no": // 사업자번호
                    $(this).keyup(function () {
                        $(this).val(ksid.string.formatBizNo($(this).val()));
                    }).blur(function () {
                        $(this).val(ksid.string.formatBizNo($(this).val()));
                    });
                    break;
                case "card_no": // 카드번호
                    $(this).keyup(function () {
                        $(this).val(ksid.string.formatCardNo($(this).val()));
                    }).blur(function () {
                        $(this).val(ksid.string.formatCardNo($(this).val()));
                    });
                    break;
                case "zip_no": // 우편번호
                    $(this).keyup(function () {
                        $(this).val(ksid.string.formatZipNo($(this).val()));
                    }).blur(function () {
                        $(this).val(ksid.string.formatZipNo($(this).val()));
                    });
                    break;
                case 'ym' : // 월선택
                    $(this).css({'text-align':'center'});
                    $(this).keyup(function () {
                        $(this).val(ksid.string.formatYm($(this).val()));
                    }).blur(function () {
                        $(this).val(ksid.string.formatYm($(this).val()));
                    });

                    $(this).MonthPicker({
                        Button: '<img class="icon" src="static/image/ksid/ico_cal.png" style="margin-left:3px;cursor:pointer" title="' + $(this).attr('title') + '" />'
                      , MinMonth: -10000
                      , MaxMonth: 10000
                    });
                    break;
                case "date": // 달력
                    $(this).click(function(){
                        applyFieldOptionClickDate = $(this).val();
                    });
                    var datepickerProp = {
                        showOn          : "both",
                        buttonImage     : "static/image/ksid/ico_cal.png",
                        buttonImageOnly : true,
                        changeYear      : true,
                        changeMonth     : true,
                        dateFormat      : "yy-mm-dd",
                        yearRange       : 'c-100:c+10',
                        minDate         : '-100y',
                        showAnim        : "fadeIn",
                        onSelect        : function() {$(this).change();},
                        buttonText  	: $(this).attr('title')
                    };
                    if( $(this).attr("disabled") == "disabled" ) datepickerProp.disabled = true;
                    $.datepicker.setDefaults($.datepicker.regional[ksid.language]);
                    $(this).css({"text-align":"center","width":"80px"}).attr("readonly",false).datepicker(datepickerProp).blur(function () {
                        var lsDate = ksid.string.formatDate($(this).val());
                        if(isNaN(Date.parse(lsDate)) == true || lsDate.length != 10) {
                            if( lsDate == "" ) {
                                return;
                            } else {
                                if(isNaN(Date.parse(applyFieldOptionClickDate)) == true) {
                                    $(this).val("");
                                    return;
                                } else if(applyFieldOptionClickDate.length != 10) {
                                    $(this).val("");
                                    return;
                                } else {
                                    $(this).val(applyFieldOptionClickDate).focus().select();
                                }

                            }
                        } else {
                            $(this).val(lsDate).change();
                        }
                    });
                    $(this).attr("title", $(this).datepicker("option","buttonText"));
                    if( typeof( $(this).attr("min") ) != "undefined" ) {
                        var ls_min = $(this).attr("min");
                        if( ls_min == "today" ) {
                            $(this).change(function() {
                                $(this).attr("title", $(this).datepicker("option","buttonText"));
                                var li_today = ksid.number.toNumber(new ksid.datetime().getDate("yyyymmdd"));
                                if(ksid.number.toNumber($(this).val()) < li_today) {
                                    alert($(this).datepicker("option","buttonText") + "는 오늘(" + ksid.string.formatDate(li_today) + ") 이후 날짜이어야 합니다.");
                                    $(this).val(applyFieldOptionClickDate);
                                    return;
                                }
                            });
                        }
                    }
                    if( typeof( $(this).attr("setday") ) != "undefined" ) {
                        var setDayNum = ksid.number.toNumber($(this).attr("setday"));
                        if( setDayNum == 0 ) {
                            $(this).val(new ksid.datetime().getDate("yyyy-mm-dd"));
                        } else if( setDayNum > 0 ) {
                            $(this).val(new ksid.datetime().after(0,0,setDayNum).getDate("yyyy-mm-dd"));
                        } else if( setDayNum < 0 ) {
                            $(this).val(new ksid.datetime().before(0,0,Math.abs(setDayNum)).getDate("yyyy-mm-dd"));
                        }
                    }
                    if( typeof( $(this).attr("to") ) != "undefined" ) {
                        $(this).change(function() {
                            $(this).attr("title", $(this).datepicker("option","buttonText"));
                            var ls_date_from    = $(this).val();
                            var ls_date_to      = $(panelId + " *[name=" + $(this).attr("to") + "]").val();
                            if( ls_date_from.length < 8 || ls_date_to < 8) return;
                            var li_date_from = ksid.number.toNumber(ls_date_from);
                            var li_date_to = ksid.number.toNumber(ls_date_to);

                            if( li_date_from > li_date_to ) {
                                alert( $(this).attr("title") + " 은(는) " + $(panelId + " *[name=" + $(this).attr("to") + "]").attr("title") + " 보다 작거나 같아야 합니다." );
                                $(this).val(applyFieldOptionClickDate);
                                return;
                            }
                        });
                    }
                    if( typeof( $(this).attr("from") ) != "undefined" ) {
                        $(this).change(function() {
                            $(this).attr("title", $(this).datepicker("option","buttonText"));
                            var ls_date_from  = $(panelId + " *[name=" + $(this).attr("from") + "]").val();
                            var ls_date_to    = $(this).val();
                            if( ls_date_from.length < 8 || ls_date_to < 8) return;
                            var li_date_from = ksid.number.toNumber(ls_date_from);
                            var li_date_to = ksid.number.toNumber(ls_date_to);

                            if( li_date_from > li_date_to ) {
                                alert( $(this).attr("title") + " 은(는) " + $(panelId + " *[name=" + $(this).attr("from") + "]").attr("title") + " 보다 크거나 같아야 합니다." );
                                $(this).val(applyFieldOptionClickDate);
                                return;
                            }
                        });
                    }
                    $(this).change(function(){
                        $(this).attr("title", $(this).datepicker("option","buttonText"));
                        ksid.form.nextElemnent(panelId, this);
                    });
                    break;
            }
        }
        if( typeof($(this).attr("maxlength")) != "undefined" ) {
            $(this).keyup(function () {
                ksid.form.checkMaxLength($(this));
            });
        }
    });


    /**
     * ajaxCombo 가 비동기로 데이터를 불러오기 때문에
     * 조회조건에 콤보가 있는상태에서 로딩 후 자동조회시 문제가 된다.
     * 따라서 콤보로딩시까지 page 를 block 시키고,
     * 콤보로딩 후 ComboAjaxAfterDoQuery() 함수를 페이지내에 추가하여
     * 해당함수에서 doQuery() 함수를 call 하면 처리가 원할하다.
     * 또한, 해당 콤보의 데이터 존재여부도 체크하였다.
     */

    var comboAjaxCnt       = 0;
    var totComboAjaxCnt    = 0;

    $(panelId + " select").each(function () {
        if( $(this).attr("codeGroupCd") ) {
            totComboAjaxCnt++;
        }
    });

    $(panelId + " select").each(function () {

        var codeGroupCd = $(this).attr("codeGroupCd");

        var cbName = $(this).attr("name");

        if( codeGroupCd ) {
            if( comboAjaxCnt == 0 ) {
//                $.blockUI({
//                    message: '페이지에 필요한 초기 데이터를 불러오는 중입니다.<br/>잠시만 기다려 주세요 ...',
//                    css: { "font-weight": "bold", "height": "80px", "color": "#000", "opacity": "1", "font-size": "10pt", "line-height": "1.8", "padding-top": "8px", "font-family": "굴림체" }
//                });
            }
            var params = {"codeGroupCd": codeGroupCd.toUpperCase()};

            if( $(this).attr("textonly") ) params["textonly"] = true;

            ksid.net.ajaxCombo(this, ( (contextRoot) ? contextRoot + "/" : "" ) + "/admin/system/code/comboList", params, function(result){
                  if( result.resultCd != "00" ) {
                      $.unblockUI();
                      ksid.ui.alert("select name='" + cbName + "' codeGroupCd = '" + codeGroupCd + "'" + " 의 데이터를 불러오지 못했습니다.");
                  }
                  comboAjaxCnt++;
                  if( comboAjaxCnt == totComboAjaxCnt ) {
                      $(panelId + " select").select2();
                      setTimeout('$.unblockUI()', 1000);
                          try{
                              var callFuncName = ksid.string.replace(ksid.string.replace(panelId, '-', ''), '#', '') + 'ComboAjaxAfterDoQuery()';
                              eval(callFuncName);
                          } catch(e){
                          }
                  }

            }, function(){$.unblockUI();});

        }

    });

    function callFunction() {

    }

    $(window).resize(function(){
        $(panelId + " select").select2();
    });

    $(panelId + " input").keydown(function (e) {
        if (e.keyCode == 13) {
            if (typeof ($(this).attr("command")) != "undefined") {
                e.preventDefault();
                eval($(this).attr("command"));
            } else if (typeof ($(this).attr("next")) != "undefined") {
                e.preventDefault();
                ksid.form.nextElemnent(panelId, this);
            }
        }
    });

    $(panelId + " .ui-datepicker-trigger").each(function () {
        $(this).css({ "margin-left": "3px;" });
        if ($(this).prev().attr("title") != undefined) {
            $(this).attr("alt", $(this).prev().attr("title"));
            $(this).attr("title", $(this).prev().attr("title"));
        }
    });
};

ksid.form.nextElemnent = function(panelId, elem) {

    if( $(elem).attr("next") ) {
        var nextElem = $(panelId + " *[name=" + $(elem).attr("next") + "]");
        var i = 0;
        while( ( typeof(nextElem.attr("disabled")) != "undefined" || nextElem.attr("")==true ) && i < 10 ) {
            nextElem = $(panelId + " *[name=" + nextElem.attr("next") + "]");
            i++;
        }
        nextElem.focus();
    }


};

/**
 *
 * @param as_select_id
 * @param jsonData
 * @param ao_option
 */
//ksid.form.bindSelect = function( as_select_id, jsonData, ao_option ) {
//
//    $( as_select_id + " option" ).remove();
//
//    var lo_map = null;
//    var ls_default = (ksid.json.containsKey(ao_option, "DEFAULT") == true) ? ao_option.DEFAULT : "";
//
//    if (ksid.json.containsKey(ao_option, "ITEM")) {
//        for (var i = 0; i < ao_option.ITEM.length; i++) {
//            if( typeof ao_option.ITEM[i] != "undefined" ) {
//                lo_map = ao_option.ITEM[i];
//                $(as_select_id).append('<option value="' + lo_map["VAL"] + '"' + ((lo_map["VAL"] == ls_default) ? ' selected' : '') + '>' + lo_map.TEXT + '</option>');
//            }
//        }
//    }
//
//    if( ksid.json.containsKey( ao_option, "REMOVE" ) ) {
//
//        var lb_remove = false;
//
//        if (jsonData != "" && jsonData != null) {
//            for (var i = 0; i < jsonData.length; i++) {
//                if(  jsonData[i].CODE_NM != "" && typeof jsonData[i].CODE_NM != "undefined" ) {
//                    lb_remove = false;
//                    for (var j = 0; j < ao_option.REMOVE.length; j++) {
//                        if( jsonData[i].CODE_CD == ao_option.REMOVE[j] ) {
//                            lb_remove = true;
//                            break;
//                        }
//                    }
//                    if( lb_remove == false ) {
//                        $(as_select_id).append('<option value="' + jsonData[i].CODE_CD + '"' + ((jsonData[i].CODE_CD == ls_default) ? ' selected' : '') + '>' + jsonData[i].CODE_NM + '</option>');
//                    }
//
//                }
//
//            }
//        }
//
//    } else {
//
//        if (jsonData != "" && jsonData != null) {
//            for (var i = 0; i < jsonData.length; i++) {
//                if(  jsonData[i].CODE_NM != "" && typeof jsonData[i].CODE_NM != "undefined" )
//                $(as_select_id).append("<option value='" + jsonData[i].CODE_CD + "'" + ((jsonData[i].CODE_CD == ls_default) ? " selected" : "") + ">" + jsonData[i].CODE_NM + "</option>");
//            }
//        }
//
//    }
//
//};


ksid.form.bindCheckbox = function(as_checkbox_id, jsonData, ao_option) {

    as_checkbox_id = "#" + ksid.string.ltrim(as_checkbox_id, "#");
    var ls_element_id = $(as_checkbox_id).attr("id");
    var ls_element_name = ls_element_id.substring(as_checkbox_id.indexOf("_"));
    var ls_html = "";

    $( as_checkbox_id ).html("");

    var lo_map = null;
    var ls_default = (ksid.json.containsKey(ao_option, "DEFAULT") == true) ? ao_option.DEFAULT : "";

    var ls_checkbox_title = ( ksid.json.containsKey(ao_option, "TITLE") == true ) ? ao_option.TITLE : "";

    var li_checkbox_cnt = ( ksid.json.containsKey(ao_option, "COL_CNT") == true ) ? ao_option.COL_CNT : 9999;

    var li_cnt = 0;

//    console.log('#################################################');
//    console.log('as_checkbox_id = ' + as_checkbox_id);
//    console.log('ls_element_id = ' + ls_element_id);
//    console.log('ls_element_name = ' + ls_element_name);
//    console.log(jsonData);

    if (ksid.json.containsKey(ao_option, "ITEM")) {
        for (var i = 0; i < ao_option.ITEM.length; i++) {
            if( typeof ao_option.ITEM[i] != "undefined" ) {
                lo_map = ao_option.ITEM[i];
                ls_html += ('<input type="checkbox" id="' + ls_element_id + '_' + i + '" name="' + ls_element_name + '" title="' + ls_checkbox_title + '" value="' + lo_map["VAL"] + '"' + ((lo_map["VAL"] == ls_default) ? ' checked' : '') + '/><label for="' + ls_element_id + '_' + i + '">' + lo_map.TEXT + '</label>&nbsp;');
                li_cnt++;
                if( ( li_cnt % li_checkbox_cnt ) == 0 ) ls_html += '<br />';
            }
        }
    }

    if( ksid.json.containsKey( ao_option, "REMOVE" ) ) {

        var lb_remove = false;

        if (jsonData != "" && jsonData != null) {
            for (var i = 0; i < jsonData.length; i++) {
                if(  jsonData[i].codeNm != "" && typeof jsonData[i].codeNm != "undefined" ) {
                    lb_remove = false;
                    for (var j = 0; j < ao_option.REMOVE.length; j++) {
                        if( jsonData[i].codeCd == ao_option.REMOVE[j] ) {
                            lb_remove = true;
                            break;
                        }
                    }
                    if( lb_remove == false ) {
                        ls_html += ('<input type="checkbox" id="' + ls_element_id + '_' + i + '" name="' + ls_element_name + '" title="' + ls_checkbox_title + '" value="' + jsonData[i].codeCd + '"' + ((jsonData[i].codeCd == ls_default) ? ' checked' : '') + '/><label for="' + ls_element_id + '_' + i + '">' + jsonData[i].codeNm + '</label>&nbsp;');
                        li_cnt++;
                        if( ( li_cnt % li_checkbox_cnt ) == 0 ) ls_html += '<br />';
                    }

                }

            }
        }

    } else {

        if (jsonData != "" && jsonData != null) {
            for (var i = 0; i < jsonData.length; i++) {
                if(  jsonData[i].codeNm != "" && typeof jsonData[i].codeNm != "undefined" )
                    ls_html += ('<input type="checkbox" id="' + ls_element_id + '_' + i + '" name="' + ls_element_name + '" title="' + ls_checkbox_title + '" value="' + jsonData[i].codeCd + '"' + ((jsonData[i].codeCd == ls_default) ? ' checked' : '') + '/><label for="' + ls_element_id + '_' + i + '">' + jsonData[i].codeNm + '</label>&nbsp;');
                    li_cnt++;
                    if( ( li_cnt % li_checkbox_cnt ) == 0 ) ls_html += '<br />';
            }
        }

    }

    ls_html = ksid.string.rtrim(ls_html, '<br />');

//    console.log(ls_html);

    $(as_checkbox_id).html(ls_html);

};

ksid.form.bindCheckboxPrice = function(as_checkbox_id, jsonData, ao_option) {

    as_checkbox_id = "#" + ksid.string.ltrim(as_checkbox_id, "#");
    var ls_element_id = $(as_checkbox_id).attr("id");
    var ls_element_name = ls_element_id.substring(as_checkbox_id.indexOf("_"));
    var ls_html = "";

    $( as_checkbox_id ).html("");

    var lo_map = null;
    var ls_default = (ksid.json.containsKey(ao_option, "DEFAULT") == true) ? ao_option.DEFAULT : "";

    var ls_checkbox_title = ( ksid.json.containsKey(ao_option, "TITLE") == true ) ? ao_option.TITLE : "";

    var li_checkbox_cnt = ( ksid.json.containsKey(ao_option, "COL_CNT") == true ) ? ao_option.COL_CNT : 9999;

    var li_cnt = 0;

//    console.log('#################################################');
//    console.log('as_checkbox_id = ' + as_checkbox_id);
//    console.log('ls_element_id = ' + ls_element_id);
//    console.log('ls_element_name = ' + ls_element_name);
//    console.log(jsonData);

    if (ksid.json.containsKey(ao_option, "ITEM")) {
        for (var i = 0; i < ao_option.ITEM.length; i++) {
            if( typeof ao_option.ITEM[i] != "undefined" ) {
                lo_map = ao_option.ITEM[i];
                ls_html += ('<input type="checkbox" id="' + ls_element_id + '_' + i + '" name="' + ls_element_name + '" title="' + ls_checkbox_title + '" value="' + lo_map["VAL"] + '"' + ((lo_map["VAL"] == ls_default) ? ' checked' : '') + '/><label for="' + ls_element_id + '_' + i + '">' + lo_map.TEXT + '</label>&nbsp;');
                li_cnt++;
                if( ( li_cnt % li_checkbox_cnt ) == 0 ) ls_html += '<br />';
            }
        }
    }

    if( ksid.json.containsKey( ao_option, "REMOVE" ) ) {

        var lb_remove = false;

        if (jsonData != "" && jsonData != null) {
            for (var i = 0; i < jsonData.length; i++) {
                if(  jsonData[i].codeNm != "" && typeof jsonData[i].codeNm != "undefined" ) {
                    lb_remove = false;
                    for (var j = 0; j < ao_option.REMOVE.length; j++) {
                        if( jsonData[i].codeCd == ao_option.REMOVE[j] ) {
                            lb_remove = true;
                            break;
                        }
                    }
                    if( lb_remove == false ) {
                        ls_html += ('<input type="checkbox" id="' + ls_element_id + '_' + i + '" name="' + ls_element_name + '" title="' + ls_checkbox_title + '" value="' + jsonData[i].codeCd + '"' + ((jsonData[i].codeCd == ls_default) ? ' checked' : '') + '/><label for="' + ls_element_id + '_' + i + '">' + jsonData[i].codeNm + '</label>&nbsp;');
                        li_cnt++;
                        if( ( li_cnt % li_checkbox_cnt ) == 0 ) ls_html += '<br />';
                    }

                }

            }
        }

    } else {

        if (jsonData != "" && jsonData != null) {
            ls_html += '<table>';
            ls_html += '<tr>';
            for (var i = 0; i < jsonData.length; i++) {
                if(  jsonData[i].codeNm != "" && typeof jsonData[i].codeNm != "undefined" )
                    ls_html += ('<td><input type="checkbox" id="' + ls_element_id + '_' + i + '" name="' + ls_element_name + '" title="' + ls_checkbox_title + '" value="' + jsonData[i].codeCd + '"' + ((jsonData[i].codeCd == ls_default) ? ' checked' : '') + '/><label " for="' + ls_element_id + '_' + i + '" style="font-size:11px;" >' + jsonData[i].codeNm + '</label>&nbsp;</td>');
                    ls_html += ('<td><input type="text" name="' + jsonData[i].codeCd + '" format="number" value="0" class="style-input width40" style="height:16px" disabled />&nbsp;</td>');
                    li_cnt++;
                    if( ( li_cnt % li_checkbox_cnt ) == 0 && i != (jsonData.length - 1) ) ls_html += '</tr>';
                    if(i == (jsonData.length - 1)) ls_html += '</tr>';
            }
            ls_html += '</table>';
        }

    }

    ls_html = ksid.string.rtrim(ls_html, '<br />');

//    console.log(ls_html);

    $(as_checkbox_id).html(ls_html);

};

ksid.form.bindRadio = function(as_radio_id, jsonData, ao_option) {

    var ls_element_id = $(as_radio_id).attr("id");
    var ls_element_name = ls_element_id.substring(as_radio_id.indexOf("_"));
    var ls_html = "";

    $( as_radio_id ).html("");

    var lo_map = null;
    var ls_default = (ksid.json.containsKey(ao_option, "DEFAULT") == true) ? ao_option.DEFAULT : "";

    var ls_radio_title = ( ksid.json.containsKey(ao_option, "TITLE") == true ) ? ao_option.TITLE : "";

    var li_radio_cnt = ( ksid.json.containsKey(ao_option, "COL_CNT") == true ) ? ao_option.COL_CNT : 9999;

    var li_cnt = 0;

    if (ksid.json.containsKey(ao_option, "ITEM")) {
        for (var i = 0; i < ao_option.ITEM.length; i++) {
            if( typeof ao_option.ITEM[i] != "undefined" ) {
                lo_map = ao_option.ITEM[i];
                ls_html += ('<input type="radio" id="' + ls_element_id + '_' + i + '" name="' + ls_element_name + '" title="' + ls_radio_title + '" value="' + lo_map["VAL"] + '"' + ((lo_map["VAL"] == ls_default) ? ' checked' : '') + '/><label for="' + ls_element_id + '_' + i + '">' + lo_map.TEXT + '</label>&nbsp;');
                li_cnt++;
                if( ( li_cnt % li_radio_cnt ) == 0 ) ls_html += '<br />';
            }
        }
    }

    if( ksid.json.containsKey( ao_option, "REMOVE" ) ) {

        var lb_remove = false;

        if (jsonData != "" && jsonData != null) {
            for (var i = 0; i < jsonData.length; i++) {
                if(  jsonData[i].codeNm != "" && typeof jsonData[i].codeNm != "undefined" ) {
                    lb_remove = false;
                    for (var j = 0; j < ao_option.REMOVE.length; j++) {
                        if( jsonData[i].codeCd == ao_option.REMOVE[j] ) {
                            lb_remove = true;
                            break;
                        }
                    }
                    if( lb_remove == false ) {
                        ls_html += ('<input type="radio" id="' + ls_element_id + '_' + i + '" name="' + ls_element_name + '" title="' + ls_radio_title + '" value="' + jsonData[i].codeCd + '"' + ((jsonData[i].codeCd == ls_default) ? ' checked' : '') + '/><label for="' + ls_element_id + '_' + i + '">' + jsonData[i].codeNm + '</label>&nbsp;');
                        li_cnt++;
                        if( ( li_cnt % li_radio_cnt ) == 0 ) ls_html += '<br />';
                    }

                }

            }
        }

    } else {

        if (jsonData != "" && jsonData != null) {
            for (var i = 0; i < jsonData.length; i++) {
                if(  jsonData[i].codeNm != "" && typeof jsonData[i].codeNm != "undefined" )
                    ls_html += ('<input type="radio" id="' + ls_element_id + '_' + i + '" name="' + ls_element_name + '" title="' + ls_radio_title + '" value="' + jsonData[i].codeCd + '"' + ((jsonData[i].codeCd == ls_default) ? ' checked' : '') + '/><label for="' + ls_element_id + '_' + i + '">' + jsonData[i].codeNm + '</label>&nbsp;');
                    li_cnt++;
                    if( ( li_cnt % li_radio_cnt ) == 0 ) ls_html += '<br />';
            }
        }

    }

    ls_html = ksid.string.rtrim(ls_html, '<br />');

//    console.log(ls_html);

    $(as_radio_id).html(ls_html);

};

/***************************************************************************
 * Function Name : checkMaxLength
 * Description : element를사용하여 length 체크
 * 				 length에 초과되는 필드 alert으로 보여줌
 * parameters : element
 * return :
 ***************************************************************************/
ksid.form.checkMaxLength = function (element) {
    var tempText = $(element);
    var tempChar = "";                                        // TextArea의 문자를 한글자씩 담는다
    var tempChar2 = "";                                        // 절삭된 문자들을 담기 위한 변수
    var countChar = 0;                                        // 한글자씩 담긴 문자를 카운트 한다
    var tempHangul = 0;                                        // 한글을 카운트 한다
    var maxSize = $(element).attr("maxlength");                                        // 최대값

    // 글자수 바이트 체크를 위한 반복
    for(var i = 0 ; i < tempText.val().length; i++) {
        tempChar = tempText.val().charAt(i);

        // 한글일 경우 2 추가, 영문일 경우 1 추가
        if(escape(tempChar).length > 4) {
            countChar += 2;
            tempHangul++;
        } else {
            countChar++;
        }
    }

    // 카운트된 문자수가 MAX 값을 초과하게 되면 절삭 수치까지만 출력을 한다.(한글 입력 체크)
    // 내용에 한글이 입력되어 있는 경우 한글에 해당하는 카운트 만큼을 전체 카운트에서 뺀 숫자가 maxSize보다 크면 수행
    //한글 체크 위해서 한글빼주던거 삭제함
//    if(countChar > maxSize) {
    if((countChar-tempHangul) > maxSize) {
        tempChar2 = tempText.val().substr(0, maxSize-1);
        tempText.val(tempChar2);
    }
};



/***************************************************************************
 * Function Name : validatePanel
 * Description : panelId를사용하여 validate 체크
 * 				 panelId는 필드를 감싸고 있는 엘리먼트의 ID
 * 				 validation에 위배되는 필드 alert으로 보여줌
 * parameters : panelId
 * return :
 ***************************************************************************/
ksid.form.validateForm = function (panelId) {
    var returnVal = true;
    var titleList = "";
    var title = "";

    $("#"+panelId + " input," + "#"+panelId + " textarea," + "#"+panelId + " select").each(function () {
        if ($(this).attr("required")) {
            if( $(this).val() == "" || $(this).val() == null ) {
                returnVal = false;
                title = ( typeof $(this).attr("title") == "undefined" ) ? "항목" : $(this).attr("title");
                titleList += (titleList == "") ? title : ", " + title;
            }
        }
    });

    if (returnVal == false) {
        ksid.ui.alert("<strong>[ " + titleList + " ]</strong><br />" + "위 항목은 필수항목 입니다. <br />확인해 주시기 바랍니다.");
    }

    return returnVal;
};

function numbersonly(e, decimal) {
    var key;
    var keychar;
    if (window.event) {  //익스와 파폭 체크 !
        key = window.event.keyCode;
    } else if (e) {
        key = e.which;
    } else {
        return true;
    }
    keychar = String.fromCharCode(key);
    if ((key == null) || (key == 0) || (key == 8) || (key == 9) || (key == 13)
            || (key == 27)) {
        return true;
    } else if ((("0123456789").indexOf(keychar) > -1)) {
        return true;
    } else if (decimal && (keychar == ".")) {
        return true;
    } else
        return false;
}





















