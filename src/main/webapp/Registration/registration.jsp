<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registration | FuelSwift</title>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" >
<!-- Add Bootstrap Icons -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
 <style>
			body, input-group{
			    font-family: 'Poppins', sans-serif;
			    background: rgb(20, 36, 105);
			    margin: 0;
		        padding: 0;
		        height: 100vh; /* Ensures the body takes full viewport height */
		        display: flex;
		        justify-content: center;
		        align-items: center;
			}
			/* Apply font-family to input fields */
			.input-group .form-control {
			    font-family: 'Poppins', sans-serif;
			    font-size: 16px;			    
			}
	/*------------ Register container ------------*/
			.box-area{
				display:inline block;
				width: 400px;
			    box-shadow: 0 60px 80px rgba(0, 0, 0, 0);
			    border: 2px solid rgb(33, 37,41); /* Set border to primary color *//* Set the background color for the box area */
				margin: 0;
			    padding: 0;
			}
			.box-area, .row, .container {
			    border: none;
			}
			/*------------ Custom Placeholder ------------*/
			::placeholder{
			    font-size: 16px;
			    font-family: 'Poppins', sans-serif;
			}
			.rounded-5, .input-group{
			    border-radius: 30px;
			}
			@media only screen and (max-width: 768px) {
	            .box-area {
	                width: 100%; /* Adjusts the width to 90% of the viewport width */
	            }            
       	 	}
       	 
        .dropdown-toggle-end {
            width: 100%;
        	right: 0;
        }
         .footer-text {
		    text-align: center;
		    color: #6c757d;
		    margin-top: 20px;
		    padding: 10px 0; /* Adjusted padding */
		    font-size: 15px; 
		    width: 100%; /* Ensure it takes up the full width */
		    position: absolute; /* Position it absolutely */
		    bottom: 0; /* Align it to the bottom */
		    line-height: 20px; /* Adjust line height to create space below */
    		padding-top: 5px; /* Increase top padding to move text down */
		}
		#loading-overlay {
		    position: fixed;
		    top: 0;
		    left: 0;
		    width: 100%;
		    height: 100%;
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    background-color: rgb(33, 37, 41, 0.7); /* Semi-transparent background */
		    z-index: 9999; /* Ensure it sits above all other content */
		    flex-direction: column; /* Stack the loader and text */
		}
		
		#loading-overlay p {
		    margin-top: 10px;
		    font-size: 20px;
		    color: yellow; /* Adjust text color as needed */
		}
		
		.loader {
		    animation: rotate 1s infinite;
		    height: 50px;
		    width: 50px;
		}
		
		.loader:before,
		.loader:after {
		    border-radius: 50%;
		    content: "";
		    display: block;
		    height: 20px;
		    width: 20px;
		}
		
		.loader:before {
		    animation: ball1 1s infinite;
		    background-color: yellow;
		    box-shadow: 30px 0 0 rgb(20, 36, 105);
		    margin-bottom: 10px;
		}
		
		.loader:after {
		    animation: ball2 1s infinite;
		    background-color: rgb(20, 36, 105);
		    box-shadow: 30px 0 0 yellow;
		}
		
		@keyframes rotate {
		    0% { transform: rotate(0deg) scale(0.8); }
		    50% { transform: rotate(360deg) scale(1.2); }
		    100% { transform: rotate(720deg) scale(0.8); }
		}
		
		@keyframes ball1 {
		    0% {
		        box-shadow: 30px 0 0 rgb(20, 36, 105);
		    }
		    50% {
		        box-shadow: 0 0 0 rgb(20, 36, 105);
		        margin-bottom: 0;
		        transform: translate(15px, 15px);
		    }
		    100% {
		        box-shadow: 30px 0 0 rgb(20, 36, 105);
		        margin-bottom: 10px;
		    }
		}
		
		@keyframes ball2 {
		    0% {
		        box-shadow: 30px 0 0 yellow;
		    }
		    50% {
		        box-shadow: 0 0 0 yellow;
		        margin-top: -20px;
		        transform: translate(15px, 15px);
		    }
		    100% {
		        box-shadow: 30px 0 0 yellow;
		        margin-top: 0;
		    }
		}
		.pass-validation-message {
            color: red;
            margin-top: -12px;
            display: none;
            font-family: 'Poppins', sans-serif;
			font-size: 14px;
			text-align:left;
        }
        .veh-validation-message {
            color: red;
            margin-top: 5px;
            display: none;
            font-family: 'Poppins', sans-serif;
			font-size: 14px;
        }

    </style>
