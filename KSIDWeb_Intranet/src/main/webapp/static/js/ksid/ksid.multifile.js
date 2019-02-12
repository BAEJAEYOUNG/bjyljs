ksid.multifile = function(args) {

    this.config = {};
    this.config.id = null;             // 파일 div id
    this.config.title = "파일첨부";    // 파일 dialog title
    this.config.contextPath = "";      // context root path

    this.grid = null;       // file grid

    // 추가 argument 가 있으면 기존 config 에 덮어쓴다.
    if(args) {
        ksid.json.mergeObject(this.config, args);
    }



};
// 파일 그리드및 버튼 load
ksid.multifile.prototype.load = function() {



};