/*******************************************************************************
 * 파일명: ksid.date.js
 *
 * 설명: 전체 홈페이지 날짜 관련 class
 *
 * 수정일 수정자 수정내용 ------------------------------------------------------
 * 2015-02-13 배재영 초기작성 ------------------------------------------------------
 ******************************************************************************/

ksid.datetime = {};

// ksid site class
ksid.datetime = function() {
    this.date = null;
    this.yyyy = null;
    this.mm = null;
    this.dd = null;
    this.hh = null;
    this.mi = null;
    this.ss = null;
    this.pm = false;
    this.weekday = null;
    this.dayKor = "";
    this.dayEng = "";
    this.dayCnt = 0;
    this.weekOfMonth = "";
    this.weekName = "";
    this.weekOfMonth = "";
    this.arrDayCnt = ksid.datetime.lang.DAYCNT;
    this.arrDayKor = ksid.datetime.lang.DAYNAME_ORGINAL;
    this.arrDayEng = ksid.datetime.lang.DAYENG_ORGINAL;
    this.arrWeekOfMonth = ksid.datetime.lang.WEEKOFMONTH;
    this.arrWeekName = ksid.datetime.lang.WEEKNAME;
    this.hashDayName = ksid.datetime.lang.HASH_DAYNAME;
    this.hashWeekOfMonth = ksid.datetime.lang.HASH_WEEKOFMONTH;
    this.hashWeekName = ksid.datetime.lang.HASH_WEEKNAME;

    if (typeof arguments[0] == "undefined")
        this.date = new Date();
    else if (typeof arguments[0] == "object") {
        this.date = arguments[0];
    } else
        this.setDate(arguments[0]);

    this.init();
    return this;
};

/**
    영업일기준 이전일로 datetime object 가져오기
    사용법 : new ksid.datetime().beforeWorkDateTime();
**/
ksid.datetime.prototype.beforeWorkDateTime = function() {

    if(this.dayKor == "토") {
        return this.before(0,0,1);
    } else if(this.dayKor == "일") {
        return this.before(0,0,2);
    } else {
        return this;
    }

};

/**
영업일기준 이후일로 datetime object 가져오기
사용법 : new ksid.datetime().afterWorkDateTime();
**/
ksid.datetime.prototype.afterWorkDateTime = function() {

    if(this.dayKor == "토") return this.after(0,0,2);
    if(this.dayKor == "일") return this.after(0,0,1);

};

/** 해당월의 주의 갯수  **/
ksid.datetime.prototype.getWeekCnt = function() {
    return Math
            .ceil((this.dd + new Date(this.yyyy, this.mm - 1, 1).getDay()) / 7);
};

/** 초기화 **/
ksid.datetime.prototype.init = function() {
    this.yyyy = this.date.getFullYear();
    this.mm = this.date.getMonth() + 1;
    this.dd = this.date.getDate();
    this.hh = this.date.getHours();
    this.mi = this.date.getMinutes();
    this.ss = this.date.getSeconds();

    if ((this.yyyy % 4 == 0 || this.yyyy % 100 == 0) && (this.yyyy % 400 == 0)) {
        this.arrDayCnt[1] = 29;
    } else {
        this.arrDayCnt[1] = 28;
    }

    this.dayCnt = this.arrDayCnt[this.mm - 1];

    this.dayKor = this.arrDayKor[this.date.getDay()];
    this.dayEng = this.arrDayEng[this.date.getDay()];

    if (this.getWeekCnt() <= 4)
        this.weekOfMonth = this.arrWeekOfMonth[this.getWeekCnt()];
    else
        this.weekOfMonth = this.arrWeekOfMonth[5];
};

