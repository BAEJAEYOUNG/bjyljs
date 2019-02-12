
/**
 * ksid grid class
 */

ksid.grid		= function( as_id, ao_prop ) {

    this.id                 = as_id;        // grid 고유 id

    this.prop               = {
        datatype: "local",                  // 로컬 데이터를 사용
        autowidth: true,                    // 자동으로 width 조정
//        height: 100,                        // 높이
        resizable: true,                    // 컬럼 사이즈를 자유자제로 조절할 수 있음
        frozon: true,                       // 컬럼 틀고정 기능 사용 ( editable, multiselect 기능과 중복사용불가 )
        shrinkToFit: true,                  // 그리드에 각각의 width 적용없이 꽉채우기 여부
        gridview: true,                     // 처리속도를 빠르게 해준다. 시간측정시 절반가량 로딩시간 감소!!! 하지만 다음 모듈엔 사용할 수 없다!! ==> treeGrid, subGrid, afterInsertRow(event)
        loadonce: false,                    // reload 여부
        rownumbers: true,                   // 맨앞에 줄번호 보이기 여부
        rownumWidth: 50,                    // 줄번호의 width
        scroll: 1,                          // 스크롤 페이징 처리(에러발생하니 잘 고쳐서 사용 ^^;)
        scrollrows : true,					// row 선택시 스크롤링
        rowTotal: -1,                       // 결과 전부 조회하기
        rowNum: 100,                         // row 갯수
        viewrecords: false,                 // 총페이지 현재페이지 정보를 노출
        sortable: false,                     // 컬럼간의 위치를 바꿀수 있다. (틀고정(frozen) 기능사용시 컬럼이동 불가)
        jsonReader: { repeatitems: false }, // repeatitems : true 의 row type => [{"id":"", "cell":[{}{}{}.....]}]   // repeatitems : false 의 row type => [{}{}{}.....]
        multiselect: false,                 // 다중선택불가
        multiboxonly: false,                // 체크박스로만 체크
        footerrow: false,                   // 하단합계 표시하고자 할때
        userDataOnFooter: false,            // 하단합계를 실행중 구하여 적용.
        emptyrecords:"데이터가 존재하지 않습니다.",
        colModel : []
    };

    this.grid               = null;         // jqGrid
    this.pager              = null;         // pager class instance

    this.rows               = null;         // grid row array

    this.clickedRowData     = null;         // grid clicked rowid
    this.clickedRowId       = null;         // grid clicked data
    this.clickedRowIndex    = null;         // grid clicked index

    this.checkRowIds        = [];           // checkbox checked 인 rowid 저장배열
    this.selectRowId        = null;         // 현재 선택된 rowid를 저장
    this.bChkAll            = false;        // multiselect, checkboxonly 일경우 전체선택여부

    if (!$.isEmptyObject(ao_prop)) {
        this.init(ao_prop);
    }

    $("body").append(this);
};

/***************************************************************************
 * Function Name : bindGrid
 * Description : gridId안의 컬럼에 jsonData bind
 * parameters : gridId
 * 				jsonData
 * return :
 ***************************************************************************/
//ksid.grid.bindGrid = function(gridId, jsonData) {
//
//    window[gridId].bindGrid(jsonData);
//
//};

/**
 * grid 초기 세팅
 * @param aoProp
 */
