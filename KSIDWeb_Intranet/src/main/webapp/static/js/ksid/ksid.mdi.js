
/**
 * <pre>
 * resources/js/comm
 * ksid.mdi.js
 * </pre>
 * 
 * @author  : 배재영
 * @Date    : 2015. 5. 19.
 * @Version : 1.0.0.0
**/
ksid.mdi		= function() {
    
    this.isr_clicked_tab_id         = [];                       // 클릭한 Tab 의 id
    this.is_active_tab_id           = null;                     // 현재 활성화된 Tab 의 id ( menuCode 값을 등록한다 )
    this.is_active_iframe_id        = null;                     // 현재 활성화된 Tab 의 iframe id
    this.ii_opened_tab_cnt          = 0;                        // 열려진 tab의 갯수
    this.ii_max_tab_cnt             = 6;                        // 최대 tab 갯수
    this.is_maxed_proc_type         = ksid.mdi.type.close;     // 닫기로 설정
    this.lor_menu_list              = [];                       // 열려있는 모든 tab 정보 list [{CODE:"",NAME:"",URL:""}......]        
    
    this.init();                        // 초기화
    
};


ksid.mdi.type = {
        
    close       : "닫기"      , // 클릭한 tab 기준으로 처음 tab을 닫고 새로 오픈한다.
    alert       : "알림"        // 최대 tab갯수 입니다. 알림메시지창 띄우기
        
};



/**
 * 초기화
 */
ksid.mdi.prototype.init = function() {
    
    this.open('EPS_MAIN', '대시보드', 'EPS_MAIN.do', true);
    
};




/**
 * ksid.mdi.prototype.open - 메뉴 신규 open 또는 열려있는 메뉴 선택
 * 
 * @param as_menu_code    : 메뉴코드                              ( 예 : EPS_1010 )
 * @param as_menu_name    : 메뉴명                                ( 예 : 사용자관리 )
 * @param as_menu_url     : 메뉴경로                              ( 예 : EPS_1010.do )
 * @param ab_refresh      : 메뉴가 열릴때 새로고침(초기화) 여부   ( 예 : true )
 * 
 */
ksid.mdi.prototype.open = function( as_menu_code, as_menu_name, as_menu_url, ab_refresh ) {
    
    this.click(as_menu_code);
    
    // 새로고침 여부
    var lb_refresh = ( typeof(ab_refresh) == "undefined" ) ? false : ab_refresh;
    
    // 해당 메뉴 tab 이 이미 열려있다면 ..
    // 해당 메뉴를 active tab id 로 정한 후 해당 탭을 활성화 시킨다.
    // 활성화된 iframe id 등록
    
    if( this.fn_tab_opened(as_menu_code) == true ) {
        
        this.is_active_tab_id        = as_menu_code;
        this.is_active_iframe_id     = $('li[id="' + this.is_active_tab_id + '"]').attr("name");
        
        if( ksid.json.containsKey( page.param, this.is_active_tab_id ) == true ) {
    
            if( page.param[this.is_active_tab_id].view == true ) {
                
                lb_refresh = true;
                
            }
            
        }

        // this.is_active_tab_id 에 해당하는 tab 활성화 및 is_active_iframe_id 에 해당하는 iframe show
        this.fn_show_tab();
        
        // 이미 메뉴가 열려있고 메뉴를 열때 새로고침 한다면...
        if( lb_refresh == true ) {
            
            // 해당 iframe 을 새로고침 한다.
            $('#' + this.is_active_iframe_id).attr("src", as_menu_url);
            
        } 
    
    // 해당 tab 이 열리지 않았다면 ..
        
    } else {
        
        // 열려있는 tab의 갯수가 최대 갯수에 도달했다면 (홈제외)..
        if( this.ii_opened_tab_cnt >= this.ii_max_tab_cnt && as_menu_code != "EPS_MAIN" ) {
            
            
            // 최대창도달시 처리유형이 alarm 이라면 ..
            if( this.is_maxed_proc_type == ksid.mdi.type.alarm ) {
                
                alert("메뉴가 " + this.ii_max_tab_cnt + "개 이상입니다.<br />메뉴는 최대 " + this.ii_max_tab_cnt + "개 까지 열 수 있습니다.");
                return;
            
            // 최대창도달시 처리유형이 close 이라면 ..
            } else if( this.is_maxed_proc_type == ksid.mdi.type.close ) {
                
                var lo_menu         = this.lor_menu_list[0];
                var li_menu_idx     = 0;
                
                // 첫번째 tab이 EPS_MAIN ( 홈 ) 라면 두번째 tab을 닫고 새로운 tab을 추가한다.
                if( lo_menu.CODE == "EPS_MAIN" )
                {
                    lo_menu         = this.lor_menu_list[1];
                    li_menu_idx     = 1;
                }
                
                // 해당 tab을 없앤다.
                this.close(lo_menu.CODE);
                
                // 메뉴 리스트에서 삭제한다.
//                this.lor_menu_list.splice(li_menu_idx, 1);
                
                // 새로운 tab을 띄운다.
                this.openTab( as_menu_code, as_menu_name, as_menu_url );
                
            }
        
        // max 갯수에 도달하지 않았다. 새로운 tab을 추가하여 띄워야 한다. 
        } else {
        
            this.openTab( as_menu_code, as_menu_name, as_menu_url );
         
        }
        
    }

    this.click(as_menu_code);
  
//    ksid.debug.array_map("this.lor_menu_list", this.lor_menu_list);
    
};