/** Strign format의 날짜형식으로 datetime object 생성하기 **/
ksid.datetime.prototype.setDate = function(asDate) {
    var lsDate = asDate.toUpperCase();
    lsDate = ksid.string.replace(lsDate, "-", "");
    lsDate = ksid.string.replace(lsDate, ".", "");
    lsDate = ksid.string.replace(lsDate, "/", "");
    lsDate = ksid.string.replace(lsDate, ":", "");
    lsDate = ksid.string.replace(lsDate, " ", "");
    lsDate = ksid.string.replace(lsDate, "년", "");
    lsDate = ksid.string.replace(lsDate, "월", "");
    lsDate = ksid.string.replace(lsDate, "일", "");
    lsDate = ksid.string.replace(lsDate, "시", "");
    lsDate = ksid.string.replace(lsDate, "분", "");
    lsDate = ksid.string.replace(lsDate, "초", "");
    lsDate = ksid.string.replace(lsDate, "월", "");
    lsDate = ksid.string.replace(lsDate, "화", "");
    lsDate = ksid.string.replace(lsDate, "수", "");
    lsDate = ksid.string.replace(lsDate, "목", "");
    lsDate = ksid.string.replace(lsDate, "금", "");
    lsDate = ksid.string.replace(lsDate, "토", "");
    lsDate = ksid.string.replace(lsDate, "일", "");
    lsDate = ksid.string.replace(lsDate, "(", "");
    lsDate = ksid.string.replace(lsDate, ")", "");
    lsDate = ksid.string.replace(lsDate, "T", "");
    lsDate = ksid.string.replace(lsDate, "Z", "");
    lsDate = ksid.string.replace(lsDate, "D", "");

    if (lsDate.indexOf("오후") > 0)
        this.pm = true;

    lsDate = ksid.string.replace(lsDate, "오전", "");
    lsDate = ksid.string.replace(lsDate, "오후", "");

    if (lsDate.indexOf("PM") > 0)
        this.pm = true;

    lsDate = ksid.string.replace(lsDate, "AM", "");
    lsDate = ksid.string.replace(lsDate, "PM", "");

    this.yyyy = ksid.number.toNumber(lsDate.substring(0, 4));
    this.mm = ksid.number.toNumber(lsDate.substring(4, 6));
    this.dd = ksid.number.toNumber(lsDate.substring(6, 8));

    if (lsDate.length >= 10) {
        this.hh = ksid.number.toNumber(lsDate.substring(8, 10));

        if (this.pm)
            this.hh += 12;
    } else
        this.hh = 0;

    if (lsDate.length >= 12)
        this.mi = ksid.number.toNumber(lsDate.substring(10, 12));
    else
        this.mi = 0;

    if (lsDate.length >= 14)
        this.ss = ksid.number.toNumber(lsDate.substring(12, 14));
    else
        this.ss = 0;

    this.date = new Date(this.yyyy, this.mm - 1, this.dd, this.hh, this.mi,
            this.ss);

    this.init();

    return this;
};

ksid.datetime.prototype.getApm = function() {
    return (this.hh < 12) ? "오전" : "오후";
};

ksid.datetime.prototype.getApmEng = function() {
    return (this.hh < 12) ? "AM" : "PM";
};

