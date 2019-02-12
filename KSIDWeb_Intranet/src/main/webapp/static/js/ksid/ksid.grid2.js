ksid.grid = function(gridId, gridProp) {

    this.id = gridId; // jqGrid wrapper html element id
    this.prop = {
            datatype: "local",                  // 로컬 데이터를 사용
            autowidth: true,                    // 자동으로 width 조정
            height: 100,                        // 높이
            resizable: true,                    // 컬럼 사이즈를 자유자제로 조절할 수 있음
            frozen: true,                       // 컬럼 틀고정 기능 사용 ( editable, multiselect 기능과 중복사용불가 )
            shrinkToFit: true,                  // 그리드에 각각의 width 적용없이 꽉채우기 여부
            gridview: true,                     // 처리속도를 빠르게 해준다. 시간측정시 절반가량 로딩시간 감소!!! 하지만 다음 모듈엔 사용할 수 없다!! ==> treeGrid, subGrid, afterInsertRow(event)
            loadonce: false,                    // reload 여부
            rownumbers: true,                   // 맨앞에 줄번호 보이기 여부
            rownumWidth: 35,                    // 줄번호의 width
            scroll: 1,                          // 스크롤 페이징 처리(에러발생하니 잘 고쳐서 사용 ^^;)
            scrollrows : true,                  // row 선택시 스크롤링
            rowTotal: -1,                       // 결과 전부 조회하기
            rowNum: 20,                         // row 갯수
            viewrecords: false,                 // 총페이지 현재페이지 정보를 노출
            sortable: false,                    // 컬럼간의 위치를 바꿀수 있다. (틀고정(frozen) 기능사용시 컬럼이동 불가)
            jsonReader: { repeatitems: false }, // repeatitems : true 의 row type => [{"id":"", "cell":[{}{}{}.....]}]   // repeatitems : false 의 row type => [{}{}{}.....]
            multiselect: false,                 // 다중선택불가
            multiboxonly: false,                // 체크박스로만 체크
            footerrow: false,                   // 하단합계 표시하고자 할때
            userDataOnFooter: false,            // 하단합계를 실행중 구하여 적용.
            emptyrecords:"데이터가 존재하지 않습니다.",
            colModel : []
        };
    this.pager = null; // pager class instance

    this.rows = null; // grid row array

    this.clickedRowData = null; // grid clicked rowid
    this.clickedRowId = null; // grid clicked data
    this.clickedRowIndex = null; // grid clicked index

    this.checkRowIds = []; // checkbox checked 인 rowid 저장배열
    this.selectRowId = null; // 현재 선택된 rowid를 저장
    this.bChkAll = false; // multiselect, checkboxonly 일경우 전체선택여부

    this.init(gridProp);

};
// 그리드 초기화 - 추가 properties 존재시 실행
ksid.grid.prototype.init = function (gridProp) {

    if (!$.isEmptyObject(gridProp)) {
        ksid.json.mergeObject(this.prop, gridProp);
    }

    for (var i = 0; i < this.prop.colModel.length; i++) {

        this.prop.colModel[i].sortable = false; // header click 시 정렬기능 삭제( group header 기능 사용시 버그가 있다 )

        if( ksid.json.containsKey(this.prop.colModel[i], "name") == false) break;   // name 값이 존재하지 않는다면 실행 중지.

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
                        this.prop.colModel[i].edittype = 'text';
                        this.prop.colModel[i].editrules = {required:true};
                        this.prop.colModel[i].editoptions = { dataInit:function(el){ $(el).datepicker({dateFormat:'yy-mm-dd'}) }};
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