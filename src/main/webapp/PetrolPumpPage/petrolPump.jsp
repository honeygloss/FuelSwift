<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- Java code to retrieve and display index parameter --%>
    <%
        // Retrieve index parameter from URL
        String indexParam = request.getParameter("index");
    	String titleParam = request.getParameter("title");
    	String addressParam = request.getParameter("address");
    	String userId = request.getParameter("userId");
    	String pointsStr = request.getParameter("points");
    	
    	int points = 0;
    	if (pointsStr != null && !pointsStr.isEmpty()) {
            try {
            	points = Integer.parseInt(pointsStr);
            } catch (NumberFormatException e) {
            	
                e.printStackTrace();
            }
        }

        int selectedIndex = -1; // Default value or error handling if needed
        if (indexParam != null && !indexParam.isEmpty()) {
            try {
                selectedIndex = Integer.parseInt(indexParam);
            } catch (NumberFormatException e) {
            	
                e.printStackTrace();
            }
        }
    %>  
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pump | FuelSwift</title>
    <!-- Bootstrap CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap JS -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <style>
        body {
        	font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            font-size: 24px;
            background-color: rgb(20, 36, 105);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        
        .form-label, .H1{
    		font-family: 'Poppins', sans-serif; /* Ensure font family is applied to form labels */
			color: white;
		}
		
		.box-area{			
				width: 400px;
			    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.5);
			    border: 2px solid rgb(33, 37,41); /* Set border to primary color *//* Set the background color for the box area */
				margin: 0;
			    padding: 0;
			    border:none;
		}
		.btn-custom {
            background-color: rgb(30, 46, 125);
            color: yellow;
            cursor: pointer;
            transition: background-color 0.3s ease, color 0.3s ease;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0);
            cursor:pointer;
        }
        .btn-custom:hover {
            background-color: rgb(20, 36, 105);
            color: white;
        }
        .footer-text {
            text-align: center;
            color: #6c757d;
            margin-top: auto;
            padding: 8px 0;
            font-size: 15px; 
        }
        .toggle-switch {
		    display: flex;
		    justify-content: flex-end; /* Align to the right */
		    margin-top: 10px;
		}

		.toggle-switch input {
		    display: none;
		}

        .toggle-switch label {
            cursor: pointer;
            text-indent: -9999px;
            width: 40px;
            height: 20px;
            background: grey;
            display: block;
            border-radius: 100px;
            position: relative;
        }

        .toggle-switch label:after {
            content: '';
            position: absolute;
            top: 3px;
            left: 3px;
            width: 14px;
            height: 14px;
            background: #fff;
            border-radius: 50%;
            transition: 0.3s;
        }

        .toggle-switch input:checked + label {
            background: yellow;
        }

        .toggle-switch input:checked + label:after {
            left: calc(100% - 3px);
            transform: translateX(-100%);
        }

        .toggle-switch label:active:after {
            width: 30px;
        }
        
        .btn-custom.selected {
	        background-color: red; /* Selected background color */
	        color: green; /* Selected text color */
	    }
	    .error-message {
            position: fixed;
            top: -100px; /* Initial position above the viewport */
            left: 50%;
            transform: translateX(-50%);
            width: 90%;
            max-width: 400px;
            padding: 20px;
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
            z-index: 1000;
            opacity: 0;
            font-family: 'Montserrat';
        }

        .show {
            animation: slideDown 1s forwards;
        }

        .hide {
            animation: slideUp 1s forwards;
        }

        @keyframes slideDown {
            to {
                top: 20px; /* Final position */
                opacity: 1;
            }
        }

        @keyframes slideUp {
            from {
                top: 20px; /* Start from final position */
                opacity: 1;
            }
            to {
                top: -100px; /* Back to initial position */
                opacity: 0;
            }
        }

        .error-message h3 {
            margin: 0;
            font-size: 17px;
            font-weight: bold;
        }

        .error-message p {
            margin: 0;
            font-size: 15px;
        }
        
    </style>
