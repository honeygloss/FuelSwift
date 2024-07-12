<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Staff Dashboard</title>
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
			            <h1 style="font-size: 33px; font-weight: bold; margin-bottom: 10px; margin-left: 10px;">249</h1>
			        </div>
			    </a>
			
			    <a href="#" id="reports-link" style="text-decoration: none; color: inherit;">
			        <div class="card" style="background-color: #ff6d00; height: 180px; width:345px;padding: 10px;">
			            <div class="card-inner" style="font-size: 15px; font-weight: bold;">
			                <h3 style="font-size: 18px; font-weight: bold; margin-top: 10px; margin-left: 10px;margin-bottom: 5px;">REPORTS</h3>
			                <span class="material-icons-outlined" style="font-size: 40px; margin-right: 15px;">category</span>
			            </div>
			            <h1 style="font-size: 33px; font-weight: bold; margin-bottom: 10px; margin-left: 10px;">25</h1>
			        </div>
			    </a>
			
			    <a href="#" id="customers-link" style="text-decoration: none; color: inherit;">
			        <div class="card single-card" style="background-color: #2e7d32; height: 180px; width:345px;padding: 10px;">
			            <div class="card-inner" style="font-size: 15px; font-weight: bold;">
			                <h3 style="font-size: 18px; font-weight: bold; margin-top: 10px; margin-left: 10px;margin-bottom: 5px;">CUSTOMERS</h3>
			                <span class="material-icons-outlined" style="font-size: 40px; margin-right: 15px;">groups</span>
			            </div>
			            <h1 style="font-size: 33px; font-weight: bold; margin-bottom: 10px; margin-left: 10px;">1500</h1>
			        </div>
			    </a>
			</div>
            <!-- End Cards Section -->
			        
			   
		    
		    <div id="transactions" class="main-content" style="display: none;">
            <h1 style="text-align: center; font-weight: bold; color: yellow; font-size:30px; margin-top:20px; margin-bottom:40px;">View Transactions</h1>
        
        
        <!-- Transaction Table -->
        <table class="table table-dark table-striped">
            <thead>
                <tr>
                    <th>Transaction ID</th>
                    <th>Date</th>
                    <th>Petrol Station</th>
                    <th>Amount</th>
                    <!-- Add more columns as needed -->
                </tr>
            </thead>
            <tbody>
                <!-- Example rows, replace with JSP code to dynamically populate -->
                <tr>
                    <td>1</td>
                    <td>2024-07-15</td>
                    <td>John Doe</td>
                    <td>RM 100.00</td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>2024-07-14</td>
                    <td>Jane Smith</td>
                    <td>RM 50.00</td>
                </tr>
                <!-- Add more rows dynamically -->
            </tbody>
        </table>
        </div>

        <!-- Customers Content -->
        <div id="customers" class="main-content" style="display: none;">
            <h1 style="text-align: center; font-weight: bold; color: yellow; font-size:30px; margin-top:20px; margin-bottom:40px;">View Customers</h1>
            <!-- Transaction Table -->
        <table class="table table-dark table-striped">
            <thead>
                <tr>
                	<th>No</th>
                    <th>Email</th>
                    <th>Customer Name</th>
                    <th>Gender</th>
                    <th>Points</th>
                    <!-- Add more columns as needed -->
                </tr>
            </thead>
            <tbody>
                <!-- Example rows, replace with JSP code to dynamically populate -->
                <tr>
                    <td>1</td>
                    <td>2024-07-15</td>
                    <td>John Doe</td>
                    <td>RM 100.00</td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>2024-07-14</td>
                    <td>Jane Smith</td>
                    <td>RM 50.00</td>
                </tr>
                <!-- Add more rows dynamically -->
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
    }

	    document.getElementById('customers-link').addEventListener('click', showCustomers);
	    document.getElementById('transaction-link').addEventListener('click', showTransactions);
	    document.getElementById('reports-link').addEventListener('click', showReports);
        // SIDEBAR TOGGLE

        // ---------- CHARTS ----------

        // BAR CHART
        const barChartOptions = {
          series: [
            {
              data: [10, 8, 6, 4, 2],
              name: 'Products',
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
            categories: ['Laptop', 'Phone', 'Monitor', 'Headphones', 'Camera'],
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

        // AREA CHART
        // LINE CHART (Single Series)
		const lineChartOptions = {
		  series: [
		    {
		      name: 'Purchase Orders',
		      data: [31, 40, 28, 51, 42, 109, 100], // Data for Purchase Orders
		    },
		  ],
		  chart: {
		    type: 'line', // Change type to 'line'
		    background: 'transparent',
		    height: 350,
		    toolbar: {
		      show: false,
		    },
		  },
		  colors: ['#00ab57'], // Color for the line
		  labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
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
		      text: 'Purchase Orders',
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
        	  window.location.href = `/FuelSwift/Login/Login.jsp`;
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
          
    </script>
  </body>
</html>