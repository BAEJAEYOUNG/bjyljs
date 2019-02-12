/****************************************************************
    파일명: ksid.js
    설명:  ksid js
        
    수정일         수정자        수정내용
    ------------------------------------------------------
    2015-01-14     배재영        초기작성 
    ------------------------------------------------------
****************************************************************/

/**
 * ao_prop : {
 *              PUPUP_ID        : "",
 *              CALLBACK_ID     : "",
 *              CLICK           : funcion
 *           }
 */
ksid.popup       = function( ao_prop ) {
    
    if( ksid.json.containsKey(ao_prop, "CHOICE") == true ) {
        
        $("#DialogComm button[name=btnPopChoice]").show();
        
    } else {
        
        $("#DialogComm button[name=btnPopChoice]").hide();
        
    }
    
    this.prop = {
            
        TITLE   : "팝업선택",
        WIDTH   : 600,
        HEIGHT  : 500
    
    }; 
    
    this.grid   = null;
    
    ksid.json.mergeObject(this.prop, ao_prop);
    
    this.pager  = null;
    
    this.init();
    
};

/**'
 * 초기화
 */
ksid.popup.prototype.init = function() {
    
    $("#DialogCommTop").html($("#" + this.prop.POPUP_ID).html());
    $("#DialogCommGridDiv").html('<table id="DialogCommGrid"></table>');
    
};

/**
 * pupup search data bind
 */
ksid.popup.prototype.search_bind = function( ao_data ) {
    
	ksid.form.bindPanel( "#DialogCommTop", ao_data );  
    
};

/**
 * popup open
 */
ksid.popup.prototype.open = function() {
    
//    alert("open");
    
    var ref_popup = this;
    
    //###############################################################################
    //###   요기서 꼭 추가해 줘야 한다 !!!!!!!!!!!!!!!!!!!!!! (시작)
    //###############################################################################
    
    switch( this.prop.POPUP_ID ) {
    
        case "POP_MP"       :         // 휴대폰 조회
            this.set_POP_MP();
            break;
            
        case "POP_CERT"     :         // 인증서 조회
            this.set_POP_CERT();
            break;
            
        default :
            this.set_POPUP();
            break;
    
    }
    
    //###############################################################################
    //###   요기서 꼭 추가해 줘야 한다 !!!!!!!!!!!!!!!!!!!!!! (끝)
    //###############################################################################

    DialogCommGrid = this.grid;
    
    if( this.grid != null ) {
        
        this.grid.pager = new ksid.paging({
            "var": {
                elementId: "DialogCommGridPager"   // 페이저 id ( 임의로 지정, 같은이름만 없으면 된다. )
            },
            "prop": {
                totrowcnt: 1,       // 전체row수
                pagecnt: 100,       // 페이지당 row수
                pagenow: 1,         // 현재 page 번호
                blockcnt: 10        // 블록당페이지수
            }
        });
        this.grid.pager.parent      = ref_popup.grid;                // 페이저 소속 GRID 를 지정한다.
        this.grid.pager.selectFunc  = ref_popup.search_paging;       // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
        this.grid.pager.show();
        
    }
    
    this.title          = this.prop.TITLE + " 선택";
    this.grid_title     = this.prop.TITLE + " 목록";
    
    $("#popup_grid_title").html(this.grid_title);          // 그리드 타이틀
    
//    ksid.u.dialog_open( "#DialogComm", {"title": this.title, "width":this.prop.WIDTH, "height":this.prop.HEIGHT});
    
    $("#DialogComm").dialog({"title": this.title, "width":this.prop.WIDTH, "height":this.prop.HEIGHT});
    
    var ref_popup = this;
    
    ksid.form.applyFieldOption("#DialogCommTop");
    
    $("#DialogComm button[name=btnPopSearch]").unbind().click(function () {
        ref_popup.search();
    });
    
    $("#DialogComm button[name=btnPopChoice]").unbind().click(function () {
        ref_popup.choice();
    });

    $("#DialogComm button[name=btnPopCancel]").unbind().click(function () {
        ref_popup.close();
    });
    
    $(".ui-dialog-titlebar").addClass("pop_head");
    
    $("#DialogCommGrid").jqGrid('setGridWidth'  , this.prop.WIDTH - 3);
    $("#DialogCommGrid").jqGrid('setGridHeight' , this.prop.HEIGHT - $("#DialogCommTop").outerHeight() - 180);
    
};

/**
 * search
 */
