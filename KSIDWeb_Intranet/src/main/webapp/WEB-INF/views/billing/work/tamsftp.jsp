<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// TAM SFTP Client 데이터정보 json
var newJson1 = {};

// TAM SFTP Client 데이터리스트 grid
var grid1 = null;
var grid2 = null;


/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModelLocal = [];
    colModelLocal.push({ label:'파일명', name:'fileNm', format:'string', width:200 });
    colModelLocal.push({ label:'크기(Bytes)', name:'fileSz', format:'number', width:150 });
    colModelLocal.push({ label:'수정일시', name:'fileDtm', format:'dttm', width:150 });

    var gridProp = {};
    gridProp.colModel = colModelLocal;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid1.setClickedProp(rowId);

        var rowData = grid1.clickedRowData;
        $("#local-edit-panel input[name=localFile]").val(rowData.fileNm);
    }
    //Local 리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();


    var colModelRemote = [];
    colModelRemote.push({ label:'파일명', name:'fileNm', format:'string', width:200 });
    colModelRemote.push({ label:'파일정보', name:'longNm', width:400 });

    var gridProp = {};
    gridProp.colModel = colModelRemote;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid2.setClickedProp(rowId);

        var rowData = grid2.clickedRowData;
        $("#remote-edit-panel input[name=remoteFile]").val(rowData.fileNm);
    }
    //Remote 리스트 그리드 생성
    grid2 = new ksid.grid("grid2", gridProp);
    grid2.loadGrid();

    searchpanelComboAjaxAfterDoQuery();
}

function searchpanelComboAjaxAfterDoQuery() {

    var params;

    ksid.net.ajax("${pageContext.request.contextPath}/billing/work/sftp/serverFtpList", params, function(result) {
        if(result.resultCd == "00" && result.resultData.length > 0) {
            for(i=0; i < result.resultData.length; i++) {
                if(result.resultData[i].codeCd == "HOST") {
                    $('#search-panel input[name=host]').val(result.resultData[i].codeNm);
                } else if(result.resultData[i].codeCd == "PORT") {
                    $('#search-panel input[name=port]').val(result.resultData[i].codeNm);
                } else if(result.resultData[i].codeCd == "USERID") {
                    $('#search-panel input[name=userName]').val(result.resultData[i].codeNm);
                } else if(result.resultData[i].codeCd == "PASSWORD") {
                    $('#search-panel input[name=password]').val(result.resultData[i].codeNm);
                }

            }
        }
    });

    ksid.net.ajax("${pageContext.request.contextPath}/billing/work/sftp/tamFileDirList", params, function(result) {
        if(result.resultCd == "00" && result.resultData.length > 0) {
            for(i=0; i < result.resultData.length; i++) {
                if(result.resultData[i].codeCd == "PC_TAM_DIR") {
                    $("#local-edit-panel input[name=localDir]").val(result.resultData[i].codeNm);
                } else if(result.resultData[i].codeCd == "SERVER_TAM_DIR") {
                    $("#remote-edit-panel input[name=remoteDir]").val(result.resultData[i].codeNm);
                }
            }
        }
    });

    $("#local-edit-panel input[name=localFile]").val("");
    $("#remote-edit-panel input[name=remoteFile]").val("");
}


/*****************************************************
* 함수명 : Local PC의 파일 목록 조회
* 설명   :
*****************************************************/
function doLocalFile(resultMsg) {

    $("#local-edit-panel input[name=localFile]").val("");

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");
    params.dir = $("#local-edit-panel input[name=localDir]").val();

    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/work/sftp/fileList"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            if(result.resultCd == "00") {
                CommonJs.setStatus( ksid.string.replace( "Local 파일 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
            } else {
                CommonJs.setStatus( "Local 디렉토리 조회 작업이 실패했습니다." );
            }
        }

    });

}


/*****************************************************
* 함수명 : Remote 서버의 파일 목록 조회
* 설명   :
*****************************************************/
function doRemoteFile(resultMsg) {

    $("#remote-edit-panel input[name=remoteFile]").val("");

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");
    console.log(params);
    params.dir = $("#remote-edit-panel input[name=remoteDir]").val();

    ksid.net.ajaxJqGrid(grid2
                      , "${pageContext.request.contextPath}/billing/work/sftp/getFileList"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            if(result.resultCd == "00") {
                CommonJs.setStatus( ksid.string.replace( "Remote 파일 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
            } else {
                CommonJs.setStatus( "Remote 디렉토리 조회 작업이 실패했습니다." );
            }
        }

    });

}


