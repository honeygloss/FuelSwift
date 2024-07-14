<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="jakarta.servlet.http.*,jakarta.servlet.*, java.util.*"%>
<%
	String fullName = (String) session.getAttribute("fullName");
	String email = (String) session.getAttribute("email");
	Integer points = (Integer) session.getAttribute("points");
	String username = "";
	
	if (fullName != null && email != null && points != null) {
	    // Extract username (first name)
	    String[] nameParts = fullName.split(" ");
	    username = nameParts[0]; // Assuming first part is the first name
	}

	 ArrayList<Transaction> transactions = (ArrayList<Transaction>) session.getAttribute("transactions");
	 String customerId = (String) session.getAttribute("customerId");
	    if (customerId != null && transactions == null) {
	        response.sendRedirect("TransactionHistoryServlet?customerId=" + customerId);
	  ArrayList<VehicleBean> vehicles = (ArrayList<VehicleBean>) session.getAttribute("vehicles");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HomePage | FuelSwift</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">     
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>    
        
    <style>
        body {
		    font-family: 'Poppins', sans-serif;
		    background-color: rgb(20, 36, 105);
		    margin: 0;
		    padding: 0;
		    /* overflow: hidden; */ /* Remove this line to enable scrolling */
		    height: 100% !important;
		    display: flex; /* Use flexbox */
		    flex-direction: column; /* Arrange child elements vertically */
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
		#home-page {
    		overflow-y: auto; /* Enable vertical scrolling for the home page */
		}
		#fuelStations {
    		overflow: hidden; /* Disable scrolling on the fuel stations page */
		}
		.no-scroll {
    		overflow: hidden !important;
		}
		/*Transaction css*/
        .box-area-alt {
            padding-top: 5px; /* Reduce the top padding */
            padding-bottom: 10px; /* Add some bottom padding for spacing */
            margin-top: 10px; /* Adjust the top margin */
        }

        .box-area-alt h1 {
            margin-bottom: 20px;
            color: white;
            text-align: center;
        }

        .transaction-item {
            margin-bottom: 10px;
            padding: 10px;
            color: white;
            background-color: rgb(33, 37, 41);
            border-radius: 5px;
        }

        .transaction-item p {
            margin: 0;
        }

        .navbar-brand p {
            margin-bottom: 0; /* Remove the bottom margin */
        }

        @media only screen and (max-width: 576px) {
            .box-area-alt {
                margin: 20px auto; /* Centering horizontally */
            }
            .transaction-item {
                font-size: 12px;
            }
        }
        
        /*Profile css*/
        .box-area-alt-alt {
			
				width: 400px;
			    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.5);
			    border: 2px solid rgb(33, 37,41); /* Set border to primary color *//* Set the background color for the box area */
				margin: auto; /* Center horizontally */
			    margin-top: 20px; /* Adjust top margin for vertical centering */
			    padding: 20px; /* Add padding for better appearance */		
		}
		.btn-alt {
		    width: 100%;
		    padding: 10px;
		    background-color: rgb(20, 36, 105); /* Default background color */
		    color: yellow; /* Default text color */
		    border: none;
		    border-radius: 5px;
		    cursor: pointer;
		    text-align: center;
		}
		@media only screen and (max-width: 768px) {
            .box-area-alt-alt {
                width: 100%; /* Adjusts the width to 90% of the viewport width */
            }
        }
        .box-area-alt-alt, .row, .container {
			    border: none;
		}
		/*------------ Custom Placeholder ------------*/
		::placeholder{
			   font-size: 16px;
		}
		.rounded-5{
			   border-radius: 30px;
		}
		label{
			font-weight:bold;
			color: white;
		}
		        /* FUEL STATIONS */
		#fuelStations {
		    border: none;
		    margin: 0;
		    padding: 0;
		}
		.container-alt {
		    justify-content: center;
		    align-items: center;
		    height: 100vh;
		    overflow: hidden;
		    border: none;
		    margin: 0;
		    padding: 0;
		}
		.box-area-alt-alt-alt {
		    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.5);
		    background: white;
		    padding: 20px;
		    overflow-y: hidden;
		    border: none;
		    display: flex;
		    flex-direction: column;
		    max-width: 800px; /* Adjust the max-width value as needed */
		    margin: 0 auto; /* Center the box horizontally */
		}
		.result-item {
		    display: flex;
		    justify-content: space-between; /* Distribute space between child elements */
		    align-items: center;
		    border-top: 1px solid #ddd;
		    border-bottom: 1px solid #ddd;
		    padding: 10px 0;
		    cursor: pointer;
		    transition: background-color 0.3s, color 0.3s;
		}
		.result-item:hover {
		    background-color: #f8f9fa;
		    color: #0056b3;
		}
		.result-info {
		    flex-grow: 1; /* Allow this div to grow and take up available space */
		}
		.result-title {
		    font-weight: bold;
		}
		.result-rating {
		    color: #f39c12;
		}
		.result-address {
		    margin: 5px 0;
		}
		.result-actions a {
		    margin-right: 10px;
		}
		#results {
		    max-height: 250px;
		    overflow-y: auto;
		    border-radius: 4px;
		    padding: 10px;
		    flex-grow: 1;
		}
		.form-group {
		    margin-bottom: 10px;
		}
		/* Additional CSS for rounded circle buttons */
		.btn-circle {
		    width: 40px;
		    height: 40px;
		    border-radius: 50%;
		    border: 2px solid #0056b3;
		    background-color: #ffffff;
		    display: inline-flex;
		    align-items: center;
		    justify-content: center;
		    margin-right: 10px;
		}
		.selected {
		    color: #01579B; /* Ensures text is readable */
		}
		
		.form-select {
		    font-size: 1rem; /* Match font size */
		    line-height: 1.5; /* Match line height */
		    cursor: pointer; /* Use pointer cursor */
		    border: 1px solid #ced4da; /* Match border */
		    border-radius: 0.25rem; /* Match border radius */
		}
		
		.disabled-field:disabled {
	        background-color: #e9ecef; /* Light gray */
	        color: #6c757d; /* Gray text color */
	        border: 1px solid #ced4da; /* Gray border */
	    }
	
	    .editable-field {
	        background-color: #ffffff; /* White background */
	        border: 2px solid #007bff; /* Bold blue border */
	        box-shadow: 0 0 10px rgba(0, 123, 255, 0.7); /* More pronounced blue shadow */
	        color: #000000; /* Black text color */
	    }
    </style>
