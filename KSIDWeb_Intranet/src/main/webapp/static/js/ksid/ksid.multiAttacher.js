/**
 * 다중파일첨부 패널
 *      - 여러 첨부파일을 추가 삭제할 수 있는 패널로 ksid.attacher 를 사용하여 파일 첨부
 *
 *      stylesheet
 *          jquery-ui-1.10.4.custom.css
 *      js
 *          jquery-1.7.1.min.js
 *          jquery.form.js
 *          json3.min.js
 *          jquery-ui-1.10.3.custom.js
 *
 * @author 염국선
 * @since 2014.11.19
 *
 * >>> grid 버전으로 수정
 * @author 배재영
 * @since 2015.02.10
 */


if(!window.ksid) {
    ksid = new Object();
}

/**
 * 다중파일 파일처부를 위한  object 선언
 */
ksid.multiAttacher = function() {

    //초기화를 위한 configure
    this.config = new ksid.multiAttacher.prototype.configModel();

    //생성된 widget 관련 정보
    this.widget = new ksid.multiAttacher.prototype.widgetgModel();

    this.files = [];

    //삭제된 파일(ksid.multiAttacher.prototype.fileModel) 목록
    this.deletedFiles = [];

};

/**
 * initialized configure
 *      - 기본값 정의, 사용자에 의해서 변경
 */
ksid.multiAttacher.prototype.configModel = function() {


//    this.userId     = ( session.emp_no ) ? "admin" : session.emp_no;      // 사용자 ID user define, optional, 세션을 사용할 경우 서블릿에서 처리

    this.compCd     = "ksid";
    this.userId     = "admin";

    this.title      = "첨부파일";

    this.batchTp    = null;
    this.delDirect  = false;

    this.refId      = null;     // multiAttacher instance id
    this.panelId    = null;     // 파일 grid panel id
    this.dialogId   = null;     // 파일다이얼로그 고유 id
    this.width      = $(window).width()-29;
    this.height     = 60;       // grid height

    //최소크기
    if(this.width < 700) this.width = 700;

    this.check      = false;    // 필수체크여부

    this.store      = null;     // store 정보

    this.editable   = true;     // 수정모드일경우 추가,삭제 보이게, false일 경우 버튼 안보이게 처리

    this.downloadUrl    = "/file/download";
    this.ownerFilesUrl  = "/file/list";
    this.uploadUrl      = "/file/upload";

};

/**
 * 생성된 widget 보관
 */
ksid.multiAttacher.prototype.widgetgModel = function() {

    this.view       = null;           // 첨부목록 뷰(grid)
    this.gridId     = null;           // 첨부목록 grid id
    this.downForm   = "downForm";     // 파일다운로드 폼
    this.attacher   = null;           // 파일 첨부


};

/**
 * file 정보를 담은 데이터 모델
 */
ksid.multiAttacher.prototype.fileModel = function() {

    this.fileId = null;

};

/**
 * 초기화
 */
ksid.multiAttacher.prototype.init = function(config, widget) {

    //설정된 정보를 읽어서 저장, 설정하지 않은 값은 기본값으로 사용(ksid.attacher.prototype.configModel)
    if( typeof(config) != "undefined" ) {

        ksid.json.mergeObject(this.config, config);

    }

    if( typeof(widget) != "undefined" ) {

        ksid.json.mergeObject(this.widget, widget);

    }

    this.widget.gridId = "grid_" + this.config.panelId;

//    ksid.ui.alert("this.widget.gridId = " + this.widget.gridId );

    this.drawLayout();

    var multiAttacher = this;
    //resize event 설정
    $(window).resize(function() {
        multiAttacher.resize();
    });

};

/**
 * 외곽패널 크기에 따라 내부 위젯 크기 설정
 */
ksid.multiAttacher.prototype.resize = function() {

    $("#grid_file_01").jqGrid('setGridWidth', $("#" + this.config.panelId).width());

};

/**
 * 전체 layout을 그리고 필요한 이벤트 등을 설정한다.
  *     - 뷰/컨트롤더/다운로드폼(hidden)
 *      - private
 *
 *  <div style="margin-bottom:5px; text-align:right;">
 *      <button id="btn_file_upload_01_add">추가</button>
 *      <button id="btn_file_upload_01_del">삭제</button>
 *  </div>
 *  <table id="grid_file_01" width="100%"></table>
 */
