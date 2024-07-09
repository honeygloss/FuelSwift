public class Customer {
    private int id;
    private String name;
    private String email;
    private String plateNo;
    private String geranNo;
    private String vehicleType;
    private String password;
    private String confirmPassword;

    public Customer(int id, String name, String email, String plateNo, String geranNo, String vehicleType, String password, String confirmPassword) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.plateNo = plateNo;
        this.geranNo = geranNo;
        this.vehicleType = vehicleType;
        this.password = password;
        this.confirmPassword = confirmPassword;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
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
}
