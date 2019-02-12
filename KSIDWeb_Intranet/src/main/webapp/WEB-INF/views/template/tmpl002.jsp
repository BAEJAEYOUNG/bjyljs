<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- jybae : 2016. 1. 15.오후 1:39:47 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@include file="/WEB-INF/view/common/common_head.jsp"%>
<script type="text/javascript" src="${viewJsPath}/template/tmpl002.js" charset="utf-8"></script>
</head>
<body>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">시스템</span> > <span name="menu">공통코드관리</span></p>
    </div>


    <!-- 검색조건 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt name="title"><label for="code_group_nm">코드그룹</label></dt>
                <dd><input type="text" maxlength="100" class="style-input width133" name="code_group_nm" title="코드그룸id 또는 코드그룹명" class="style-input" command="doQuery()" /></dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 검색조건 끝 -->

    <div class="variableWrapCode">
        <!-- 왼쪽 컨텐츠  -->
        <div class="fLeft">
           <h3 class="style-title"><span name="title">코드그룹정보</span></h3>

            <!-- 입력화면 시작 -->
            <div class="edit-panel" style="min-width:500px">

                <div id="group-edit-panel" class="styleDlTable" style="min-width:500px;width:500px;">

                    <input type="hidden" name="mode" value="I" />

                    <dl>
                        <dt name="title" class="title_on width80"><label for="codeGroupCd">코드그룹ID</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="20" class="style-input width120" name="codeGroupCd" title="코드그룹ID" next="code_group_nm" modestyle="enable" required />
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="title_on width80"><label for="code_group_nm">코드그룹명</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="100" class="style-input width120" name="code_group_nm" title="코드그룹명" command="doSave()" required />
                        </dd>
                        <dt name="title" class="width90"><label for="code_group_type">코드그룹유형</label></dt>
                        <dd>
                            <select class="style-select width100" name="code_group_type" title="코드그룹유형" codeGroupCd="code_group_type" selected_value="N" required></select>
                        </dd>
<!-- 						<dt name="title"><label for="ref_codeGroupCd">상위코드그룹ID</label></dt> -->
<!-- 						<dd> -->
<!-- 							 <input type="text" maxlength="100" class="style-input width90" name="ref_codeGroupCd" title="상위코드그룹ID" maxlength="20" /> -->
<!-- 						</dd> -->
                    </dl>
                    <dl>
                        <dt name="title" class="width80">정렬순번</dt>
                        <dd class="width130">
                            <input type="text" maxlength="200" class="style-input width80" name="sort_seq" format="number" title="정렬순번" />
                        </dd>
                        <dt name="title" class="width90"><label for="use_yn">사용여부</label></dt>
                        <dd>
                            <select class="style-select width100" name="use_yn" title="사용여부" codeGroupCd="use_yn" selected_value="Y" required></select>
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="remark">비고</label></dt>
                        <dd>
                            <input type="text" maxlength="300" class="style-input width360" name="remark" title="비고" />
                        </dd>
                    </dl>
                </div>
                <!--  button bar  -->
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="W" onclick="doNew()">신규</button>
                    <button type="button" class="style-btn" auth="W" onclick="doSave()">저장</button>
                    <button type="button" class="style-btn" auth="D" onclick="doDelete()">삭제</button>
                    <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button>
                </div>
                <!--// button bar  -->

            </div>

            <!-- 입력화면 끝 -->
            <h3 class="style-title"><span name="title">코드그룹목록</span></h3>
            <!-- 그리드 시작 -->
            <table id="grid1" ></table>
            <!-- 그리드 끝 -->
        </div>
        <!--// 왼쪽 컨텐츠  -->

        <!-- 오른쪽 컨텐츠  -->
        <!-- 입력화면 시작 -->
        <div class="fRight" style="min-width:500px;padding-left:510px;">
            <h3 class="style-title"><span name="title">코드정보</span></h3>

            <div class="edit-panel" style="min-width:422px;">

                <div id="cd-edit-panel" class="styleDlTable" style="min-width:422px;">

                    <input type="hidden" name="mode" value="I" />
                    <input type="hidden" name="code_lvl" value="1" />

                    <dl>
                        <dt name="title" class="title_on width80"><label for="codeGroupCd">코드그룹ID</label></dt>
                        <dd class="width130">
                            <input type="text" class="style-input width120" name="codeGroupCd" maxlength="20" title="코드그룹ID" disabled required />
                        </dd>
                        <dt name="title" class="title_on width80"><label for="code_cd">코드ID</label></dt>
                        <dd>
                            <input type="text" class="style-input width120" name="code_cd" maxlength="20" title="코드ID" next="code_nm" modestyle="enable" required />
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="code_nm">코드명</label></dt>
                        <dd class="width130">
                            <input type="text" class="style-input width120" name="code_nm" maxlength="100" title="코드명" command="doSave2()" />
                        </dd>
                        <dt name="title" class="title_on width80" ><label for="code_type">코드유형</label></dt>
                        <dd>
                            <select class="style-select width110" name="code_type" title="코드유형" codeGroupCd="code_type" required></select>
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="sort_seq">정렬순번</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="200" class="style-input width80" name="sort_seq" format="number" title="정렬순번" />
                        </dd>
                        <dt name="title" class="width80"><label for="use_yn">사용여부</label></dt>
                        <dd>
                            <select class="style-select width110" name="use_yn" title="사용여부" codeGroupCd="use_yn" required></select>
                        </dd>
                    </dl>
<!-- 					<dl> -->
<!-- 						<dt name="title"><label for="ref_codeGroupCd">상위코드그룹ID</label></dt> -->
<!-- 						<dd> -->
<!-- 							<input type="text" class="style-input width80" name="ref_codeGroupCd" maxlength="20" title="상위코드그룹ID" /> -->
<!-- 						</dd>					 -->
<!-- 						<dt name="title"><label for="ref_code_cd">상위코드ID</label></dt> -->
<!-- 						<dd> -->
<!-- 							<input type="text" class="style-input width80" name="ref_code_cd" maxlength="20" title="상위코드ID" /> -->
<!-- 						</dd> -->
<!-- 					</dl> -->
                    <dl>
                        <dt name="title" class="width80"><label for="remark">비고</label></dt>
                        <dd>
                            <input type="text" class="style-input width350" name="remark" maxlength="300" title="비고" />
                        </dd>
                    </dl>
                </div>
                <!--  button bar  -->
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="W" onclick="doNew2()">신규</button>
                    <button type="button" class="style-btn" auth="W" onclick="doSave2()">저장</button>
                    <button type="button" class="style-btn" auth="D" onclick="doDelete2()">삭제</button>
                    <button type="button" class="style-btn" auth="P" onclick="doExcel2()">출력</button>
                </div>
                <!--// button bar  -->
            </div>

            <!-- 입력화면 끝 -->
            <h3 class="style-title"><span name="title">코드목록</span></h3>
            <!-- 그리드 시작 -->
            <table id="grid2" ></table>
            <!-- 그리드 끝 -->

        </div>
        <!--// 오른쪽 컨텐츠  -->
    </div>
    <!-- 상태 메세지 s -->
    <div class="statusResult">
         <dl>
            <dt name="title">상태메세지</dt>
            <dd id="page_status"></dd>
        </dl>
    </div>
    <!--// 상태 메세지 e -->
</div>
<jsp:include page="/WEB-INF/view/common/common_bottom.jsp" />
</body>
</html>