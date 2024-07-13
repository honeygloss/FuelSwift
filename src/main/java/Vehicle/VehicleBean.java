package Vehicle;

import java.io.Serializable;

public class VehicleBean implements Serializable {
    private static final long serialVersionUID = 1L;
    private String plateNumber;
    private String vehicleType;
    private String vin;

    // Constructors, getters, and setters
    public VehicleBean() {}

    public VehicleBean(String plateNumber, String vehicleType, String vin) {
        this.plateNumber = plateNumber;
        this.vehicleType = vehicleType;
        this.vin = vin;
    }

    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public String getVin() {
        return vin;
    }

    public void setVin(String vin) {
        this.vin = vin;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        VehicleBean that = (VehicleBean) o;
        return plateNumber.equals(that.plateNumber) &&
                vehicleType.equals(that.vehicleType) &&
                vin.equals(that.vin);
    }

    @Override
    public int hashCode() {
        int result = plateNumber.hashCode();
        result = 31 * result + vehicleType.hashCode();
        result = 31 * result + vin.hashCode();
        return result;
    }
}
