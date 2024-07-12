<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <link rel="stylesheet" href="/FuelSwift/src/main/webapp/Login/Login.css">
    <title>Login | FuelSwift</title>
 <style>
 	/* Footer text */
	.footer-text {
	    text-align: center;
	    color: #6c757d;
	    padding: 10px 0;
	    font-size: 15px;
	    width: 100%;
	    margin: auto; /* Horizontally center */
	    position: fixed; /* Position footer absolutely */
	    bottom: 0; /* Align footer to bottom */
	    left: 0; /* Align footer to the left */
	    right: 0; /* Align footer to the right */
	}

	/* Login container */
	.box-area {
	    max-width: 800px;
	    box-shadow: 80px 60px 20px rgba(0, 0, 0, 0); /* Increased shadow */
	    border: 2px solid rgb(33, 37, 41); /* Set border to primary color */
	    margin:0;
	    padding:0;
	}

	.box-area, .row, .container {
	    
	    border: none;
	}

	/* Right box */
	.right-box {
	    padding: 20px;
	}

	/* Custom Placeholder */
	::placeholder {
	    font-size: 16px;
	}

	.rounded-4 {
	    border-radius: 20px;
	}

	.rounded-5 {
	    border-radius: 30px;
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
	
 </style>
</head>
<body style="background-color: rgb(20, 36, 105);">
<form action="/FuelSwift/LoginJava/servletLogin" method=post>
    <!----------------------- Main Container -------------------------->
     <div class="container d-flex justify-content-center align-items-center min-vh-100">
    <!----------------------- Login Container -------------------------->
       <div class="row rounded-5 p-3 shadow box-area" style="background-color: rgb(20, 36, 105);">
    <!--------------------------- Left Box ----------------------------->
       <div class="col-md-6 rounded-4 d-flex justify-content-center align-items-center flex-column left-box">
           <div class="featured-image mb-0 " style=" display: flex; justify-content: center; align-items: center;">
            <img src="logo1.png" class="img-fluid" style="width: 80%; height: 80%;">
           </div>
           <p class="text-white fs-2" style="font-family: 'Courier New', Courier, monospace; font-weight: 600;"></p>
           <small class="text-white text-wrap text-center" style="width: 17rem;font-family: 'Courier New', Courier, monospace;"></small>
       </div> 
    <!-------------------- ------ Right Box ---------------------------->
        
       <div class="col-md-6 right-box">
          <div class="row align-items-center">
                <div class="header-text mb-4">
                     <h1 style="text-align: center; font-weight: bold; color:yellow;">FuelSwift</h1>
                </div>
                <div class="input-group mb-3">
                    <input type="text" name = username class="form-control form-control-lg bg-light fs-6" placeholder="Email address">
                </div>
                <div class="input-group mb-1">
                    <input type="password" name = password class="form-control form-control-lg bg-light fs-6" placeholder="Password">
                </div>
                <div class="input-group mb-3 d-flex justify-content-between">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="formCheck">
                        <label for="formCheck" class="form-check-label text-secondary"><small style="color: black;">Remember Me</small></label>
                    </div>
                </div>
                <div class="input-group mb-3">
                    <button class="btn custombutton btn-lg w-100 fs-6" style="background-color: rgb(30, 46, 125); color: yellow; cursor: pointer; transition: background-color 0.3s ease, color 0.3s ease;"  onmouseover="this.style.backgroundColor='rgb(20, 36, 105)'; this.style.color='white';"
        onmouseout="this.style.backgroundColor='rgb(30, 46, 125)'; this.style.color='yellow';">Login</button>
                </div>
                <div class="row mb-4">
                    <small>Don't have account? <a href="/FuelSwift/Registration/registration.jsp" style="color: yellow;">Sign Up</a></small>
                </div>
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
<script>
    	document.addEventListener("DOMContentLoaded", function() {
        // Simulate loading completion after 3 seconds for demo purposes
        setTimeout(function() {
            document.getElementById('loading-overlay').style.display = 'none';
        }, 3000);
    });
</script>
</body>
</html>