ksid.datetime.prototype.getDate = function(asFormat) {
    if (asFormat == "object")
        return this.date;
    else {
        var lsReturn = asFormat;

        lsReturn = ksid.string.replace(lsReturn, "yyyy", this.yyyy);

        if (lsReturn.indexOf("yy") > -1)
            lsReturn = ksid.string.replace(lsReturn, "yy", ksid.string.right(this.yyyy.toString(), 2));

        if (lsReturn.indexOf("mmN") > -1)
            lsReturn = ksid.string.replace(lsReturn, "mmN", this.mm);

        if (lsReturn.indexOf("mm") > -1)
            lsReturn = ksid.string.replace(lsReturn, "mm", ksid.string.lpad(this.mm, "0", 2));

        if (lsReturn.indexOf("ddN") > -1)
            lsReturn = ksid.string.replace(lsReturn, "ddN", this.dd);

        if (lsReturn.indexOf("dd") > -1)
            lsReturn = ksid.string.replace(lsReturn, "dd", ksid.string.lpad(this.dd, "0", 2));

        if (lsReturn.indexOf("hhN") > -1)
            lsReturn = ksid.string.replace(lsReturn, "hhN", this.hh);

        if (lsReturn.indexOf("hh") > -1)
            lsReturn = ksid.string.replace(lsReturn, "hh", ksid.string.lpad(ksid.string.ltrim(this.hh), "0", 2));

        if (lsReturn.indexOf("miN") > -1)
            lsReturn = ksid.string.replace(lsReturn, "miN", this.mi);

        if (lsReturn.indexOf("mi") > -1)
            lsReturn = ksid.string.replace(lsReturn, "mi", ksid.string.lpad(ksid.string.ltrim(this.mi), "0", 2));

        if (lsReturn.indexOf("ssN") > -1)
            lsReturn = ksid.string.replace(lsReturn, "ssN", this.ss);

        if (lsReturn.indexOf("ss") > -1)
            lsReturn = ksid.string.replace(lsReturn, "ss", ksid.string.lpad(ksid.string.ltrim(this.ss), "0", 2));

        if (lsReturn.indexOf("day") > -1)
            lsReturn = ksid.string.replace(lsReturn, "eday", this.arrDayCnt[this.mm - 1]);

        if (lsReturn.indexOf("day") > -1)
            lsReturn = ksid.string.replace(lsReturn, "day", this.dayKor);

        if (lsReturn.indexOf("KAMPM") > -1)
            lsReturn = ksid.string.replace(lsReturn, "KAMPM", this.getApm());

        if (lsReturn.indexOf("AMPM") > -1)
            lsReturn = ksid.string.replace(lsReturn, "AMPM", this.getApmEng());

        if (lsReturn.indexOf("KWOM") > -1)
            lsReturn = ksid.string.replace(lsReturn, "KWOM", this.hashWeekOfMonth[this.weekOfMonth]);

        if (lsReturn.indexOf("WOM") > -1)
            lsReturn = ksid.string.replace(lsReturn, "WOM", this.weekOfMonth);

        return lsReturn;
    }
};

/*******************************************************************************
 * 연중 몇째 주인지 가져오기
 ******************************************************************************/
ksid.datetime.prototype.getWeek = function() {
    var onejan = new Date(this.date.getFullYear(), 0, 1);

    return Math.ceil((((this - onejan) / 86400000) + onejan.getDay() + 1) / 7);
};
ksid.datetime.prototype.after = function(years, months, dates, hours,
        miniutes, seconds, mss) {
    if (typeof years == "undefined")
        years = 0;
    if (typeof months == "undefined")
        months = 0;
    if (typeof dates == "undefined")
        dates = 0;
    if (typeof hours == "undefined")
        hours = 0;
    if (typeof miniutes == "undefined")
        miniutes = 0;
    if (typeof seconds == "undefined")
        seconds = 0;
    if (typeof mss == "undefined")
        mss = 0;
    this.date = this.date.after(years, months, dates, hours, miniutes, seconds,
            mss);
    this.init();
    return this;
};
ksid.datetime.prototype.afterWork = function(years, months, dates, hours, miniutes, seconds, mss) {

    this.after(years, months, dates, hours, miniutes, seconds, mss);

    if( this.dayKor == "토" ) this.after(0, 0, 2);
    else if( this.dayKor == "일" ) this.after(0, 0, 1);

    return this;

};
ksid.datetime.prototype.after_string = function(as_date) {

    var lsr_date = as_date.split(",");

    var years = 0;
    var months = 0;
    var dates = 0;

    for ( var i = 0; i < lsr_date.length; i++) {

        if (i == 0) {
            years = Number(lsr_date[i]);
        } else if (i == 1) {
            months = Number(lsr_date[i]);
        } else if (i == 2) {
            dates = Number(lsr_date[i]);
        }
    }

    return this.after(years, months, dates);

};
ksid.datetime.prototype.before = function(years, months, dates, hours,
        miniutes, seconds, mss) {
    if (typeof years == "undefined")
        years = 0;
    if (typeof months == "undefined")
        months = 0;
    if (typeof dates == "undefined")
        dates = 0;
    if (typeof hours == "undefined")
        hours = 0;
    if (typeof miniutes == "undefined")
        miniutes = 0;
    if (typeof seconds == "undefined")
        seconds = 0;
    if (typeof mss == "undefined")
        mss = 0;
    this.date = this.date.before(years, months, dates, hours, miniutes,
            seconds, mss);
    this.init();
    return this;
};
ksid.datetime.prototype.beforeWork = function(years, months, dates, hours, miniutes, seconds, mss) {

    this.before(years, months, dates, hours, miniutes, seconds, mss);

    if( this.dayKor == "토" ) this.before(0, 0, 1);
    else if( this.dayKor == "일" ) this.before(0, 0, 2);

    return this;

};
ksid.datetime.prototype.dateCompare = function(startDate, endDate) {
    var Sdt = new Date(startDate.substring(0, 4) + "-"
            + startDate.substring(4, 6) + "-" + startDate.substring(6, 9));
    var Edt = new Date(endDate.substring(0, 4) + "-" + endDate.substring(4, 6)
            + "-" + endDate.substring(6, 9));

    if ((Edt - Sdt) < 0) {
        return false;
    }

    return true;
};

