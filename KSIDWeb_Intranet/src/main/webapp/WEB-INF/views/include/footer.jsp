<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="${config.includePath}/popup.jsp" />

<div style="display:none">

    <form id="form_excel" action="" target="frm_excel" method="POST">
        <input type="hidden" name="params" />
    </form>
    <iframe id="frm_excel" name="frm_excel"  src="" title="엑셀"></iframe>

    <form id="form_ksid_file_download" method="post" action="/file/download" target="frm_download">
        <input type="hidden" name="fileId">
        <input type="hidden" name="fileOwnerCd">
        <input type="hidden" name="fileOwnerKey1">
        <input type="hidden" name="fileOwnerKey2">
        <input type="hidden" name="fileOwnerKey3">
        <input type="hidden" name="inline" value="false">
    </form>
    <iframe id="frm_download" name="frm_download" src="" title="파일다운로드"></iframe>

</div>