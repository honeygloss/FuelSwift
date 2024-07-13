package Customer;
public class Customer {
    private String id;
    private String name;
    private String email;
    private String plateNo;
    private String geranNo;
    private String vehicleType;
    private String password;
    private String confirmPassword;
    private String gender;
    private String phoneNo;

    public Customer(String id, String name, String email, String plateNo, String geranNo, String vehicleType, String password, String confirmPassword, String gender, String phoneNo) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.plateNo = plateNo;
        this.geranNo = geranNo;
        this.vehicleType = vehicleType;
        this.password = password;
        this.confirmPassword = confirmPassword;
        this.gender = gender;
        this.phoneNo = phoneNo;
    }

    // Getters and setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPlateNo() {
        return plateNo;
    }

    public void setPlateNo(String plateNo) {
        this.plateNo = plateNo;
    }

    public String getGeranNo() {
        return geranNo;
    }

    public void setGeranNo(String geranNo) {
        this.geranNo = geranNo;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }
    
    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public String getPhoneNo() {
        return phoneNo;
    }

    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo;
    }
}