</head>
<body>
    <!-- Navigation Bar with Logo -->
    <div class="wrapper">
        <nav class="navbar navbar-expand-lg navbar-custom">
            <div class="container-fluid d-flex align-items-center">
                <!-- Navbar Brand (Logo) -->
                <a class="navbar-brand" href="#">
                    <img src="logo1.png" alt="Logo" width="50" height="45" class="d-inline-block align-text-top me-2">
                    <p style="font-weight: bold; color: yellow; font-size: 12px;">FuelSwift</p>
                </a>
            </div>
        </nav>

        <!-- Main Container -->
        <div class="content">
            <!-- ---------------------------------------- Home Page Content ----------------------------------------------------------------------------------->
            <div id="home-page" class="container">
                <!-- Points Container -->
                <div class="row mb-2 rounded-5 p-4 shadow box-area d-flex justify-content-center" style="background-color: rgb(33, 37, 41);">
                    <!-- Right Box -->
                    <div class="col-md-6 right-box mb-3" style="padding: 0 20px; align-items: center;">
                        <div class="row align-items-center">
                            <div class="header-text mb-2 mt-2">
                                <h5 style=" text-align: center;font-weight: bold; color: white">Welcome, <%=username %></h5>
                                <h1 style=" text-align: center; font-weight: bold; font-size: 80px; margin-bottom: 10px; margin-top: 20px; color: white"><%=points %>.00</h1>
                                <h2 style="text-align: center; font-size: 15px; color: white">Points</h2>
                            </div>
                        </div>
                    </div>     
                </div>
                <!-- Vehicle Number Plate Container -->
					<div class="row rounded-2 mb-5 p-1 shadow box-area d-flex justify-content-center align-items-center" style="max-height: 55px; text-align:center; background-color: rgb(33, 37, 41);">
					    <!-- Plate Number -->
					    <div class="col-6 mt-1">
					        <div class="header-text">
					            <h4 style="font-weight: bold; font-size: 10px; color: white; margin-bottom:0;">Plate Number</h4>
					            <div class="dropdown">
					                <button class="btn dropdown-toggle m-0 mt-0" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false" style="background-color: rgb(33, 37, 41); color:yellow; font-size:8px;">
					                    Select Vehicle
					                </button>
					                <ul class="dropdown-menu m-0 mt-0" aria-labelledby="dropdownMenuButton" id="vehicleDropdown" style="background-color: rgb(33, 37, 41); font-size:8px;">
					                    <!-- Dropdown items for vehicle information will be added dynamically -->
					                </ul>
					            </div>
					        </div>
					    </div>
					    <!-- Vehicle type -->
					    <div class="col-6 mt-1">
					        <div class="header-text">
					            <h4 class=" mt-0 mb-0" style="font-weight: bold; font-size: 10px; color: white;">Vehicle Type</h4>
					            <p class=" m-0 mt-0 p-2" id="vehicleType" style="font-size: 8px; color: yellow;"></p>
					        </div>
					    </div>
					</div>
				    <!-- Current Fuel Price -->
				    <div class="row justify-content-center">
				        <div class="col d-flex justify-content-center align-items-center">
				            <div class="text-center">
				                <h4 style="font-weight: bold; color: yellow;">Current Fuel Price</h4>
				                <h1 style="font-size: 40px; font-weight: bold; color: white;">RM2.50/L</h1>
				                <p style="font-size: 16px; color: white;">Updated: May 25, 2024</p>
				            </div>
				        </div>
				    </div>
                <!-- Options -->
                <div class="row justify-content-center align-items-center mx-auto mb-5">
                    <!-- First Image and Link -->
                        <a href=# id="fuelStations-link" class="d-flex flex-column align-items-center justify-content-center" >
                            <img src="fuel.png" style="width: 50%; height: 50%;" class="mb-2">
                        </a>
                        <p class="text-center" style="font-weight: bold; color: yellow;">Fuel Stations</p> 
                </div>
            </div>

            <!--------------------------------- Transaction History ---------------------------------------->
            <div id="transaction-history" class="container box-area-alt" style="display: none;">
            	<h1 style="font-weight: bold;">Transaction History</h1>
				     <% if (transactions != null) {
        				for (Transaction transaction : transactions) { %>
            				<div class="transaction-item">
                				<p>Transaction ID: #<%= transaction.getTransactionId() %></p>
                				<p>Date: <%= transaction.getDate() %></p>
               	 				<p>Amount: RM <%= transaction.getAmount() %></p>
                				<p>Status: Completed</p>
            				</div>
        <% }
				    } else { %>
				        <div style="position: absolute; top: 50%; left: 50%; text-align:center; transform: translate(-50%, -50%);">
						    <i class="bi bi-fuel-pump" style="color:grey; font-size:44px; text-align:center;"></i>
						    <p style="margin-top: 10px; color:grey; font-size:15px;">No bookings yet.<br>Make one today!</p>
						</div>
				    <%} %>
			</div>
        </div>
        
        <!---------------------------------------- Profile -------------------------------- -->
		<div id="profile" style="display: none;">
		    <!-- Icon below Navigation Bar -->
		    <div class="container d-flex justify-content-center align-items-center">
		        <i class="bi bi-person-circle" style="color: #cccccc; margin-right: 20px; font-size: 2rem;"></i>
		        <h2 style="color: white; margin-right: 10px; font-weight: bold;">Fatin</h2>
		    </div>
		
		    <div class="row rounded-5 p-4 shadow box-area-alt-alt" style="background-color: rgb(20, 36, 105)">
		        <div class="row align-items-center d-flex justify-content-center align-items-center m-0 p-0">
		            <form id="profileForm" action="UpdateProfileServlet" method="post" onsubmit="UpdateProfileServlet">
		                <div class="form-group mb-3">
		                    <label class="form-label">Full Name</label>
		                    <input class="form-control form-control-lg bg-light fs-6 disabled-field" name="fullname" id="fullname" placeholder="Fatin Humaira" disabled>
		                </div>
		                <div class="form-group mb-3">
		                    <label class="form-label">Email</label>
		                    <p class="form-control form-control-lg bg-light fs-6" name="email">fatin@gmail.com</p>
		                </div>
		                <div class="form-group mb-3">
		                    <label class="form-label">Gender</label>
		                    <div class="dropdown" id="gender">
		                        <select class="form-select m-0 mt-0 fs-6 disabled-field" id="genderSelect" name="gender" style="background-color: white; color: black; width: 330px; padding: 0.5rem 1rem;" disabled>
		                            <option value="" selected disabled>Select Gender</option>
		                            <option value="male">Male</option>
		                            <option value="female">Female</option>
		                            <option value="other">Rather not say</option>
		                        </select>
		                    </div>
		                </div>
		                <div class="form-group mb-3">
		                    <label class="form-label">Phone Number</label>
		                    <div class="input-group">
		                        <span class="input-group-text">+60</span>
		                        <input class="form-control form-control-lg bg-light fs-6 disabled-field" name="phoneNo" id="phoneNo" placeholder="Enter Phone Number" disabled>
		                    </div>
		                </div>
		                <div class="input-group-alt mb-3" id="editBtn">
		                    <button type="button" class="btn-alt custombutton btn-lg w-100 fs-6" style="background-color: rgb(30, 46, 125); color: yellow; cursor: pointer; transition: background-color 0.3s ease, color 0.3s ease;" onclick="enableEditing()" onmouseover="this.style.backgroundColor='rgb(20, 36, 105)'; this.style.color='white';" onmouseout="this.style.backgroundColor='rgb(30, 46, 125)'; this.style.color='yellow';">Edit</button>
		                </div>
		                <div class="input-group-alt mb-3" id="updateBtn" style="display: none;">
		                    <button type="submit" class="btn-alt btn-success btn-block">Update</button>
		                    <button type="button" class="btn-alt btn-danger btn-block mt-2" onclick="cancelEditing()">Cancel</button>
		                </div>
		            </form>
		            <div class="input-group-alt mb-3">
		                <a href="#" class="btn custombutton btn-lg w-100 fs-6" onclick="logout()" style="background-color: rgb(20, 36, 105); color: yellow; cursor: pointer; transition: background-color 0.3s ease, color 0.3s ease;">
		                    Logout <i class="bi bi-box-arrow-right"></i>
		                </a>
		            </div>
		        </div>
		    </div>
		</div>
       
		<!---------------------------------------- Fuel Stations -------------------------------- -->
         <div id="fuelStations" style="display:none;">
	    <div class="container-alt">
	        <div class="box-area-alt-alt-alt bg-white rounded" style="height:80%">
	            <h1 style="font-weight: bold;">Fuel Stations</h1>
	            <div id="map" style="height: 400px;"></div>
	            <form id="searchForm">
	                <div class="form-group mt-2">
	                    <input type="text" class="form-control" id="searchInput" placeholder="Type to search" oninput="filterLocations()">
	                </div>
	                <div id="results" class="row">
	                    <div class="result-item" onclick="handleClick(0)">
	                        <div class="result-info">
	                            <div class="result-title">Petron Tapah Road</div>
	                            <div class="result-rating">4.0 ★★★★☆ (246)</div>
	                            <div class="result-address">Petrol Station - KM8, Tapah Rd</div>
	                            <div class="result-hours">Open 24 hours · 1-300-22-8211</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="https://maps.google.com/maps?ll=4.182198,101.208029&z=21&t=m&hl=en-US&gl=US&mapclient=apiv3&cid=6161286462136182391" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                        <div class="result-item" onclick="handleClick(1)">
	                        <div class="result-info">
	                            <div class="result-title">Petron Tapah (Fl)</div>
	                            <div class="result-rating">4.0 ★★★★☆ (219)</div>
	                            <div class="result-address">Petrol Station - PT 4800-1, Jalan Temoh</div>
	                            <div class="result-hours">Open 24 hours · 05-401 2900</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="https://maps.google.com/maps?ll=4.217218,101.237452&z=22&t=m&hl=en-US&gl=US&mapclient=apiv3&cid=3321883033827026345" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                        <div class="result-item" onclick="handleClick(2)">
	                        <div class="result-info">
	                            <div class="result-title">PETRONAS</div>
	                            <div class="result-rating">4.0 ★★★★☆ (303)</div>
	                            <div class="result-address">Petrol Station - Lot 1317, GRN 12990, Jalan Bidor</div>
	                            <div class="result-hours">Open 24 hours</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="https://maps.google.com/maps?ll=4.194683,101.261567&z=18&t=m&hl=en-US&gl=US&mapclient=apiv3&cid=2054500792220682713" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                        <div class="result-item" onclick="handleClick(3)">
	                        <div class="result-info">
	                            <div class="result-title">Petronas Tapah (PLUS)</div>
	                            <div class="result-rating">4.0 ★★★★☆ (1,308)</div>
	                            <div class="result-address">Petrol Station - Lebuhraya Utara Selatan, Kawasan Rehat & Rawat Hala Utara</div>
	                            <div class="result-hours">Open 24 hours · 03-4293 7580</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="https://maps.google.com/maps?ll=4.179547,101.289099&z=21&t=m&hl=en-US&gl=US&mapclient=apiv3&cid=10541676871044767881" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                        <div class="result-item" onclick="handleClick(4)">
	                        <div class="result-info">
	                            <div class="result-title">BHPetrol Tapah 2</div>
	                            <div class="result-rating">4.0 ★★★★☆ (138)</div>
	                            <div class="result-address">Petrol Station - Lot 5541-1, Jalan Bidor</div>
	                            <div class="result-hours">Open 24 hours · 05-401 1086</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="https://maps.google.com/maps?ll=4.19347,101.263341&z=22&t=m&hl=en-US&gl=US&mapclient=apiv3&cid=13100363592971762713" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                        <div class="result-item" onclick="handleClick(5)">
	                        <div class="result-info">
	                            <div class="result-title">Shell</div>
	                            <div class="result-rating">4.0 ★★★★☆ (374)</div>
	                            <div class="result-address">Petrol Station - Kaw R&R Tapah, North-South Expy</div>
	                            <div class="result-hours">Open 24 hours · 05-401 3863</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="https://maps.google.com/maps?ll=4.179088,101.290875&z=20&t=m&hl=en-US&gl=US&mapclient=apiv3&cid=10937259924059749594" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                        <div class="result-item" onclick="handleClick(6)">
	                        <div class="result-info">
	                            <div class="result-title">Shell</div>
	                            <div class="result-rating">4.0 ★★★★☆ (597)</div>
	                            <div class="result-address">Petrol Station - North-South Expy</div>
	                            <div class="result-hours">Open 24 hours · 05-401 6785</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="https://maps.google.com/maps?ll=4.179141,101.289432&z=20&t=m&hl=en-US&gl=US&mapclient=apiv3&cid=18170086032194273371" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                        <div class="result-item" onclick="handleClick(7)">
	                        <div class="result-info">
	                            <div class="result-title">Shell</div>
	                            <div class="result-rating">4.0 ★★★★☆ (597)</div>
	                            <div class="result-address">Petrol Station - A10 Lot 10746, Grn 42493</div>
	                            <div class="result-hours">Closes 11 pm · 013-858 8828</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="https://maps.google.com/maps?ll=4.162338,101.180408&z=21&t=m&hl=en-US&gl=US&mapclient=apiv3&cid=15688763625513908972" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                        <div class="result-item" onclick="handleClick(8)">
	                        <div class="result-info">
	                            <div class="result-title">Petronas Bidor</div>
	                            <div class="result-rating">4.0 ★★★★☆ (273)</div>
	                            <div class="result-address">Petrol Station - 945, Jalan Tapah</div>
	                            <div class="result-hours">Open 24 hours · 1-300-88-8181</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="#" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                        <div class="result-item" onclick="handleClick(9)">
	                        <div class="result-info">
	                            <div class="result-title">Caltex Bidor</div>
	                            <div class="result-rating">4.0 ★★★★☆ (134)</div>
	                            <div class="result-address">Petrol Station - 62-C, Jalan Besar</div>
	                            <div class="result-hours">Open 24 hours</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="#" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                        <div class="result-item" onclick="handleClick(10)">
	                        <div class="result-info">
	                            <div class="result-title">Petron Bidor</div>
	                            <div class="result-rating">4.0 ★★★★☆ (181)</div>
	                            <div class="result-address">Petrol Station - LT 2672, Jalan Besar</div>
	                            <div class="result-hours">Open 24 hours · 05-434 1337</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="#" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                        <div class="result-item" onclick="handleClick(11)">
	                        <div class="result-info">
	                            <div class="result-title">Shell</div>
	                            <div class="result-rating">4.0 ★★★★☆ (181)</div>
	                            <div class="result-address">Petrol Station - Lot 2674, Jalan Besar</div>
	                            <div class="result-hours">Open 24 hours · 05-434 1566</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="https://maps.google.com/maps?ll=4.115132,101.290396&z=15&t=m&hl=en-US&gl=US&mapclient=apiv3&cid=3302995116548542083" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>
	                         <div class="result-item" onclick="handleClick(12)">
	                         <div class="result-info">
	                            <div class="result-title">BHPetrol Ladang Bikam (Northbound)</div>
	                            <div class="result-rating">4.0 ★★★★☆ (322)</div>
	                            <div class="result-address">Petrol Station - Kaw. Hentian Ladang Bikam Arah U/S</div>
	                            <div class="result-hours">Open 24 hours · 011-4061 9260</div>
	                        </div>
	                        <div class="result-actions">
	                            <a href="https://maps.google.com/maps?ll=4.0495,101.310348&z=15&t=m&hl=en-US&gl=US&mapclient=apiv3&cid=282603716767156735" class="btn btn-circle btn-sm">
	                                <img src="nav.png" alt="Direction Icon" style="width:24px; height:27px">
	                            </a>
	                        </div>
	                        </div>                       
	                    </div>
	                    <div class="text-center mt-3" style="font-family: 'Poppins', sans-serif">
					    	<button type="button" class="btn " onclick="fuelNow()" style="background-color: rgb(30, 46, 125); color: yellow; cursor: pointer; transition: background-color 0.3s ease, color 0.3s ease;" onmouseover="this.style.backgroundColor='rgb(20, 36, 105)'; this.style.color='white';" onmouseout="this.style.backgroundColor='rgb(30, 46, 125)'; this.style.color='yellow';">Fuel Now</button>
						</div> 
	                </form>
	            </div>
	        </div>
	    </div>

		 <div id="loading-overlay">
	        <span class="loader"></span>
	        <p>Loading...</p>
    	</div>
		
        <!-- Footer -->
        <footer class="footer box-area fixed-bottom" style="background-color: rgb(23, 59, 121);">
            <div class="navbar" style="display: flex; justify-content: space-around; align-items: center;">
                <!-- Home Link -->
                <a href="#" id="home-link" style="text-decoration: none; color: white; display: flex; flex-direction: column; align-items: center;">
                    <img src="HomeIcon.png" alt="Home Icon" style="width: 25px; height: auto; margin-bottom: 2px;">
                    <p style="margin: 0; font-size: 12px; font-weight: bold;">Home</p>
                </a>
                <!-- History Link -->
                <a href="#" id="history-link" style="text-decoration: none; color: white; display: flex; flex-direction: column; align-items: center;">
                    <img src="history.png" alt="History Icon" style="width: 18px; height: auto; margin-bottom: 2px;">
                    <p style="margin: 0; font-size: 12px; font-weight: bold;">History</p>
                </a>
                <!-- Profile Link -->
                <a href="#" id="profile-link" style="text-decoration: none; color: white; display: flex; flex-direction: column; align-items: center;">
                    <img src="profile.png" alt="Profile Icon" style="width: 23px; height: auto; margin-bottom: 2px;">
                    <p style="margin: 0; font-size: 12px; font-weight: bold;">Profile</p>
                </a>
            </div>
        </footer>
        
        
        <!-- Modal HTML -->
	    <div class="modal fade" id="locationModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	      <div class="modal-dialog" role="document">
	        <div class="modal-content">
	          <div class="modal-header">
	            <h5 class="modal-title" id="exampleModalLabel">No Location Selected</h5>
	            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	              <span aria-hidden="true">&times;</span>
	            </button>
	          </div>
	          <div class="modal-body">
	            Please select a location first.
	          </div>
	        </div>
	      </div>
	    </div>
        
    </div>
    