ksid.grid.prototype.init = function (ao_prop) {

//    ksid.debug.printObj("this.prop", this.prop);

    ksid.json.mergeObject(this.prop, ao_prop);

//    ksid.debug.printObj("this.prop", this.prop);

    for (var i = 0; i < this.prop.colModel.length; i++) {

        this.prop.colModel[i]['sortable'] = false;

        if( ksid.json.containsKey(this.prop.colModel[i], "name") == false) break;

        if( ksid.language != "kr" ) {

            if( ksid.json.containsKey( ksid.lan.title, this.prop.colModel[i].label ) == true ) {

                this.prop.colModel[i].label = ksid.lan.title[ this.prop.colModel[i].label ];

            }

        }

        // format 옵션이 존재한다면
        if( ksid.json.containsKey( this.prop.colModel[i], "format" ) == true ) {

            var lb_width = ( ksid.json.containsKey( this.prop.colModel[i], "width" ) == true );

            var li_width = 100;

            switch( this.prop.colModel[i].format ) {

                // 문자인 경우
                case "string" :
                    if(lb_width == false) li_width = 100;
                    this.prop.colModel[i].align = "left";
                    break;

                // 숫자인 경우
                case "number" :
                    if(lb_width == false) li_width = 60;
                    this.prop.colModel[i].align = "right";
                    this.prop.colModel[i].formatter = "integer";
                    break;
                // 전화번호 형식
                case "tel_no" :
                    if(lb_width == false) li_width = 100;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.tel_no;
                    break;
                // 사업자번호 형식
                case "biz_no" :
                    if(lb_width == false) li_width = 80;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.biz_no;
                    break;
                 // 카드번호 형식
                case "card_no" :
                    if(lb_width == false) li_width = 120;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.card_no;
                    break;
                 // 사업자번호 형식
                case "zip_no" :
                    if(lb_width == false) li_width = 60;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.zip_no;
                    break;
                // money 형식
                case "money" :
                    this.prop.colModel[i].align = "right";
                    if(lb_width == false) li_width = 80;
                    this.prop.colModel[i].formatter = "currency";
                    this.prop.colModel[i].formatoptions = ksid.grid.formatoption.money;
                    break;
                // currency
                case "currency" :
                    this.prop.colModel[i].align = "right";
                    if(lb_width == false) li_width = 100;
                    this.prop.colModel[i].formatter = "currency";
                    this.prop.colModel[i].formatoptions = ksid.grid.formatoption.currency;
                    break;
                // 백분율
                case "rate" :
                    this.prop.colModel[i].align = "right";
                    if(lb_width == false) li_width = 60;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.rate;
                    break;
                // 파일크기
                case "file_size" :
                    this.prop.colModel[i].align = "right";
                    if(lb_width == false) li_width = 60;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.file_size;
                    break;
                case "date" :
                    if(lb_width == false) li_width = 80;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.date;
                    break;
                case "ym" :
                    if(lb_width == false) li_width = 70;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.ym;
                    break;
                case "ymd" :
                    if(lb_width == false) li_width = 90;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.ymdh;
                    break;
                case "ymdh" :
                    if(lb_width == false) li_width = 100;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.ymdh;
                    break;
                case "time" :
                    if(lb_width == false) li_width = 60;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.time;
                    break;
                case "dttm" :
                    if(lb_width == false) li_width = 150;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.dttm;
                    break;
                case "ctemp" :
                    if(lb_width == false) li_width = 80;
                    this.prop.colModel[i].formatter = ksid.grid.formatter.ctemp;
                    break;

            }

            if( true == this.prop.colModel[i].editable ) {

                switch( this.prop.colModel[i].edittype ) {

                    case "date" :
                        var datepickerProp = {
                            changeYear      : true,
                            changeMonth     : true,
                            dateFormat      : "yy-mm-dd",
                            yearRange       : 'c-100:c+10',
                            minDate         : '-100y',
                            showAnim        : "fadeIn",
                            onSelect        : function() {$(this).change();}
                        };
                        this.prop.colModel[i].edittype = 'text';
                        this.prop.colModel[i].editrules = {required:true};
                        this.prop.colModel[i].editoptions = { dataInit:function(el){ $(el).datepicker(datepickerProp) }};
                        break;
                    case "select" :
                        this.prop.colModel[i].formatter = 'select';
                        this.prop.colModel[i].editoptions = {value:this.prop.colModel[i].editoptions};
                        break;
                    case "checkbox" :
                        this.prop.colModel[i].edittype = 'checkbox';
                        this.prop.colModel[i].editoptions = {value:'Y:N'};
                        break;
                    default:
                        break;
                }

            }

            delete this.prop.colModel[i].format;

        }

        //  index 가 없다면 name 과 동일한 값으로
        if( ksid.json.containsKey(this.prop.colModel[i], "index") == false ) {
            this.prop.colModel[i].index = this.prop.colModel[i].name;
        }

        // width 가 없다면 100 기본값으로
        if( lb_width == false ) {
            this.prop.colModel[i].width = li_width;
        }

        // align 이 없다면 center 기본으로
        if( ksid.json.containsKey(this.prop.colModel[i], "align") == false ) {
            this.prop.colModel[i].align = "center";
        }

        // hidden 이라면 너비를 0으로
//        if( ksid.json.containsKey(this.prop.colModel[i], "hidden") == true ) {
//            if( this.prop.colModel[i].hidden == true ) {
//                this.prop.colModel[i].width = 0;
//            }
//        }

    }

    return this;

};

