<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">
<title>사진 첨부하기 :: SmartEditor2</title>
<style type="text/css">
/* NHN Web Standard 1Team JJS 120106 */
/* Common */
body,p,h1,h2,h3,h4,h5,h6,ul,ol,li,dl,dt,dd,table,th,td,form,fieldset,legend,input,textarea,button,select{margin:0;padding:0}
body,input,textarea,select,button,table{font-family:'돋움',Dotum,Helvetica,sans-serif;font-size:12px}
img,fieldset{border:0}
ul,ol{list-style:none}
em,address{font-style:normal}
a{text-decoration:none}
a:hover,a:active,a:focus{text-decoration:underline}

/* Contents */
.blind{visibility:hidden;position:absolute;line-height:0}
#pop_wrap{width:383px}
#pop_header{height:26px;padding:14px 0 0 20px;border-bottom:1px solid #ededeb;background:#f4f4f3}
.pop_container{padding:11px 20px 0}
#pop_footer{margin:21px 20px 0;padding:10px 0 16px;border-top:1px solid #e5e5e5;text-align:center}
h1{color:#333;font-size:14px;letter-spacing:-1px}
.btn_area{word-spacing:2px}
.pop_container .drag_area{overflow:hidden;overflow-y:auto;position:relative;width:341px;height:230px;margin-top:4px;border:1px solid #eceff2}
.pop_container .drag_area .bg{display:block;position:absolute;top:0;left:0;width:341px;height:230px;background:#fdfdfd url(${config.imagePath}/uploader/bg_drag_image.png) 0 0 no-repeat}
.pop_container .nobg{background:none}
.pop_container .bar{color:#e0e0e0}
.pop_container .lst_type li{overflow:hidden;position:relative;padding:7px 0 6px 8px;border-bottom:1px solid #f4f4f4;vertical-align:top}
.pop_container :root .lst_type li{padding:6px 0 5px 8px}
.pop_container .lst_type li span{float:left;color:#222}
.pop_container .lst_type li em{float:right;margin-top:1px;padding-right:22px;color:#a1a1a1;font-size:11px}
.pop_container .lst_type li a{position:absolute;top:6px;right:5px}
.pop_container .dsc{margin-top:6px;color:#666;line-height:18px}
.pop_container .dsc_v1{margin-top:12px}
.pop_container .dsc em{color:#13b72a}
.pop_container2{padding:46px 60px 20px}
.pop_container2 .dsc{margin-top:6px;color:#666;line-height:18px}
.pop_container2 .dsc strong{color:#13b72a}
.upload{margin:0 4px 0 0;_margin:0;padding:6px 0 4px 6px;border:solid 1px #d5d5d5;color:#a1a1a1;font-size:12px;border-right-color:#efefef;border-bottom-color:#efefef;length:300px;}
:root  .upload{padding:6px 0 2px 6px;}
.myButton {
    -moz-box-shadow:inset 0px 1px 0px 0px #a4e271;
    -webkit-box-shadow:inset 0px 1px 0px 0px #a4e271;
    box-shadow:inset 0px 1px 0px 0px #a4e271;
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #89c403), color-stop(1, #77a809));
    background:-moz-linear-gradient(top, #89c403 5%, #77a809 100%);
    background:-webkit-linear-gradient(top, #89c403 5%, #77a809 100%);
    background:-o-linear-gradient(top, #89c403 5%, #77a809 100%);
    background:-ms-linear-gradient(top, #89c403 5%, #77a809 100%);
    background:linear-gradient(to bottom, #89c403 5%, #77a809 100%);
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#89c403', endColorstr='#77a809',GradientType=0);
    background-color:#89c403;
    -moz-border-radius:6px;
    -webkit-border-radius:6px;
    border-radius:6px;
    border:1px solid #74b807;
    display:inline-block;
    cursor:pointer;
    color:#ffffff;
    font-family:Arial;
    font-size:12px;
    font-weight:bold;
    padding:3px 12px;
    text-decoration:none;
    text-shadow:0px 1px 0px #528009;
    margin-left:10px;
}
.myButton:hover {
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #77a809), color-stop(1, #89c403));
    background:-moz-linear-gradient(top, #77a809 5%, #89c403 100%);
    background:-webkit-linear-gradient(top, #77a809 5%, #89c403 100%);
    background:-o-linear-gradient(top, #77a809 5%, #89c403 100%);
    background:-ms-linear-gradient(top, #77a809 5%, #89c403 100%);
    background:linear-gradient(to bottom, #77a809 5%, #89c403 100%);
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#77a809', endColorstr='#89c403',GradientType=0);
    background-color:#77a809;
}
.myButton:active {
    position:relative;
    top:1px;
}

</style>
</head>
<body>
<div id="pop_wrap">
    <!-- header -->
    <div id="pop_header">
        <h1>파일 첨부하기</h1>
    </div>
    <!-- //header -->
    <!-- container -->

    <!-- [D] HTML5인 경우 pop_container 클래스와 하위 HTML 적용
             그밖의 경우 pop_container2 클래스와 하위 HTML 적용      -->
    <div id="pop_container2" class="pop_container2" style="display:none;">
        <!-- content -->
        <form id="editor_upimage" name="editor_upimage" action="FileUploader.php" method="post" enctype="multipart/form-data" onSubmit="return false;">
        <div id="pop_content2">
            <input type="file" class="upload" id="uploadInputBox" name="fileData" multiple>
            <p class="dsc" id="info"><strong>10MB</strong>이하의 파일만 등록할 수 있습니다.<br>(JPG, GIF, PNG, BMP)</p>
        </div>
        </form>
        <!-- //content -->
    </div>
    <div id="pop_container" class="pop_container" style="display:;">
        <!-- content -->
        <div id="pop_content">
            <p class="dsc">
                <em id="imageCountTxt">0개</em>/10개 <span class="bar">|</span> <em id="totalSizeTxt">0MB</em>/100MB
                <button id="addMultiFile" class="myButton">파일추가</button>
            </p>
            <!-- [D] 첨부 이미지 여부에 따른 Class 변화
                 첨부 이미지가 있는 경우 : em에 "bg" 클래스 적용 //첨부 이미지가 없는 경우 : em에 "nobg" 클래스 적용   -->

            <div class="drag_area" id="drag_area">
                <ul class="lst_type" >
                </ul>
                <em class="blind">마우스로 드래그해서 파일를 추가해주세요.</em><span id="guide_text" class="bg"></span>
            </div>
            <div style="display:none;" id="divImageList"></div>
            <p class="dsc dsc_v1"><em>개당 최대 100MB, 1회에 100MB까지, 10개 이하로</em> 파일을<br>등록할 수 있습니다.</p>
        </div>
        <!-- //content -->
    </div>

    <!-- //container -->
    <!-- footer -->
    <div id="pop_footer">
        <div class="btn_area">
            <a href="#"><img src="${config.imagePath}/uploader/btn_confirm.png" width="49" height="28" alt="확인" id="btn_confirm"></a>
            <a href="#"><img src="${config.imagePath}/uploader/btn_cancel.png" width="48" height="28" alt="취소" id="btn_cancel"></a>
        </div>
    </div>
    <form id="testForm">
        <input type="hidden" name="aaaaaa" value="aaaaaa"/>
    </form>
    <!-- //footer -->
    <!-- <form id="multiImgForm" name="multiImgForm" method="post" enctype="multipart/form-data" style="display:none">
        <input type="file" id="file" name="file">
    </form> -->
</div>

<script type="text/javascript" src="${config.jsPath}/lib/attach_photo.js" charset="utf-8"></script>

</body>
</html>

