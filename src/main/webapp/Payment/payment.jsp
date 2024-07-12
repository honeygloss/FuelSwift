<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*, java.util.UUID"%>
    
    <%
    	// points = total points collected, currentPts = points redeemed pointsEarned = new points earned
	    String title = request.getParameter("title");
	    String current = request.getParameter("currentPts"); // Convert to int
	    String pump = request.getParameter("index");
	    int currentPts = -1;
	    int pumpNum = 0; 
	    if (current != null && ! current.isEmpty()) {
            try {
            	currentPts = Integer.parseInt(current);		// points redeemed (or not)
            } catch (NumberFormatException e) {
                // Handle parsing error if necessary
                e.printStackTrace();
            }
        }
	    if(pump != null && !pump.isEmpty()){
	    	try{
	    		pumpNum = Integer.parseInt(pump);
	    	}catch (NumberFormatException e) {
                // Handle parsing error if necessary
                e.printStackTrace();
            }
	    }
	    
	    // Remove "RM" prefix and convert to appropriate data type
	    String totAmountStr = request.getParameter("totAmount").substring(2); // Remove "RM"
	    double totAmount = Double.parseDouble(totAmountStr); // Convert to double
	    String formattedAmount = String.format("%.2f", totAmount);
	    String pointsRed = request.getParameter("pointsRed");
	    double amount = Double.parseDouble(request.getParameter("amount")); // Convert to double
	    double litres = Double.parseDouble(request.getParameter("litres"));
	    int locNum = Integer.parseInt(request.getParameter("indexParam")) + 1; // Convert to int and add 1
	    
	    String transactionId = "SFS" + UUID.randomUUID().toString().replaceAll("-", "").toUpperCase().substring(0, 7);
	 	
	    // Calculate pointsEarned and points
	    int pointsEarned = (int) totAmount; // totAmount as integer
	    int points;
	    if (pointsRed.equals("-RM0.00")) {		// no points redeemed
	        points = pointsEarned  + currentPts;
	    	currentPts = 0;
	    } else {
	        points = pointsEarned;
	    }
	    
	%>  
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Page</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <link rel="stylesheet" href="Payment.css">
</head>
<body>

<div class="container d-flex justify-content-center align-items-center min-vh-100">    
    <div class="row p-3">   
        <div class="header-text mb-4 mt-5">
            <h2 style="text-align: center; font-weight: bold; color: white">Payment Details</h2>
        </div>
        <h6 id="timer" style="text-align: center; color: yellow; margin-top: 15px"></h6>
        <div class="col-md-12">   	
            <form action="" method="POST">
                <div class="form-group mb-3">
                    <label for="cardType" class="form-label text-white">Card Type</label>
                    <div class="btn-group w-100" role="group" aria-label="Card Type">
                        <input type="radio" class="btn-check" name="cardType" id="visa" autocomplete="off" checked>
                        <label class="btn btn-outline-primary w-50" for="visa">
                            <img src="visa.png" width="50" height="25" alt="Visa Logo">
                        </label>
                        <input type="radio" class="btn-check" name="cardType" id="mastercard" autocomplete="off">
                        <label class="btn btn-outline-primary w-50" for="mastercard">
                            <img src="mastercard.png" width="50" height="25" alt="MasterCard Logo">
                        </label>
                    </div>
                </div>
                <div class="form-group mb-3">
                    <label for="cardNumber" class="form-label text-white">Card Number</label>
                    <input type="text" class="form-control" id="cardNumber" name="cardNumber" placeholder="XXXX XXXX XXXX XXXX" oninput="formatCardNumber(this)">
                </div>
                <div class="form-group mb-3">
                    <label for="expiryDate" class="form-label text-white">Expiry Date</label>
                    <input type="text" class="form-control" id="expiryDate" name="expiryDate" placeholder="MM/YY" oninput="formatExpiryDate(this)">
                </div>
                <div class="form-group mb-3">
                    <label for="cvv" class="form-label text-white">CVV</label>
                    <input type="text" class="form-control" id="cvv" name="cvv" placeholder="CVV" oninput="formatCVV(this)">
                </div>
                <div class="form-group mb-3">
                    <label for="cardHolder" class="form-label text-white">Cardholder Name</label>
                    <input type="text" class="form-control" id="cardHolder" name="cardHolder" placeholder="Enter cardholder name">
                </div>
                <div class="form-group">
                    <button type="button" class="btn btn-primary w-100" style="margin-top:30px;" onclick="showReceiptModal()">Pay Now</button>
                </div>
                <div class="form-group mt-3">
                    <button type="button" class="btn btn-secondary w-100" onclick="cancel()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    <div class="footer-text">
        <small>&copy; FuelSwift</small>
    </div>