/*****************************************************
* 함수명 : Local/Remote 서버의 파일 목록 조회
* 설명   :
*****************************************************/
function doQuery()
{
    doLocalFile();
    doRemoteFile();
}


/*****************************************************
* 함수명 : Remote 서버로 파일 업로드
* 설명   :
*****************************************************/
function doUpload() {

    if(grid1.clickedRowData == null) {
        ksid.ui.alert("선택한 Local 파일이 없습니다.<br />UPLOAD 파일을 선택하세요.");
        return;
    }

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");
    params.dir    = $("#remote-edit-panel input[name=remoteDir]").val().trim();
    params.upFile = $("#local-edit-panel input[name=localDir]").val().trim() + "/" + grid1.clickedRowData.fileNm;

    ksid.ui.confirm("Remote 서버로 파일을 UPLOAD 하시겠습니까?"+ "\n파일명:" + params.upFile, function() {
        ksid.net.ajax("${pageContext.request.contextPath}/billing/work/sftp/upload", params, function(result) {
            if(result.resultCd == "00") {
                var msg2 = ksid.string.replace( "파일 {0}이 성공적으로 UPLOAD 되었습니다.", "{0}", params.upFile );
                //CommonJs.setStatus( ksid.string.replace( "파일 {0}이 성공적으로 UPLOAD 되었습니다.", "{0}", params.upFile ) );
                doRemoteFile(msg2);
            } else {
                CommonJs.setStatus( ksid.string.replace( "파일 {0}의 UPLOAD 작업이 실패했습니다..", "{0}", params.upFile ) );
                ksid.ui.alert("UPLOAD 작업이 실패했습니다."+ "\n파일명:" + params.upFile);
            }

        });
    });

}


/*****************************************************
* 함수명 : Remote 서버로 디렉토리 업로드
* 설명   :
*****************************************************/
function doUploadDir() {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");
    params.localDir  = $("#local-edit-panel input[name=localDir]").val().trim();
    params.remoteDir = $("#remote-edit-panel input[name=remoteDir]").val().trim();

    if(params.localDir.length == null) {
        ksid.ui.alert("Local 디렉토리를 입력하세요.");
        return;
    }

    if(params.remoteDir.length == null) {
        ksid.ui.alert("Remote 디렉토리를 입력하세요.");
        return;
    }

    var msg1 = "Local 디렉토리의 파일들을 UPLOAD 하시겠습니까?"
            + "\nLocal 디렉토리: " + params.localDir
            + "\nRemote 디렉토리: " + params.remoteDir;

    ksid.ui.confirm(msg1, function() {
        ksid.net.ajax("${pageContext.request.contextPath}/billing/work/sftp/uploadFolder", params, function(result) {
            if(result.resultCd == "00") {
                var msg2=ksid.string.replace( "디렉토리 {0}이 성공적으로 UPLOAD 되었습니다.", "{0}", params.localDir );
                //CommonJs.setStatus( ksid.string.replace( "디렉토리 {0}이 성공적으로 UPLOAD 되었습니다.", "{0}", params.localDir ) );
                doRemoteFile(msg2);
            } else {
                CommonJs.setStatus( ksid.string.replace( "디렉토리 {0}의 UPLOAD 작업이 실패했습니다..", "{0}", params.localDir ) );
                ksid.ui.alert("UPLOAD 작업이 실패했습니다."+ "\n디렉토리:" + params.localDir);
            }

        });

    });

}


/*****************************************************
* 함수명 : Local PC로 파일 다운로드
* 설명   :
*****************************************************/
function doDownload() {

    if(grid2.clickedRowData == null) {
        ksid.ui.alert("선택한 Remote 파일이 없습니다.<br />DOWNLOAD 파일을 선택하세요.");
        return;
    }

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");
    params.dir      = $("#remote-edit-panel input[name=remoteDir]").val().trim();
    params.fileName = grid2.clickedRowData.fileNm;
    params.saveDir  = $("#local-edit-panel input[name=localDir]").val().trim() + "/" + grid2.clickedRowData.fileNm;

    ksid.ui.confirm("Local PC로 파일을 DOWNLOAD 하시겠습니까?"+ "\n파일명:" + params.fileName, function() {
        ksid.net.ajax("${pageContext.request.contextPath}/billing/work/sftp/download", params, function(result) {
            if(result.resultCd == "00") {
                var msg2=ksid.string.replace( "파일 {0}이 성공적으로 DOWNLOAD 되었습니다.", "{0}", params.fileName );
                //CommonJs.setStatus( ksid.string.replace( "파일 {0}이 성공적으로 DOWNLOAD 되었습니다.", "{0}", params.fileName ) );
                doLocalFile(msg2);
            } else {
                CommonJs.setStatus( ksid.string.replace( "파일 {0}의 DOWNLOAD 작업이 실패했습니다..", "{0}", params.fileName ) );
                ksid.ui.alert("DOWNLOAD 작업이 실패했습니다." + "\n파일명:" + params.fileName);
            }
        });
    });

}