ksid.multiAttacher.prototype.drawLayout = function() {

  //wrap 패널 저장
    var _panel = $(this.widget.panel = $('#'+this.config.panelId));

    var _panelHtml  = '<div class="tit_area">';

        if( this.config.title == '' ) {

            _panelHtml  += '<br /><br />';

            _panelHtml  += '<ul style="margin-bottom:3px;">';
            _panelHtml  += '<li id="btn_' + this.config.panelId + '_add"><a href="javascript:void(0);">파일추가</a></li>';
            _panelHtml  += '<li id="btn_' + this.config.panelId + '_del"><a href="javascript:void(0);">파일삭제</a></li>';
            _panelHtml  += '</ul>';

        } else {



            if( this.config.check == true ) {
                _panelHtml  += '<h3 class="style-title">' + this.config.title + '</h3>';
            } else {
                _panelHtml  += '<h3 class="style-title">' + this.config.title + '</h3>';
            }

            _panelHtml  += '<ul>';
            _panelHtml  += '<li id="btn_' + this.config.panelId + '_add"><a href="javascript:void(0);">파일추가</a></li>';
            _panelHtml  += '<li id="btn_' + this.config.panelId + '_del"><a href="javascript:void(0);">파일삭제</a></li>';
            _panelHtml  += '</ul>';

        }

        _panelHtml  += '</div>';

        _panelHtml  += '<table id="grid_' + this.config.panelId + '"></table>';

//        _panelHtml  += '<button id="btn_' + this.config.panelId + '_add">파일추가</button>';
//        _panelHtml  += '&nbsp;';
//        _panelHtml  += '<button id="btn_' + this.config.panelId + '_del">파일삭제</button>';
//        _panelHtml  += '</div>';
//        _panelHtml  += '<table id="grid_' + this.config.panelId + '"></table>';

    _panel.html(_panelHtml);

    this.drawConroller();

};

/**
 * 파일컨트롤러 작성
 *      - private
 */
ksid.multiAttacher.prototype.drawConroller = function() {

    var grid_id         = this.widget.gridId;
    var multiAttacher   = this;

//    ksid.ui.alert("grid_id = " + grid_id);

    this.widget.view = new ksid.grid( grid_id , {

        colModel: [
                       { label: "파일ID",     name: "fileId"            , hidden: true   },
                       { label: "파일DATA",   name: "fileData"          , hidden: true   },
                       { label: "파일명",     name: "logicalFileNm"     , width: 500,    align: "left"  },
                       { label: "파일크기",   name: "fileSize"          , width: 100,    align: "right" }
                  ],
        rownumbers: false,
        multiselect: true,
        shrinkToFit: false,
        onSelectRow: function (rowId, status, e) {},
        loadComplete: function(data) {

            var ids = $("#" + grid_id).jqGrid('getDataIDs');

            for(var i=0;i < ids.length; i++){

                var rowId = ids[i];

                var rowData = $("#" + grid_id).getRowData(rowId);

                var loNewCol = {

                    logicalFileNm   : '<a title="파일을 다운로드 합니다" href="javascript:ksid.file[\'' + multiAttacher.config.refId + '\'].download(\'' + rowData.fileId + '\')">' + rowData.logicalFileNm + '</a>',
                    fileSize        : ksid.string.formatBitUnit(rowData.fileSize)

                };

                ksid.json.mergeObject(rowData, loNewCol);

                $("#" + grid_id).setRowData(rowId, rowData);

            }

        }

    });

    this.widget.view.loadGrid();

    var li_width = this.config.width;
    var li_height = this.config.height;

    $("#" + grid_id).jqGrid('setGridHeight', li_height);
    $("#" + grid_id).jqGrid('setGridWidth', li_width);

    if( this.config.editable == false ) {

        $('#btn_' + this.config.panelId + '_add').parent().hide();
        return;

    } else {

        $('#btn_' + this.config.panelId + '_add').parent().show();

    }

    //attacher(파일첨부) 생성 및 초기화
    var multiAttacher = this;

    var attacher = this.widget.attacher = new ksid.attacher();

    var callback = function(fileData) {
        multiAttacher.addFile(fileData);
    };

    attacher.init({dialogId: this.config.dialogId, compCd: this.config.compCd, userId: this.config.userId, batchTp:this.config.batchTp, uploadUrl:this.config.uploadUrl, store:this.config.store, callback: callback});

    //추가버튼 이벤트 설정
    $('#btn_' + this.config.panelId + '_add').click(function(){

        attacher.open();

    });

    $('#btn_' + this.config.panelId + '_del').click(function(){

        multiAttacher.removeFiles();

        //바로 삭제하게 세팅하였다면 db에 적용후 파일을 삭제한다.
        if(true == multiAttacher.config.delDirect) {

            var paramFiles = multiAttacher.getParamFiles(1);

              // 파일정보 param 생성 시작(첨부파일 그리드 갯수)
            var paramFiles = ksid.file.multi_attacher_01.getParamFiles(1);
            //     console.log('param_files', param_files);

            var paramsMulti = {};
            paramsMulti.param = JSON.stringify({"file":paramFiles});

            ksid.net.file(paramsMulti, function(result){

                doQuery();

            });

        }

    });

};