</div>

<!-- Modal Session Timeout-->
<div class="modal fade" id="timeoutModal" tabindex="-1" aria-labelledby="timeoutModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-dark font-weight-bold" id="timeoutModalLabel">Session Timeout</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-dark" >
                Your session has timed out. You will be redirected to the homepage.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="cancel()">OK</button>
            </div>
        </div>
    </div>
</div>

<!-- Receipt Modal -->
<div class="modal fade" id="receiptModal" tabindex="-1" aria-labelledby="receiptModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-dark font-weight-bold" id="receiptModalLabel">Payment Successful</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-dark">
                <!-- Add receipt content here -->
                <h3 style="text-align: center"><%=title %></h3>
                <p><h6 id="receiptDate" style="text-align: center"></h6></p>
                <p>Transaction ID: #<%=transactionId %></p>
                <p>Total Amount: RM<%=formattedAmount %></p>
                <!-- Example content, replace with actual receipt details -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal" onClick="cancel()">Close</button>
            </div>
        </div>
    </div>
</div>

	<input type="hidden" id="title" value="<%= title %>">
    <input type="hidden" id="pumpNum" value="<%= pumpNum %>">
    <input type="hidden" id="currentPts" value="<%= currentPts %>">
    <input type="hidden" id="totAmount" value="<%= totAmount %>">
    <input type="hidden" id="pointsRed" value="<%= pointsRed %>">
    <input type="hidden" id="amount" value="<%= amount %>">
    <input type="hidden" id="locNum" value="<%= locNum %>">
    <input type="hidden" id="transactionId" value="<%= transactionId %>">
    <input type="hidden" id="pointsEarned" value="<%= pointsEarned %>">
    <input type="hidden" id="points" value="<%= points %>">
    <input type="hidden" id="litres" value="<%= litres %>">
    <input type="hidden" id="dateFuel" value="">
    <input type="hidden" id="paymentMethod" name="cardType" value="">
    <input type="hidden" id="timeFuel" value="">

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>
<script>
    function formatCardNumber(input) {
        let value = input.value.replace(/\D/g, '');
        value = value.substring(0, 16);
        value = value.replace(/(\d{4})(?=\d)/g, '$1 ');
        input.value = value;
    }

    function formatExpiryDate(input) {
        let value = input.value.replace(/\D/g, '');
        value = value.substring(0, 4);
        if (value.length >= 2) {
            value = value.slice(0, 2) + '/' + value.slice(2);
        }
        input.value = value;
    }

    function formatCVV(input) {
        let value = input.value.replace(/\D/g, '');
        value = value.substring(0, 3);
        input.value = value;
    }

    var timerDuration = 301;
    var startTime = Math.floor(Date.now() / 1000);
    var timerInterval = setInterval(updateTimer, 1000);

    function updateTimer() {
        var currentTime = Math.floor(Date.now() / 1000);
        var remainingTime = timerDuration - (currentTime - startTime);
        var minutes = Math.floor(remainingTime / 60);
        var seconds = remainingTime % 60;
        document.getElementById("timer").innerText = "0" + minutes + ":" + (seconds < 10 ? '0' : '') + seconds;
        if (remainingTime <= 0) {
            clearInterval(timerInterval);
            document.getElementById("cardNumber").disabled = true;
            document.getElementById("expiryDate").disabled = true;
            document.getElementById("cvv").disabled = true;
            document.getElementById("cardHolder").disabled = true;
            document.querySelector("button[type=button]").disabled = true;
            showTimeoutModal();
        }
    }

    function showTimeoutModal() {
        var timeoutModal = new bootstrap.Modal(document.getElementById('timeoutModal'));
        timeoutModal.show();
    }

    function cancel() {
        window.location.href = "/FuelSwift/HomePage/HomePage2.html";
    }
    // Function to format date and time
    function formatDate(date) {
        return date.toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }) + ' ' + date.toLocaleTimeString('en-US');
    }
    
 // Function to format date as day month year
    function formatDateDayMonthYear(date) {
        var options = { day: 'numeric', month: 'long', year: 'numeric' };
        return date.toLocaleDateString('en-GB', options);
    }

 // Function to format time only
    function formatTime(date) {
        return date.toLocaleTimeString('en-US');
    }

    // Get current date and time
    var currentDate = new Date();
    var formattedDate = formatDate(currentDate);
    var dateFuel = formatDateDayMonthYear(currentDate);
    var timeFuel = formatTime(currentDate);

    // Set the formatted date and time in the modal
    document.getElementById('receiptDate').innerText = formattedDate;
    document.getElementById('dateFuel').value = dateFuel;
    document.getElementById('timeFuel').value = timeFuel;
    
    function showReceiptModal() {
    	clearInterval(timerInterval);
        var receiptModal = new bootstrap.Modal(document.getElementById('receiptModal'));
        receiptModal.show();
        document.getElementById("cardNumber").disabled = true;
        document.getElementById("expiryDate").disabled = true;
        document.getElementById("cvv").disabled = true;
        document.getElementById("cardHolder").disabled = true;
        document.querySelector("button[type=button]").disabled = true;
        
        var title = document.getElementById('title').value;
        var pumpNum = document.getElementById('pumpNum').value;
        var currentPts = document.getElementById('currentPts').value;
        var totAmount = document.getElementById('totAmount').value;
        var pointsRed = document.getElementById('pointsRed').value;
        var amount = document.getElementById('amount').value;
        var locNum = document.getElementById('locNum').value;
        var transactionId = document.getElementById('transactionId').value;
        var pointsEarned = document.getElementById('pointsEarned').value;
        var points = document.getElementById('points').value;
        var litres = document.getElementById('litres').value;
        var dateFuel = document.getElementById('dateFuel').value;
        var paymentMethod = document.getElementById('paymentMethod').value;
        var timeFuel = document.getElementById('timeFuel').value;

        console.log("Title: ", title);
        console.log("Pump Number: ", pumpNum);
        console.log("Current Points: ", currentPts);
        console.log("Total Amount: ", totAmount);
        console.log("Points Redeemed: ", pointsRed);
        console.log("Amount: ", amount);
        console.log("Location Number: ", locNum);
        console.log("Transaction ID: ", transactionId);
        console.log("Points Earned: ", pointsEarned);
        console.log("Points: ", points);
        console.log("Litres: ", litres);
        console.log("Date of Fuel: ", dateFuel);
        console.log("Payment Method: ", paymentMethod);
        console.log("Time Fuel: ", timeFuel);
        
    }
 	// Function to update hidden input field based on radio button selection
    function updateHiddenCardType() {
        var hiddenInput = document.getElementById('paymentMethod');
        var selectedCardType = document.querySelector('input[name="cardType"]:checked').id;
        hiddenInput.value = selectedCardType;
    }

    // Event listener to update hidden input field when radio button changes
    var radioButtons = document.querySelectorAll('input[name="cardType"]');
    radioButtons.forEach(function(radioButton) {
        radioButton.addEventListener('change', updateHiddenCardType);
    });

    // Call the function initially to set the default value
    updateHiddenCardType();
</script>
</body>
</html>