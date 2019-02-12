/**
 * 파일첨부
 *      - 지정된 div 를 dialog 를 사용하여 파일을 첨부하는 기능으로 작성
 *      stylesheet
 *          jquery-ui-1.10.4.custom.css
 *      js
 *          jquery-1.7.1.min.js
 *          jquery.form.js
 *          json3.min.js
 *          jquery-ui-1.10.3.custom.js
 *
 * @author 염국선
 * @since 2014.11.18
 */

if(!window.ksid) {
    ksid = new Object();
}

//unique id generrator
if(!window.ksid.idgen) {
    ksid.idgen = new Object();
    ksid.idgen.id = 1;
    ksid.idgen.next = function() {
        return this.id++;
    };
}


/**
 * 파일처부를 위한  object 선언
 */
ksid.attacher = function() {
    //초기화를 위한 configure
    this.config = new ksid.attacher.prototype.configModel();
    //생성된 widget
    this.widget = new ksid.attacher.prototype.widgetgModel();
};

/**
 * initialized configure
 *      - 기본값 정의, 사용자에 의해서 변경
 */
ksid.attacher.prototype.configModel = function() {
    this.dialogId = null;   //user define, required
    this.compCd = null;     //user define, optional, 서블릿에서 기본값 처리
    this.userId = null;     //user define, optional, 세션을 사용할 경우 서블릿에서 처리
    this.batchTp = null;    //batch 유형
    this.callback = null;   //user define, required, 승인전 파일정보를 받아 저장하고 관련 데이터 저장시 승인시킴
    this.uploadUrl = null;  // upload url
    this.store = {};      // 직접저장시 store 정보
    this.id = ksid.idgen.next();
    this.formId = "attacherForm" + this.id;
};

/**
 * 생성된 widget 보관
 */
ksid.attacher.prototype.widgetgModel = function() {
    this.panel = null;    //외곽패널(dialog)
    this.form = null;     //multipart form
    this.compCd = null;   //input compCd
    this.userId = null;   //input userId
    this.batchTp = null;  // batch 유형
    this.file = null;     //input file
    this.fakeFile = null; //input fake
    this.mask = null;     //waiting mask panel
};

/**
 * 초기화
 */
ksid.attacher.prototype.init = function(config) {

    //설정된 정보를 읽어서 저장, 설정하지 않은 값은 기본값으로 사용(ksid.attacher.prototype.configModel)
//    this.copyProps();
    ksid.json.mergeObject(this.config, config);

    $('#'+this.config.dialogId).children().remove();

    //dialog 생성
    $(this.widget.panel = $('#'+this.config.dialogId).css("overflow","hidden").get(0)).dialog({
        //autoOpen : false,
        closed: true,
        modal : true,
        width : 270,
        height: 130,
        resizable : false
    });

    //존재하지 않는 dialog id 인지 확인
    if(!this.widget.panel) {
        ksid.ui.alert("dialog id가 존재하지 않아 attacher를  초기화 하지 못하였습니다.:"+this.config.dialogId);
        return;
    }

    //첨부파일 전송을 위한 multipart form 생성 및 이벤트 설정
    this.drawLayout();

    //dialog 객체에서 참조하기 위해 선언
    var conf = this.config;

    //multipart form submit시 처리이벤트, 전송후 결과값을 json형태로 받아 오류확이니하고 callback에 성공된 파일정보 넘겨줌
    $('#'+this.config.formId).ajaxForm(
        {
            // 반환할 데이터의 타입. 'json'으로 하면 IE 에서만 제대로 동작하고 크롬, FF에서는 응답을 수신하지 못함
            dataType : 'json',
            // form을 직렬화하기전 엘레먼트의 속성을 수정
            beforeSerialize: function() {},
            beforeSubmit : function() {
                var fileLoc = $('#'+conf.dialogId + ' input[name="file"]').val();
                if(fileLoc == "") {
                    ksid.ui.alert("첨부할 파일을 선택하세요");
                    return false;
                }

                //loading mask show
                $('#'+conf.dialogId + ' div[class="loading"]').show();
            },
            // 크롬, FF에서 반환되는 데이터(String)에는 pre 태그가 쌓여있으므로
            // 정규식으로 태그 제거. IE의 경우 정상적으로 값이 반환된다.
            //data = data.replace(/[<][^>]*[>]/gi, '');
            success : function(result) {
//                console.log('ajaxForm > result', result);
                //loading mask hide
                $('#'+conf.dialogId + ' div[class="loading"]').hide();
                if(result.resultCd == "00") {
                    console.log('conf.dialogId', conf.dialogId);
                    conf.callback(result.resultData[0]);
                } else {
                    ksid.ui.alert(result.resultCd+":"+result.resultMsg);
                }
                $('#'+conf.dialogId).dialog("close");
            },
            error: function(data){
                //loading mask hide
                $('#'+conf.dialogId + ' div[class="loading"]').hide();
                $('#'+conf.dialogId).dialog("close");
                ksid.ui.alert("파일은 20 MByte 를 초과할 수 없습니다");
            }
        }
    );

    console.log('attacher.config', this.config);

};

