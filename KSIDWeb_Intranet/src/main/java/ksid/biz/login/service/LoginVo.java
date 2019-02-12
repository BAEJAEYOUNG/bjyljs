package ksid.biz.login.service;

/**
 * <pre>
 * ksid.web.login.service
 * LoginVo.java
 * </pre>
 * @author  : jybae
 * @Date    : 2016. 7. 18.
 * @Version : 1.0
 * @Comment :
 */
public class LoginVo {

    private String authGrpCd;       // 권한그룹코드( AGC000:ROOT관리자, 001:내부관리자, 005:콜센터, 010:SP관리자, 011:SP사용자
                                    //                           , 020:제조사관리자, 021:제조사사용자(AGC000 ~ AGC999))
    private String spCd;            // 서비스제공자코드
    private String adminId;         // 관리자아이디
    private String makerCd;         // 제조사코드
    private String adminPw;         // 관리자비밀번호
    private String deptCd;          // 부서코드
    private String adminNm;         // 관리자명
    private String hpHo;            // 휴대폰번호
    private String email;           // 이메일
    private String sex;             // 성별[M:남자(MALE),F:여자(FEMALE)]
    private String nation;          // 국적
    private String certDn;          // 인증서DN
    private String certificate;     // 인증서
    private String certRegDtm;      // 인증서등록일시
    private String useYn;           // 사용여부
    private String regDtm;          // 등록일시
    private String regId;           // 등록자
    private String chgDtm;          // 변경일시
    private String chgId;           // 변경자

    public String getAuthGrpCd() {

        return authGrpCd;
    }

    public void setAuthGrpCd(String authGrpCd) {

        this.authGrpCd = authGrpCd;
    }

    public String getSpCd() {

        return spCd;
    }

    public void setSpCd(String spCd) {

        this.spCd = spCd;
    }

    public String getAdminId() {

        return adminId;
    }

    public void setAdminId(String adminId) {

        this.adminId = adminId;
    }

    public String getMakerCd() {

        return makerCd;
    }

    public void setMakerCd(String makerCd) {

        this.makerCd = makerCd;
    }

    public String getAdminPw() {

        return adminPw;
    }

    public void setAdminPw(String adminPw) {

        this.adminPw = adminPw;
    }

    public String getDeptCd() {

        return deptCd;
    }

    public void setDeptCd(String deptCd) {

        this.deptCd = deptCd;
    }

    public String getAdminNm() {

        return adminNm;
    }

    public void setAdminNm(String adminNm) {

        this.adminNm = adminNm;
    }

    public String getHpHo() {

        return hpHo;
    }

    public void setHpHo(String hpHo) {

        this.hpHo = hpHo;
    }

    public String getEmail() {

        return email;
    }

    public void setEmail(String email) {

        this.email = email;
    }

    public String getSex() {

        return sex;
    }

    public void setSex(String sex) {

        this.sex = sex;
    }

    public String getNation() {

        return nation;
    }

    public void setNation(String nation) {

        this.nation = nation;
    }

    public String getCertDn() {

        return certDn;
    }

    public void setCertDn(String certDn) {

        this.certDn = certDn;
    }

    public String getCertificate() {

        return certificate;
    }

    public void setCertificate(String certificate) {

        this.certificate = certificate;
    }

    public String getCertRegDtm() {

        return certRegDtm;
    }

    public void setCertRegDtm(String certRegDtm) {

        this.certRegDtm = certRegDtm;
    }

    public String getUseYn() {

        return useYn;
    }

    public void setUseYn(String useYn) {

        this.useYn = useYn;
    }

    public String getRegDtm() {

        return regDtm;
    }

    public void setRegDtm(String regDtm) {

        this.regDtm = regDtm;
    }

    public String getRegId() {

        return regId;
    }

    public void setRegId(String regId) {

        this.regId = regId;
    }

    public String getChgDtm() {

        return chgDtm;
    }

    public void setChgDtm(String chgDtm) {

        this.chgDtm = chgDtm;
    }

    public String getChgId() {

        return chgId;
    }

    public void setChgId(String chgId) {

        this.chgId = chgId;
    }
}