/**
 * datablock array map bind
 */
ksid.grid.prototype.bindGrid = function( ao_array ) {

    this.hideLoading();

    this.initGridData();

    if(!ao_array) return;

    this.rows = ksid.json.cloneObject(ao_array);

    if( ao_array.length > 0 ) {

        // grid data bind
        if ($("#" + this.id).get(0).p.treeGrid) {
            $("#" + this.id).get(0).addJSONData({
                total: 1,
                page: 1,
                records: ao_array.length,
                rows: ao_array
            });
        } else {
            $("#" + this.id).setGridParam({
                datatype: 'local',
                data: ao_array,
                rowNum: ao_array.length
            }).trigger("reloadGrid");
        }

        // 페이저 전체갯수 세팅
        if (this.pager != null) {
            // 전체갯수를 첫번째 row 에서 가져온다.
            this.pager.prop.totrowcnt = (this.rows.length > 0) ? this.rows[0].totrowcnt : 0;
            // prop 변경후에 모든 pager변수를 초기화해야 한다.
            this.pager.initPager();
            // pager를 보여준다.
            this.pager.show();
        }

    }

    if(this.pager != null) {
        var refGrid = this;
        $('#'+this.id).find('.jqgrid-rownum').each(function(index) {
            $(this).text((refGrid.pager.prop.pagenow-1) * refGrid.pager.prop.pagecnt + index + 1);
        });
    }

    return this;

};

/**
 * jqgrid load
 */
ksid.grid.prototype.loadGrid = function () {

    if(this.grid == null) {
        this.grid = $("#" + this.id).jqGrid(this.prop);
        if( ksid.json.containsKey(this.prop, 'height')) {
            $("#" + this.id).jqGrid('setGridHeight', this.prop.height);
        }
    } else {
        this.initGridData();
    }

    return this;

};


/**
 * jqgrid 로딩바 보이기
 */
ksid.grid.prototype.showLoading = function() {

    $("#load_" + this.id).show();

    return this.initGridData();

};
/**
 * jqgrid 로딩바 숨기기
 */
ksid.grid.prototype.hideLoading = function () {

    $("#load_" + this.id).fadeOut(100);

};
/**
 * 그리드 데이터 다시 읽기
 */
ksid.grid.prototype.reload = function() {

    $("#" + this.id).trigger("reloadGrid");         // grid 다시로딩
    this.initClickedData();
    // grid click 정보 초기화

    return this;

};

/**
 * grid clicked 정보 초기화
 */
ksid.grid.prototype.initClickedData = function() {

    this.clickedRowData = null;
    this.clickedRowId = null;
    this.clickedRowIndex = null;

    return this;

};

/**
 * grid 전체 data 초기화
 */
ksid.grid.prototype.initGridData = function () {

    this.initClickedData();

    this.rows = null;
    this.checkRowIds = [];

    try {
        $("#" + this.id).jqGrid('clearGridData');
    } catch (e) {
//        console.log(e);
    };

    this.bChkAll = false;

    return this;

};

/**
 * grid pager 초기화
 */
ksid.grid.prototype.initPager = function() {

    if( this.pager != null ) {

        this.pager.prop.pagenow     = 1;
        this.pager.prop.totrowcnt   = 1;
        this.pager.initPager();
        this.pager.show();

    }

    return this;

};

/**
 * grid multiselect 에서 체크된 array 가져오기
 */
ksid.grid.prototype.getCheckedList = function () {

    var rowsId = $( "#" + this.id ).jqGrid('getGridParam', 'selarrrow');

    if( rowsId.length == 0 ) {

        return null;

    } else {

        var rtnList = [];
        for ( var i = 0; i < rowsId.length; i++) {
            rtnList.push(ksid.json.cloneObject(this.rows[$('#' + $.jgrid.jqID(rowsId[i]))[0].rowIndex - 1]));
        }
        return rtnList;

    }

};

/**
 * grid click 할때 clicked 데이터 만들기
 * @param as_row_id
 */
