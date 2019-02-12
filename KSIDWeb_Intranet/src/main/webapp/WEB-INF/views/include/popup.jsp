<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="DialogComm" class="dialog"  title="공통선택창" style="display:none;">

        <div class="popup_btns">
            <button type="button" name="btnPopSearch">조회</button>
            <button type="button" name="btnPopChoice" style="display:none;">선택</button>
            <button type="button" name="btnPopCancel">닫기</button>
        </div>

        <div id="DialogCommTop" class="box_st1"></div>

        <!-- 그리드 -->
        <section>
            <h2 class="style-title" id="popup_grid_title" style="margin-left:2px;"></h2>
            <div id="DialogCommGridDiv" class="ui-body ui-body-c" style="padding:0;">
                <table id="DialogCommGrid"></table>
            </div>
            <div id="DialogCommGridPager"></div>
        </section>

</div>

<!-- 장치휴대폰선택 공통 -->
<!-- 작업자 : 배재영 -->
<!-- 조회샘플 : 장치관리 - data/device -->
<div id="POP_MP" style="display:none;">

    <input type="hidden" name="CMD" value="MP" />

    <div style="padding:3px 0;">
        <fieldset>
            <legend>휴대폰조회</legend>
            <label for="">휴대폰번호</label>
            <input type="text" name="mp_no" format="tel_no" class="style-input width100" title="휴대폰번호"  command="page.dialog_comm.search();" />
        </fieldset>
    </div>

</div>

<!-- 장치인증서선택 공통 -->
<!-- 작업자 : 배재영 -->
<!-- 조회샘플 : 장치관리 - data/device -->
<div id="POP_CERT" style="display:none;">

    <input type="hidden" name="CMD" value="CERT" />

    <div style="padding:3px 0;">
        <fieldset>
            <legend>인증서조회</legend>
            <label for="">인증서DN</label>
            <input type="text" name="cert_dn" title="인증서DN" class="style-input width300"  command="page.dialog_comm.search();" />
        </fieldset>
    </div>

</div>

<!-- 서비스제공자-서비스선택 공통 -->
<!-- 작업자 : 배재영 -->
<!-- 조회샘플 : 서비스제공자-서비스 과금관리 - service/sp_service_billing -->
<div id="POP_SP_SERVICE" style="display:none;">

    <input type="hidden" name="CMD" value="SP_SERVICE" />

    <div style="padding:3px 0;">
        <fieldset>
            <legend>서비스제공자-서비스조회</legend>
            <label for="">서비스명</label>
            <input type="hidden" name="sp_cd" title="서비스제공자코드" />
            <input type="text" name="service_nm" title="서비스명" class="style-input width300"  command="page.dialog_comm.search();" />
        </fieldset>
    </div>

</div>

<!-- 서비스제공자-서비스-사용자 선택 공통 -->
<!-- 작업자 : 배재영 -->
<!-- 조회샘플 : 서비스제공자-서비스-사용자 과금관리 - service/sp_service_user_billing -->
<div id="POP_SP_SERVICE_USER" style="display:none;">

    <input type="hidden" name="CMD" value="SP_SERVICE_USER" />

    <div style="padding:3px 0;">
        <fieldset>
            <legend>서비스제공자-서비스조회</legend>
            <input type="hidden" name="sp_cd" title="서비스제공자코드" />
            <input type="hidden" name="service_cd" title="서비스코드" />
            <label for="">사용자명</label>
            <input type="text" name="user_nm" title="사용자아이디/명" class="style-input width100"  command="page.dialog_comm.search();" />
            <label for="">생년월일</label>
            <input type="text" maxlength="8" name="birth_day" title="생년월일" class="style-input width100" format="no" command="page.dialog_comm.search();" />
            <label for="">휴대폰번호</label>
            <input type="text" maxlength="20" name="hp_no" title="휴대폰번호" class="style-input width110" format="tel_no" command="page.dialog_comm.search();"/>
        </fieldset>
    </div>

</div>

<!-- 서비스제공자-서비스-사용자 장치.매체선택 공통 -->
<!-- 작업자 : 배재영 -->
<!-- 조회샘플 : 서비스제공자-서비스-사용자 과금관리 - service/sp_service_user_billing -->
<div id="POP_SP_SERVICE_USER_DM" style="display:none;">

    <input type="hidden" name="CMD" value="SP_SERVICE_USER_DM" />
    <input type="hidden" name="sp_cd" title="서비스제공자코드" />
    <input type="hidden" name="service_cd" title="서비스코드" />
    <input type="hidden" name="user_id" title="사용자아이디" />

    <div style="padding:3px 0;">
        <fieldset>
            <legend>서비스제공자-서비스-사용자 장치.매체 조회</legend>
            <label for="">장치명</label>
            <input type="text" name="device_nm" title="장치명" class="style-input width100"  command="page.dialog_comm.search();" />
            <label for="">매체명</label>
            <input type="text" name="media_nm" title="매체명" class="style-input width100" command="page.dialog_comm.search();" />
        </fieldset>
    </div>

</div>

