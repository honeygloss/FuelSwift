package RefuelVehicle;
import java.math.BigDecimal;
import java.sql.Time;
import java.sql.Date;


public class refuelVehicleBean {
    private String rvID;
    private BigDecimal amount;
    private BigDecimal litres;
    private BigDecimal totalPymt;
    private int ptsEarned;
    private int ptsRedeemed;
    private Time time;
    private Date date;
    private String custID;
    private String transactionID;
    private String psID;
    private String ppID;

    // Constructor
    public refuelVehicleBean() {
    }

    // Getters and Setters
    public String getRvID() {
        return rvID;
    }

    public void setRvID(String rvID) {
        this.rvID = rvID;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public BigDecimal getLitres() {
        return litres;
    }

    public void setLitres(BigDecimal litres) {
        this.litres = litres;
    }

    public BigDecimal getTotalPymt() {
        return totalPymt;
    }

    public void setTotalPymt(BigDecimal totalPymt) {
        this.totalPymt = totalPymt;
    }

    public int getPtsEarned() {
        return ptsEarned;
    }

    public void setPtsEarned(int ptsEarned) {
        this.ptsEarned = ptsEarned;
    }

    public int getPtsRedeemed() {
        return ptsRedeemed;
    }

    public void setPtsRedeemed(int ptsRedeemed) {
        this.ptsRedeemed = ptsRedeemed;
    }

    public Time getTime() {
        return time;
    }

    public void setTime(Time time) {
        this.time = time;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getCustID() {
        return custID;
    }

    public void setCustID(String custID) {
        this.custID = custID;
    }

    public String getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(String transactionID) {
        this.transactionID = transactionID;
    }

    public String getPsID() {
        return psID;
    }

    public void setPsID(String psID) {
        this.psID = psID;
    }

    public String getPpID() {
        return ppID;
    }

    public void setPpID(String ppID) {
        this.ppID = ppID;
    }
}
