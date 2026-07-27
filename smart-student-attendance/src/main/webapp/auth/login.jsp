<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Campus Analytics & Student Monitoring Portal - Secure Enterprise Login">
    <title>Login | <c:out value="${portalName}" default="Campus Analytics & Student Monitoring Portal" /></title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #1e3c72;
            --secondary-blue: #2a5298;
            --accent-blue: #4facfe;
            --glass-bg: rgba(255, 255, 255, 0.88);
            --glass-border: rgba(255, 255, 255, 0.4);
            --text-dark: #2d3748;
            --text-muted: #718096;
            --success-color: #10b981;
            --error-color: #ef4444;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        html, body { height: 100%; margin: 0; }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            position: relative;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .floating-shape {
            position: fixed;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(2px);
            animation: float 20s infinite ease-in-out;
            z-index: 0;
            pointer-events: none;
        }
        .shape-1 { width: 300px; height: 300px; top: -50px; left: -50px; animation-delay: 0s; }
        .shape-2 { width: 200px; height: 200px; bottom: 10%; right: -50px; animation-delay: -5s; }
        .shape-3 { width: 150px; height: 150px; top: 40%; left: 20%; animation-delay: -10s; }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(10deg); }
        }

        .main-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 2rem;
            position: relative;
            z-index: 1;
            width: 100%;
        }

        .content-wrapper {
            display: flex;
            align-items: flex-start;
            justify-content: center;
            gap: 4rem;
            max-width: 1400px;
            width: 100%;
        }

        .left-section {
            flex: 1;
            max-width: 720px;
            color: white;
            animation: fadeInLeft 1s ease-out;
            padding-top: 1rem;
        }

        .brand-logo {
            font-size: 2rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            font-weight: 600;
        }

        .welcome-heading {
            font-size: 2.4rem;
            font-weight: 700;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .welcome-desc {
            font-size: 1.05rem;
            opacity: 0.9;
            margin-bottom: 3rem;
            font-weight: 300;
            line-height: 1.6;
        }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 16px;
            padding: 1.5rem;
            transition: all 0.3s ease;
            animation: fadeInUp 0.8s ease-out backwards;
        }

        .stat-card:nth-child(1) { animation-delay: 0.2s; }
        .stat-card:nth-child(2) { animation-delay: 0.4s; }
        .stat-card:nth-child(3) { animation-delay: 0.6s; }
        .stat-card:nth-child(4) { animation-delay: 0.8s; }

        .stat-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .stat-icon { font-size: 1.6rem; margin-bottom: 0.8rem; color: var(--accent-blue); }
        .stat-value { font-size: 1.7rem; font-weight: 700; margin-bottom: 0.2rem; }
        .stat-label { font-size: 0.85rem; opacity: 0.8; font-weight: 400; }

        .right-section {
            flex: 0 0 480px;
            max-width: 480px;
            width: 100%;
            animation: fadeInRight 1s ease-out;
        }

        .login-card {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.2);
        }

        .card-header-custom { text-align: center; margin-bottom: 2rem; }
        .card-header-custom h2 { color: var(--primary-blue); font-weight: 700; font-size: 1.4rem; margin-bottom: 0.5rem; line-height: 1.3; }
        .card-header-custom p { color: var(--text-muted); font-size: 0.85rem; line-height: 1.5; }

        .form-floating-custom {
            position: relative;
            margin-bottom: 1.5rem;
        }

        .form-floating-custom .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            z-index: 4;
            transition: color 0.3s ease;
            pointer-events: none;
        }

        .form-floating-custom .form-control {
            height: 56px;
            padding-left: 48px;
            padding-right: 48px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            background: rgba(255, 255, 255, 0.95);
            font-size: 0.95rem;
            color: var(--text-dark);
            transition: all 0.3s ease;
        }

        .form-floating-custom .form-control:focus {
            border-color: var(--secondary-blue);
            box-shadow: 0 0 0 4px rgba(42, 82, 152, 0.1);
            background: #fff;
        }

        .form-floating-custom .form-control:focus ~ .input-icon {
            color: var(--secondary-blue);
        }

        .form-floating-custom label {
            position: absolute;
            left: 48px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            pointer-events: none;
            transition: all 0.2s ease;
            background: transparent;
            padding: 0 4px;
            font-size: 0.95rem;
            opacity: 0;
            z-index: 5;
        }

        .form-floating-custom .form-control:focus ~ label,
        .form-floating-custom .form-control:not(:placeholder-shown) ~ label {
            top: 0;
            font-size: 0.75rem;
            color: var(--secondary-blue);
            background: rgba(255, 255, 255, 0.98);
            font-weight: 500;
            opacity: 1;
            transform: translateY(-50%);
        }

        .form-floating-custom .form-control:placeholder-shown:not(:focus) ~ label {
            opacity: 0;
        }

        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            cursor: pointer;
            z-index: 4;
            transition: color 0.3s ease;
            background: none;
            border: none;
            padding: 0;
        }

        .password-toggle:hover { color: var(--secondary-blue); }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }

        .form-check-input:checked {
            background-color: var(--secondary-blue);
            border-color: var(--secondary-blue);
        }

        .btn-login {
            width: 100%;
            height: 56px;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-login:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(42, 82, 152, 0.3);
        }

        .btn-login:disabled { opacity: 0.7; cursor: not-allowed; }
        .spinner-border { width: 1.2rem; height: 1.2rem; border-width: 0.15em; }

        .security-info {
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(0, 0, 0, 0.06);
            font-size: 0.75rem;
            color: var(--text-muted);
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
        }

        .security-info i { color: var(--success-color); margin-right: 4px; }

        .custom-alert {
            border-radius: 12px;
            border: none;
            padding: 0.9rem 1.2rem;
            font-size: 0.88rem;
            margin-bottom: 1.5rem;
            display: none;
            align-items: center;
            gap: 12px;
            animation: slideInDown 0.4s ease-out;
        }

        .custom-alert.show { display: flex; }
        .alert-error { background-color: #fef2f2; color: #991b1b; border-left: 4px solid var(--error-color); }
        .alert-success { background-color: #f0fdf4; color: #166534; border-left: 4px solid var(--success-color); }
        .alert-warning { background-color: #fffbeb; color: #92400e; border-left: 4px solid #f59e0b; }

        .footer {
            text-align: center;
            padding: 1.5rem 2rem;
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.85rem;
            position: relative;
            z-index: 1;
            flex-shrink: 0;
        }

        .footer a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            margin: 0 8px;
            transition: color 0.3s;
        }

        .footer a:hover { color: white; text-decoration: underline; }

        @keyframes fadeInLeft { from { opacity: 0; transform: translateX(-30px); } to { opacity: 1; transform: translateX(0); } }
        @keyframes fadeInRight { from { opacity: 0; transform: translateX(30px); } to { opacity: 1; transform: translateX(0); } }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes slideInDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        @media (max-width: 1100px) {
            .content-wrapper { flex-direction: column; align-items: center; gap: 2rem; }
            .left-section { display: none; }
            .right-section { flex: 0 0 auto; max-width: 480px; }
            .main-container { padding: 2rem 1rem; }
        }

        @media (max-width: 576px) {
            .right-section { flex: 0 0 auto; max-width: 100%; }
            .login-card { padding: 2rem 1.5rem; }
            .form-options { flex-direction: column; align-items: flex-start; gap: 1rem; }
            .security-info { flex-direction: column; text-align: center; }
            .welcome-heading { font-size: 1.8rem; }
        }
    </style>
</head>
<body>

    <div class="floating-shape shape-1"></div>
    <div class="floating-shape shape-2"></div>
    <div class="floating-shape shape-3"></div>

    <div class="main-container">
        <div class="content-wrapper">
            
            <!-- Left Section: Dynamic Statistics from Database -->
            <div class="left-section">
                <div class="brand-logo">
                    <i class="fas fa-university"></i>
                    <span><c:out value="${systemShortName}" default="Campus Analytics" /></span>
                </div>
                <h1 class="welcome-heading">Smart Student Attendance &<br>Academic Monitoring System</h1>
                <p class="welcome-desc">
                    Empowering educational institutions with real-time analytics, automated attendance tracking, and comprehensive performance monitoring in a single, secure platform.
                </p>

                <div class="stat-grid">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="fas fa-user-graduate"></i></div>
                        <div class="stat-value"><c:out value="${totalStudents}" default="0" /></div>
                        <div class="stat-label">Total Students</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon"><i class="fas fa-chalkboard-user"></i></div>
                        <div class="stat-value"><c:out value="${totalFaculty}" default="0" /></div>
                        <div class="stat-label">Total Faculty</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon"><i class="fas fa-clipboard-check"></i></div>
                        <div class="stat-value"><c:out value="${attendancePercentage}" default="0%" /></div>
                        <div class="stat-label">Attendance Records</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon"><i class="fas fa-book-open"></i></div>
                        <div class="stat-value">
						    <c:out value="${activeSubjects}" default="0" />
						</div>
						<div class="stat-label">Active Subjects</div>
                    </div>
                </div>
            </div>

            <!-- Right Section: Login Card -->
            <div class="right-section">
                <div class="login-card">
                    <div class="card-header-custom">
                        <h2><c:out value="${portalName}" default="Campus Analytics & Student Monitoring Portal" /></h2>
                        <p>Secure access to academic records, attendance tracking, and performance monitoring.</p>
                    </div>

                    <!-- Server-Side Alerts -->
                    <c:if test="${not empty errorMessage}">
                        <div class="custom-alert alert-error show">
                            <i class="fas fa-exclamation-circle"></i>
                            <span><c:out value="${errorMessage}" /></span>
                        </div>
                    </c:if>
                    <c:if test="${not empty successMessage}">
                        <div class="custom-alert alert-success show">
                            <i class="fas fa-check-circle"></i>
                            <span><c:out value="${successMessage}" /></span>
                        </div>
                    </c:if>
                    <c:if test="${not empty warningMessage}">
                        <div class="custom-alert alert-warning show">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span><c:out value="${warningMessage}" /></span>
                        </div>
                    </c:if>

                    <!-- Client-Side Validation Alert Container -->
                    <div id="clientAlert" class="custom-alert">
                        <i id="alertIcon" class="fas"></i>
                        <span id="alertMessage"></span>
                    </div>

                    <!-- Login Form -->
                    <form id="loginForm" action="${pageContext.request.contextPath}/login" method="POST" novalidate>
                        <input type="hidden" name="csrf_token" value="${csrfToken}">

                        <!-- Email Field -->
                        <div class="form-floating-custom">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" class="form-control" id="email" name="username" placeholder="Username / Email" required autocomplete="username">
                            <label for="email">Username / Email</label>
                            <div class="invalid-feedback">Please enter a valid university email address.</div>
                        </div>

                        <!-- Password Field -->
                        <div class="form-floating-custom">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Password" required autocomplete="current-password">
                            <label for="password">Password</label>
                            <button type="button" class="password-toggle" id="togglePassword" aria-label="Toggle password visibility">
                                <i class="fas fa-eye"></i>
                            </button>
                            <div class="invalid-feedback">Password is required.</div>
                        </div>

                        <div class="form-options">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                                <label class="form-check-label" for="rememberMe" style="color: var(--text-dark); cursor: pointer;">Remember Me</label>
                            </div>
                        </div>

                        <button type="submit" class="btn-login" id="loginBtn">
                            <span id="btnText">Sign In</span>
                            <span class="spinner-border spinner-border-sm d-none" id="btnSpinner" role="status" aria-hidden="true"></span>
                        </button>
                    </form>

                    <div class="security-info">
                        <span><i class="fas fa-shield-alt"></i> Secured by Enterprise Brute-Force Protection</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; ${currentYear} <c:out value="${universityName}" default="University Name" />. All rights reserved.</p>
        <div class="mt-2">
            <a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a> • 
            <a href="${pageContext.request.contextPath}/terms">Terms of Service</a> • 
            <a href="mailto:${supportEmail}">Contact IT Support</a>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const loginForm = document.getElementById('loginForm');
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const togglePassword = document.getElementById('togglePassword');
            const loginBtn = document.getElementById('loginBtn');
            const btnText = document.getElementById('btnText');
            const btnSpinner = document.getElementById('btnSpinner');
            const clientAlert = document.getElementById('clientAlert');
            const alertIcon = document.getElementById('alertIcon');
            const alertMessage = document.getElementById('alertMessage');

            // Password Visibility Toggle
            togglePassword.addEventListener('click', function() {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                const icon = this.querySelector('i');
                icon.classList.toggle('fa-eye');
                icon.classList.toggle('fa-eye-slash');
            });

            // Real-time Email Validation
            emailInput.addEventListener('input', function() {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                this.style.borderColor = (this.value && !emailRegex.test(this.value)) ? 'var(--error-color)' : '#e2e8f0';
            });

            // Client-side Alert Helper
            function showAlert(type, message) {
                clientAlert.className = 'custom-alert show';
                if (type === 'error') { clientAlert.classList.add('alert-error'); alertIcon.className = 'fas fa-exclamation-circle'; }
                else if (type === 'success') { clientAlert.classList.add('alert-success'); alertIcon.className = 'fas fa-check-circle'; }
                else if (type === 'warning') { clientAlert.classList.add('alert-warning'); alertIcon.className = 'fas fa-exclamation-triangle'; }
                alertMessage.textContent = message;
                setTimeout(() => { clientAlert.classList.remove('show'); }, 3000);
            }

            // Form Submission & Client-Side Validation
            loginForm.addEventListener('submit', function(e) {
                let isValid = true;
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                
                emailInput.style.borderColor = '#e2e8f0';
                passwordInput.style.borderColor = '#e2e8f0';
                clientAlert.classList.remove('show');

                if (!emailInput.value.trim() || !emailRegex.test(emailInput.value)) {
                    emailInput.style.borderColor = 'var(--error-color)';
                    isValid = false;
                }
                if (!passwordInput.value.trim()) {
                    passwordInput.style.borderColor = 'var(--error-color)';
                    isValid = false;
                }

                if (!isValid) {
                    e.preventDefault();
                    showAlert('error', 'Please correct the errors in the form before submitting.');
                    return;
                }

                loginBtn.disabled = true;
                btnText.textContent = 'Authenticating...';
                btnSpinner.classList.remove('d-none');
            });
        });
    </script>
</body>
</html>