/**
 * 첨부파일 전송을 위한 multipart form 생성 및 이벤트 설정
 *      - multipart form 생성, text input 및 img 를 그리고 그위에 file input을 투명하게 처리하는 스타일 적용
 *      - fake input 및 fake img의 크기와 투명처리된 file input 의 크기를 같게한다
 *      - private
 *
 *  <form id="formId" method="POST" enctype="multipart/form-data"' action="/upload.do">
 *      <input type="hidden" name="compCd">
 *      <input type="hidden" name="userId">
 *      <input type="hidden" name="batchTp">
 *      <div class="attacher_file_wrap">
 *          <input type="file" name="file" class="attacher_file" />
 *          <div class="attacher_fake_wrap">
 *              <input type"text" class="attacher_fake_input" />
 *              <img class="attacher_fake_search" />
 *          </div>
 *      </div>
 *      <div class="attacher_buttons">
 *          <input type="button" class="attacher_submit" value="전송">
 *          <input type="button" class="attacher_cancel" value="취소">
 *
 *      </div>
 *  </form>
 *  <div class="loading">
 *      <div class="loading-indicator">
 *          <img src="/resources/images/loading.gif" width="32" height="32"/><br />
 *          <span class="loading-msg"> Uploading...</span>
 *      </div>
 *  </div>
 */
