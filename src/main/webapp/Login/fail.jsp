<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            margin: 0;
            font-family: 'Montserrat', sans-serif;
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
        }

        .show {
            animation: slideDown 1.5s forwards;
        }

        .hide {
            animation: slideUp 1.5s forwards;
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
        }

        .error-message p {
            margin: 0;
            font-size: 15px;
        }

        .container {
            padding-top: 100px; /* To avoid overlap with the error message */
        }
    </style>
</head>
<body>
    <div class="error-message show" id="error-message">
        <h3>Login Failed</h3>
        <p>The email or password you entered is incorrect. Please try again.</p>
    </div>

        <%@ include file="Login.jsp" %>
   

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var errorMessage = document.getElementById('error-message');
            
            // Delay adding hide class to ensure slideDown animation completes
            setTimeout(function() {
                errorMessage.classList.add('hide');
            }, 3000); // Adjust this delay if needed
            
            // Remove show class after slideUp animation completes
            setTimeout(function() {
                errorMessage.classList.remove('show');
            }, 3000); // Adjust this delay if needed
        });
    </script>
</body>
</html>