</head>
<body>
    <form action="/FuelSwift/Customer/servletCustomer" method="post" onsubmit="return validateSelection()">
        <!----------------------- Main Container -------------------------->
     <div class="container d-flex justify-content-center align-items-center min-vh-100 ">
    <!----------------------- Register Container -------------------------->
      <div class="row rounded-5 p-5 shadow box-area" style="background-color: rgb(20, 36, 105);">
            
                    <div class="row align-items-center d-flex justify-content-center align-items-center">
                        <div class="header-text mb-3">
                            <h1 style="text-align: center; font-weight: bold; color:yellow;">Register</h1>
                       </div>
                        <div class="input-group mb-3">
                            <input type="text" class="form-control form-control-lg bg-light fs-6" name="fullName" placeholder="Full Name" required>
                        </div>           
                        <div class="input-group mb-3">
                            <input type="email" class="form-control form-control-lg bg-light fs-6" name="email" placeholder="Email" required>
                        </div>
                        <div class="input-group mb-3">
                            <input type="text" class="form-control form-control-lg bg-light fs-6" name="plateNo" placeholder="Plate No" required>
                        </div>
                        <div class="input-group mb-3">
                            <input type="text" class="form-control form-control-lg bg-light fs-6" name="vin" placeholder="VIN" required>
                        </div>
					    <div class="dropdown mb-3 fs-6 w-100 ">
                        <button class="btn form-control-lg dropdown-toggle dropdown-toggle-end" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false" style="color:black; background-color:white;">
                            Vehicle type
                        </button>
                        <ul class="dropdown-menu fs-6 w-100" aria-labelledby="dropdownMenuButton">
                            <li><a class="dropdown-item" href="#" onclick="selectVehicleType('Car')">Car</a></li>
                            <li><a class="dropdown-item" href="#" onclick="selectVehicleType('Motorcycle')">Motorcycle</a></li>
                            <li><a class="dropdown-item" href="#" onclick="selectVehicleType('Truck')">Truck</a></li>
                        </ul>
                        <input type="hidden" id="selectedVehicleType" name="vehicleType">
                        <div id="vehicleValidationMessage" class="veh-validation-message">Please select a vehicle type before submitting.</div>
	                    </div> 
                    
                        <div class="input-group mb-3">
                            <input type="password" id="pass" class="form-control form-control-lg bg-light fs-6" name="password" placeholder="Password" required>
                        </div>
                        <div class="input-group mb-3">
                            <input type="password" id="confPass" class="form-control form-control-lg bg-light fs-6" name="confirm_password" placeholder="Confirm Password" required>
                        </div>
                        <div class="input-group mb-3">
						    <div id="passValidationMessage" class="pass-validation-message">Passwords do not match.</div>
						</div>
                        <div class="input-group mb-3 d-flex justify-content-between">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="formCheck" required>
                                <label for="formCheck" class="form-check-label text-secondary"><small style="color: black;">I accept the <a href="a" style="color:yellow;">Terms of Use</a> & <a href="" style="color:yellow;">Privacy Policy</a></small></label>
                            </div>
                        </div>
                        <div class="input-group mb-3">
                            <button class="btn custombutton btn-lg w-100 fs-6" style="font-size: 16px; background-color: rgb(30, 46, 125); color: yellow; cursor: pointer; transition: background-color 0.3s ease, color 0.3s ease;" onmouseover="this.style.backgroundColor='rgb(20, 36, 105)'; this.style.color='white';" onmouseout="this.style.backgroundColor='rgb(30, 46, 125)'; this.style.color='yellow';">Sign Up</button>
                        </div>
                        
                        <div class="row mb-4">
		                    <small>Already have an account? <a href="/FuelSwift/Login/Login.jsp" style="color: yellow;">Sign in</a></small>
		                </div>
                    </div>
                </div>
            </div>
    </form>
    <div class="footer-text">
     	<small>&copy; FuelSwift</small>
	</div>
	<div id="loading-overlay">
	        <span class="loader"></span>
	        <p>Loading...</p>
    </div>
    <!-- Bootstrap JS (Optional, for dropdown functionality) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
     <script>
        // Function to handle selection of vehicle type
        function selectVehicleType(type) {
            // Update the button text with the selected vehicle type
            document.getElementById('dropdownMenuButton').innerText = type;
            document.getElementById('selectedVehicleType').value = type;
            document.getElementById('vehicleValidationMessage').style.display = 'none';
        }
        function validateSelection() {
            var isValid = true;

            // Validate vehicle type selection
            var selectedType = document.getElementById('selectedVehicleType').value;
            if (selectedType === "") {
                document.getElementById('vehicleValidationMessage').style.display = 'block';
                isValid = false;
            } else {
                document.getElementById('vehicleValidationMessage').style.display = 'none';
            }

            // Validate password matching
            var password = document.getElementById('pass').value;
            var confirmPassword = document.getElementById('confPass').value;
            if (password !== confirmPassword) {
                document.getElementById('passValidationMessage').style.display = 'block';
                isValid = false;
            } else {
                document.getElementById('passValidationMessage').style.display = 'none';
            }

            return isValid;
        }
    	document.addEventListener("DOMContentLoaded", function() {
        // Simulate loading completion after 3 seconds for demo purposes
        setTimeout(function() {
            document.getElementById('loading-overlay').style.display = 'none';
        }, 3000);
    });

    </script>
</body>
</html>