ksid.grid.prototype.setClickedProp = function (as_row_id) {

    this.clickedRowId = as_row_id;

    if (ksid.json.containsKey(this.prop, "grouping") == true) {

        if (this.prop["grouping"] == true) {

            this.clickedRowIndex = (this.clickedRowId - 1);

        } else {

            this.clickedRowIndex = ($('#' + $.jgrid.jqID(as_row_id))[0].rowIndex - 1);

        }

    } else {

        this.clickedRowIndex = ($('#' + $.jgrid.jqID(as_row_id))[0].rowIndex - 1);

    }

//    console.log(this.rows);

    this.clickedRowData = ksid.json.cloneObject(this.rows[this.clickedRowIndex]);

    return this;

};

/**
 * jqgrid 확장 - 콤보박스와 select 따로 작동 beforeSelectRow
 * @param rowId
 * @param e
 * @returns {Boolean}
 */
ksid.grid.prototype.beforeSelectRow = function(rowId,e) {

    if(e.target.type == "checkbox" ) {

        var gridId = this.id;
        this.checkRowIds = [];
        var lsrcheckRowIds = [];

        $('input:checkbox:checked[id^="jqg_' + this.id + '"]').each(function() {

            lsrcheckRowIds.push($(this).attr("id").replace("jqg_" + gridId + "_", ""));

        });

        this.checkRowIds = lsrcheckRowIds;

        return false;

    } else if(e.target.type == "radio" ) {

        var rowIds = $("#" + this.id).jqGrid('getDataIDs');     // 전체 rowid 가져오기

        this.checkRowIds = [];

        for (var i = 0; i < rowIds.length; i++) {

            if($("input:radio[id='jqg_" + this.id + "_" + rowIds[i] + "']").is(":checked")){

                this.checkRowIds = [rowIds[i]];

            }

        }

        return false;

    } else {

        return true;

    }

};
/**
 * jqgrid 확장 - 콤보박스와 select 따로 작동 onSelectRow
 * @param rowId
 * @param status
 * @param e
 */
ksid.grid.prototype.onSelectRow = function(rowId, status, e) {

    $("input:checkbox[id^=jqg_" + this.id + "_]").attr("checked", false);

    for (var i = 0; i < this.checkRowIds.length; i++) {

        $("input:checkbox[id='jqg_" + this.id + "_" + this.checkRowIds[i] + "']").attr("checked", true);

    }

    this.selectRowId = rowId;

    $("#cb_" + this.id).attr("checked", this.bChkAll);

    return this;

};
/**
 * jqgrid 확장 - 콤보박스와 select 따로 작동 onSelectAll
 * @param rowId
 * @param status
 * @param e
 */
ksid.grid.prototype.onSelectAll = function(aRowids,status) {

    $("#" + this.id).resetSelection();
    $("#" + this.id).setSelection(this.selectRowId, true);

    this.bChkAll = status;

    if(status == true) {

        $("#cb_" + this.id).attr("checked", true);
        $("input:checkbox[id^=jqg_" + this.id + "_]").attr("checked", true);
        var rowIds = $("#" + this.id).jqGrid('getDataIDs');     // 전체 rowid 가져오기
        this.checkRowIds = [];
        for (var i = 0; i < rowIds.length; i++) {
            if($("input:checkbox[id='jqg_" + this.id + "_" + rowIds[i] + "']").is(":checked")){
                this.checkRowIds.push(rowIds[i]);
            }
        }

    } else {

        $("#cb_" + this.id).attr("checked", false);
        $("input:checkbox[id^=jqg_" + this.id + "_]").attr("checked", false);
        this.checkRowIds = [];

    }

    return this;

};

/**
 * 합계구하기
 * @param option
 */
ksid.grid.prototype.setSum = function(option) {

    var grid = $("#" + this.id);
    var loSum = {};
    for (var i = 0; i < option.col.length; i++) {
        loSum[option.col[i]] = grid.jqGrid('getCol',option.col[i],false,'sum');
    }
    var loSumProp = {};

    ksid.json.mergeObject(loSumProp, option.label);

    if( ksid.json.containsKey(option, "label") == true ) {
        for(key in option.label){
            $("#gview_" + this.id + " .ui-jqgrid-ftable [aria-describedby=" + this.id + "_" + key + "]").css({"text-align":"center"});
        }
        ksid.json.mergeObject(loSumProp, option.label);
    }

    ksid.json.mergeObject(loSumProp, loSum);

    grid.jqGrid('footerData','set', loSumProp);

    $("#gview_" + this.id + " .ui-jqgrid-ftable [aria-describedby=" + this.id + "_servNm]").css({"text-align":"center"});

    $("#gview_" + this.id + " div.ui-jqgrid-sdiv").after($("#gview_" + this.id + " div.ui-jqgrid-bdiv"));

    return this;

};