ksid.multiAttacher.prototype.attacherReInit = function() {

    //attacher(파일첨부) 생성 및 초기화
    var multiAttacher = this;

    var attacher = this.widget.attacher = new ksid.attacher();

    var callback = function(fileData) {
        multiAttacher.addFile(fileData);
    };

    attacher.init({dialogId: this.config.dialogId, compCd: this.config.compCd, userId: this.config.userId, batchTp:this.config.batchTp, uploadUrl:this.config.uploadUrl, store:this.config.store, callback: callback});

}

/**
 * 파일정보에 대해 파일레코드 패널을 추가한다
 *
 *      <div class="multi_attcher_record">
 *          <input type="checkbox" class="multi_attcher_rec_chk"/>
 *          <span class="multi_attcher_rec_file">파일이름</span>
 *      </div>
 */
ksid.multiAttacher.prototype.addFile = function(fileData) {

//    ksid.debug.map("fileData", fileData);

    this.files.push(fileData);

    this.refresh();

    this.getAllFiles();

};

/**
 * 파일정보 목록 추가
 */
ksid.multiAttacher.prototype.addFiles = function(fileDatas) {
     for(var i=0; i<fileDatas.length; i++) {
         this.addFile(fileDatas[i]);
     }
 };

/**
 * 소유파일 목록을 로드한다
 *  - loadConfig: {fileOwnerCd: BBS, fileOwnerKey1: "1"}
 *          optional: fileOwnerKey2, fileOwnerKey3, fileOwnerType, fileOwnerRef
 */
ksid.multiAttacher.prototype.loadStore = function(loadConfig) {

    this.clearStore();
    var multiAttacher = this;
    var queryUrl = this.config.ownerFilesUrl;
    $.ajax(
        {
            type: 'POST',
            url: queryUrl,
            data: loadConfig,
            dataType: "json",
            async: true,
            success : function(result) {

//                console.log('loadStore > result', result);

                if(result.resultCd == "00") {

                    multiAttacher.config.store = loadConfig;

                    multiAttacher.files = ksid.json.cloneObject(result.resultData);
                    multiAttacher.refresh();

                } else {

                    ksid.ui.alert(result.resultMsg+":"+result.resultCd);

                }

            },
            error: function() {
                ksid.ui.alert("소유첨부 조회중 통신오류가 발생하였습니다");
            }
        }
    );

 };


/**
 * 모든 파일정보를 초기화 한다
 */
ksid.multiAttacher.prototype.clearStore = function() {

    this.config.store = null;

    this.files = [];
    this.deletedFiles = [];

    this.widget.view.initGridData();

};

/**
 * 전체파일 삭제처리
 */
ksid.multiAttacher.prototype.removeAllFiles = function() {

    for( var i = this.files.length - 1 ; i >= 0 ; i-- ) {

        lo_file_data = this.files[i];

        //승인된 파일 삭제시 삭제 버퍼에 삭제 플래그를 Y로 해서 옮긴다
        if( lo_file_data.approvalYn == "Y" ) {

            lo_file_data.delYn = "Y";

            this.deletedFiles.push(ksid.json.cloneObject(lo_file_data));

        }

    }

    this.files = [];

};

/**
 * 선택된 파일정보 및 파일레코드 패널 삭제
 *      - 승인된 파일은 삭제플래그 처리해서 삭제버퍼에 저장
 */
