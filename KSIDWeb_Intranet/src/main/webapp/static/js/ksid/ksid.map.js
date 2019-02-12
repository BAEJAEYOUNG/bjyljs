var normalImage = new google.maps.MarkerImage(
					'/resources/images/icons/icon50.png',
                    new google.maps.Size(32, 32),
                    new google.maps.Point(0, 0),
                    new google.maps.Point(12, 12),
                    new google.maps.Size(24, 24)
                );


var emergencyImage = new google.maps.MarkerImage(
		'/resources/images/icons/icon49.png',
        new google.maps.Size(32, 32),
        new google.maps.Point(0, 0),
        new google.maps.Point(12, 12),
        new google.maps.Size(24, 24)
    );


var selectImage = new google.maps.MarkerImage(
        '/resources/images/icons/icon57.png',
        new google.maps.Size(32, 32),
        new google.maps.Point(0, 0),
        new google.maps.Point(12, 12),
        new google.maps.Size(24, 24)
    );


ksid.map = function() {
    
    this.id = null;     // wrapper id
    
    this.map = null;    // google map instance
    this.routhPath = null;   // google map pliyline instance
    
    this.mapOption = {  // google map option -> draw 시에 center 를 추가하여 그린다.
        zoom: 3,
        mapTypeId: google.maps.MapTypeId.TERRAIN
    };
    
    this.list = [];     // list data
    
    this.coords = [];   // map 좌표 google.maps.LatLng type array [ { lat:function(), lng:function(), toString(), toJSON() } ........ ]
    
    this.lineOption = { // poly line option -> draw 시에 path를 추가하여 그린다.
//        geodesic: true,
        strokeColor: '#FF6633',
        strokeOpacity: 0.8,
        strokeWeight: 3
    };
    
    this.markers = [];  // marker array
    
    this.totDistance_m = 0; // 총 이동거리(m)
    
};
// wrapper id , option 추가
ksid.map.prototype.init = function( mapId, aoOption ) {
    
    this.id = mapId;
    this.wrapper = document.getElementById(mapId);
    
    if( typeof mapOption != "undefined" ) {
        ksid.json.mergeObject( this.mapOption, aoOption );
    }
    
};
// 좌표추가
ksid.map.prototype.setList = function( arrList ) {

    this.list = ksid.json.cloneObject(arrList);
    
    var lat = 0;
    var lng = 0;

    if(this.list.length == 0) {

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function(position) {
                    lat = position.coords.latitude;
                    lng = position.coords.longitude;
                }
                , function() { alert("navigator geolocation error"); }
            );
        }
        
    } else {
        lat = this.list[this.list.length -1]["latitude"];
        lng = this.list[this.list.length -1]["longitude"];
    }
    
    this.mapOption.center = { "lat":lat, "lng":lng };

};
// 구글맵 drow
ksid.map.prototype.draw = function() {
    
    this.map = new google.maps.Map(this.wrapper, this.mapOption);
    
    if( this.list.length == 0 ) return;
    
    // 좌표 추가
    for (var i = 0; i < this.list.length; i++) {
        
        var point = new google.maps.LatLng(this.list[i]["latitude"], this.list[i]["longitude"]);
        
        this.coords.push( point );
        
        this.setMarker(point, this.coords.length);
        
    }
    
    this.lineOption.path = this.trimCoords();
    
    this.routhPath = new google.maps.Polyline(this.lineOption);
    this.routhPath.setMap(this.map);
    
    this.setDistance();
    
    this.setZoom();
    
};

//좌표중 0, 0 좌표 제거
ksid.map.prototype.trimCoords = function() {
	var trimCoords = [];
	
	for (var i = 0; i < this.coords.length; i++) {
		if(this.coords[i] != "(0, 0)"){
			trimCoords.push(this.coords[i]);
		}
	}
	
	return trimCoords;
}