</head>
<body>
	<!-- Error message container -->
    <div id="errorMessage" class="error-message">
        <h3>Error!</h3>
        <p id="errorMessageText">This is an error message.</p>
    </div>
	<!-- Navigation Bar with Logo -->
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container-fluid d-flex align-items-center">
            <!-- Navbar Brand (Logo) -->
            <a class="navbar-brand" href="#">
                <img src="logo1.png" alt="Logo" width="50" height="45" class="d-inline-block align-text-top me-2">
                <p style="font-weight: bold; color: yellow; font-size: 12px">FuelSwift</p>
            </a>
        </div>
    </nav>
	
	<H3 style="text-align: center; font-weight: bold; color: white; margin-bottom:5px;"><%= titleParam  %></H3>
	<H6 style="text-align: center; font-style: italic; color: white; margin-bottom:10px; padding:5px; margin-right:5px; margin-left:5px;"><%= addressParam  %></H6>
	<div class="container d-flex justify-content-center align-items-center">    
    <!-----------------------  Container -------------------------->
    <div class="row rounded-5 p-5 shadow box-area">
        <div class="row align-items-center justify-content-center">
            <div class="col-md-12 text-center mb-3">
                <div class="header-text">
                	<h5 id="selectedPump" style="color: #F2ED00; font-weight:bold;"></h5>
                    <h5 style="color: white;">Select a pump:</h5>
                </div>
                <div>
                    <button class="btn btn-custom" onclick="selectPump(1)">1</button>
                    <button class="btn btn-custom" onclick="selectPump(2)">2</button>
                    <button class="btn btn-custom" onclick="selectPump(3)">3</button>
                    <button class="btn btn-custom" onclick="selectPump(4)">4</button>
                    <button class="btn btn-custom" onclick="selectPump(5)">5</button>
                    <button class="btn btn-custom" onclick="selectPump(6)">6</button>
                </div>
            </div>
            <div class="col-md-12 mb-1">
                <div class="form-group mb-3">
                    <label class="form-label" for="amount">Amount (RM)</label>
                    <input type="text" class="form-control" id="amount" placeholder="Enter amount" oninput="calculateLitres()">        
                </div>
            </div>
            <div class="col-md-12 mb-1">
                <div class="form-group mb-3">
                    <label class="form-label" for="litres">Litres (L)</label>
                    <input type="text" class="form-control bg-secondary" id="litres" placeholder="0.00" style="color:white; border: none;" readonly>
                </div>
            </div>
            <div class="col-md-12 text-center mb-3">
                <div class="form-group mb-4">
                    <button class="btn btn-custom" onclick="selectOption('20')">RM20</button>
                    <button class="btn btn-custom" onclick="selectOption('40')">RM40</button>
                    <button class="btn btn-custom" onclick="selectOption('60')">RM60</button>
                </div>
			    <div class="col-md-12 toggle-switch">
				    <div class="row">
				            <span class="text-white" id="currentPts" style="font-size: 14px; position: absolute; left:0;">Use points</span>	        
				        <div class="col" style="position: relative;">
				            <input type="checkbox" id="switch" style="position: absolute; right:0;" onclick="handleToggle()"/>
				            <label class="text-white" for="switch" style="position: absolute; right:0;">Toggle</label>
				        </div>
				    </div>
					<div class="mb-3" style="border-bottom: 1px solid gray; margin-top: 5px;"></div>		
				</div>
				<div class="mb-3" style="border-bottom: 1px solid gray; margin-top: 5px;"></div>		
				<div class="col-md-12 mb-4">
				    <div class="row" style="font-size: 17px; left:0;">
				            <span class="text-white" style="font-size: 12px; position: absolute; left:0;">Amount:</span>	        
				        <div class="col" style="font-size: 17px; right:0;">
				            <span class="text-white" style="font-size: 12px; position: absolute; right:0;" id="amount2">RM 0.00</span>	        
				        </div>
				    </div>
				</div>
				<div class="col-md-12 mb-4">
				    <div class="row" style="font-size: 17px; left:0;">
				            <span class="text-white" style="font-size: 12px; position: absolute; left:0;">Points Redeem:</span>	        
				        <div class="col" style="font-size: 17px; right:0;">
				            <span class="text-white" style="font-size: 12px; position: absolute; right:0;" id="ptsRedeem">-RM 0.00</span>	        
				        </div>
				    </div>
				</div>
				<div class="col-md-12 mb-4">
				    <div class="row" style="font-size: 17px; left:0;">
				            <span class="text-white" style="font-size: 14px; position: absolute; left:0;">Total Amount:</span>	        
				        <div class="col" style="font-size: 17px; right:0;">
				            <span class="text-white" style="font-size: 14px; position: absolute; right:0;" id="totAmount">RM 0.00</span>	        
				        </div>
				    </div>
				</div>
			 </div>
			</div>
            <div class="col-md-12 text-center">
                <button class="btn btn-primary" onclick="payNow()">Pay Now</button>
            </div>
        </div>
    </div>
 <div class="footer-text">
     <small>&copy; FuelSwift</small>