ksid.popup.prototype.search = function() {
    
    if( this.grid != null && this.grid.pager != null ) {
        
        this.grid.pager.prop.pagenow = 1;
        
        this.search_paging();
        
    } 

};

/**
 * search
 */
ksid.popup.prototype.search_paging = function() {
    
    if( DialogCommGrid != null ) {
        
        DialogCommGrid.showLoading();
        
        var params = ksid.form.flushPanel("#DialogCommTop");
        
        params.pagecnt = DialogCommGrid.pager.prop.pagecnt;
        params.pagenow = DialogCommGrid.pager.prop.pagenow;
        
//        ksid.debug.printObj("공통팝업params", params);
        
        ksid.net.ajax("/common/get_popup_list.do", params, function(result){

            DialogCommGrid.bindGrid(result.resultData);    // grid1 data bind
            
        },function(){ref_popup.grid.hideLoading();});
        
    }
    
};

ksid.popup.prototype.choice = function() {
    
    try{
        
        var selRowIds = $("#DialogCommGrid").jqGrid("getGridParam", "selarrrow"); 
        
        if( selRowIds.length == 0 ) {
            
            alert( "선택한 목록이 존재하지 않습니다" );
            return;
            
        }
        
        var lor_return = [];
        
        for(var i = 0; i < selRowIds.length; i++){
            
            lor_return.push(ksid.json.cloneObject($("#DialogCommGrid").getRowData(selRowIds[i])));
            
        }
        
        this.prop.CHOICE(lor_return);
        
    } catch(e){ alert("선택 함수가 존재하지 않습니다") }
    
};

ksid.popup.prototype.click = function(ao_data) {
    
    try {
        
        this.prop.CLICK(ksid.json.cloneObject(ao_data));
        
    } catch(e) { alert("CLICK 함수가 존재하지 않습니다."); }
    
};

ksid.popup.prototype.close = function() {
    
	$("#DialogComm").dialog('close');
    
};


//###############################################################################
//###   요기서 위에서 추가한 함수를 만들자 !!!!!!!!!!!!!!!!!!!!!! (시작)
//###############################################################################

/*
 * 팝업공통
 */
ksid.popup.prototype.set_POPUP = function(ao_prop) {
    
    var ref_popup = this;
    
    var lo_prop = {
            
//        colNames    : ref_popup.prop.COL_NAMES,
        colModel    : ref_popup.prop.COL_MODEL,
        onSelectRow : function(rowId, status, e){

            if( ksid.json.containsKey(ref_popup.prop, "CLICK") == true ) {
                
                ref_popup.grid.setClickedProp(rowId);
                ref_popup.click(ref_popup.grid.clickedRowData);
                
            }
            
        },
        
    }
    
    if( typeof ao_prop != "undefined" ) {
        
        ksid.json.mergeObject(lo_prop, ao_prop);
    }
    
    this.grid   = new ksid.grid("DialogCommGrid", lo_prop);
    
    this.grid.loadGrid();
    
};


/* 휴대폰 조회 */
ksid.popup.prototype.set_POP_MP = function() {
    
    this.prop.TITLE = "휴대폰";
    
    this.prop.COL_MODEL = [
       
		{ label: '휴대폰아이디',     name: 'mp_id',                                       width:100 },
		{ label: '휴대폰번호',       name: 'mp_no',                    format: 'tel_no' , width:120 },
		{ label: '통신사유형',       name: 'isp_type_nm',              format: 'string' , width:100 },
		{ label: 'OS유형',           name: 'mobile_os_type_nm',        format: 'string' , width:100 }
                       
    ];
    
    this.set_POPUP();
    
};


/* 인증서 조회 */
ksid.popup.prototype.set_POP_CERT = function() {
    
    this.prop.TITLE = "인증서";
    
    this.prop.COL_MODEL = [
                           
		{ label: '인증서아이디',     name: 'cert_id',                                     width:100 },
		{ label: '인증서DN',         name: 'cert_dn',                  format: 'string' , width:300 },
		{ label: '인증서유형',       name: 'cert_type_nm',                                width:120 },
		{ label: '유효기간시작',     name: 's_dt',                     format: 'date' ,   width:80  },
		{ label: '유효기간종료',     name: 'e_dt',                     format: 'date' ,   width:80  },
		{ label: '인증서상태',       name: 'cert_status_nm',                              width:80  }

		
    ];
    
    this.set_POPUP();
    
};


//###############################################################################
//###   요기서 위에서 추가한 함수를 만들자 !!!!!!!!!!!!!!!!!!!!!! (끝)
//###############################################################################
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

