package StaffJava;

public class staffBean {
	private String staffID;
    private String staffName;
    private String staffEmail;
    private String staffPassword;
    
    public staffBean(String staffID, String staffName, String staffEmail, String staffPassword) {
    	this.staffID = staffID;
        this.staffName = staffName;
        this.staffEmail = staffEmail;
        this.staffPassword = staffPassword;
    }
    
    public String getStaffId() {
        return staffID;
    }

    public void setStaffId(String staffID) {
        this.staffID = staffID;
    }
    
    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }
    
    public String getStaffEmail() {
        return staffEmail;
    }

    public void setStaffEmail(String staffEmail) {
        this.staffEmail = staffEmail;
    }
    
    public String getStaffPassword() {
        return staffPassword;
    }

    public void setStaffPassword(String staffPassword) {
        this.staffPassword = staffPassword;
    }

}