ksid.attacher.prototype.drawLayout = function() {

    console.log('drawLayout > config', this.config);

    //패널 - dialog
     var panel = this.widget.panel;

    //form 생성
    var form = this.widget.form = document.createElement("form");
    form.id = this.config.formId;
    form.method = "POST";
    form.enctype = "multipart/form-data";
    form.action = this.config.uploadUrl;
    panel.appendChild(form);

    //compCd input hidden 생성
    this.widget.compCd = document.createElement("input");
    this.widget.compCd.type = "hidden";
    this.widget.compCd.name = "compCd";
    if(this.config.compCd != null) { this.widget.compCd.value = this.config.compCd };
    this.widget.form.appendChild(this.widget.compCd);

    //userId input hidden 생성
    this.widget.userId = document.createElement("input");
    this.widget.userId.type = "hidden";
    this.widget.userId.name = "userId";
    if(this.config.userId != null) { this.widget.userId.value = this.config.userId };
    this.widget.form.appendChild(this.widget.userId);

    //batchTp input hidden 생성
    this.widget.batchTp = document.createElement("input");
    this.widget.batchTp.type = "hidden";
    this.widget.batchTp.name = "batchTp";
    if(this.config.batchTp != null) { this.widget.batchTp.value = this.config.batchTp };
    this.widget.form.appendChild(this.widget.batchTp);

    for (var key in this.config.store) {

        console.log('key', key);
        console.log('this.config.store[key]', this.config.store[key]);

        var widgetAppend = document.createElement("input");
        widgetAppend.type = "hidden";
        widgetAppend.name = key;
        widgetAppend.value = this.config.store[key];

        this.widget.form.appendChild(widgetAppend);

    }

    console.log('this.config.store', this.config.store);

    //file panel
    var filePanel = document.createElement("div");
    filePanel.className = "attacher_file_wrap";
    this.widget.form.appendChild(filePanel);

    //input file 생성
    var file = this.widget.file = document.createElement("input");
    file.type = "file";
    file.name = "file";
    file.className = "attacher_file";
    filePanel.appendChild(file);

    //fake panel
    var fakePanel = document.createElement("div");
    fakePanel.className = "attacher_fake_wrap";
    filePanel.appendChild(fakePanel);

    var fakeFile = this.widget.fakeFile = document.createElement("input");
    fakeFile.type = "text";
    fakeFile.className = "attacher_fake_input";
    fakePanel.appendChild(fakeFile);

    var fakeImg = document.createElement("img");
    fakeImg.className = "attacher_fake_search";
    fakePanel.appendChild(fakeImg);

    //버튼패널 생성
    var buttonBar = document.createElement("div");
    buttonBar.className = "attacher_buttons";
    this.widget.form.appendChild(buttonBar);

    //전송버튼 생성
    var submitBtn = document.createElement("input");
    submitBtn.type = "button";
    submitBtn.value = "전송";
    submitBtn.className = "attacher_submit";
    buttonBar.appendChild(submitBtn);

    //취소버튼 생성
    var cancelBtn = document.createElement("input");
    cancelBtn.type = "button";
    cancelBtn.value = "취소";
    cancelBtn.className = "attacher_cancel";
    buttonBar.appendChild(cancelBtn);


    //waiting panel 생성
    var maskHtml =
            '<div class="loading-indicator">' +
            '   <img src="/static/image/ksid/loading.gif" width="32" height="32"/><br />' +
            '   <span class="loading-msg"> Uploading...</span>' +
            '</div>';
    this.widget.mask = document.createElement("div");
    this.widget.mask.className = "loading";
    this.widget.mask.innerHTML = maskHtml;
    this.widget.panel.appendChild(this.widget.mask);


    //fake input 및 fake img의 크기와 투명처리된 file input 의 크기를 같게한다
    //html이 완전히 그려지기 전이므로 css에서 fake input 및 fake img 의 폭을 정한다
    //var fakeInputWidth = $('#'+this.config.dialogId + ' .attacher_fake_input').width();
    //var fakeImgWidth = $('#'+this.config.dialogId + ' .attacher_fake_search').width();
    //$('#'+this.config.dialogId + ' input[class="attacher_fake_input"]').width(fakeInputWidth + fakeImgWidth);

    //파일선택이 변경되면(투명처리) fake input 에서 값을 보여주기 위한 이벤트 설정
    $(file).change(function() {
        var fullname = $(file).val();
        var filename = "";
        //파일분리자가 \ 이거나 / 인 경우 체크하여 파일이름만 처리한다
        if(fullname.indexOf("\\") > 0) {
            filename = fullname.split("\\").pop();
        } else if(fullname.indexOf("/")) {
            filename = fullname.split("/").pop();
        } else { //크롬등은 경로없음
            filename = fullname;
        }
        $(fakeFile).val(filename);
    });

    //전송버튼 이벤트 설정
    $(submitBtn).click(function() {
        $(form).submit();
    });

    //취소버튼 이벤트 설정
    $(cancelBtn).click(function() {
        $(panel).dialog("close");
    });

};

/**
 * 첨부를 위한 dialog show
 */
ksid.attacher.prototype.open = function() {

    this.widget.file.value = "";

    console.log('this.widget', this.widget);

    //dialog open
    $(this.widget.panel).dialog("open");
};

/**
 * 객체 복사, 소스에 정의되지 않았으면 복사하지 않음
 *      - private
 */
ksid.attacher.prototype.copyProps = function(target, source) {
    for(name in target) {
        var value = source[name];
        //ksid.ui.alert(name+":"+target[name] +"===>" + source[name]+","+(typeof value == 'undefined'));
        //정의된 데이터만 복사
        if(typeof value != 'undefined') {
            target[name] = value;
        }
    }
};
