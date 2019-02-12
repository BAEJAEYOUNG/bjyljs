
/**
 * ksid calendar class
 */

ksid.calendar = function( findMm ) {
    
    this.arrDayObj      = [];   // 일별데이터배열
    this.arrCalendar    = [];   // 달력배열
    
    var startDy        = findMm + '01';

    var cDate          = new ksid.datetime().setDate(startDy);
    
    var endDy          = cDate.getDate("yyyymmeday");
    
    var startDay       = cDate.date.getDay(); // 0:일 , 1:월 , 2:화 , 3:수 , 4:목 , 5:금 , 6:토
    var startDayKor    = cDate.dayKor;
    var dayCnt         = cDate.dayCnt;
    
//    alert('startDy = ' + startDy);
//    alert('startDay = ' + startDay);
//    alert('startDayKor = ' + startDayKor);
    
    for ( var i = 1; i <= dayCnt; i++) {
        
        var dayObj = { "day" : i , "day_dy" : findMm  + ksid.string.lpad( i, 2, "0" ) , msg : "" };
        
        this.arrDayObj.push(dayObj);
        
    }
    
    var arrWeek = [];
    var weekIdx = 0;

    for ( var i = 0; i < dayCnt; i++) {
        
        iDay = startDay % 7;

        // 시작이거나 일요일이면 새로운 배열을 만든다.
        if( i == 0 || ( i > 0 && iDay == 0 ) ) {
            
            arrWeek[weekIdx] = [];
            arrWeek[weekIdx].length = 7;
            
        }
        
        this.arrDayObj[i].weekday   = ( iDay + 1 );         // oracle 기준으로 요일숫자 추가
        arrWeek[weekIdx][iDay]      = this.arrDayObj[i];
        
        // 토요일 이거나 마지막 데이터라면 달력배열에 push 한다.
        if( iDay == 6 || ( iDay < 6 && i == (dayCnt-1) ) ) {
            
            this.arrCalendar.push(arrWeek[weekIdx]);
            
            weekIdx++;
            
        }
        
        startDay++;
        
    }
    
};
// 달력의 해당날짜에 보여질 메세지를 세팅한다.
ksid.calendar.prototype.setDay = function(dy, msg) {
    
    for ( var i = 0; i < this.arrDayObj.length; i++) {
        
        if( this.arrDayObj[i] != null && this.arrDayObj[i].day_dy == dy ) {
        
            this.arrDayObj[i].msg = msg;
            
            break;
            
        }
        
    }
    
};
ksid.calendar.prototype.printData = function() {
    
    for ( var i = 0; i < this.arrCalendar.length; i++) {
        
        ksid.debug.printArrayObj('arrCalendar[ ' + i + ' ]', this.arrCalendar[i]);
        
    }
    
};