</div>
<script>

	document.getElementById('ptsRedeem').innerText = '-RM0.00';
	
	function selectOption(option) {
	    if (option !== 'other') {
	        document.getElementById('amount').value = option;
	        calculateLitres();
	    }
	}
	
	const pricePerLiter = 2.50; // Example price per liter. You can update this value as needed.
	function calculateLitres() {
	    const amount = document.getElementById('amount').value / 1;
	    const litres = amount / pricePerLiter;
	    document.getElementById('litres').value = litres.toFixed(2); // Update litres input field
	    document.getElementById('amount2').innerText = 'RM' + amount.toFixed(2); 
	    document.getElementById('totAmount').innerText = 'RM' + amount.toFixed(2); 
	}
	// Define initial current points
	let currentPoints = '<%=points%>'; // Assuming starting points
	let pointsToDeduct = 0;
	pointsToDeduct = '<%=points%>' * 0.10; // Calculate points to deduct (1 point = 10 cents)
	// Function to handle toggle click
	function handleToggle() {
		 const toggle = document.getElementById('switch');
		 const amount = document.getElementById('amount').value / 1;
	     const currentPointsElement = document.getElementById('currentPts');
	     
	     
	     if (toggle.checked) {
	         // Deduct points if toggle is checked
	         const deductedAmount = amount - pointsToDeduct;
	         // Update UI with new total amount value
	         document.getElementById('totAmount').innerText = 'RM' + deductedAmount.toFixed(2);
	         document.getElementById('amount2').innerText = 'RM' + amount.toFixed(2); 
	         document.getElementById('ptsRedeem').innerText = '-RM' + pointsToDeduct.toFixed(2);
	         currentPointsElement.innerText = 'Redeem '+ currentPoints +' points';
	     } else {
	         // If toggle is unchecked, show the original amount
	         document.getElementById('amount2').innerText = 'RM' + amount.toFixed(2); 
	    	 document.getElementById('totAmount').innerText = 'RM' + amount.toFixed(2);
	    	 document.getElementById('ptsRedeem').innerText = '-RM0.00';
	         currentPointsElement.innerText = 'Use points'; // Added this line to reset the label
	     }
	 }

	 
	 function selectPump(index) {
		    document.getElementById('selectedPump').innerText = index;
		}
	 
	// Function to show error message
     function showError(message) {
         var errorMessage = document.getElementById('errorMessage');
         var errorMessageText = document.getElementById('errorMessageText');
         
         // Set error message text
         errorMessageText.textContent = message;
         
         // Show error message
         errorMessage.classList.add('show');
         errorMessage.classList.remove('hide');
         
         // Automatically hide after 2 seconds 
         setTimeout(function() {
             hideError();
         }, 2000); 
     }

     // Function to hide error message
     function hideError() {
         var errorMessage = document.getElementById('errorMessage');
         
         // Hide error message
         errorMessage.classList.remove('show');
         errorMessage.classList.add('hide');
     }
	 
	 function payNow() {
		    // Retrieve values needed for parameters
		    const index = document.getElementById('selectedPump').innerText;
		    const totAmount = document.getElementById('totAmount').innerText;
		    const amount = document.getElementById('amount').value;
		    const pointsRed = document.getElementById('ptsRedeem').innerText;
		    const litres = amount / pricePerLiter;
		    const currentPts = currentPoints;
		    
		 // Check if index or amount is empty or null
            if (!index || !amount || index.trim() === '' || amount.trim() === '') {
                showError('Please select the pump number & enter amount.');
                return;
            }
		    else{
		    	// Retrieve indexParam from JSP scripting
			    const indexParam = '<%=indexParam %>'; 
			    const titleParam = '<%=titleParam %>';
			    const userId = '<%=userId%>';
			    // Construct the URL with parameters
			    const url = `/Roslizam/Payment.jsp?index=`+ index + `&litres=` + litres + `&currentPts=` + currentPts +`&pointsRed=` + pointsRed + `&totAmount=` + totAmount + `&amount=` + amount +  `&indexParam=` + indexParam + `&title=` + titleParam + `&userId=` + userId;
			    
			    console.log("userId" + userId);
			    console.log("Redirecting to: " + url);
			    
		
			    window.location.href = url;
		    }
		}
         
</script>
</body>
</html>