<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editModalLabel">Edit Vehicle</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editVehicleForm">
                    <div class="mb-3">
                        <label for="editPlateNumber" class="form-label" style="color: black; font-weight: normal;">Plate Number:</label>
                        <input type="text" class="form-control" id="editPlateNumber" name="editPlateNumber" required>
                        <small id="plateNumberError" class="text-danger d-none">Plate number is required.</small>
                    </div>
                    <div class="mb-3">
                        <label for="editVehicleType" class="form-label" style="color: black; font-weight: normal;">Vehicle Type:</label>
                        <input type="text" class="form-control" id="editVehicleType" name="editVehicleType" required>
                        <small id="vehicleTypeError" class="text-danger d-none">Vehicle type is required.</small>
                    </div>
                    <div class="mb-3">
                        <label for="editVIN" class="form-label" style="color: black; font-weight: normal;">VIN:</label>
                        <input type="text" class="form-control" id="editVIN" name="editVIN" required>
                        <small id="vinError" class="text-danger d-none">VIN is required.</small>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="saveEditBtn" style="background-color:rgb(20, 36, 105); color:yellow" onmouseout="this.style.backgroundColor='rgb(30, 46, 125)'; this.style.color='yellow';">Save changes</button>
            </div>
        </div>
    </div>
</div>