/*****************************************************
* 함수명 : Remote 폴더의 모든 파일을 Local 폴더로 다운로드
* 설명   :
*****************************************************/
function doDownloadFolder() {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");
    params.localDir  = $("#local-edit-panel input[name=localDir]").val().trim();
    params.remoteDir = $("#remote-edit-panel input[name=remoteDir]").val().trim();

    if(params.localDir.length == null) {
        ksid.ui.alert("Local 디렉토리를 입력하세요.");
        return;
    }

    if(params.remoteDir.length == null) {
        ksid.ui.alert("Remote 디렉토리를 입력하세요.");
        return;
    }

    var msg1 = "Remote 디렉토리의 파일들을 DOWNLOAD 하시겠습니까?"
            + "\nLocal 디렉토리: " + params.localDir
            + "\nRemote 디렉토리: " + params.remoteDir;

    ksid.ui.confirm(msg1, function() {
        ksid.net.ajax("${pageContext.request.contextPath}/billing/work/sftp/downloadFolder", params, function(result) {
            if(result.resultCd == "00") {
                var msg2=ksid.string.replace( "디렉토리 {0}이 성공적으로 DOWNLOAD 되었습니다.", "{0}", params.remoteDir ) ;
                //CommonJs.setStatus( ksid.string.replace( "디렉토리 {0}이 성공적으로 DOWNLOAD 되었습니다.", "{0}", params.remoteDir ) );
                doLocalFile(msg2);
            } else {
                CommonJs.setStatus( ksid.string.replace( "디렉토리 {0}의 DOWNLOAD 작업이 실패했습니다..", "{0}", params.remoteDir ) );
                ksid.ui.alert("DOWNLOAD 작업이 실패했습니다."+ "\n디렉토리:" + params.remoteDir);
            }

        });

    });

}



/*****************************************************
* 함수명 : Local 파일 삭제
* 설명   :
*****************************************************/
function doDelLocalFile() {

    if(grid1.clickedRowData == null) {
        ksid.ui.alert("선택한 Local 파일이 없습니다.<br />Delete 파일을 선택하세요.");
        return;
    }

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");
    params.dir      = $("#local-edit-panel input[name=localDir]").val().trim();
    params.fileName = grid1.clickedRowData.fileNm;

    ksid.ui.confirm("Local 파일을 DELETE 하시겠습니까?"+ "\n파일명:" + params.fileName, function() {
        ksid.net.ajax("${pageContext.request.contextPath}/billing/work/sftp/rmLocalFile", params, function(result) {
            if(result.resultCd == "00") {
                var msg2=ksid.string.replace( "파일 {0}이 성공적으로 DELETE 되었습니다.", "{0}", params.fileName );
                //CommonJs.setStatus( ksid.string.replace( "파일 {0}이 성공적으로 DELETE 되었습니다.", "{0}", params.fileName ) );
                doLocalFile(msg2);
            } else {
                CommonJs.setStatus( ksid.string.replace( "파일 {0}의 DELETE 작업이 실패했습니다..", "{0}", params.fileName ) );
                ksid.ui.alert("DELETE 작업이 실패했습니다." + "\n파일명:" + params.fileName);
            }
        });
    });

}


