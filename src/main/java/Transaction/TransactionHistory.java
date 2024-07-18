package Transaction;

public class TransactionHistory {
	 private String transactionId;
	    private String transactionDate;
	    private double amount;

	    public TransactionHistory(String transactionId, String transactionDate, double amount) {
	        this.transactionId = transactionId;
	        this.transactionDate = transactionDate;
	        this.amount = amount;
	    }

	    public String getTransactionId() {
	        return transactionId;
	    }

	    public void setTransactionId(String transactionId) {
	        this.transactionId = transactionId;
	    }

	    public String getTransactionDate() {
	        return transactionDate;
	    }

	    public void setTransactionDate(String transactionDate) {
	        this.transactionDate = transactionDate;
	    }

	    public double getAmount() {
	        return amount;
	    }

	    public void setAmount(double amount) {
	        this.amount = amount;
	    }

}