//새로 추가된 좌표 marker, polyline 그리기
ksid.map.prototype.addDraw = function() {
    
    if( this.list.length == 0 ) return;
    
    
    for (var i = this.coords.length; i < this.list.length; i++) {
        
        var point = new google.maps.LatLng(this.list[i]["latitude"], this.list[i]["longitude"]);
        
        this.coords.push( point );
        
        if(this.list[i]["latitude"] != null && this.list[i]["longitude"] != null){
        	
        	//새로운 마커 추가
        	this.setMarker(point, this.coords.length);
        	
        	//새로운 동선 추가
        	this.routhPath.getPath().push(point);
        }
        
    }
    
    this.setZoom();
    
};

ksid.map.prototype.setMarker = function( point, number) {
    
    var image = normalImage;
//    var imageSrc = '/resources/images/icons/marker2.png';
    
    if( this.list[number-1].prog_fg == '50' ) {
    	image = emergencyImage;
//        imageSrc = '/resources/images/icons/marker4.png';
    }
    
//    var image = new google.maps.MarkerImage(
//                    imageSrc,
//                    new google.maps.Size(32, 32),
//                    new google.maps.Point(0, 0),
//                    new google.maps.Point(12, 12),
//                    new google.maps.Size(24, 24)
//                );
    
    var text="(" + number + ")" + point;
    
    var refMap = this;
    
    var defaultPoint = "";
    
//    ksid.debug.printObj(google.maps.Animation);
    setTimeout(
        function() {
            refMap.markers.push(
                                new google.maps.Marker(
                                        {
                                            position    : point,
                                            map         : refMap.map,
                                            icon        : image,
//                                            label       : number+"",
                                            title       : text,
//                                            animation   : google.maps.Animation.DROP,
//                                            animation   : google.maps.Animation.BOUNCD,
//                                            animation   : google.maps.Animation.Tr,
//                                            animation   : google.maps.Animation.Rr,
                                            zIndex      : number,
                                            draggable   : false
                                         }
                                   )
                             );
            refMap.markers[number-1].idx = number;
            
            if(point == "(0, 0)"){
            	refMap.markers[number-1].setVisible(false);
            }
            
            // marker click 시 listener ( 차후 이용하기로 한다. )
            google.maps.event.addListener(refMap.markers[number-1], 'click', function(e) {
               
                if(typeof clickMarker == "function") {
                    clickMarker(e, this);
                }
                
            });
            
        }, number * 50
    );
    
};
ksid.map.prototype.setDistance = function() {
    
    this.totDistance_m = 1000 * this.routhPath.inKm();
    
};
ksid.map.prototype.setZoom = function() {
    
    var latlngBounds = new google.maps.LatLngBounds();
    
    var thisCoords = this.trimCoords();
    
    if (thisCoords) 
    {
        for (i in thisCoords) 
        {
            latlngBounds.extend(thisCoords[i]);
        }
    }
    
    this.map.setCenter(latlngBounds.getCenter());
    
//    if(thisCoords.length>1){//1개 일때 센터 최대확대 방지
    	this.map.fitBounds(latlngBounds);
//    }

    
};

google.maps.LatLng.prototype.kmTo = function(a)
{
    var e = Math, ra = e.PI/180;
    var b = this.lat() * ra, c = a.lat() * ra, d = b - c;
    var g = this.lng() * ra - a.lng() * ra;
    var f = 2 * e.asin(e.sqrt(e.pow(e.sin(d/2), 2) + e.cos(b) * e.cos(c) * e.pow(e.sin(g/2), 2)));
    return f * 6378.137;
};

google.maps.Polyline.prototype.inKm = function(n)
{
    var a = this.getPath(n), len = a.getLength(), dist = 0;
    for(var i=0; i<len-1; i++)
    {
        dist += a.getAt(i).kmTo(a.getAt(i+1));
    }
    return dist;
};

