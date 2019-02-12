package ksid.biz.util;


public class CommonConstantDefine {
    public final static int ROK   = 0;
    public final static int RFAIL = -1;
    public final static int RFAIL_AUTH = 1;
    public final static int RFAIL_TIMEOUT = 2;

    public final static int INS_DEL_MAX_CNT = 1;
    public final static int SEL_MIN_CNT     = 1;
    public final static int UPD_MIN_CNT     = 1;

    public final static int SEND_PC  = 1;
    public final static int SEND_APP = 2;

    public final static String MINOR    = "-";
    public final static String NORMAL   = "NOR";
    public final static String REQUEST  = "REQ";
    public final static String RESPONSE = "REP";
    public final static String RESULT   = "RES";

    public final static String PKITYPE_PC  = "1";
    public final static String PKITYPE_APP = "2";

    public final static String SMS = "1";
    public final static String LMS = "2";
    public final static String MMS = "3";

    public final static String SQL_ROK          = "00";
    public final static String SQL_RFAIL        = "01";
    public final static String AUTH_RFAIL       = "02";
    public final static String AUTH_ROK         = "03";
    public final static String TIMEOUT_RFAIL    = "04";
    public final static String USERINFO_RFAIL   = "05";
    public final static String CUSTUSERNO_RFAIL = "06";
    public final static String TELNO_RFAIL      = "07";
    public final static String USER_PAY         = "08";
    public final static String USER_UNPAY       = "09";
    public final static String USER_PROID_OVER  = "10";
    public final static String USER_PROID_NOT  = "11";

    public final static String MOBILE_AUTH_OK  = "1";
    public final static String MOBILE_AUTH_NOK = "2";

    public final static String DEV_PCWEB = "PC";
    public final static String DEV_APP   = "APP";
    public final static String DEV_PROXY = "PROXY";

    public final static String WEB_SVC_REG    = "REG";
    public final static String WEB_SVC_CANCEL = "CANCEL";
    public final static String WEB_SVC_PAY    = "PAY";
    public final static String WEB_SVC_INFO   = "INFO";
}
