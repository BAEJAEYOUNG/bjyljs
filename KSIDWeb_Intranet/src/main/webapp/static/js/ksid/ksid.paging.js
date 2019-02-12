/****************************************************************
    파일명: ksid.paging.js
    설명:  ksid paging js

    수정일         수정자        수정내용
    ------------------------------------------------------
    2015-01-14     배재영        초기작성
    ------------------------------------------------------
****************************************************************/

// ksid paging class
ksid.paging = function (amArg) {

    this.parent = null;

    this.context = ""

    this.selectFunc = null;
    this.selectFuncCallback = null;

    this.elementId = "";    // pager element id

    this.prop = ksid.json.cloneObject(ksid.paging.prop);

    this.init(amArg["var"], amArg["prop"]);

};
ksid.paging.prototype.bindVar = function (aoVar) {
    for (var key in aoVar) {
        this[key] = aoVar[key];
    }
};
ksid.paging.prototype.bindProp = function (aoProp) {
    for (var key in aoProp) {
        this.prop[key] = aoProp[key];
    }
};
ksid.paging.prototype.init = function (amVar, amProp) {
    this.bindVar(amVar);
    this.bindProp(amProp);
    this.initPager();
};
ksid.paging.prototype.initPager = function () {

    // 현재 block 번호
    this.prop.blocknow = parseInt(this.prop.pagenow / this.prop.blockcnt) + ((parseInt(this.prop.pagenow % this.prop.blockcnt) == 0) ? 0 : 1);

    // 현재페이지시작번호
    this.prop.pagestart = (this.prop.pagenow - 1) * this.prop.pagecnt + 1;

    // 현재페이지끝번호
    this.prop.pageend = this.prop.pagenow * this.prop.pagecnt;
    if (this.prop.pageend > this.prop.totrowcnt) this.prop.pageend = this.prop.totrowcnt;

    // 전체페이지수
    this.prop.totpagecnt = parseInt(this.prop.totrowcnt / this.prop.pagecnt) + ((parseInt(this.prop.totrowcnt % this.prop.pagecnt) == 0) ? 0 : 1);

    // block시작페이지
    this.prop.blockstart = (this.prop.blocknow - 1) * this.prop.blockcnt + 1;

    // block마지막페이지
    this.prop.blockend = this.prop.blockstart + this.prop.blockcnt - 1;
    if (this.prop.blockend > this.prop.totpagecnt) this.prop.blockend = this.prop.totpagecnt;

    // 전체블럭수
    this.prop.totblockcnt = parseInt(this.prop.totpagecnt / this.prop.blockcnt) + ((parseInt(this.prop.totpagecnt % this.prop.blockcnt) == 0) ? 0 : 1);

    // pageprev: 이전페이지 세팅 => (1페이지보다크다면) 현재 page 번호 - 1
    this.prop.pageprev = (this.prop.pagenow > 1) ? (this.prop.pagenow - 1) : 1;

    // pagenext: 다음페이지 세팅 => (마지막페이지보다작다면) 현재 page 번호 + 1
    this.prop.pagenext = (this.prop.pagenow < this.prop.totpagecnt) ? (this.prop.pagenow + 1) : this.prop.totpagecnt;

    // 이전 block의 첫페이지로 이동
    this.prop.blockprev = (this.prop.blocknow - 2) * this.prop.blockcnt + 1;
    if (this.prop.blockprev < 1) this.prop.blockprev = 1;

    // 다음 block의 첫페이지로 이동
    this.prop.blocknext = this.prop.blocknow * this.prop.blockcnt + 1;
    if (this.prop.blocknext > this.prop.totpagecnt) this.prop.blocknext -= this.prop.blockcnt;

};
ksid.paging.prototype.show = function () {

    var lsPager = '<div class="paging_wrap01">';

    // 좌측 페이지 정보 ( 현재페이지 / 전체페이지 [전페ROW수] ) 나중에 필요하면 아래 소스를 참고한다.

    if( this.prop.totpagecnt > this.prop.blockcnt ) {
        // 페이져 좌측 정보 ( 처음페이지 , 이전BLOCKCNT마지막페이지 )
        lsPager += '<span><a href="javascript:' + this.parent.id + '.pager.movePage(1)"><img src="' + this.context + '/static/image/ksid/paging_prive02.gif" alt="처음페이지"></a></span>';
        lsPager += '&nbsp;';
        lsPager += '<span><a href="javascript:' + this.parent.id + '.pager.movePage(' + this.prop.blockprev + ')"><img src="' + this.context + '/static/image/ksid/paging_prive01.gif" alt="이전 ' + this.prop.blockcnt + '개"></a></span>';
    } else {
        lsPager += '<span><img src="' + this.context + '/static/image/ksid/paging_prive02.gif" alt="처음페이지"></span>';
        lsPager += '&nbsp;';
        lsPager += '<span><img src="' + this.context + '/static/image/ksid/paging_prive01.gif" alt="이전 ' + this.prop.blockcnt + '개"></span>';
    }

    // 페이징 ( BLOCKSTART ~ BLOCKEND )
    lsPager += '<ul>';
    for (var i = this.prop.blockstart; i <= this.prop.blockend; i++) {
        // 현재페이지
        if (this.prop.pagenow == i) {
            lsPager += '<li>' + i + '</li>';
        } else {
            lsPager += '<li><a href="javascript:' + this.parent.id + '.pager.movePage(' + i + ')" title="' + i + '페이지로">' + i + '</a></li>';
        }

    }
    lsPager += '</ul>';
    if( this.prop.totpagecnt > this.prop.blockcnt ) {
        lsPager += '<span><a href="javascript:' + this.parent.id + '.pager.movePage(' + this.prop.blocknext + ')"><img src="' + this.context + '/static/image/ksid/paging_next01.gif" alt="다음 ' + this.prop.blockcnt + '개"></a></span>';
        lsPager += '&nbsp;';
        lsPager += '<span><a href="javascript:' + this.parent.id + '.pager.movePage(' + this.prop.totpagecnt + ')"><img src="' + this.context + '/static/image/ksid/paging_next02.gif" alt="마지막페이지로"></a></span>';
    } else {
        lsPager += '<span><img src="' + this.context + '/static/image/ksid/paging_next01.gif" alt="다음 ' + this.prop.blockcnt + '개"></span>';
        lsPager += '&nbsp;';
        lsPager += '<span><img src="' + this.context + '/static/image/ksid/paging_next02.gif" alt="마지막페이지로"></span>';
    }

    lsPager += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
    lsPager += '<span style="color:#999999">';
    lsPager += '(<strong>' + this.prop.pagenow + '</strong> Page / ' + ksid.string.formatNumber(this.prop.totpagecnt) + ' Pages , Total : <strong>' + ksid.string.formatNumber(this.prop.totrowcnt) + '</strong> rows)';
    lsPager += '</span>';

    lsPager += '</div>';

    $("#" + this.elementId).html(lsPager);

};
ksid.paging.prototype.movePage = function (aiPageNo) {

    var pager = this;

    pager.prop.pagenow = aiPageNo;
    pager.initPager();
    pager.selectFunc();
    pager.show();

//    ksid.site.pager[asRefName].prop.PAGENOW = aiPageNo;
//    ksid.site.pager[asRefName].initPager();
//    ksid.site.pager[asRefName].selectFunc(ksid.site.pager[asRefName].selectFuncCallback);
//    ksid.site.pager[asRefName].show();

};
ksid.paging.prop = {

    totrowcnt: 0,       // 전체row수
    pagecnt: 20,        // 페이지당row수
    pagenow: 1,         // 현재page번호
    blockcnt: 10,       // 블록당페이지수
    blocknow: 1,        // 현재block번호
    pagestart: 0,       // 현재페이지시작번호
    pageend: 0,         // 현재페이지끝번호
    totpagecnt: 0,      // 전체페이지수
    blockstart: 1,      // block시작페이지
    blockend: 1,        // block마지막페이지
    totblockcnt: 0,     // 전체블럭수
    pageprev: 0,        // 이전페이지
    pagenext: 0,        // 다음페이지
    blockprev: 0,       // 이전blockcnt마지막페이지
    blocknext: 0        // 다음blockcnt첫페이지

};