//그리드에서 선택시 구글맵 마커 이미지 변경 메서드
ksid.map.prototype.changeMarker = function(rowId) {
	
	var iRow = $('#' + rowId)[0].rowIndex;
	
	if(this.selMarkerInfo){
     	var image = normalImage;
     	if(this.selGridInfo.prog_fg == '50'){
     		image = emergencyImage;
     	}
     	
//     	 var image1 = new google.maps.MarkerImage(
//                 imageSrc,
//                 new google.maps.Size(32, 32),
//                 new google.maps.Point(0, 0),
//                 new google.maps.Point(12, 12),
//                 new google.maps.Size(24, 24)
//             );
     	
     	this.selMarkerInfo.setIcon(image);
     }
    
	//선택된 마커 정보 기억
	this.selMarkerInfo = this.markers[this.markers.length-iRow];
	this.selGridInfo = this.list[this.list.length-iRow];
	
//	var image2 = new google.maps.MarkerImage(
//			"/resources/images/icons/icon57.png",
//            new google.maps.Size(32, 32),
//            new google.maps.Point(0,0),
//            new google.maps.Point(12, 12),
//            new google.maps.Size(24, 24)
//        );
	this.markers[this.markers.length-iRow].setIcon(selectImage);
	
//    this.markers[this.markers.length-iRow].setIcon("/resources/images/icons/yellow-dot.png");
    
}



// auto zoom value 구하기
//ksid.map.prototype.setZoom = function() {
//    
//    var latlngbounds = new google.maps.LatLngBounds();
//    
//    for( i in this.coords ) {
//        
//        latlngbounds.extend(this.coords[i]);
//        
//    }
//    
//    this.map.setCenter(latlngbounds.getCenter());
//    this.map.fitBounds(latlngbounds);
//    
//    
////    var minLat = 180;
////    var maxLat = 0;
////    var minLng = 360;
////    var maxLng = 0;
////    
////    for (var i = 0; i < this.coords.length; i++) {
////        if( this.coords[i].lat >= maxLat ) maxLat = this.coords[i].lat;
////        if( this.coords[i].lat <= minLat ) minLat = this.coords[i].lat;
////        if( this.coords[i].lng >= maxLng ) maxLng = this.coords[i].lng;
////        if( this.coords[i].lng <= minLng ) minLng = this.coords[i].lng;
////    }
////
////    var maxLatlng = new GLatLng(maxLat, maxLng);
////    var minLatlng = new GLatLng(minLat, minLng);
////    
////    alert(minLatlng.distanceFrom(maxLatlng) / 1000);
////    
//////    alert( maxLng + " - " + minLng + " = " + (maxLng - minLng) );
////    
////    var gapLat = Math.abs(maxLat - minLat);
////    var gapLng = Math.abs(maxLng - minLng) ;
////    
////    gapLat = ( gapLat == 0 ) ? 180 : gapLat;
////    gapLng = ( gapLng == 0 ) ? 360 : gapLng;
////
////    
////    
////    zoomLat = ( Math.ceil(gapLat * 20 / 360) - 2 >= 2 ) ? Math.ceil(gapLat * 20 / 360) - 2 : 2 ;
////    zoomLng = ( Math.ceil(gapLng * 20 / 360) - 2 >= 2 ) ? Math.ceil(gapLng * 20 / 360) - 2 : 2 ;
////    
////    return ( zoomLat <= zoomLng ) ? zoomLat : zoomLng;
//    
//};
//ksid.map.prototype.drawMarkerLine = function() {
//    
//    var mapRef = this;
//    
//    this.polyline = new google.maps.Polyline(this.lineOption);
//    this.polyline.setMap(this.map);
//    
//    for (var i = 0; i < this.coords.length; i++) {
//
//        var marker = new google.maps.Marker({
//            position    : mapRef.coords[i],
//            map         : mapRef.map,
//            animation   : google.maps.Animation.DROP,
//            zIndex      : i
//        });
//        
//        marker.idx = i;
//        
//        this.markers.push(marker);
//        
//        this.markers[i].addListener('click', function(e) {
//            if(typeof clickMarker == "function") {
//                clickMarker(e, this.idx);
//            }
//        });
//        
//       if( this.list[i]['mf_evt_h'] == "1" ) {
//           var cityCircle = new google.maps.Circle({
//               strokeColor: '#FF0000',
//               strokeOpacity: 0.8,
//               strokeWeight: 2,
//               fillColor: '#FF0000',
//               fillOpacity: 0.35,
//               map: mapRef.map,
//               center: { lat:mapRef.list[i]["lat"], lng:mapRef.list[i]["lng"] },
//               radius: Math.sqrt(2000000) * 100
//             });
//       }
//        
//    }
//    
//};