/**
 * is_active_tab_id 에 해당하는 메뉴 활성화 및 해당 iframe show
 */
ksid.mdi.prototype.fn_show_tab = function() {
    
    $('#tabs li').removeClass('on');                                // 모든 tab 숨기기
    $('.frame_box iframe').hide();                                  // 모든 iframe 숨기기
    
    $('li[id="' + this.is_active_tab_id + '"]').addClass('on');      // 활성화된 tab 보이기
    $('#' + this.is_active_iframe_id).show();                        // 활성화된 iframe 보이기
    
};












// X 버튼 클릭
ksid.mdi.prototype.clickRemove = function( asTabId ) {
    
    for (var i = 0; i < this.isr_clicked_tab_id.length; i++) {
        
        if( this.isr_clicked_tab_id[i] == asTabId ) this.isr_clicked_tab_id.splice(i,1);
        
    }
    
};

// 클릭한 tab의 id를 저장
ksid.mdi.prototype.click = function( asTabId ){
    
//    ksid.debug.array("this.isr_clicked_tab_id", this.isr_clicked_tab_id);
    
    this.clickRemove(asTabId);
    
//    ksid.debug.array("this.isr_clicked_tab_id", this.isr_clicked_tab_id);
    
    this.isr_clicked_tab_id.push(asTabId);
    
//    ksid.debug.array("this.isr_clicked_tab_id", this.isr_clicked_tab_id);
    
};

ksid.mdi.prototype.isPopup = function() {
    
    var lb_return = false;
    
    switch( this.is_active_tab_id ) {
    
        case    'EPS_4011' :
        case    'EPS_4012' :
        case    'EPS_4013' :
            alert( "현재tab을 닫으셔야만 다른창에서 업무를 진행하실 수 있습니다." );
            lb_return = true;
            break;
        default :
            break;
    
    }
    
    return lb_return;
    
};


