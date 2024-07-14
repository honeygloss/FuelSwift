package Customer;
public class Customer {
	private String id;
    private String name;
    private String email;
    private String password;
    private int points;
    private String gender;
    private String phoneNo;

    public Customer() {
    	this.id = "A001";
        this.name = "ali";
        this.email = "ali@gmail.com";
        this.password = "ali123";
        this.points = 0;
        this.gender = "Male";
        this.phoneNo = "000-0000000";
    }
    
    public Customer(String id, String name, String email, String password,int points, String gender, String phoneNo) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.points = points;
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points=points;
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