ksid.multiAttacher.prototype.removeFiles = function(fileData) {

    var chks = $('input[type="checkbox"]:checked', this.widget.view);

    var rowsId = $( "#" + this.widget.gridId ).jqGrid('getGridParam', 'selarrrow');

    if( rowsId.length < 1 ) {
        ksid.ui.alert("삭제할 파일을 선택하세요");
        return;
    }

    var lo_checked      = null;
    var ls_file_id      = null;
    var lo_file_data    = null;

    // 체크박스에 체크한 목록을 loop 돌린다.
    for (var i = 0; i < rowsId.length; i++) {

        lo_checked = $( "#" + this.widget.view.id ).jqGrid('getRowData', rowsId[i]);

        ls_file_id = lo_checked.fileId.toString();

        // 배열에서 해당 index 를 삭제하기때문에 꺼꾸로 돌려야 한다.
        // 중간에서 삭제되면 index가 밀려서 이상현상이 발생하기 때문이다.
        for( var j = this.files.length - 1 ; j >= 0 ; j-- ) {

            lo_file_data = this.files[j];

            // 체크된 목록의 fileId에 해당 하는 파일을 가져온다.
            if( lo_file_data.fileId.toString() == ls_file_id ) {

              //승인된 파일 삭제시 삭제 버퍼에 삭제 플래그를 Y로 해서 옮긴다
                if( lo_file_data.approvalYn == "Y" ) {

                    lo_file_data.delYn = "Y";

                    this.deletedFiles.push(ksid.json.cloneObject(lo_file_data));

                }

                this.files.splice(j, 1);

            }

        }

    }

    this.refresh();

};

ksid.multiAttacher.prototype.refresh = function() {

    this.widget.view.showLoading();
    this.widget.view.bindGrid(this.files);

};

/**
 * 삭제버퍼 및 파일목로을 모두 반환한다
 */
ksid.multiAttacher.prototype.getAllFiles = function() {

    var allFiles = ksid.json.cloneObject(this.files);

    for(var i=0; i<this.deletedFiles.length; i++) {

        allFiles[allFiles.length] = this.deletedFiles[i];
    }

    return allFiles;
};

/**
 * 파일 다운로드
 */
ksid.multiAttacher.prototype.download = function(as_file_id) {

    var fileData = null;

    for (var i = 0; i < this.files.length; i++) {


        if( this.files[i].fileId.toString() == as_file_id ) {

            fileData = this.files[i];
            break;

        }

    }

    if( fileData == null ) {

        ksid.ui.alert("파일이 존재하지 않습니다.");
        return;

    }

    ksid.form.bindPanel("form_ksid_file_download", fileData);

//    ksid.debug.printObj(fileData);

    $("#form_ksid_file_download").submit();
};

/**
 * 객체 복사, 소스에 정의되지 않았으면 복사하지 않음
 *      - private
 */
ksid.multiAttacher.prototype.copyProps = function(target, source) {
    for(name in target) {
        var value = source[name];
        //ksid.ui.alert(name+":"+target[name] +"===>" + source[name]+","+(typeof value == 'undefined'));
        //정의된 데이터만 복사
        if(typeof value != 'undefined') {
            target[name] = value;
        }
    }
};

/**
 * file모듈 넓이 resize
 */
ksid.multiAttacher.prototype.fileWidthResize = function(width, num) {

    var fileGrid = 0;
    if(!num){
        fileGrid = 2;
    }else{
        fileGrid = num+1;
    }

    for(var i = 1; i < fileGrid; i++) {

        //버튼 위치 변경
        $("#file_0"+i).css("width",width+"px");
        //그리드 리싸이징
        $("#grid_file_upload_0"+i).jqGrid('setGridWidth', width);
    }
};

ksid.multiAttacher.prototype.getParamFiles = function(cntFiles) {
    var param_files = [];
    for (var idx_files = 1; idx_files <= cntFiles; idx_files++) {
        if( ksid.file["multi_attacher_0" + idx_files].config.store == null ) {
            alert("store [0" + idx_files + "] 파일에 대한 정보키가 존재하지 않습니다");
            return;
        }
        var lor_files = ksid.file["multi_attacher_0" + idx_files].getAllFiles();
        for (var i = 0; i < lor_files.length; i++) {
            ksid.json.mergeObject(lor_files[i], ksid.file["multi_attacher_0" + idx_files].config.store);
        }
        param_files.push(lor_files);
    }
    return param_files;
}