/*******************************************************************************
 * @type : Prototype Function
 * @object : Date
 * @access : public
 * @desc : 현재 Date 객체의 날짜보다 이후 날짜를 가진 Date 객체를 리턴한다. 예를 들어 내일 날짜를 얻으려면 다음과 같이 하면
 *       된다.
 *
 * <pre>
 * 사용예 :
 *     주로 format()과 함께 사용한다.
 *     var oneDayAfter = new Date.after(0, 0, 1); =&gt; Fri Apr 11 13:19:45 UTC+0900 2003
 *     var oneDayAfter = new Date.after(0, 0, 1).format(&quot;YYYYYMMDD&quot;); =&gt; 20030411
 *
 *     - 다음날의 경우 : after(0, 0, 1);
 *     - 다음달의 경우 : after(0, 1, 0);
 *     - 내년의 경우   : after(1, 0, 0);
 * </pre>
 *
 * @sig : [years[, months[, dates[, hours[, minutes[, seconds[, mss]]]]]]]
 * @param :
 *            years optional 이후 년수
 * @param :
 *            months optional 이후 월수
 * @param :
 *            dates optional 이후 일수
 * @param :
 *            hours optional 이후 시간수
 * @param :
 *            minutes optional 이후 분수
 * @param :
 *            seconds optional 이후 초수
 * @param :
 *            mss optional 이후 밀리초수
 * @return : 이후 날짜를 표현하는 Date 객체
 ******************************************************************************/
Date.prototype.after = function(years, months, dates, hours, miniutes, seconds,
        mss) {
    if (typeof years == "undefined")
        years = 0;
    if (typeof months == "undefined")
        months = 0;
    if (typeof dates == "undefined")
        dates = 0;
    if (typeof hours == "undefined")
        hours = 0;
    if (typeof miniutes == "undefined")
        miniutes = 0;
    if (typeof seconds == "undefined")
        seconds = 0;
    if (typeof mss == "undefined")
        mss = 0;

    return new Date(this.getFullYear() + years
            , this.getMonth() + months
            , this.getDate() + dates
            , this.getHours() + hours
            , this.getMinutes() + miniutes
            , this.getSeconds() + seconds
            , this.getMilliseconds() + mss);
};