/*****************************************************
* 함수명 : Remote 파일 삭제
* 설명   :
*****************************************************/
function doDelRemoteFile() {

    if(grid2.clickedRowData == null) {
        ksid.ui.alert("선택한 Remote 파일이 없습니다.<br />Delete 파일을 선택하세요.");
        return;
    }

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");
    params.dir      = $("#remote-edit-panel input[name=remoteDir]").val().trim();
    params.fileName = grid2.clickedRowData.fileNm;

    ksid.ui.confirm("Remote 파일을 DELETE 하시겠습니까?"+ "\n파일명:" + params.fileName, function() {
        ksid.net.ajax("${pageContext.request.contextPath}/billing/work/sftp/rmFile", params, function(result) {
            if(result.resultCd == "00") {
                var msg2=ksid.string.replace( "파일 {0}이 성공적으로 DELETE 되었습니다.", "{0}", params.fileName ) ;
                //CommonJs.setStatus( ksid.string.replace( "파일 {0}이 성공적으로 DELETE 되었습니다.", "{0}", params.fileName ) );
                doRemoteFile(msg2);
            } else {
                CommonJs.setStatus( ksid.string.replace( "파일 {0}의 DELETE 작업이 실패했습니다..", "{0}", params.fileName ) );
                ksid.ui.alert("DELETE 작업이 실패했습니다." + "\n파일명:" + params.fileName);
            }
        });
    });

}


/*****************************************************
* 함수명 : Local 파일 이름 변경
* 설명   :
*****************************************************/
function doRenameLocalFile() {

    if(grid1.clickedRowData == null) {
        ksid.ui.alert("선택한 Local 파일이 없습니다.<br />변경할 파일을 선택하세요.");
        return;
    }

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");
    params.dir       = $("#local-edit-panel input[name=localDir]").val().trim();
    params.oldFileNm = grid1.clickedRowData.fileNm;
    params.newFileNm = $("#local-edit-panel input[name=localFile]").val().trim();

    if(params.oldFileNm == params.newFileNm) {
        ksid.ui.alert("신규 파일명이 기존 파일명과 동일합니다..<br />신규 파일명을 입력하세요." + "\n파일명:" + params.oldFileNm);
        $("#local-edit-panel input[name=localFile]").focus();
        return;
    }

    ksid.ui.confirm("Local 파일을 RENAME 하시겠습니까?"+ "\n기존 파일명:" + params.oldFileNm+ "\n신규 파일명:" + params.newFileNm, function() {
        ksid.net.ajax("${pageContext.request.contextPath}/billing/work/sftp/renameLocalFile", params, function(result) {
            if(result.resultCd == "00") {
                var msg2=ksid.string.replace( "파일 {0}으로 성공적으로 RENAME 되었습니다.", "{0}", params.newFileNm );
                //CommonJs.setStatus( ksid.string.replace( "파일 {0}으로 성공적으로 RENAME 되었습니다.", "{0}", params.newFileNm ) );
                doLocalFile(msg2);
            } else {
                CommonJs.setStatus( ksid.string.replace( "파일 {0}의 RENAME 작업이 실패했습니다..", "{0}", params.fileName ) );
                ksid.ui.alert("RENAME 작업이 실패했습니다." + "\n기존 파일명:" + params.oldFileNm+ "\n신규 파일명:" + params.newFileNm);
            }
        });
    });

}


/*****************************************************
* 함수명 : Remote 파일 이름 변경
* 설명   :
*****************************************************/
function doRenameRemoteFile() {

    if(grid2.clickedRowData == null) {
        ksid.ui.alert("선택한 Remote 파일이 없습니다.<br />변경할 파일을 선택하세요.");
        return;
    }

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");
    params.dir       = $("#remote-edit-panel input[name=remoteDir]").val().trim();
    params.oldFileNm = grid2.clickedRowData.fileNm;
    params.newFileNm = $("#remote-edit-panel input[name=remoteFile]").val().trim();

    if(params.oldFileNm == params.newFileNm) {
        ksid.ui.alert("신규 파일명이 기존 파일명과 동일합니다..<br />신규 파일명을 입력하세요." + "\n파일명:" + params.oldFileNm);
        $("#remote-edit-panel input[name=remoteFile]").focus();
        return;
    }

    ksid.ui.confirm("Remote 파일을 RENAME 하시겠습니까?"+ "\n기존 파일명:" + params.oldFileNm+ "\n신규 파일명:" + params.newFileNm, function() {
        ksid.net.ajax("${pageContext.request.contextPath}/billing/work/sftp/renameFile", params, function(result) {
            if(result.resultCd == "00") {
                var msg2=ksid.string.replace( "파일 {0}으로 성공적으로 RENAME 되었습니다.", "{0}", params.newFileNm ) ;
                //CommonJs.setStatus( ksid.string.replace( "파일 {0}으로 성공적으로 RENAME 되었습니다.", "{0}", params.newFileNm ) );
                doRemoteFile(msg2);
            } else {
                CommonJs.setStatus( ksid.string.replace( "파일 {0}의 RENAME 작업이 실패했습니다..", "{0}", params.fileName ) );
                ksid.ui.alert("RENAME 작업이 실패했습니다." + "\n기존 파일명:" + params.oldFileNm+ "\n신규 파일명:" + params.newFileNm);
            }
        });
    });

}