/*
// 메뉴 open ( 메뉴코드, 메뉴명, url, open시 새로고침여부
ksid.mdi.prototype.open = function( as_menu_code, as_menu_name, as_menu_url, ab_refresh ) {
    
//    alert("as_menu_code = " + as_menu_code);
//    alert("as_menu_name = " + as_menu_name);
//    alert("as_menu_url = " + as_menu_url);
    
    this.click(as_menu_code);
    
    // 이미 Tab이 열려있다면 ..
    if( this.fn_tab_opened(as_menu_code) == true ) {
        
        this.is_active_tab_id        = as_menu_code;                                           // 활성화된 tab ID 등록
        this.is_active_iframe_id     = $('li[id="' + this.is_active_tab_id + '"]').attr("name");  // 활성화된 iframe ID 등록
        
        this.fn_show_tab();
        
        // 이미 메뉴가 열려있고 메뉴를 열때 새로고침 한다면...
        if( typeof ab_refresh != "undefined" ) {
            
            if( ab_refresh == true ) {
                
                $('#' + this.is_active_iframe_id).attr("src", as_menu_url);
                
            } 
            
        }
        
    // 동일한 menuCode 에 해당하는 tab이 열려있지 않다면 ..
    } else {
        
        // 열린 tab의 갯수가 최대 tab 갯수에 도달했다면 ... ( 홈제외 )
        if( this.ii_opened_tab_cnt >= this.ii_max_tab_cnt && as_menu_code != "EPS_MAIN" ) {
            
            if( this.is_maxed_proc_type == ksid.mdi.type.alarm ) {
                
                alert("메뉴가 " + this.ii_max_tab_cnt + "개 이상입니다.<br />메뉴는 최대 " + this.ii_max_tab_cnt + "개 까지 열 수 있습니다.");
                
            } else if( this.is_maxed_proc_type == ksid.mdi.type.close ) {
                
                var lo_menu      = this.lor_menu_list[0];
                var li_menu_idx   = 0;
                
                // 첫번째 tab이 EPS_MAIN ( 홈 ) 라면 두번째 tab을 닫고 새로운 tab을 추가한다.
                if( lo_menu.CODE == "EPS_MAIN" )
                {
                    lo_menu      = this.lor_menu_list[1];
                    li_menu_idx   = 1;
                }
                
                // 해당 tab을 없앤다.
                this.close(lo_menu.CODE);
                
                // 메뉴 리스트에서 삭제한다.
//                this.lor_menu_list.splice(d, 1);
                
                // 새로운 tab을 띄운다.
                this.openTab( as_menu_code, as_menu_name, as_menu_url );
                
            }
        
        // max 갯수에 도달하지 않았다. 새로운 tab을 추가하여 띄워야 한다.
        } else {
            
            this.openTab( as_menu_code, as_menu_name, as_menu_url );
             
        }
        
    }
    
};
*/
ksid.mdi.prototype.openTab = function( as_menu_code, as_menu_name, as_menu_url ) {
    
    var mdiTab = this;
    
    if( typeof(as_menu_name) == "undefined" ) return;

    var lsTabHtml   = "";   // tab html
    var lsClose     = "";
    
    // 메인데시보드가 아니라면 tab갯수에 추가한다. ( 최대 갯수에서 메인페이지는 제외 )
    if( as_menu_code != "EPS_MAIN" ) this.ii_opened_tab_cnt++;
    
    // lor_menu_list 에 해당 tab의 정보를 담는다.
    this.lor_menu_list.push( {CODE:as_menu_code, NAME:as_menu_name, URL:as_menu_url} );
    
     $('#tabs li').removeClass('on');   // 모든 tab 감추기

     for (var i = 0; i <= this.ii_max_tab_cnt; i++) {
         
         // 해당 iframe 경로가 없다면
         if ($('#frame' + i).attr("src") == '') {
             
             this.is_active_tab_id   = as_menu_code;   // 활성화된 tab ID 등록
             
             lsClose = '<span class="ui-icon ui-icon-close" role="presentation" onclick="mdiTab.close(\'' + this.is_active_tab_id + '\')">tab닫기</span>';
             
             lsTabHtml = '<li id="' + this.is_active_tab_id + '" class="on" name="frame' + i + '" title="' + this.is_active_tab_id + '"><a href="javascript:mdiTab.open(\'' + as_menu_code + '\');">' + as_menu_name + '</a>' + lsClose + '</li>';
             
//           var loTab = this.getMenuObject(this.is_active_tab_id);
             
             $('#frame' + i).attr("src", as_menu_url);
             
             $('.frame_box iframe').hide();
             
             $('#frame' + i).show();
             
             break;
             
         }
        
    }
     
    // tab 추가
    $('#tabs ul').prepend(lsTabHtml);
     
    $('#tabs li').unbind('click'); 
        
    // 이벤트 설정
    $('#tabs li').click(function() {

        mdiTab.is_active_tab_id      = $(this).attr("id");
        mdiTab.is_active_iframe_id   =  $('#' + $(this).attr("name"));
        
        mdiTab.fn_show_tab();
        
    });  
    
};
// tab 닫기
ksid.mdi.prototype.close = function( as_menu_code ) {
    
    var mdiTab = this;
    
    var iframeId = "";
    
    $('#tabs li').each(function() {
        
        if ($(this).attr("id") == as_menu_code )        //   if ($(this).attr("id") == active)    추가
        {
            
            iframeId = $(this).attr("name");
            
            // 해당 tab을 없앤다.
            $('#' + iframeId).attr("src", "").hide();
            $(this).remove();
            
            // 텝을 삭제한다.
            mdiTab.lor_menu_listRemove(as_menu_code);
            
            // 메인데시보드가 아니라면 tab갯수에 제거한다.
            if( as_menu_code != "EPS_MAIN" ) mdiTab.ii_opened_tab_cnt--;
            
            // 클릭된 tab에서 해당 메뉴를 삭제한다.
            mdiTab.clickRemove(as_menu_code);
            
        }

    });

    if( this.is_active_tab_id == as_menu_code ) {
        if( this.isr_clicked_tab_id.length > 0 ) {
            this.open(this.isr_clicked_tab_id[this.isr_clicked_tab_id.length-1]);
        }
    }
    
};
// 모든 tab 닫기
ksid.mdi.prototype.closeAll = function() {
    
    $('#tabs li').each(function() {
        
        if($(this).attr("id") != "alltab"){
            
            mdiTab.close($(this).attr("id"));
            
//          lsFrameId = $(this).attr("name");
//          
//          $('#' + lsFrameId).attr("src", "").hide();
//          
//          $(this).remove();
            
        }
        
    });
    
    this.ii_opened_tab_cnt = 0;
    
};
// 현재 활성화 tab 새로고침
ksid.mdi.prototype.refresh = function() {
    
    $('#' + this.is_active_iframe_id).attr('src', $('#' + this.is_active_iframe_id).attr('src'));
    
};