/*******************************************************************************
 * @type : Prototype Function
 * @object : Date
 * @access : public
 * @desc : 현재 Date 객체의 날짜보다 이전 날짜를 가진 Date 객체를 리턴한다. 예를 들어 어제 날짜를 얻으려면 다음과 같이 하면
 *       된다.
 *
 * <pre>
 * 사용예 :
 *     주로 format()과 함께 사용한다.
 *     var oneDayBefore = new Date.before(0, 0, 1); =&gt; Fri Apr 11 13:19:45 UTC+0900 2003
 *     var oneDayBefore = new Date.before(0, 0, 1).format(&quot;YYYYYMMDD&quot;); =&gt; 20030411
 *
 *     - 하루전 : before(0, 0, 1);
 *     - 한달전 : before(0, 1, 0);
 *     - 일년전 : before(1, 0, 0);
 * </pre>
 *
 * @sig : [years[, months[, dates[, hours[, minutes[, seconds[, mss]]]]]]]
 * @param :
 *            years optional 이전으로 돌아갈 년수
 * @param :
 *            months optional 이전으로 돌아갈 월수
 * @param :
 *            dates optional 이전으로 돌아갈 일수
 * @param :
 *            hours optional 이전으로 돌아갈 시간수
 * @param :
 *            minutes optional 이전으로 돌아갈 분수
 * @param :
 *            seconds optional 이전으로 돌아갈 초수
 * @param :
 *            mss optional 이전으로 돌아갈 밀리초수
 * @return : 이전 날짜를 표현하는 Date 객체
 ******************************************************************************/
Date.prototype.before = function(years, months, dates, hours, miniutes,
        seconds, mss) {
    if (typeof years == undefined)
        years = 0;
    if (typeof months == undefined)
        months = 0;
    if (typeof dates == undefined)
        dates = 0;
    if (typeof hours == undefined)
        hours = 0;
    if (typeof miniutes == undefined)
        miniutes = 0;
    if (typeof seconds == undefined)
        seconds = 0;
    if (typeof mss == undefined)
        mss = 0;

    return new Date(this.getFullYear() - years
            , this.getMonth() - months
            , this.getDate() - dates
            , this.getHours() - hours
            , this.getMinutes() - miniutes
            , this.getSeconds() - seconds
            , this.getMilliseconds() - mss);
};

ksid.datetime.lang = {
    AM : "오전",
    PM : "오후",
    RECURRING_TRUE : "설정",
    RECURRING_FALSE : "해제",
    DAYNAME : [ "월", "화", "수", "목", "금", "토", "일" ],
    DAYNAME_ORGINAL : [ "일", "월", "화", "수", "목", "금", "토" ],
    DAYENG_ORGINAL : [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
            "Friday", "Saturday" ],
    WEEKNAME : [ "", "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December" ],
    WEEKOFMONTH : [ "", "First", "Second", "Third", "Fourth", "Last" ],
    DAYCNT : [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ],
    REMINDER : [ 0, 15, 30, 60, 120, 180, 720, 1440, 2880, 4320, 10080, 20160,
            30240 ],
    HASH_WEEKOFMONTH : {
        "First" : "첫째주",
        "Second" : "둘째주",
        "Third" : "셋째주",
        "Fourth" : "넷째주",
        "Last" : "마지막주"
    },
    HASH_DAYNAME : {
        "Monday" : "월요일",
        "Tuesday" : "화요일",
        "Wednesday" : "수요일",
        "Thursday" : "목요일",
        "Friday" : "금요일",
        "Saturday" : "토요일",
        "Sunday" : "일요일"
    },
    HASH_WEEKNAME : {
        "January" : 1,
        "February" : 2,
        "March" : 3,
        "April" : 4,
        "May" : 5,
        "June" : 6,
        "July" : 7,
        "August" : 8,
        "September" : 9,
        "October" : 10,
        "November" : 11,
        "December" : 12
    },
    HASH_REMINDER : {
        0 : "해제",
        15 : "15분",
        30 : "30분",
        60 : "1시간",
        120 : "2시간",
        180 : "3시간",
        720 : "12시간",
        1440 : "1일",
        2880 : "2일",
        4320 : "3일",
        10080 : "1주",
        20160 : "2주",
        30240 : "3주"
    }
};