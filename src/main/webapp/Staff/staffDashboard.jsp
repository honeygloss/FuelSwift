<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*, Customer.Customer"%>
    
<%
	    String staffName = (String)session.getAttribute("staffName");
		String noTransString = (String)session.getAttribute("noTransaction");	// Number of transactions
		
		int noTrans = 0;
		if (noTransString != null && ! noTransString.isEmpty()) {
            try {
            	noTrans = Integer.parseInt(noTransString);		
            } catch (NumberFormatException e) {
                // Handle parsing error if necessary
                e.printStackTrace();
            }
        }
		
		String noCustString =  (String)session.getAttribute("noCust");	// Number of customers
		
		int noCust = 0;
		if (noCustString != null && ! noCustString.isEmpty()) {
            try {
            	noCust = Integer.parseInt(noCustString);		
            } catch (NumberFormatException e) {
                // Handle parsing error if necessary
                e.printStackTrace();
            }
        }
		ArrayList<Customer> cust = (ArrayList<Customer>) session.getAttribute("customers");
		ArrayList<String> transId = (ArrayList<String>) session.getAttribute("transId");
		ArrayList<String> custName = (ArrayList<String>) session.getAttribute("custName");
		ArrayList<String> date = (ArrayList<String>) session.getAttribute("date");
		ArrayList<String> time = (ArrayList<String>) session.getAttribute("time");
		ArrayList<String> petrolStation = (ArrayList<String>) session.getAttribute("petrolStation");
		ArrayList<String> totalAmt = (ArrayList<String>) session.getAttribute("totalAmt");
		
		ArrayList<String> pumpStation = (ArrayList<String>) session.getAttribute("pumpStation");
	    ArrayList<Integer> countPump = (ArrayList<Integer>) session.getAttribute("countPump");
	    
	    
	    ArrayList<Integer> totalAmount = (ArrayList<Integer>) session.getAttribute("totalAmount");
	    ArrayList<String> dateTransaction = (ArrayList<String>) session.getAttribute("dateTransaction");
	%>    
    
    
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Staff Dashboard | FuelSwift</title>
    <!-- Montserrat Font -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
    
    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet">

    <style>
        @charset "UTF-8";

        body {
            margin: 0;
            padding: 0;
            background-color: #121265;
            color: #9e9ea4;
            font-family: 'Montserrat', sans-serif;
        }

        .material-icons-outlined {
            vertical-align: middle;
            line-height: 1px;
            font-size: 35px;
        }

        .grid-container {
            display: grid;
            grid-template-columns: 260px 1fr 1fr 1fr;
            grid-template-rows: 0.2fr 3fr;
            grid-template-areas:
                'sidebar header header header'
                'sidebar main main main';
            height: 100vh;
        }

        /* ---------- HEADER ---------- */
        .header {
            grid-area: header;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 30px 0 30px;
            box-shadow: 0 6px 7px -3px rgba(0, 0, 0, 0.35);
        }

        .menu-icon {
            display: none;
        }

        /* ---------- SIDEBAR ---------- */

        #sidebar {
            grid-area: sidebar;
            height: 100%;
            background-color: rgb(20, 36, 105);
            overflow-y: auto;
            transition: all 0.5s;
            -webkit-transition: all 0.5s;
        }

        .sidebar-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 30px 30px 30px 30px;
            margin-bottom: 30px;
        }

        .sidebar-title > span {
            display: none;
        }

        .sidebar-brand {
            margin-top: 15px;
            font-size: 20px;
            font-weight: 700;
        }

        .sidebar-list {
            padding: 0;
            margin-top: 15px;
            list-style-type: none;
        }

        .sidebar-list-item {
            padding: 20px 20px 20px 20px;
            font-size: 18px;
        }

        .sidebar-list-item:hover {
            background-color: rgba(255, 255, 255, 0.2);
            cursor: pointer;
        }

        .sidebar-list-item > a {
            text-decoration: none;
            color: #9e9ea4;
        }

        .sidebar-responsive {
            display: inline !important;
            position: absolute;
            z-index: 12 !important;
        }

        /* ---------- MAIN ---------- */

        .main-container {
            grid-area: main;
            overflow-y: auto;
            padding: 20px 20px;
            color: rgba(255, 255, 255, 0.95);
        }

        .main-title {
            display: flex;
            justify-content: space-between;
        }

        .main-cards {
		    display: grid;
		    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); /* Adjust width of cards */
		    gap: 20px;
		    margin: 20px 0;
		}

        .card {
		        display: flex;
		        flex-direction: column;
		        justify-content: space-around;
		        padding: 25px;
		        border-radius: 5px;
		    }
		
		    .card.single-card {
		        grid-column: span 2; /* Spanning across two columns */
		    }
		
		    .card:nth-child(1) {
		        background-color: #2962ff;
		    }
		
		    .card:nth-child(2) {
		        background-color: #ff6d00;
		    }
		
		    .card:nth-child(3) {
		        background-color: #2e7d32;
		    }
		
		    .card-inner {
		        display: flex;
		        align-items: center;
		        justify-content: space-between;
		    }
		
		    .card-inner > .material-icons-outlined {
		        font-size: 45px;
		    }

        .charts {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 60px;
        }

        .charts-card {
            background-color: #263043;
            margin-bottom: 20px;
            padding: 25px;
            box-sizing: border-box;
            -webkit-column-break-inside: avoid;
            border-radius: 5px;
            box-shadow: 0 6px 7px -4px rgba(0, 0, 0, 0.2);
        }

        .chart-title {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* ---------- MEDIA QUERIES ---------- */

        /* Medium <= 992px */
        @media screen and (max-width: 992px) {
            .grid-container {
                grid-template-columns: 1fr;
                grid-template-rows: 0.2fr 3fr;
                grid-template-areas:
                    'header'
                    'main';
            }

            #sidebar {
                display: none;
            }

            .menu-icon {
                display: inline;
            }

            .sidebar-title > span {
                display: inline;
            }
        }

        /* Small <= 768px */
        @media screen and (max-width: 768px) {
            .main-cards {
                grid-template-columns: 1fr;
                gap: 10px;
                margin-bottom: 0;
            }

            .charts {
                grid-template-columns: 1fr;
                margin-top: 30px;
            }
        }

        /* Extra Small <= 576px */
        @media screen and (max-width: 576px) {
            .hedaer-left {
                display: none;
            }
        }
        
        .account-button {
		    cursor: pointer; /* Change cursor to pointer on hover */
		}
		
		.account-button:hover {
		    color: #3366cc; /* Change text color on hover to indicate interactivity */
		}
        .account-dropdown {
		    display: none;
		    position: absolute;
		    background-color: white;
		    min-width: 160px;
		    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
		    z-index: 1;
		    right: 40px;
		    top: 52px;
		  }
		
		  .account-dropdown ul {
		    list-style-type: none;
		    padding: 0;
		    margin: 0;
		  }
		
		  .account-dropdown ul li a {
		    display: block;
		    padding: 12px 16px;
		    text-decoration: none;
		    color: black;
		  }
		
		  .account-dropdown ul li a:hover {
		    background-color: #D9D9DC;
		  }
		
		  .account-dropdown.show {
		    display: block;
		  }
		  
		  .search-icon {
		    cursor: pointer; /* Change cursor to pointer on hover */
		}
		
		.search-container {
		    position: relative;
		}
		
		.search-dropdown {
		    display: none;
		    position: absolute;
		    top: calc(100% + 5px); /* Adjust distance below the search icon */
		    left: 10px;
		    background-color: white;
		    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
		    z-index: 1;
		    min-width: 160px;
		}
		
		.search-dropdown input[type="text"] {
		    width: 100%;
		    box-sizing: border-box;
		    padding: 10px;
		    border: 1px solid #ccc;
		    border-radius: 4px;
		    margin-bottom: 8px;
		}
		
		.search-dropdown ul {
		    list-style-type: none;
		    padding: 0;
		    margin: 0;
		}
		
		.search-dropdown ul li a {
		    display: block;
		    padding: 12px 16px;
		    text-decoration: none;
		    color: black;
		}
		
		.search-dropdown ul li a:hover {
		    background-color: #f1f1f1;
		}
		table {
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            text-align: center;
            padding: 10px;
        }
        .sidebar-list-item.active {
		  background-color: rgba(255, 255, 255, 0.2); /* Active state background color */
		}
		  
		  
    </style>
  </head>
  <body>
    <div class="grid-container">

      <!-- Header -->
      <header class="header">
        <div class="menu-icon" onclick="openSidebar()">
          <span class="material-icons-outlined">menu</span>
        </div>
        <div class="header-left">
		    <div class="search-container">
		        <span id="search-icon" class="material-icons-outlined search-icon" onclick="toggleSearch()">search</span>
		        <div id="search-dropdown" class="search-dropdown">
		            <input type="text" id="search-input" oninput="filterDropdown()" placeholder="Search...">
		            <ul id="search-list">
		                <li><a href="#" onclick="showTransactions(event);">Transactions</a></li>
		                <li><a href="#" onclick="showCustomers(event);">Customers</a></li>
		                <li><a href="#" onclick="showReports(event);">Reports</a></li>
		            </ul>
		        </div>
		    </div>
		</div>

        <div class="header-right">
        	<span style="margin-right:8px";><%=staffName %></span>
		    <span id="account-button" class="material-icons-outlined account-button" onclick="toggleDropdown()">account_circle</span>
		    <div id="account-dropdown" class="account-dropdown">
		      <ul>
		        <li><a href="#" onclick="logout()">Logout</a></li>
		      </ul>
		    </div>
		  </div>
		</header>
      <!-- End Header -->

      <!-- Sidebar -->
      <aside id="sidebar">
        <div class="sidebar-title">
          <div class="sidebar-brand">
            <a class="navbar-brand" href="#"onclick="window.location.reload();">
			    <img src="logo1.png" alt="Logo" width="50" height="45" style="vertical-align: middle; border-radius: 50%; margin-right: 8px; margin-top: -5px;">
			    <p style="margin: 0; font-weight: bold; color: yellow; font-size: 12px; margin-top:2px;">FuelSwift</p>
			</a>
          </div>
        </div>

        <ul class="sidebar-list">
          <li class="sidebar-list-item">
            <a href="#" id="dashboardSide" onclick="window.location.reload();">
              <span class="material-icons-outlined">dashboard</span> Dashboard
            </a>
          </li>
          <li id="transactionsSide" class="sidebar-list-item">
            <a href="#" onclick="showTransactions(event);">
              <span class="material-icons-outlined">inventory_2</span> Transactions
            </a>
          </li>
          <li id="custSide" class="sidebar-list-item">
            <a href="#" onclick="showCustomers(event);">
              <span class="material-icons-outlined">groups</span> Customers
            </a>
          </li>
          <li id="reportSide" class="sidebar-list-item">
            <a href="#" onclick="showReports(event);">
              <span class="material-icons-outlined">poll</span> Reports
            </a>
          </li>
        </ul>
      </aside>
      <!-- End Sidebar -->
      
		<!-- Start main -->
		    <main class="main-container">
		    <div id=mainTitle class="main-title">
		        <h2 style="font-weight:bold; font-size:22px; margin-top: 15px; margin-bottom:40px;">DASHBOARD</h2>
		    </div>
		
			<!-- Cards Section -->
			<div id="mainCards" class="main-cards">
			    <a href="#" id="transaction-link" style="text-decoration: none; color: inherit;">
			        <div class="card" style="background-color: red; height: 180px; width:345px;padding: 10px;">
			            <div class="card-inner">
			                <h3 style="font-size: 18px; font-weight: bold; margin-top: 10px; margin-left: 10px;margin-bottom: 5px;">TRANSACTIONS</h3>
			                <span class="material-icons-outlined" style="font-size: 40px; margin-right: 15px;">inventory_2</span>
			            </div>
			            <h1 style="font-size: 33px; font-weight: bold; margin-bottom: 10px; margin-left: 10px;"><%=noTrans %></h1>
			        </div>
			    </a>
			
			    <a href="#" id="reports-link" style="text-decoration: none; color: inherit;">
			        <div class="card" style="background-color: #ff6d00; height: 180px; width:345px;padding: 10px;">
			            <div class="card-inner" style="font-size: 15px; font-weight: bold;">
			                <h3 style="font-size: 18px; font-weight: bold; margin-top: 10px; margin-left: 10px;margin-bottom: 5px;">REPORTS</h3>
			                <span class="material-icons-outlined" style="font-size: 40px; margin-right: 15px;">category</span>
			            </div>
			            <h1 style="font-size: 33px; font-weight: bold; margin-bottom: 10px; margin-left: 10px;">2</h1>
			        </div>
			    </a>
			
			    <a href="#" id="customers-link" style="text-decoration: none; color: inherit;">
			        <div class="card single-card" style="background-color: #2e7d32; height: 180px; width:345px;padding: 10px;">
			            <div class="card-inner" style="font-size: 15px; font-weight: bold;">
			                <h3 style="font-size: 18px; font-weight: bold; margin-top: 10px; margin-left: 10px;margin-bottom: 5px;">CUSTOMERS</h3>
			                <span class="material-icons-outlined" style="font-size: 40px; margin-right: 15px;">groups</span>
			            </div>
			            <h1 style="font-size: 33px; font-weight: bold; margin-bottom: 10px; margin-left: 10px;"><%=noCust %></h1>
			        </div>
			    </a>
			</div>
            <!-- End Cards Section -->
			        
			   
		    
	    <div id="transactions" class="main-content" style="display: none;">
           <h1 style="text-align: center; font-weight: bold; color: yellow; font-size:30px; margin-top:20px; margin-bottom:40px;">View Transactions</h1>
	        
	        <div class="dropdown mb-3">
			    <label for="sortOption" style="margin-right: 10px; margin-bottom: 10px; font-size: 18px;">Find:</label>
			    <div class="input-group mb-3" style="width: 500px; margin-bottom: 15px;">
			        <input type="text" class="form-control" id="transactionSortOption" name="sortOption" oninput="filterTransactionTable()" placeholder="Search customer name...">
			        <div class="input-group-append">
			            <button class="btn btn-secondary" type="button">Search</button>
			        </div>
			    </div>
			</div>
	        <!-- Transaction Table -->
			<table id="transactionTable" class="table table-dark table-striped">
			    <thead>
			        <tr>
			            <th>Transaction ID</th>
			            <th>Name</th>
			            <th>Date</th>
			            <th>Time</th>
			            <th>Petrol Station</th>
			            <th>Total Payment</th>
			        </tr>
			    </thead>
			    <tbody>
			        <% 
			            // Iterate over the lists (assuming all lists have the same size)
			            if (transId != null && !transId.isEmpty()) {
			                for (int i = 0; i < transId.size(); i++) {
			        %>
			        <tr>
			            <td><%= transId.get(i) %></td>
			            <td><%= custName.get(i) %></td>
			            <td><%= date.get(i) %></td>
			            <td><%= time.get(i) %></td>
			            <td><%= petrolStation.get(i) %></td>
			            <td>RM <%= totalAmt.get(i) %></td>
			        </tr>
			        <% 
			                }
			            }
			        %>
			    </tbody>
			</table>
        </div>

        <!-- Customers Content -->
        <div id="customers" class="main-content" style="display: none;">
            <h1 style="text-align: center; font-weight: bold; color: yellow; font-size:30px; margin-top:20px; margin-bottom:40px;">View Customers</h1>
        
        <div class="dropdown mb-3">
			    <label for="sortOption" style="margin-right: 10px; margin-bottom: 10px; font-size: 18px;">Find:</label>
			    <div class="input-group mb-3" style="width: 500px; margin-bottom: 15px;">
			        <input type="text" class="form-control" id="customerSortOption" name="sortOption" oninput="filterCustomerTable()" placeholder="Search customer name...">
			        <div class="input-group-append">
			            <button class="btn btn-secondary" type="button">Search</button>
			        </div>
			    </div>
			</div>
			<!-- Customer Table -->
			<table id="customerTable" class="table table-dark table-striped">
			    <thead>
			        <tr>
			            <th>No</th>
			            <th>Email</th>
			            <th>Customer Name</th>
			            <th>Gender</th>
			            <th>Points</th>
			        </tr>
			    </thead>
			    <tbody>
			        <% 
			            // Iterate over the ArrayList<Customer> cust
			            if (cust != null && !cust.isEmpty()) {
			                int count = 1; // Initialize count variable to 1
			                for (Customer customer : cust) {
			        %>
			        <tr>
			            <td><%= count++ %></td>
			            <td><%= customer.getEmail() %></td>
			            <td><%= customer.getName() %></td>
			            <td><%= customer.getGender() %></td>
			            <td><%= customer.getPoints() %></td>
			        </tr>
			        <% 
			                }
			            }
			        %>
			    </tbody>
			</table>
        </div>

        <!-- Reports Content -->
        <div id="reports" class="main-content" style="display: none;">
            <h1 style="text-align: center; font-weight: bold; color: yellow; font-size:30px; margin-top:20px; margin-bottom:40px;">Sales Report</h1>
            <div class="charts">

          <div class="charts-card">
            <h2 class="chart-title">Top 5 Pump Station</h2>
            <div id="bar-chart"></div>
          </div>

          <div class="charts-card">
            <h2 class="chart-title">Purchase and Sales Orders</h2>
            <div id="line-chart"></div>
          </div>

        </div>
        </div>
		</main>
    </div>

    <!-- Scripts -->
    <!-- ApexCharts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/apexcharts/3.35.5/apexcharts.min.js"></script>
    <!-- Custom JS -->
    <script>
    
    let sidebarOpen = false;
    const sidebar = document.getElementById('sidebar');

    function openSidebar() {
      if (!sidebarOpen) {
        sidebar.classList.add('sidebar-responsive');
        sidebarOpen = true;
      }
    }

    function closeSidebar() {
      if (sidebarOpen) {
        sidebar.classList.remove('sidebar-responsive');
        sidebarOpen = false;
      }
    }
    
 // Close dropdowns if clicked outside
    window.onclick = function(event) {
        // Check if clicked target is not within search icon or search dropdown
        if (!event.target.matches('.search-icon') && !event.target.closest('.search-dropdown')) {
            var dropdowns = document.getElementsByClassName("search-dropdown");
            for (var i = 0; i <   dropdowns.length; i++) {
                var openDropdown = dropdowns[i];
                if (openDropdown.style.display === "block") {
                    openDropdown.style.display = "none";
                }
            }
        }

        // Check if clicked target is not within account button or account dropdown
        if (!event.target.matches('.account-button') && !event.target.closest('.account-dropdown')) {
            var accountDropdowns = document.getElementsByClassName("account-dropdown");
            for (var j = 0; j < accountDropdowns.length; j++) {
                var openAccountDropdown = accountDropdowns[j];
                if (openAccountDropdown.classList.contains('show')) {
                    openAccountDropdown.classList.remove('show');
                }
            }
        }
    }
    
    function showCustomers(e) {
        e.preventDefault();
        document.getElementById('customers').style.display = 'block';
        document.getElementById('transactions').style.display = 'none';
        document.getElementById('reports').style.display = 'none';
        document.getElementById('mainCards').style.display = 'none';
        document.getElementById('mainTitle').style.display = 'none';
        document.getElementById('custSide').style.backgroundColor = 'rgba(255, 255, 255, 0.2)';
        document.getElementById('transactionsSide').style.backgroundColor = 'rgb(20, 36, 105)';
        document.getElementById('reportSide').style.backgroundColor = 'rgb(20, 36, 105)';
        
        var dropdown = document.getElementById("search-dropdown");
	    dropdown.style.display = dropdown.style.display === "block" ? "none" : "block";
	    
	    closeSidebar();
    }

    function showTransactions(e) {
        e.preventDefault();
        document.getElementById('transactions').style.display = 'block';
        document.getElementById('customers').style.display = 'none';
        document.getElementById('reports').style.display = 'none';
        document.getElementById('mainCards').style.display = 'none';
        document.getElementById('mainTitle').style.display = 'none';
        document.getElementById('transactionsSide').style.backgroundColor = 'rgba(255, 255, 255, 0.2)';
        document.getElementById('reportSide').style.backgroundColor = 'rgb(20, 36, 105)';
        document.getElementById('custSide').style.backgroundColor = 'rgb(20, 36, 105)';
        
        var dropdown = document.getElementById("search-dropdown");
	    dropdown.style.display = dropdown.style.display === "block" ? "none" : "block";
	    
	    closeSidebar();
    }

    function showReports(e) {
        e.preventDefault();
        document.getElementById('reports').style.display = 'block';
        document.getElementById('customers').style.display = 'none';
        document.getElementById('transactions').style.display = 'none';
        document.getElementById('mainCards').style.display = 'none';
        document.getElementById('mainTitle').style.display = 'none';
        document.getElementById('reportSide').style.backgroundColor = 'rgba(255, 255, 255, 0.2)';
        document.getElementById('transactionsSide').style.backgroundColor = 'rgb(20, 36, 105)';
        document.getElementById('custSide').style.backgroundColor = 'rgb(20, 36, 105)';

        var dropdown = document.getElementById("search-dropdown");
	    dropdown.style.display = dropdown.style.display === "block" ? "none" : "block";
	    
	    closeSidebar();
    }

	    document.getElementById('customers-link').addEventListener('click', showCustomers);
	    document.getElementById('transaction-link').addEventListener('click', showTransactions);
	    document.getElementById('reports-link').addEventListener('click', showReports);
      

        // ---------- CHARTS ----------
        
        // BAR CHART
	    
	    const barChartOptions = {
	      series: [
	        {
	          data:  <%=countPump%>, // Assigning countPump data to series data
	          name: 'Pump Station',
	        },
	      ],
	      chart: {
	        type: 'bar',
	        background: 'transparent',
	        height: 350,
	        toolbar: {
	          show: false,
	        },
	      },
	      colors: ['#2962ff', '#d50000', '#2e7d32', '#ff6d00', '#583cb3'],
	      plotOptions: {
	        bar: {
	          distributed: true,
	          borderRadius: 4,
	          horizontal: false,
	          columnWidth: '40%',
	        },
	      },
	      dataLabels: {
	        enabled: false,
	      },
	      fill: {
	        opacity: 1,
	      },
	      grid: {
	        borderColor: '#55596e',
	        yaxis: {
	          lines: {
	            show: true,
	          },
	        },
	        xaxis: {
	          lines: {
	            show: true,
	          },
	        },
	      },
	      legend: {
	        labels: {
	          colors: '#f5f7ff',
	        },
	        show: true,
	        position: 'top',
	      },
	      stroke: {
	        colors: ['transparent'],
	        show: true,
	        width: 2,
	      },
	      tooltip: {
	        shared: true,
	        intersect: false,
	        theme: 'dark',
	      },
	      xaxis: {
	        categories:  <%=pumpStation%>, // Assigning pumpStation categories (x-axis labels)
	        title: {
	          style: {
	            color: '#f5f7ff',
	          },
	        },
	        axisBorder: {
	          show: true,
	          color: '#55596e',
	        },
	        axisTicks: {
	          show: true,
	          color: '#55596e',
	        },
	        labels: {
	          style: {
	            colors: '#f5f7ff',
	          },
	        },
	      },
	      yaxis: {
	        title: {
	          text: 'Count',
	          style: {
	            color: '#f5f7ff',
	          },
	        },
	        axisBorder: {
	          color: '#55596e',
	          show: true,
	        },
	        axisTicks: {
	          color: '#55596e',
	          show: true,
	        },
	        labels: {
	          style: {
	            colors: '#f5f7ff',
	          },
	        },
	      },
	    };
	
	    const barChart = new ApexCharts(
	      document.querySelector('#bar-chart'),
	      barChartOptions
	    );
	    barChart.render();

	    const lineChartOptions = {
    		  series: [
    		    {
    		      name: 'Sales Orders',
    		      data: <%= totalAmount %>, // Data for Sales Orders (totalAmount)
    		    },
    		  ],
    		  chart: {
    		    type: 'line',
    		    background: 'transparent',
    		    height: 350,
    		    toolbar: {
    		      show: false,
    		    },
    		  },
    		  colors: ['#00ab57'],
    		  labels: <%= dateTransaction %>, // Labels for x-axis (dateTransaction)
    		  markers: {
    		    size: 6,
    		    strokeColors: '#1b2635',
    		    strokeWidth: 3,
    		  },
    		  stroke: {
    		    curve: 'smooth',
    		  },
    		  xaxis: {
    		    axisBorder: {
    		      color: '#55596e',
    		      show: true,
    		    },
    		    axisTicks: {
    		      color: '#55596e',
    		      show: true,
    		    },
    		    labels: {
    		      offsetY: 5,
    		      style: {
    		        colors: '#f5f7ff',
    		      },
    		    },
    		  },
    		  yaxis: {
    		    title: {
    		      text: 'Sales Orders',
    		      style: {
    		        color: '#f5f7ff',
    		      },
    		    },
    		    labels: {
    		      style: {
    		        colors: ['#f5f7ff'],
    		      },
    		    },
    		  },
    		  tooltip: {
    		    shared: true,
    		    intersect: false,
    		    theme: 'dark',
    		  },
    		};

    		const lineChart = new ApexCharts(
    		  document.querySelector('#line-chart'),
    		  lineChartOptions
    		);
    		lineChart.render();

        
        function toggleDropdown() {
            var dropdown = document.getElementById("account-dropdown");
            dropdown.classList.toggle("show");
          }

          function logout() {
        	  window.location.href = `Login.jsp`;
          }
          
          function toggleSearch() {
        	    var dropdown = document.getElementById("search-dropdown");
        	    dropdown.style.display = dropdown.style.display === "block" ? "none" : "block";
        	}
          
          
       // Filter dropdown items based on user input
          function filterDropdown() {
              var input, filter, ul, li, a, i;
              input = document.getElementById("search-input");
              filter = input.value.toUpperCase();
              ul = document.getElementById("search-list");
              li = ul.getElementsByTagName("li");

              for (i = 0; i < li.length; i++) {
                  a = li[i].getElementsByTagName("a")[0];
                  if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
                      li[i].style.display = "";
                  } else {
                      li[i].style.display = "none";
                  }
              }
          }
       
          function filterTransactionTable() {
              var input, filter, table, tr, td, i, txtValue;
              input = document.getElementById("transactionSortOption");
              filter = input.value.toUpperCase();
              table = document.getElementById("transactionTable");
              tr = table.getElementsByTagName("tr");

              console.log(`Filtering transaction table rows for: ${filter}`);

              for (i = 0; i < tr.length; i++) {
                  td = tr[i].getElementsByTagName("td")[1]; // Column 2 for transactionTable
                  if (td) {
                      txtValue = td.textContent || td.innerText;
                      console.log(txtValue);
                      if (txtValue.toUpperCase().indexOf(filter) > -1) {
                          tr[i].style.display = "";
                      } else {
                          tr[i].style.display = "none";
                      }
                  }
              }
          }

          function filterCustomerTable() {
              var input, filter, table, tr, td, i, txtValue;
              input = document.getElementById("customerSortOption");
              filter = input.value.toUpperCase();
              table = document.getElementById("customerTable");
              tr = table.getElementsByTagName("tr");

              console.log(`Filtering customer table rows for: ${filter}`);

              for (i = 0; i < tr.length; i++) {
                  td = tr[i].getElementsByTagName("td")[2]; // Column 3 for customerTable
                  if (td) {
                      txtValue = td.textContent || td.innerText;
                      console.log(txtValue);
                      if (txtValue.toUpperCase().indexOf(filter) > -1) {
                          tr[i].style.display = "";
                      } else {
                          tr[i].style.display = "none";
                      }
                  }
              }
          }

          
    </script>
  </body>
</html>