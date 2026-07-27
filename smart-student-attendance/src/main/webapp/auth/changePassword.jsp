<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Campus Analytics - Change Your Password Securely">
    <title>Change Password | <c:out value="${portalName}" default="Campus Analytics" /></title>
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
            --warning-color: #f59e0b;
            --info-bg: #f0f9ff;
            --info-border: #bae6fd;
            --info-text: #0369a1;
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
            align-items: stretch;
            justify-content: center;
            gap: 4rem;
            max-width: 1400px;
            width: 100%;
        }

        .left-section {
            flex: 1;
            max-width: 650px;
            color: white;
            animation: fadeInLeft 1s ease-out;
            display: flex;
            flex-direction: column;
            justify-content: center;
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
            margin-bottom: 2.5rem;
            font-weight: 300;
            line-height: 1.6;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.2rem;
        }

        .info-card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 16px;
            padding: 1.2rem;
            transition: all 0.3s ease;
            animation: fadeInUp 0.8s ease-out backwards;
        }

        .info-card:nth-child(1) { animation-delay: 0.2s; }
        .info-card:nth-child(2) { animation-delay: 0.4s; }
        .info-card:nth-child(3) { animation-delay: 0.6s; }
        .info-card:nth-child(4) { animation-delay: 0.8s; }

        .info-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.12);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .info-icon { font-size: 1.4rem; margin-bottom: 0.6rem; color: var(--accent-blue); }
        .info-title { font-size: 0.95rem; font-weight: 600; margin-bottom: 0.3rem; }
        .info-desc { font-size: 0.8rem; opacity: 0.8; font-weight: 300; line-height: 1.4; }

        .right-section {
            flex: 0 0 520px;
            max-width: 520px;
            width: 100%;
            animation: fadeInRight 1s ease-out;
        }

        .change-password-card {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.2);
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .verified-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #dbeafe;
            color: #1e40af;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .card-header-custom { text-align: center; margin-bottom: 1.2rem; }
        .card-header-custom h2 { color: var(--primary-blue); font-weight: 700; font-size: 1.5rem; margin-bottom: 0.4rem; }
        .card-header-custom p { color: var(--text-muted); font-size: 0.85rem; line-height: 1.5; }

        .form-floating-custom {
            position: relative;
            margin-bottom: 1rem;
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

        .form-floating-custom .form-control:focus ~ .input-icon { color: var(--secondary-blue); }

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

        .form-floating-custom .form-control:placeholder-shown:not(:focus) ~ label { opacity: 0; }

        .input-action-btn {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            cursor: pointer;
            z-index: 4;
            background: none;
            border: none;
            padding: 0;
            transition: color 0.3s;
        }
        .input-action-btn:hover { color: var(--secondary-blue); }

        .caps-lock-warning {
            font-size: 0.75rem;
            color: var(--warning-color);
            margin-top: -0.5rem;
            margin-bottom: 0.5rem;
            display: none;
            align-items: center;
            gap: 5px;
        }
        .caps-lock-warning.show { display: flex; }

        /* Strength Meter */
        .strength-meter-container {
            margin-bottom: 1rem;
        }
        .strength-meter-header {
            display: flex;
            justify-content: space-between;
            font-size: 0.75rem;
            margin-bottom: 4px;
            color: var(--text-muted);
        }
        .strength-text { font-weight: 600; }
        .progress { height: 6px; border-radius: 3px; background: #e2e8f0; }
        .progress-bar { transition: width 0.4s ease, background-color 0.4s ease; }

        /* Match Indicator */
        .match-indicator {
            font-size: 0.75rem;
            margin-top: -0.5rem;
            margin-bottom: 0.8rem;
            display: flex;
            align-items: center;
            gap: 5px;
            opacity: 0;
            transition: opacity 0.3s;
        }
        .match-indicator.show { opacity: 1; }
        .match-indicator.success { color: var(--success-color); }
        .match-indicator.error { color: var(--error-color); }

        /* Policy Checklist */
        .policy-list {
            background: #f8fafc;
            border-radius: 10px;
            padding: 0.8rem 1rem;
            margin-bottom: 1rem;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.4rem 1rem;
        }
        .policy-item {
            font-size: 0.75rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 6px;
            transition: color 0.3s;
        }
        .policy-item i { font-size: 0.65rem; }
        .policy-item.valid { color: var(--success-color); font-weight: 500; }

        .btn-change {
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

        .btn-change:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(42, 82, 152, 0.3);
        }

        .btn-change:disabled { opacity: 0.6; cursor: not-allowed; transform: none; box-shadow: none; }
        .spinner-border { width: 1.2rem; height: 1.2rem; border-width: 0.15em; }

        /* Session Warning */
        .session-warning {
            background: #fffbeb;
            border: 1px solid #fde68a;
            color: #92400e;
            padding: 0.7rem 1rem;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: 500;
            margin-top: 1.2rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Redirect Notice */
        .redirect-notice {
            background: #ecfdf5;
            border: 1px solid #a7f3d0;
            color: #065f46;
            padding: 0.8rem 1rem;
            border-radius: 10px;
            font-size: 0.8rem;
            font-weight: 500;
            margin-top: 1rem;
            display: none;
            align-items: center;
            gap: 8px;
            animation: slideInDown 0.4s ease-out;
        }
        .redirect-notice.show { display: flex; }
        .countdown { font-weight: 700; color: var(--primary-blue); }

        /* Navigation Links */
        .nav-links {
            display: flex;
            justify-content: space-between;
            margin-top: 1rem;
            margin-bottom: 0;
            font-size: 0.85rem;
        }

        .nav-links a {
            color: var(--secondary-blue);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }
        .nav-links a:hover { color: var(--primary-blue); text-decoration: underline; }

        .custom-alert {
            border-radius: 12px;
            border: none;
            padding: 0.8rem 1.2rem;
            font-size: 0.85rem;
            margin-bottom: 1.2rem;
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

        @media (max-width: 991px) {
            .content-wrapper { flex-direction: column; align-items: center; gap: 2.5rem; }
            .left-section { max-width: 100%; text-align: center; align-items: center; }
            .brand-logo { justify-content: center; }
            .info-grid { max-width: 500px; margin: 0 auto; }
            .right-section { flex: 0 0 auto; max-width: 520px; width: 100%; }
            .main-container { padding: 2rem 1.5rem; }
        }

        @media (max-width: 767px) {
            .floating-shape { display: none; }
            .right-section { max-width: 100%; }
            .change-password-card { padding: 1.5rem; border-radius: 16px; }
            .nav-links { flex-direction: column; gap: 1rem; text-align: center; }
            .welcome-heading { font-size: 1.8rem; }
            .info-grid { grid-template-columns: 1fr; }
            .policy-list { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <div class="floating-shape shape-1"></div>
    <div class="floating-shape shape-2"></div>
    <div class="floating-shape shape-3"></div>

    <div class="main-container">
        <div class="content-wrapper">
            
            <!-- Left Section -->
            <div class="left-section">
                <div class="brand-logo">
                    <i class="fas fa-university"></i>
                    <span><c:out value="${systemShortName}" default="Campus Analytics" /></span>
                </div>
                <h1 class="welcome-heading">Password Security</h1>
                <p class="welcome-desc">
                    Update your password to keep your academic records, attendance data, grades, and personal information secure.
                </p>

                <div class="info-grid">
                    <div class="info-card">
                        <div class="info-icon"><i class="fas fa-shield-alt"></i></div>
                        <div class="info-title">Strong Protection</div>
                        <div class="info-desc">Use a unique password that you do not use elsewhere.</div>
                    </div>
                    <div class="info-card">
                        <div class="info-icon"><i class="fas fa-lock"></i></div>
                        <div class="info-title">Secure Storage</div>
                        <div class="info-desc">Passwords are securely hashed before storage.</div>
                    </div>
                    <div class="info-card">
                        <div class="info-icon"><i class="fas fa-key"></i></div>
                        <div class="info-title">Account Safety</div>
                        <div class="info-desc">Strong passwords reduce unauthorized access risks.</div>
                    </div>
                    <div class="info-card">
                        <div class="info-icon"><i class="fas fa-check-circle"></i></div>
                        <div class="info-title">Compliance</div>
                        <div class="info-desc">Passwords must satisfy university security requirements.</div>
                    </div>
                </div>
            </div>

            <!-- Right Section -->
            <div class="right-section">
                <div class="change-password-card">
                    
                    <div class="card-header-custom">
                        <div class="verified-badge">
                            <i class="fas fa-user-check"></i> Authenticated User
                        </div>
                        <h2>Change Password</h2>
                        <p>Enter your current password and create a new secure password for your account.</p>
                    </div>

                    <!-- Server Alerts -->
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

                    <div id="clientAlert" class="custom-alert">
                        <i id="alertIcon" class="fas"></i>
                        <span id="alertMessage"></span>
                    </div>

                    <!-- Redirect Notice -->
                    <div id="redirectNotice" class="redirect-notice">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Redirecting to login page in <span class="countdown" id="countdown">3</span> seconds...</span>
                    </div>

                    <!-- Form -->
                    <form id="ChangePasswordServlet" novalidate>
                        <input type="hidden" name="csrf_token" value="<c:out value='${csrfToken}' />">

                        <!-- Current Password -->
                        <div class="form-floating-custom">
                            <i class="fas fa-key input-icon"></i>
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" placeholder=" " required autocomplete="current-password">
                            <label for="currentPassword">Current Password</label>
                            <button type="button" class="input-action-btn toggle-password" data-target="currentPassword" aria-label="Toggle password visibility">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>

                        <!-- New Password -->
                        <div class="form-floating-custom">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder=" " required autocomplete="new-password">
                            <label for="newPassword">New Password</label>
                            <button type="button" class="input-action-btn toggle-password" data-target="newPassword" aria-label="Toggle password visibility">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="caps-lock-warning" id="capsLockWarning">
                            <i class="fas fa-exclamation-triangle"></i> Caps Lock is ON
                        </div>

                        <!-- Strength Meter -->
                        <div class="strength-meter-container">
                            <div class="strength-meter-header">
                                <span>Password Strength:</span>
                                <span class="strength-text" id="strengthText">None</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar" id="strengthBar" role="progressbar" style="width: 0%"></div>
                            </div>
                        </div>

                        <!-- Confirm Password -->
                        <div class="form-floating-custom">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder=" " required autocomplete="new-password">
                            <label for="confirmPassword">Confirm New Password</label>
                            <button type="button" class="input-action-btn toggle-password" data-target="confirmPassword" aria-label="Toggle password visibility">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="match-indicator" id="matchIndicator">
                            <i class="fas" id="matchIcon"></i>
                            <span id="matchText"></span>
                        </div>

                        <!-- Policy Checklist -->
                        <div class="policy-list" id="policyList">
                            <div class="policy-item" data-rule="length"><i class="fas fa-circle"></i> Minimum 8 characters</div>
                            <div class="policy-item" data-rule="uppercase"><i class="fas fa-circle"></i> At least one uppercase</div>
                            <div class="policy-item" data-rule="lowercase"><i class="fas fa-circle"></i> At least one lowercase</div>
                            <div class="policy-item" data-rule="number"><i class="fas fa-circle"></i> At least one number</div>
                            <div class="policy-item" data-rule="special"><i class="fas fa-circle"></i> At least one special char</div>
                            <div class="policy-item" data-rule="space"><i class="fas fa-circle"></i> Must not contain spaces</div>
                            <div class="policy-item" data-rule="history"><i class="fas fa-circle"></i> Not a previous password</div>
                        </div>

                        <button type="submit" class="btn-change" id="submitBtn">
                            <span id="btnText">Change Password</span>
                            <span class="spinner-border spinner-border-sm d-none" id="btnSpinner" role="status" aria-hidden="true"></span>
                        </button>
                    </form>

                    <!-- Session Warning -->
                    <div class="session-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>For your protection, you will be redirected to login after changing your password.</span>
                    </div>

                    <!-- Navigation Links -->
                    <div class="nav-links">
						<c:set var="backUrl" value="${pageContext.request.contextPath}/login" />
						<c:choose>
						    <c:when test="${loggedInUser.role.name() == 'STUDENT'}">
						        <c:set var="backUrl" value="${pageContext.request.contextPath}/student/profile" />
						    </c:when>
						    <c:when test="${loggedInUser.role.name() == 'FACULTY'}">
						        <c:set var="backUrl" value="${pageContext.request.contextPath}/faculty/profile" />
						    </c:when>
						    <c:when test="${loggedInUser.role.name() == 'ADMIN'}">
						        <c:set var="backUrl" value="${pageContext.request.contextPath}/admin/profile" />
						    </c:when>
						    <c:when test="${loggedInUser.role.name() == 'HOD'}">
						        <c:set var="backUrl" value="${pageContext.request.contextPath}/hod/profile" />
						    </c:when>
						</c:choose>
						
						<div class="nav-links">
						    <a href="${backUrl}"><i class="fas fa-arrow-left"></i> Back to Profile</a>
						    <a href="${pageContext.request.contextPath}/help"><i class="fas fa-question-circle"></i> Need Help?</a>
						</div>
                        <a href="${pageContext.request.contextPath}/help"><i class="fas fa-question-circle"></i> Need Help?</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; <c:out value="${copyrightYear}" default="2026" /> <c:out value="${universityName}" default="University Name" />. All rights reserved.</p>
        <div class="mt-2">
            <a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a> • 
            <a href="${pageContext.request.contextPath}/terms">Terms & Conditions</a> • 
            <a href="mailto:<c:out value='${supportEmail}' />">Contact IT Support</a>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const currentPassword = document.getElementById('currentPassword');
            const newPassword = document.getElementById('newPassword');
            const confirmPassword = document.getElementById('confirmPassword');
            const changePasswordForm = document.getElementById('ChangePasswordServlet');
            const submitBtn = document.getElementById('submitBtn');
            const btnText = document.getElementById('btnText');
            const btnSpinner = document.getElementById('btnSpinner');
            const capsLockWarning = document.getElementById('capsLockWarning');
            const redirectNotice = document.getElementById('redirectNotice');
            const countdownEl = document.getElementById('countdown');
            
            const strengthBar = document.getElementById('strengthBar');
            const strengthText = document.getElementById('strengthText');
            
            const matchIndicator = document.getElementById('matchIndicator');
            const matchIcon = document.getElementById('matchIcon');
            const matchText = document.getElementById('matchText');
            
            const policyItems = document.querySelectorAll('.policy-item');
            const clientAlert = document.getElementById('clientAlert');
            const alertIcon = document.getElementById('alertIcon');
            const alertMessage = document.getElementById('alertMessage');

            // Context path for URLs
            const contextPath = '${pageContext.request.contextPath}';

            // --- Toggle Password Visibility ---
            document.querySelectorAll('.toggle-password').forEach(btn => {
                btn.addEventListener('click', function() {
                    const targetId = this.getAttribute('data-target');
                    const input = document.getElementById(targetId);
                    const icon = this.querySelector('i');
                    
                    if (input.type === 'password') {
                        input.type = 'text';
                        icon.classList.remove('fa-eye');
                        icon.classList.add('fa-eye-slash');
                    } else {
                        input.type = 'password';
                        icon.classList.remove('fa-eye-slash');
                        icon.classList.add('fa-eye');
                    }
                });
            });

            // --- Caps Lock Detection ---
            function checkCapsLock(e) {
                if (e.getModifierState && e.getModifierState('CapsLock')) {
                    capsLockWarning.classList.add('show');
                } else {
                    capsLockWarning.classList.remove('show');
                }
            }
            currentPassword.addEventListener('keyup', checkCapsLock);
            newPassword.addEventListener('keyup', checkCapsLock);
            confirmPassword.addEventListener('keyup', checkCapsLock);

            // --- Password Policy & Strength Validation ---
            function validatePassword() {
                const pwd = newPassword.value;
                let score = 0;

                const rules = {
                    length: pwd.length >= 8,
                    uppercase: /[A-Z]/.test(pwd),
                    lowercase: /[a-z]/.test(pwd),
                    number: /[0-9]/.test(pwd),
                    special: /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(pwd),
                    space: !/\s/.test(pwd),
                    history: pwd.length > 0
                };

                policyItems.forEach(item => {
                    const rule = item.getAttribute('data-rule');
                    if (rules[rule]) {
                        item.classList.add('valid');
                        item.querySelector('i').classList.remove('fa-circle');
                        item.querySelector('i').classList.add('fa-check-circle');
                        if (rule !== 'history') score++;
                    } else {
                        item.classList.remove('valid');
                        item.querySelector('i').classList.remove('fa-check-circle');
                        item.querySelector('i').classList.add('fa-circle');
                    }
                });

                if (rules.length) score++;
                if (pwd.length >= 12) score++;
                if (rules.uppercase) score++;
                if (rules.lowercase) score++;
                if (rules.number) score++;
                if (rules.special) score++;

                updateStrengthMeter(pwd);
                validateMatch();
            }

            function updateStrengthMeter(password) {

                if (!password) {
                    strengthBar.style.width = '0%';
                    strengthBar.style.backgroundColor = '#e2e8f0';
                    strengthText.textContent = 'None';
                    strengthText.style.color = '#718096';
                    return;
                }

                let score = 0;

                // Length (40 points max)
                score += Math.min(password.length * 4, 40);

                // Character variety
                if (/[a-z]/.test(password)) score += 10;
                if (/[A-Z]/.test(password)) score += 15;
                if (/[0-9]/.test(password)) score += 15;
                if (/[^A-Za-z0-9]/.test(password)) score += 20;

                score = Math.min(score, 100);

                let color, text;

                if (score < 20) {
                    color = '#ef4444';
                    text = 'Very Weak';
                } else if (score < 40) {
                    color = '#f97316';
                    text = 'Weak';
                } else if (score < 60) {
                    color = '#f59e0b';
                    text = 'Fair';
                } else if (score < 80) {
                    color = '#3b82f6';
                    text = 'Strong';
                } else {
                    color = '#10b981';
                    text = 'Very Strong';
                }

                strengthBar.style.width = score + '%';
                strengthBar.style.backgroundColor = color;
                strengthText.textContent = text;
                strengthText.style.color = color;
            }

            function validateMatch() {
                const pwd = newPassword.value;
                const cpwd = confirmPassword.value;

                if (cpwd.length === 0) {
                    matchIndicator.classList.remove('show');
                    return;
                }

                matchIndicator.classList.add('show');
                if (pwd === cpwd) {
                    matchIndicator.classList.add('success');
                    matchIndicator.classList.remove('error');
                    matchIcon.className = 'fas fa-check-circle';
                    matchText.textContent = 'Passwords Match';
                } else {
                    matchIndicator.classList.remove('success');
                    matchIndicator.classList.add('error');
                    matchIcon.className = 'fas fa-times-circle';
                    matchText.textContent = 'Passwords Do Not Match';
                }
            }

            newPassword.addEventListener('input', validatePassword);
            confirmPassword.addEventListener('input', validateMatch);

            // --- Redirect Countdown ---
            function startRedirectCountdown(redirectUrl) {
                redirectNotice.classList.add('show');
                let seconds = 3;
                countdownEl.textContent = seconds;

                const countdownInterval = setInterval(function() {
                    seconds--;
                    countdownEl.textContent = seconds;

                    if (seconds <= 0) {
                        clearInterval(countdownInterval);
                        window.location.href = redirectUrl;
                    }
                }, 1000);
            }

            // --- Form Submission (AJAX) ---
            changePasswordForm.addEventListener('submit', function(e) {
                e.preventDefault();

                const pwd = newPassword.value;
                const cpwd = confirmPassword.value;
                const currentPwd = currentPassword.value;

                // Client-side validation
                const rules = {
                    length: pwd.length >= 8,
                    uppercase: /[A-Z]/.test(pwd),
                    lowercase: /[a-z]/.test(pwd),
                    number: /[0-9]/.test(pwd),
                    special: /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(pwd),
                    space: !/\s/.test(pwd)
                };

                const allValid = Object.values(rules).every(v => v);

                if (!allValid) {
                    showAlert('error', 'Please ensure your new password meets all security requirements.');
                    return;
                }

                if (pwd !== cpwd) {
                    showAlert('error', 'New passwords do not match. Please try again.');
                    return;
                }

                if (currentPwd === pwd) {
                    showAlert('error', 'New password must be different from your current password.');
                    return;
                }

                if (!currentPwd) {
                    showAlert('error', 'Please enter your current password.');
                    return;
                }

                // Disable button and show spinner
                submitBtn.disabled = true;
                btnText.textContent = 'Changing Password...';
                btnSpinner.classList.remove('d-none');

                // Prepare form data
                const formData = new FormData();
                formData.append('currentPassword', currentPwd);
                formData.append('newPassword', pwd);

                // Send AJAX request
                fetch(contextPath + '/auth/change-password', {
                    method: 'POST',
                    body: formData
                })
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    if (data.success) {
                        showAlert('success', data.message || 'Password changed successfully!');
                        
                        // Disable form inputs
                        currentPassword.disabled = true;
                        newPassword.disabled = true;
                        confirmPassword.disabled = true;

                        // Start countdown and redirect
                        const redirectUrl = data.redirect || (contextPath + '/login');
                        startRedirectCountdown(redirectUrl);
                    } else {
                        showAlert('error', data.message || 'Failed to change password.');
                        
                        // Re-enable button
                        submitBtn.disabled = false;
                        btnText.textContent = 'Change Password';
                        btnSpinner.classList.add('d-none');

                        // If session expired, redirect to login
                        if (data.redirect) {
                            setTimeout(function() {
                                window.location.href = data.redirect;
                            }, 2000);
                        }
                    }
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    showAlert('error', 'An unexpected error occurred. Please try again.');
                    
                    // Re-enable button
                    submitBtn.disabled = false;
                    btnText.textContent = 'Change Password';
                    btnSpinner.classList.add('d-none');
                });
             // Add this before the fetch call in your JavaScript
                console.log('Submitting password change...');
                console.log('Current password length:', currentPwd ? currentPwd.length : 'NULL');
                console.log('New password length:', pwd ? pwd.length : 'NULL');
            });

            function showAlert(type, message) {
                clientAlert.className = 'custom-alert show';
                if (type === 'error') { 
                    clientAlert.classList.add('alert-error'); 
                    alertIcon.className = 'fas fa-exclamation-circle'; 
                } else if (type === 'success') { 
                    clientAlert.classList.add('alert-success'); 
                    alertIcon.className = 'fas fa-check-circle'; 
                } else if (type === 'warning') { 
                    clientAlert.classList.add('alert-warning'); 
                    alertIcon.className = 'fas fa-exclamation-triangle'; 
                }
                alertMessage.textContent = message;
                
                // Auto-hide after 3 seconds (unless it's a success message during redirect)
                if (type !== 'success') {
                    setTimeout(function() { 
                        clientAlert.classList.remove('show'); 
                    }, 3000);
                }
            }
         
        });
    </script>
</body>
</html>