/**
 * 합계구하기
 * @param aoMap
 */
ksid.grid.prototype.setAvg = function(aoMap) {

    var grid = $("#" + this.id);
    var loAvg = {};
    for (var i = 0; i < aoMap.col.length; i++) {
        loAvg[aoMap.col[i]] = grid.jqGrid('getCol',aoMap.col[i],false,'avg');
    }
    var loAvgProp = {};

    if( ksid.json.containsKey(aoMap, "label") == true ) {
        ksid.json.mergeObject(loAvgProp, aoMap.label);
    }
    ksid.json.mergeObject(loAvgProp, loAvg);

    grid.jqGrid('footerData','set', loAvgProp);

    return this;

};

// 엑셀 다운로드시 colModel return : hidden 제외
ksid.grid.prototype.getExcelColModel = function() {

    var colModel = [];

    var gridColModel = $( "#" + this.id ).getGridParam('colModel');

    for ( var i = 0; i < gridColModel.length; i++) {

//        ksid.debug.printObj(gridColModel[i]);

        if( !gridColModel[i].hidden && gridColModel[i].label ) {
            colModel.push(
                {
                    label   : gridColModel[i].label,
                    name    : gridColModel[i].name,
                    width   : gridColModel[i].width
                }
            );
        }

    }

    return colModel;

};

/**
 * 컬럼 show / hide
 */
ksid.grid.prototype.showCol = function( asr_col ) {

    $( "#" + this.id ).jqGrid("showCol", asr_col);

    return this;

};

/**
 * 컬럼 show / hide
 */
ksid.grid.prototype.hideCol = function( asr_col ) {

    $( "#" + this.id ).jqGrid("hideCol", asr_col);

    return this;

};

ksid.grid.prototype.getRowIdKeys = function ( keys ) {

    var rowsIds = $("#"+gridId).jqGrid('getDataIDs');

    var rowArray = new Array();

    for(var i = 0; i < rows.length; i++){
        var rowData = $("#"+gridId).getRowData(rows[i]);
        rowArray[rowArray.length] = rowData;
    }

    return rowArray;

};

//jqgrid validation
ksid.grid.prototype.validateRow = function() {

  //각 행의 필수 값 검사해서 알림
   var ids = $("#" + this.id).jqGrid('getDataIDs');
   var colModel = $("#" + this.id).jqGrid('getGridParam', 'colModel');

   for(var i=0;i<ids.length;i++){

      var rowData = $("#" + this.id).getRowData(ids[i]);

      for(var j = 0; j < colModel.length; j ++) {

         if(colModel[j].editrules && colModel[j].editrules.required && rowData[colModel[j].name] == "") {
            ksid.ui.alert((i+1) +"번째 행 " + colModel[j].label+ " 값을 입력하세요.");
            return false;
         }
      }
   }

    return true;

};

//jqgrid setEditableRow
ksid.grid.prototype.setEditableRow = function(rowId, col, val, targetColArray) {
   var rowData = $("#" + this.id).getRowData(rowId);

   if(targetColArray) {
      for(var i = 0; i < targetColArray.length; i++) {
         $("#" + this.id).jqGrid("setColProp", targetColArray[i], {editable: rowData[col] == val});
      }
   } else {
      colModel = $("#" + this.id).jqGrid('getGridParam', 'colModel');

      for(var i = 0; i < colModel.length; i++) {
         $("#" + this.id).jqGrid("setColProp", colModel[i].name, {editable: rowData[col] == val});
      }
   }

};


/*****************************************************
* 함수명: 그리드 첫 줄 선택
* 설명   :
*****************************************************/
ksid.grid.prototype.firstRowSelection = function() {
    var ids = $( "#" + this.id ).jqGrid("getDataIDs");
    if(ids && ids.length > 0)
        $( "#" + this.id ).jqGrid("setSelection", ids[0]);
}


