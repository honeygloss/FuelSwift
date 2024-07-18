package Transaction;

public class Transaction {
    private String transactionId;
    private String payMethod;
    private String cardNum;
    private String cardCVV;
    private String cardExpiryDate;
    private String cardHolderName;
    private String transDate;

    public Transaction(String transactionId, String payMethod, String cardNum, String cardCVV, String cardExpiryDate, String cardHolderName, String transDate) {
    	this.transactionId=transactionId;
    	this.payMethod=payMethod;
    	this.cardNum=cardNum;
    	this.cardCVV=cardCVV;
    	this.cardExpiryDate=cardExpiryDate;
    	this.cardHolderName=cardHolderName;
    	this.transDate=transDate;
    	
    }
    
    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    
    public String getPayMethod() {
    	return payMethod;
    }
    
    public void setPayMethod(String payMethod) {
    	this.payMethod=payMethod;    
    }
    
    public String getCardNum() {
    	return cardNum;
    }
    
    public void setCardNum(String cardNum) {
    	this.cardNum=cardNum;
    }
    
    public String getCardCVV() {
    	return cardCVV;
    }
    
    public void setCardCVV(String cardCVV) {
    	this.cardCVV=cardCVV;
    }
    
    public String getExpiryDate() {
    	return cardExpiryDate;
    }
    
    public void setExpiryDate(String cardExpiryDate) {
    	this.cardExpiryDate=cardExpiryDate;
    }

    public String getHolderName() {
    	return cardHolderName;
    }
    
    public void setHolderName(String cardHolderName) {
    	this.cardHolderName=cardHolderName;
    }
    
    public String getTransDate() {
        return transDate;
    }

    public void setDate(String transDate) {
        this.transDate = transDate;
    }

    
}