<!-- Delete Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Delete Vehicle</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this vehicle?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
            </div>
        </div>
    </div>
</div>

<!-- Add Modal -->
<div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="addModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form id="addVehicleForm">
                <div class="modal-header">
                    <h5 class="modal-title" id="addModalLabel">Add Vehicle</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="addPlateNumber" class="form-label" style="color: black; font-weight: normal;">Plate Number:</label>
                        <input type="text" class="form-control" id="addPlateNumber" name="addPlateNumber" required>
                        <small id="addPlateNumberError" class="text-danger d-none">Plate number is required.</small>
                    </div>
                    <div class="mb-3">
                        <label for="addVehicleType" class="form-label" style="color: black; font-weight: normal;">Vehicle Type:</label>
                        <input type="text" class="form-control" id="addVehicleType" name="addVehicleType" required>
                        <small id="addVehicleTypeError" class="text-danger d-none">Vehicle type is required.</small>
                    </div>
                    <div class="mb-3">
                        <label for="addVIN" class="form-label" style="color: black; font-weight: normal;">VIN:</label>
                        <input type="text" class="form-control" id="addVIN" name="addVIN" required>
                        <small id="addVINError" class="text-danger d-none">VIN is required.</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary" id="saveAddBtn" style="background-color:rgb(20, 36, 105); color:yellow" onmouseout="this.style.backgroundColor='rgb(30, 46, 125)'; this.style.color='yellow';">Add Vehicle</button>
                </div>
            </form>
        </div>
    </div>