/**
 * 같은 row를 합쳐주는 함수
 */
$.fn.jqgridRowspan = function(colIndexs) {

    var model = [];

    // 각 column의 ID를 수집.

    $.each(this.getGridParam("colModel"), function(idx, value) {

        model.push(value.name);

    });

    var data = this.getCol(model[colIndexs]);

    var rowspanData = {};

    var current;

    var currentIDX = 0;

    $.each(data, function(idx, value) {

        if (current != value) {

            currentIDX = idx;

            rowspanData[currentIDX] = 1;

        } else rowspanData[currentIDX]++;

        current = value;

    });


    $('tbody tr', this).each(function(row, rowObject) {

        var tmpIDx = 0;

        $('td', this).each(function(col, colObject) {

            if (col == colIndexs && row > 0) {// 0번째 row는 숨겨진 row다 이것 때문에 width가 깨지는 현상 발생

                if (rowspanData[row - 1]) tmpIDx = rowspanData[row - 1];

                else tmpIDx = 0;

                if (tmpIDx > 0) {

                    $(colObject).attr("rowspan", tmpIDx);

                } else {

                    $(colObject).hide();

                }
            }

        });

    });

};

ksid.grid.formatter = {};
ksid.grid.formatoption = {};

/**
 * jqgrid date formatter
 */
ksid.grid.formatter.date = function(cellvalue, options, rowObject) {

    return ksid.string.formatDate(cellvalue);

};
/**
 * jqgrid date formatter
 */
ksid.grid.formatter.ym = function(cellvalue, options, rowObject) {

    return ksid.string.formatYm(cellvalue);

};
/**
 * jqgrid yyyymmddhh formatter
 */
ksid.grid.formatter.ymdh = function(cellvalue, options, rowObject) {
    return ksid.string.formatYmdh(cellvalue);

};
/**
 * jqgrid time formatter
 */
ksid.grid.formatter.time = function(cellvalue, options, rowObject) {

    return ksid.string.formatTime(cellvalue);

};
/**
 * jqgrid datetime formatter
 */
ksid.grid.formatter.dttm = function(cellvalue, options, rowObject) {

    return ksid.string.formatDttm(cellvalue);

};

/**
 * jqgrid money formatter
 */
ksid.grid.formatter.money = function(cellvalue, options, rowObject) {

    return ksid.string.formatNumber(cellvalue);

};
/**
 * jqgrid currency formatter
 */
ksid.grid.formatter.currency = function(cellvalue, options, rowObject) {

    return ksid.string.formatDecimal(cellvalue);

};
/**
 * jqgrid currency formatter
 */
ksid.grid.formatter.qty = function(cellvalue, options, rowObject) {

    return ksid.string.formatDecimal(cellvalue, 3);

};
/**
 * jqgrid tel_no formatter
 */
ksid.grid.formatter.tel_no = function(cellvalue, options, rowObject) {

    return ksid.string.formatTelNo(cellvalue);

};
/**
 * jqgrid tel_no formatter
 */
ksid.grid.formatter.card_no = function(cellvalue, options, rowObject) {

    return ksid.string.formatCardNo(cellvalue);

};
/**
 * jqgrid file_size formatter
 */
ksid.grid.formatter.file_size = function(cellvalue, options, rowObject) {

    return ksid.string.formatBitUnit(cellvalue);

};
/**
 * jqgrid biz_no formatter
 */
ksid.grid.formatter.biz_no = function(cellvalue, options, rowObject) {

    return ksid.string.formatBizNo(cellvalue);

};
/**
 * jqgrid biz_no formatter
 */
ksid.grid.formatter.zip_no = function(cellvalue, options, rowObject) {

    return ksid.string.formatZipNo(cellvalue);

};
/**
 * jqgrid rate formatter
 */
ksid.grid.formatter.rate = function(cellvalue, options, rowObject) {

    return ksid.string.formatRate(cellvalue);

};
/**
 * jqgrid ctemp formatter
 */
ksid.grid.formatter.ctemp = function(cellvalue, options, rowObject) {

    return ksid.string.formatCtemp(cellvalue);

};