</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">작업관리</span> > <span name="menu">TAM SFTP Client</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt name="title"><label for="">호스트(H)</label></dt>
                <dd>
                    <input type="text" class="style-input width120" name="host" maxlength="128" title="호스트" value="192.168.2.100" required />
                </dd>
                <dt name="title"><label for="">포트번호(O)</label></dt>
                <dd>
                    <input type="text" class="style-input width50" name="port" maxlength="6" title="포트번호" value="1458" required />
                </dd>

                <dt name="title"><label for="">사용자이름(U)</label></dt>
                <dd>
                    <input type="text" class="style-input width120" name="userName" maxlength="64" title="사용자이름" value="manager" required />
                </dd>
                <dt name="title"><label for="">암호(P)</label></dt>
                <dd>
                    <input type="password" class="style-input width120" name="password" maxlength="64" title="암호" value="ksid@2017" required />
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">Local/Remote 조회</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->

    <div class="variableWrapCode">
        <!-- 왼쪽 컨텐츠  -->
        <div class="fLeft">
            <h3 class="style-title"><span name="title">Local 파일 리스트</span></h3>

            <div class="edit-panel">
                <div id="local-edit-panel" class="styleDlTable">
                    <dl>
                        <dt name="title" class="title_on width60"><label for="">디렉토리</label></dt>
                        <dd class="width240">
                            <input type="text" maxlength="120" class="style-input" style="width:240px;" name="localDir" value="C://billfiles//tamfiles" title="디렉토리" required />
                        </dd>
                        <dt name="title" class="title_on width70"><label for="">신규파일명</label></dt>
                        <dd class="width160">
                            <input type="text" maxlength="120" class="style-input" style="width:160px;" name="localFile" title="신규파일명" required />
                        </dd>
                    </dl>
                </div>

                <!--  button bar  -->
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="W" onclick="doLocalFile()">Refresh</button>
                    <button type="button" class="style-btn" auth="W" onclick="doUpload()">File Upload</button>
                    <button type="button" class="style-btn" auth="W" onclick="doUploadDir()">Folder Upload</button>
                    <button type="button" class="style-btn" auth="W" onclick="doDelLocalFile()">Delete</button>
                    <button type="button" class="style-btn" auth="W" onclick="doRenameLocalFile()">Rename</button>
                </div>

            </div>

            <!-- 그리드 시작 -->
            <table id="grid1" ></table>
            <!-- 그리드 끝 -->

        </div>
        <!--// 왼쪽 컨텐츠  -->

        <!-- 오른쪽 컨텐츠  -->
        <div class="fRight">
           <h3 class="style-title"><span name="title">Remote 파일 리스트</span></h3>

            <div class="edit-panel">
                <div id="remote-edit-panel" class="styleDlTable">
                    <dl>
                        <dt name="title" class="title_on width60"><label for="">디렉토리</label></dt>
                        <dd class="width240">
                            <input type="text" maxlength="120" class="style-input" style="width:240px;" name="remoteDir" value="/domain/files/tamfiles/" title="디렉토리" required />
                        </dd>
                        <dt name="title" class="title_on width70"><label for="">신규파일명</label></dt>
                        <dd class="width160">
                            <input type="text" maxlength="120" class="style-input" style="width:160px;" name="remoteFile" title="신규파일명" required />
                        </dd>
                    </dl>
                </div>
                <!--  button bar  -->
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="W" onclick="doRemoteFile()">Refresh</button>
                    <button type="button" class="style-btn" auth="W" onclick="doDownload()">File Download</button>
                    <button type="button" class="style-btn" auth="W" onclick="doDownloadFolder()">Folder Download</button>
                    <button type="button" class="style-btn" auth="W" onclick="doDelRemoteFile()">Delete</button>
                    <button type="button" class="style-btn" auth="W" onclick="doRenameRemoteFile()">Rename</button>
                </div>
            </div>

            <!-- 그리드 시작 -->
            <table id="grid2" ></table>
            <!-- 그리드 끝 -->

        </div>
        <!--// 오른쪽 컨텐츠  -->

    </div>

</div>