</div>

  
	<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<!-- Google Maps API -->
<script src="https://maps.googleapis.com/maps/api/js?libraries=places&callback=initMap" async defer></script>

<script>
    document.getElementById('home-link').addEventListener('click', function(event) {
        event.preventDefault();
        document.getElementById('home-page').style.display = 'block';
        document.getElementById('transaction-history').style.display = 'none';
        document.getElementById('profile').style.display = 'none';
        document.getElementById('fuelStations').style.display = 'none';
    });

    document.getElementById('history-link').addEventListener('click', function(event) {
        event.preventDefault();
        document.getElementById('home-page').style.display = 'none';
        document.getElementById('transaction-history').style.display = 'block';
        document.getElementById('profile').style.display = 'none';
        document.getElementById('fuelStations').style.display = 'none';

    });

    document.getElementById('profile-link').addEventListener('click', function(event) {
        event.preventDefault();
        document.getElementById('home-page').style.display = 'none';
        document.getElementById('transaction-history').style.display = 'none';
        document.getElementById('profile').style.display = 'block';
        document.getElementById('fuelStations').style.display = 'none';
    });
    
    document.getElementById('fuelStations-link').addEventListener('click', function(event) {
        event.preventDefault();
        document.getElementById('home-page').style.display = 'none';
        document.getElementById('transaction-history').style.display = 'none';
        document.getElementById('profile').style.display = 'none';
        document.getElementById('fuelStations').style.display = 'block';
        toggleScroll(); // Call toggleScroll function here
    });

    function toggleScroll() {
        var fuelStationsPage = document.getElementById("fuelStations");
        fuelStationsPage.style.overflow = (fuelStationsPage.style.overflow === 'hidden') ? 'auto' : 'hidden';
    }
    
    function enableEditing() {
        // Enable input fields
        document.getElementById('fullname').disabled = false;
        document.getElementById('phoneNo').disabled = false;
        document.getElementById('genderSelect').disabled = false;

        // Remove the disabled-field class and add the editable-field class
        document.getElementById('fullname').classList.remove('disabled-field');
        document.getElementById('phoneNo').classList.remove('disabled-field');
        document.getElementById('genderSelect').classList.remove('disabled-field');

        document.getElementById('fullname').classList.add('editable-field');
        document.getElementById('phoneNo').classList.add('editable-field');
        document.getElementById('genderSelect').classList.add('editable-field');

        // Show the Update and Cancel buttons, hide the Edit button
        document.getElementById('updateBtn').style.display = 'block';
        document.getElementById('editBtn').style.display = 'none';
    }

    function cancelEditing() {
        // Disable input fields  
        document.getElementById('fullname').disabled = true;
        document.getElementById('phoneNo').disabled = true;
        document.getElementById('genderSelect').disabled = true;

        // Remove the editable-field class and add the disabled-field class
        document.getElementById('fullname').classList.remove('editable-field');
        document.getElementById('phoneNo').classList.remove('editable-field');
        document.getElementById('genderSelect').classList.remove('editable-field');

        document.getElementById('fullname').classList.add('disabled-field');
        document.getElementById('phoneNo').classList.add('disabled-field');
        document.getElementById('genderSelect').classList.add('disabled-field');

        // Hide the Update and Cancel buttons, show the Edit button
        document.getElementById('updateBtn').style.display = 'none';
        document.getElementById('editBtn').style.display = 'block';
    }

    function handleSubmit(event) {
        event.preventDefault(); // Prevent the form from submitting the default way

        // Disable input fields  
        document.getElementById('fullname').disabled = true;
        document.getElementById('phoneNo').disabled = true;
        document.getElementById('genderSelect').disabled = true;

        // Remove the editable-field class and add the disabled-field class
        document.getElementById('fullname').classList.remove('editable-field');
        document.getElementById('phoneNo').classList.remove('editable-field');
        document.getElementById('genderSelect').classList.remove('editable-field');

        document.getElementById('fullname').classList.add('disabled-field');
        document.getElementById('phoneNo').classList.add('disabled-field');
        document.getElementById('genderSelect').classList.add('disabled-field');

        // Hide the Update and Cancel buttons, show the Edit button
        document.getElementById('updateBtn').style.display = 'none';
        document.getElementById('editBtn').style.display = 'block';

        // Get form data
        var formData = new FormData(document.getElementById('profileForm'));

        // Send the form data using fetch
        fetch('/FuelSwift/UpdateProfile/UpdateProfileServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => response.text())
        .then(result => {
            console.log('Success:', result);
            // You can add any additional success handling here if needed
        })
        .catch(error => {
            console.error('Error:', error);
            // You can add any error handling here if needed
        });
        location.reload();
    }
    
    document.addEventListener('DOMContentLoaded', function() {
    	var vehicles = [];

        <% for (VehicleBean vehicle : vehicles) { %>
                vehicles.push({
                    plateNumber: '<%= vehicle.getPlateNumber() %>',
                    vehicleType: '<%= vehicle.getVehicleType() %>',
                    vin: '<%= vehicle.getVin() %>'
                });
            vehicles.push(vehicle);
        <% } %>
        
    
    	const vehicleDropdown = document.getElementById("vehicleDropdown");
        const vehicleTypeElement = document.getElementById("vehicleType");

        function updateVehicleType(plateNumber) {
            const vehicle = vehicles.find(v => v.plateNumber === plateNumber);
            if (vehicle) {
                vehicleTypeElement.textContent = vehicle.vehicleType;
            } else {
                vehicleTypeElement.textContent = "";
            }
        }

        function renderDropdown() {
            vehicleDropdown.innerHTML = ""; // Clear existing dropdown items

            vehicles.forEach(vehicle => {
                const dropdownItem = document.createElement("li");
                dropdownItem.style.display = "flex";
                dropdownItem.style.justifyContent = "space-between";
                dropdownItem.style.alignItems = "center";
                dropdownItem.style.padding = "3px";
                dropdownItem.style.color = "yellow";
                dropdownItem.style.cursor = "pointer"; // Add cursor pointer style

                // Hover effect
                dropdownItem.addEventListener('mouseover', function() {
                    dropdownItem.style.backgroundColor = "#f0f0f0"; // Change this to the color you prefer
                });

                dropdownItem.addEventListener('mouseout', function() {
                    dropdownItem.style.backgroundColor = ""; // Reset to default
                });

                dropdownItem.innerHTML = `
                    <span style="flex-grow: 1; margin-left: 20px; text-align: left; font-size:10px;">${vehicle.plateNumber}</span>
                    <button style="padding: 0.1rem 0.2rem; margin-right: 3px; background: none; border: none;" class="edit-btn"><i class="bi bi-pen" style="font-size: 15px; color: #3843D7;"></i></button>
                    <button style="padding: 0.1rem 0.3rem;background: none; border: none;" class="delete-btn"><i class="bi bi-x-circle" style="font-size: 15px; color: red;"></i></button>`;

                 // Inside the edit-btn event listener
                    dropdownItem.querySelector(".edit-btn").addEventListener('click', function(event) {
                        event.stopPropagation(); // Prevent event from triggering the item click event

                        // Show edit modal
                        $('#editModal').modal('show');

                        // Set up initial values in the modal inputs
                        document.getElementById('editPlateNumber').value = vehicle.plateNumber;
                        document.getElementById('editVehicleType').value = vehicle.vehicleType;
                        document.getElementById('editVIN').value = vehicle.vin;

                        // Handle saving changes in the edit modal
                        document.getElementById('saveEditBtn').addEventListener('click', function() {
                            const newPlateNumber = document.getElementById('editPlateNumber').value.trim();
                            const newVehicleType = document.getElementById('editVehicleType').value.trim();
                            const newVIN = document.getElementById('editVIN').value.trim();
                            let formValid = true;

                            // Validate and display errors
                            if (!newPlateNumber) {
                                document.getElementById('plateNumberError').classList.remove('d-none');
                                formValid = false;
                            } else {
                                document.getElementById('plateNumberError').classList.add('d-none');
                            }

                            if (!newVehicleType) {
                                document.getElementById('vehicleTypeError').classList.remove('d-none');
                                formValid = false;
                            } else {
                                document.getElementById('vehicleTypeError').classList.add('d-none');
                            }

                            if (!newVIN) {
                                document.getElementById('vinError').classList.remove('d-none');
                                formValid = false;
                            } else {
                                document.getElementById('vinError').classList.add('d-none');
                            }

                            // If form is valid, proceed with saving changes
                            if (formValid) {
                                // Check if values are changed
                                if (newPlateNumber !== vehicle.plateNumber ||
                                    newVehicleType !== vehicle.vehicleType ||
                                    newVIN !== vehicle.vin) {
                                    // Update vehicle details
                                    vehicle.plateNumber = newPlateNumber;
                                    vehicle.vehicleType = newVehicleType;
                                    vehicle.vin = newVIN;

                                    // Update dropdown item display
                                    dropdownItem.querySelector("span").textContent = newPlateNumber;
                                    
                                 // Send data to the servlet for database update
                                    fetch('/UpdateVehicleServlet', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/x-www-form-urlencoded'
                                        },
                                        body: `editPlateNumber=${encodeURIComponent(newPlateNumber)}&editVehicleType=${encodeURIComponent(newVehicleType)}&editVIN=${encodeURIComponent(newVIN)}`
                                    })
                                    .then(response => {
                                        if (response.ok) {
                                            console.log('Form submitted successfully');
                                            // Handle success scenario here, such as updating UI or showing a success message
                                        } else {
                                            console.error('Form submission failed');
                                            // Handle failure scenario here, such as showing an error message to the user
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        // Handle any fetch error here, such as network issues or server not responding
                                    });

                                    // Hide edit modal after saving changes
                                    $('#editModal').modal('hide');
                                    location.reload();
                                } else {
                                    // No changes made
                                    $('#editModal').modal('hide');
                                }
                            }
                        });
                    });


                    // Inside the delete-btn event listener
                    dropdownItem.querySelector(".delete-btn").addEventListener('click', function(event) {
                        event.stopPropagation(); // Prevent event from triggering the item click event
                        $('#deleteModal').modal('show'); // Show delete modal

                        // Handle confirmation for deletion in the delete modal
                        document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
                        	// Immediately delete the vehicle without additional confirmation
                            vehicles.splice(vehicles.indexOf(vehicle), 1);
                            renderDropdown(); // Refresh dropdown after deletion
                            $('#deleteModal').modal('hide'); // Hide delete modal after deletion
                            
                         // Send data to the servlet for database deletion
                            fetch('/DeleteVehicleServlet', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                },
                                body: `deletePlateNumber=${encodeURIComponent(vehicle.plateNumber)}`
                            })
                            .then(response => {
                                if (response.ok) {
                                    console.log('Form submitted successfully');
                                    // Handle success scenario here, such as updating UI or showing a success message
                                } else {
                                    console.error('Form submission failed');
                                    // Handle failure scenario here, such as showing an error message to the user
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                // Handle any fetch error here, such as network issues or server not responding
                            });
                            
                            location.reload();
                        });
                    });

                dropdownItem.addEventListener('click', function() {
                    document.getElementById("dropdownMenuButton").textContent = vehicle.plateNumber;
                    updateVehicleType(vehicle.plateNumber);
                });

                vehicleDropdown.appendChild(dropdownItem);
            });

            // Add button
            const addBtn = document.createElement("button");
            addBtn.innerHTML = '<i class="bi bi-plus-circle" style="font-size: 15px; color: grey;"></i>';
            addBtn.style.marginTop = "10px";
            addBtn.style.marginRight = "3px"; // Adjust margin-right to create space from the right edge
            addBtn.style.float = "right"; // Float the button to the right
            addBtn.style.backgroundColor = "transparent"; // Remove background color
            addBtn.style.border = "none"; // Remove border
            
         // Inside the addBtn event listener
            addBtn.addEventListener('click', function() {
                $('#addModal').modal('show'); // Show add modal

                // Handle adding new vehicle in the add modal
                document.getElementById('saveAddBtn').addEventListener('click', function() {
                    const plateNumber = document.getElementById('addPlateNumber').value.trim();
                    const vehicleType = document.getElementById('addVehicleType').value.trim();
                    const vin = document.getElementById('addVIN').value.trim();
                    let formValid = true;

                    // Validate and display errors
                    if (!plateNumber) {
                        document.getElementById('addPlateNumberError').classList.remove('d-none');
                        formValid = false;
                    } else {
                        document.getElementById('addPlateNumberError').classList.add('d-none');
                    }

                    if (!vehicleType) {
                        document.getElementById('addVehicleTypeError').classList.remove('d-none');
                        formValid = false;
                    } else {
                        document.getElementById('addVehicleTypeError').classList.add('d-none');
                    }

                    if (!vin) {
                        document.getElementById('addVINError').classList.remove('d-none');
                        formValid = false;
                    } else {
                        document.getElementById('addVINError').classList.add('d-none');
                    }

                    // If form is valid, proceed with adding new vehicle
                    if (formValid) {
                        // Create new vehicle object
                        const newVehicle = {
                            plateNumber: plateNumber,
                            vehicleType: vehicleType,
                            vin: vin
                        };

                        // Add new vehicle to the vehicles array
                        vehicles.push(newVehicle);

                        // Refresh dropdown after addition
                        renderDropdown();
                        
                     // Send data to the servlet for database update
                        fetch('/AddVehicleServlet', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'
                            },
                            body: `addPlateNumber=${encodeURIComponent(plateNumber)}&addVehicleType=${encodeURIComponent(vehicleType)}&addVIN=${encodeURIComponent(vin)}`
                        })
                        .then(response => {
                            if (response.ok) {
                                console.log('Form submitted successfully');
                                // Handle success scenario here, such as updating UI or showing a success message
                            } else {
                                console.error('Form submission failed');
                                // Handle failure scenario here, such as showing an error message to the user
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            // Handle any fetch error here, such as network issues or server not responding
                        });

                        // Hide add modal after adding new vehicle
                        $('#addModal').modal('hide');
                        location.reload();
                    }
                });

                // Clear input fields and error messages on modal close
                $('#addModal').on('hidden.bs.modal', function () {
                    document.getElementById('addPlateNumber').value = '';
                    document.getElementById('addVehicleType').value = '';
                    document.getElementById('addVIN').value = '';
                    document.getElementById('addPlateNumberError').classList.add('d-none');
                    document.getElementById('addVehicleTypeError').classList.add('d-none');
                    document.getElementById('addVINError').classList.add('d-none');
                });
            });
            vehicleDropdown.appendChild(addBtn);
        }
        renderDropdown();
        
    });
   
    function logout() {
        // Perform logout functionality here
        // For example, redirecting the user to the logout page
        window.location.href = "/FuelSwift/Login/Login.jsp"; // Change "logout.php" to the actual logout URL
    }
	// GOOGLE MAPS 
    function loadGoogleMapsAPI() {
    	const apiUrl = 'http://localhost:3000/maps-api';

        fetch(apiUrl)
            .then(response => response.text())
            .then(script => {
                const scriptElement = document.createElement('script');
                scriptElement.type = 'text/javascript';
                scriptElement.text = script;
                document.body.appendChild(scriptElement);
            })
            .catch(error => console.error('Error loading Google Maps API:', error));
    }

    loadGoogleMapsAPI();
    let map;
    let markers = [];

    const locations = [
        { title: "Petron Tapah Road", address: "KM8, Tapah Rd, Kampung Baru 5, 35400 Tapah Road, Perak", coords: { lat: 4.182220948309242, lng: 101.2080520567422 } },
        { title: "Petron Tapah", address: " PT 4800-1, Jalan Temoh, 35000 Tapah, Perak", coords: { lat: 4.217226171841645, lng:  101.2374431331133 } },
        { title: "Petronas", address: "Lot 1317, GRN 12990, Jalan Bidor, 35000 Tapah, Perak", coords: { lat: 4.194367865722428, lng: 101.26132444108521 } },
        { title: "Petronas Tapah (PLUS)", address: "Lebuhraya Utara Selatan, Kawasan Rehat & Rawat Hala Utara, 35000 Tapah, Perak", coords: { lat: 4.179572447300953, lng: 101.28907041163741 } },
        { title: "BHPetrol Tapah 2", address: "Lot 5541-2, Jalan Bidor, 35000 Tapah, Perak", coords: { lat: 4.193499665733948, lng: 101.26329401163741 } },
        { title: "Shell", address: "Kaw R&R Tapah, North-South Expy, Arah Selatan, 35000 Tapah, Perak", coords: { lat: 4.1790730346943485, lng: 101.29098599998079 } },
        { title: "Shell", address: "North-South Expy, 35000 Tapah, Perak", coords: { lat: 4.179242147307275, lng: 101.28922500611534 } },
        { title: "Shell", address: "A10 Lot 10746, Grn 42493, Kampung Pekan Kecil, 35400 Tapah Road, Perak", coords: { lat: 4.162339235467068, lng: 101.1803410883242 } },
        { title: "Petronas Bidor", address: "945, Jalan Tapah, Pekan Bidor, 35500 Bidor, Perak", coords: { lat: 4.119925974633446, lng: 101.2843875593715 } },
        { title: "Caltex Bidor", address: "62-C, Jalan Besar, 35500 Bidor, Perak", coords: { lat: 4.115131862458604, lng: 101.29674717780777 } },
        { title: "Petron Bidor", address: "LT 2672, Jalan Besar, 35500 Bidor, Perak", coords: { lat: 4.120439627796194, lng: 101.28541752757454 } },
        { title: "Shell", address: "Lot 2674, Jalan Besar, 35500 Bidor, Perak", coords: { lat: 4.115131862458604, lng: 101.29039570722249 } },
        { title: "BHPetrol Ladang Bikam (NorthBound)", address: "Kaw. Hentian Ladang Bikam Arah U/S, 35600 Sungkai, Perak", coords: { lat: 4.0495, lng: 101.310348 } },

    ];
	
    function initMap() {
        const center = { lat: 4.2005, lng: 101.2557 };

        map = new google.maps.Map(document.getElementById("map"), {
            zoom: 10,
            center: center,
        });

        locations.forEach((location, index) => {
            const marker = new google.maps.Marker({
                position: location.coords,
                map: map,
                title: location.title
            });
            markers.push(marker);
        });
    }

    function filterLocations() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const resultItems = document.querySelectorAll('.result-item');

        let firstMatch = null;

        resultItems.forEach((item, index) => {
            const title = locations[index].title.toLowerCase();
            const address = locations[index].address.toLowerCase();
            
            if (title.includes(input) || address.includes(input)) {
                item.style.display = '';
                if (!firstMatch) {
                    firstMatch = item;
                }
            } else {
                item.style.display = 'none';
            }
        });

        if (firstMatch) {
            firstMatch.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

	let selectedIndex = null;
    
	function handleClick(index) {
        const location = locations[index];
        map.setCenter(location.coords);
        map.setZoom(15);
        markers[index].setAnimation(google.maps.Animation.BOUNCE);
        setTimeout(() => markers[index].setAnimation(null), 1400);
     	// Remove 'selected' class from all elements
        const resultItems = document.querySelectorAll('.result-item');
        resultItems.forEach(item => item.classList.remove('selected'));

        // Add 'selected' class to the clicked element
        const selectedItem = document.querySelector(`.result-item:nth-child(${index + 1})`);
        selectedItem.classList.add('selected');
        
     // Store the selected index
        selectedIndex = index;
    }
    
	function fuelNow() {
    	if (selectedIndex !== null) {
            const selectedLocation = locations[selectedIndex];
            const title = encodeURIComponent(selectedLocation.title); // Encode title for URL
            const address = encodeURIComponent(selectedLocation.address); // Encode address for URL
            const index = selectedIndex;
            
         // Send data to servlet using AJAX
            $.ajax({
                url: '/FuelSwift/PumpAvailability', // Replace with your servlet URL
                type: 'GET', // Or 'POST' if needed
                data: { title: title }, // Send the title as data
                success: function(response) {
                    // Assuming the response is the string you need
                    const retrievedString = response;

                    // Construct the URL with the retrieved string
                    const url = `/FuelSwift/PetrolPumpPage/petrolPump.jsp?index=${index}&title=${title}&address=${address}&retrievedString=${encodeURIComponent(retrievedString)}`;

                    // Redirect to the payment page with the constructed URL
                    window.location.href = url;
                },
                error: function(xhr, status, error) {
                    // Handle any errors that occurred during the request
                    console.error("Error occurred while communicating with the servlet:", error);
                }
            });
        
        } else {
            $('#locationModal').modal('show');
            setTimeout(() => {
                $('#locationModal').modal('hide');
            }, 2000); // Hide modal after 2 seconds (2000 milliseconds)
        }
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
   