ksid.grid.formatoption.money = {

    decimalSeparator : ".",
    thousandsSeparator : ",",
    decimalPlaces : 0,
    prefix : "",
    suffix : "",
    defaulValue : 0

};

ksid.grid.formatoption.currency = {

    decimalSeparator : ".",
    thousandsSeparator : ",",
    decimalPlaces : 2,
    prefix : "",
    suffix : "",
    defaulValue : 0.00

};

/***************************************************************************
 * Name     : CommonJs.jqGridStringFormatter
 * Desc     : jqgrid formatter for string
 * @param   : cellvalue
 *            options
 *            rowObject
 * @returns : string
 * @author  : 이경수
 * @since   : 2012.09.10
 ***************************************************************************/
/** JqGrid에 수정버튼을 붙인다. */
ksid.grid.jqGridStringFormatter = function(cellvalue, options, rowObject) {
    if(!cellvalue)return "";
    var result = cellvalue + "";
    result = result.replace("<", "&lt;");
    result = result.replace(">", "&gt;");
    return result;
};

ksid.grid.prototype.addCol = function(name, label, width, format, props) {
    var col = {};
    col.name = name;
    col.label = label;
    col.width = width;
    col.format = format;

    this.prop.colModel.push(col);
}
ksid.grid.prototype.addHidden = function(name, label, props) {
    var col = {};
    col.name = name;
    col.label = label;
    col.hidden = true;

    this.prop.colModel.push(col);
}

/***************************************************************************
 * Function Name : initJqGrid
 * Description : local jqgrid 생성
 * parameters : gridId, option
 * return : jqGrid
 ***************************************************************************/
ksid.grid.initJqGrid = function(gridId, option) {
    this.grid = {};

    //jqGrid 기본 생성 옵션
    this.prop = {
        datatype: "local",                  // 로컬 데이터를 사용
//      autowidth: true,                    // 자동으로 width 조정
//      height: 300,                        // 높이
        resizable: true,                    // 컬럼 사이즈를 자유자제로 조절할 수 있음
        frozon: true,                       // 컬럼 틀고정 기능 사용 ( editable, multiselect 기능과 중복사용불가 )
        shrinkToFit: true,                  // 그리드에 각각의 width 적용없이 꽉채우기 여부
        gridview: true,                     // 처리속도를 빠르게 해준다. 시간측정시 절반가량 로딩시간 감소!!! 하지만 다음 모듈엔 사용할 수 없다!! ==> treeGrid, subGrid, afterInsertRow(event)
        loadonce: false,                    // reload 여부
        rownumbers: true,                   // 맨앞에 줄번호 보이기 여부
        rownumWidth: 35,                    // 줄번호의 width
//      scroll: 1,                          // 스크롤 페이징 처리(에러발생하니 잘 고쳐서 사용 ^^;)
//      rowTotal: -1,                       // 결과 전부 조회하기
//      rowNum: 20,                         // row 갯수
//      viewrecords: false,                 // 총페이지 현재페이지 정보를 노출
        sortable: false,                        // 컬럼간의 위치를 바꿀수 있다. (틀고정(frozen) 기능사용시 컬럼이동 불가)
//      jsonReader: { repeatitems: false }, // repeatitems : true 의 row type => [{"id":"", "cell":[{}{}{}.....]}]   // repeatitems : false 의 row type => [{}{}{}.....]
        multiselect: false,                 // 다중선택불가
        multiboxonly: false,                // 체크박스로만 체크
        footerrow: false,                   // 하단합계 표시하고자 할때
//      userDataOnFooter: false,            // 하단합계를 실행중 구하여 적용.
        emptyrecords:"데이터가 존재하지 않습니다."
    };

    //신규 옵션 추가
    for(key in option) {
        prop[key] = option[key];
    }

    return $("#"+gridId).jqGrid(prop);
};

/***************************************************************************
 * Function Name : flushGrid
 * Description : gridId안의 데이터를 array 형태로 반환
 * parameters : gridId
 * return : array
 ***************************************************************************/
ksid.grid.flushGrid = function(gridId) {
    var rows = $("#"+gridId).jqGrid('getDataIDs');

    var rowArray = new Array();

    for(var i = 0; i < rows.length; i++){
        var rowData = $("#"+gridId).getRowData(rows[i]);
        rowArray[rowArray.length] = rowData;
    }

    return rowArray;
};