// menu url 로 부터 메뉴코드 가져오기
ksid.mdi.prototype.getMenuCodeFromUrl = function(as_menu_url) {
    
    return as_menu_url.substring(0, as_menu_url.lastIndexOf('.'))
    
};
// 해당 메뉴코드의 메뉴 LIST index 가져오기
ksid.mdi.prototype.getMenuObject = function(as_menu_code) {
    
    var loReturn = null;
    
    for (var i = 0; i < this.lor_menu_list.length; i++) {
        
        if(this.lor_menu_list[i].CODE == as_menu_code) {
            
            loReturn = this.lor_menu_list[i];
            break;
            
        }
        
    }
    
    return loReturn;
    
};
// 메뉴 리스트에서 해당 코드 삭제
ksid.mdi.prototype.lor_menu_listRemove = function(as_menu_code) {
    
    for (var i = 0; i < this.lor_menu_list.length; i++) {
        
        if(this.lor_menu_list[i].CODE == as_menu_code) {
            
            this.lor_menu_list.splice(i, 1);
            break;
            
        }
        
    }
    
};














/**
 * 탭이 현재 열려있는지 확인
 * 
 * @param as_menu_code
 * @returns {Boolean}
 */
ksid.mdi.prototype.fn_tab_opened = function( as_menu_code ) {
    
    var lb_return = false;
    
    $('#tabs li').each(function() {
        
        if ($(this).attr("id") == as_menu_code) {
        
            lb_return = true;
        
        }
        
    });
    
    return lb_return;
    
};

