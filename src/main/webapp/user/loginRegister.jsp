<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login and Register</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <!-- MDB -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.0.1/mdb.min.css">
    
    <style>
        body {
            background: linear-gradient(120deg, #7f7fd5, #86a8e7, #91eae4);
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
        }
        .auth-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(4px);
            overflow: hidden;
        }
        .nav-tabs .nav-link {
            transition: all 0.3s ease;
            border: none !important;
            font-weight: 500;
        }
        .nav-tabs .nav-link.active {
            background: linear-gradient(45deg, #667eea, #764ba2) !important;
            color: white !important;
            border-radius: 10px;
        }
        .form-outline input:focus ~ .form-notch .form-notch-leading {
            border-color: #667eea !important;
        }
        .form-outline input:focus ~ .form-notch .form-notch-middle {
            border-color: #667eea !important;
        }
        .form-outline input:focus ~ .form-notch .form-notch-trailing {
            border-color: #667eea !important;
        }
        .animated-label {
            transition: all 0.3s ease;
        }
    </style>
</head>
<body class="d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="auth-card p-4">
                    <!-- Tabs Navigation -->
                    <ul class="nav nav-pills justify-content-center mb-5" id="authTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active rounded-pill mx-1" id="login-tab" data-mdb-toggle="tab"
                                data-mdb-target="#login" type="button" role="tab" aria-controls="login"
                                aria-selected="true">
                                <i class="fas fa-sign-in-alt me-2"></i>Login
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link rounded-pill mx-1" id="register-tab" data-mdb-toggle="tab"
                                data-mdb-target="#register" type="button" role="tab" aria-controls="register"
                                aria-selected="false">
                                <i class="fas fa-user-plus me-2"></i>Register
                            </button>
                        </li>
                    </ul>

                    <!-- Tabs Content -->
                    <div class="tab-content" id="authTabsContent">
                        <!-- Login Tab -->
                        <div class="tab-pane fade show active" id="login" role="tabpanel" aria-labelledby="login-tab">
                            <form action="${pageContext.request.contextPath}/LoginUser" method="post">
                                <!-- Email input -->
                                <div class="form-outline mb-4">
                                    <input type="email" id="loginEmail" name="email" class="form-control form-control-lg"
                                        required />
                                    <label class="form-label" for="email">
                                        <i class="fas fa-envelope me-2"></i>Email address
                                    </label>
                                </div>

                                <!-- Password input -->
                                <div class="form-outline mb-4">
                                    <input type="password" id="password1" name="password1"
                                        class="form-control form-control-lg" required />
                                    <label class="form-label" for="password1">
                                        <i class="fas fa-lock me-2"></i>Password
                                    </label>
                                </div>

                                <button type="submit" class="btn btn-primary btn-lg btn-block rounded-pill mb-4">
                                    Sign in <i class="fas fa-arrow-right ms-2"></i>
                                </button>
                            </form>
                            	<!-- Display Error Message -->
						        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
						        <% if (errorMessage != null) { %>
						            <div class="alert alert-danger" role="alert"><%= errorMessage %></div>
						        <% } %>
                        </div>

                        <!-- Register Tab -->
                        <div class="tab-pane fade" id="register" role="tabpanel" aria-labelledby="register-tab">
                            <form action="${pageContext.request.contextPath}/RegisterUser" method="post">
                                <div class="row">
                                    <div class="col-md-6 mb-4">
                                        <div class="form-outline">
                                            <input type="text" id="firstname" name="firstname"
                                                class="form-control form-control-lg" required />
                                            <label class="form-label" for="firstname">
                                                <i class="fas fa-user me-2"></i>First Name
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-4">
                                        <div class="form-outline">
                                            <input type="text" id="lastname" name="lastname"
                                                class="form-control form-control-lg" required />
                                            <label class="form-label" for="lastname">
                                                <i class="fas fa-user-tag me-2"></i>Last Name
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <!-- Phone input -->
                                <div class="form-outline mb-4">
                                    <input type="number" id="phone" min="0" name="phone" class="form-control form-control-lg"
                                        required pattern="[0-9]{10}"  />
                                    <label class="form-label" for="phone">
                                        <i class="fas fa-phone me-2"></i>Phone
                                    </label>
                                </div>
                                
                                <!-- Email input -->
                                <div class="form-outline mb-4">
                                    <input type="email" id="registerEmail" name="email" class="form-control form-control-lg"
                                        required />
                                    <label class="form-label" for="email">
                                        <i class="fas fa-envelope me-2"></i>Email address
                                    </label>
                                </div>

                                <!-- Password input -->
                                <div class="form-outline mb-4">
                                    <input type="password" id="password2" name="password2"
                                        class="form-control form-control-lg" required />
                                    <label class="form-label" for="password2">
                                        <i class="fas fa-lock me-2"></i>Password
                                    </label>
                                </div>

                                <!-- Security Question -->
                                <div class="form-outline mb-4">
                                    <select class="form-select form-control-lg" id="question" name="question" required>
                                        <option value="" disabled selected>Select your security question</option>
                                        <option>What city were you born in?</option>
                                        <option>What's your favorite book?</option>
                                        <option>What was your first pet's name?</option>
                                    </select>
                                    
                                    <label class="form-label" for="question">
								   		<i class="fas fa-shield-alt me-2"></i>Security Question
									</label>	
                                </div>

                                <!-- Cancel and Submit Buttons -->
						        <div class="d-flex justify-content-center gap-2 mt-4">
						            <input type="reset" 
						                  class="btn btn-outline-danger rounded-pill">
						            
						            <button type="submit" 
						                    class="btn btn-success rounded-pill">
						                <i class="fas fa-user-plus me-2"></i>Create Account
						            </button>
						        </div>
                            </form>
                           
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- MDBootstrap JS -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.0.1/mdb.min.js"></script>
    
    <script>
        // Add animation to form labels
       // document.querySelectorAll('.form-outline').forEach((formOutline) => {
       //     new mdb.Input(formOutline).init();
       // });

        // Add smooth tab switching
        //document.querySelectorAll('[data-mdb-toggle="tab"]').forEach((tab) => {
        //    tab.addEventListener('show.mdb.tab', (e) => {
       //         const activeTab = e.target;
       //         const previousTab = e.relatedTarget;
        //        activeTab.classList.add('scale-110');
         //       previousTab.classList.remove('scale-110');
          //  });
      //  });
    </script>
</body>
</html>