<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<%-- 
    ENTERPRISE AUTO-REDIRECT LOGIC:
    If the user is already authenticated, automatically redirect them to their 
    respective role-based dashboard. Unauthenticated users remain on this landing page.
--%>
<c:if test="${not empty sessionScope.loggedInUser}">
    <c:set var="userRole" value="${fn:toLowerCase(sessionScope.loggedInUser.role.name())}" />
    <c:redirect url="/${userRole}/dashboard" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Smart Student Attendance & Academic Monitoring System - Enterprise University ERP">
    <title>Home | <c:out value="${portalName}" default="Campus Analytics & Student Monitoring Portal" /></title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #1e3c72;
            --secondary-blue: #2a5298;
            --accent-blue: #4facfe;
            --glass-bg: rgba(255, 255, 255, 0.85);
            --glass-border: rgba(255, 255, 255, 0.4);
            --dark-glass-bg: rgba(255, 255, 255, 0.05);
            --dark-glass-border: rgba(255, 255, 255, 0.1);
            --text-dark: #2d3748;
            --text-muted: #718096;
            --text-light: #f8fafc;
            --success-color: #10b981;
            --error-color: #ef4444;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        html { scroll-behavior: smooth; }
        body {
            background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
            background-attachment: fixed;
            color: var(--text-light);
            overflow-x: hidden;
            position: relative;
        }

        /* Animated Background Particles */
        .floating-shape {
            position: fixed;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.02);
            backdrop-filter: blur(2px);
            animation: float 25s infinite ease-in-out;
            z-index: 0;
            pointer-events: none;
        }
        .shape-1 { width: 400px; height: 400px; top: -100px; left: -100px; animation-delay: 0s; }
        .shape-2 { width: 300px; height: 300px; bottom: 10%; right: -100px; animation-delay: -5s; }
        .shape-3 { width: 200px; height: 200px; top: 50%; left: 30%; animation-delay: -10s; }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-40px) rotate(10deg); }
        }

        /* Scroll Animations */
        .scroll-animate {
            opacity: 0;
            transform: translateY(40px);
            transition: opacity 0.8s cubic-bezier(0.16, 1, 0.3, 1), transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .scroll-animate.animate-in {
            opacity: 1;
            transform: translateY(0);
        }

        /* Navbar */
        .navbar-custom {
            background: rgba(15, 32, 39, 0.8);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            padding: 1rem 0;
            transition: all 0.3s ease;
            z-index: 1000;
        }
        .navbar-custom.scrolled {
            padding: 0.5rem 0;
            background: rgba(15, 32, 39, 0.95);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }
        .navbar-brand-custom {
            font-size: 1.4rem;
            font-weight: 700;
            color: white !important;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .navbar-brand-custom i { color: var(--accent-blue); font-size: 1.6rem; }
        .nav-link-custom {
            color: rgba(255, 255, 255, 0.8) !important;
            font-weight: 500;
            font-size: 0.95rem;
            margin: 0 0.5rem;
            transition: color 0.3s;
        }
        .nav-link-custom:hover, .nav-link-custom.active { color: var(--accent-blue) !important; }
        .btn-login-nav {
            background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
            color: white !important;
            padding: 0.5rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
            border: none;
        }
        .btn-login-nav:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(42, 82, 152, 0.4);
            color: white !important;
        }

        /* Hero Section */
        .hero-section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 120px 0 80px;
            position: relative;
            z-index: 1;
        }
        .hero-title {
            font-size: 3.2rem;
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 1.5rem;
            background: linear-gradient(to right, #ffffff, #4facfe);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .hero-subtitle {
            font-size: 1.15rem;
            color: rgba(255, 255, 255, 0.8);
            line-height: 1.7;
            margin-bottom: 2.5rem;
            font-weight: 300;
        }
        .btn-hero-primary {
            background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
            color: white;
            padding: 14px 32px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1rem;
            border: none;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-hero-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(42, 82, 152, 0.4);
            color: white;
        }
        .btn-hero-secondary {
            background: transparent;
            color: white;
            padding: 14px 32px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1rem;
            border: 2px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-hero-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--accent-blue);
            color: var(--accent-blue);
        }

        /* Hero Illustration */
        .hero-illustration {
            position: relative;
            animation: floatIllustration 6s ease-in-out infinite;
        }
        @keyframes floatIllustration {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
        }
        .hero-illustration svg {
            width: 100%;
            max-width: 600px;
            filter: drop-shadow(0 20px 40px rgba(0, 0, 0, 0.3));
        }

        /* Section Styling */
        .section-padding { padding: 100px 0; position: relative; z-index: 1; }
        .section-title {
            font-size: 2.4rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 1rem;
            color: white;
        }
        .section-subtitle {
            text-align: center;
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.05rem;
            margin-bottom: 4rem;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Glassmorphism Cards (Light for contrast) */
        .glass-card-light {
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            height: 100%;
            color: var(--text-dark);
        }
        .glass-card-light:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
            border-color: var(--accent-blue);
        }
        .glass-card-light .card-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 1.5rem;
            transition: transform 0.3s;
        }
        .glass-card-light:hover .card-icon { transform: scale(1.1) rotate(5deg); }
        .glass-card-light h4 { font-size: 1.2rem; font-weight: 600; margin-bottom: 0.8rem; color: var(--primary-blue); }
        .glass-card-light p { font-size: 0.9rem; color: var(--text-muted); line-height: 1.6; margin: 0; }

        /* Glassmorphism Cards (Dark for variety) */
        .glass-card-dark {
            background: var(--dark-glass-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--dark-glass-border);
            border-radius: 16px;
            padding: 2rem;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            height: 100%;
            color: white;
        }
        .glass-card-dark:hover {
            transform: translateY(-8px);
            background: rgba(255, 255, 255, 0.08);
            border-color: var(--accent-blue);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
        }
        .glass-card-dark .card-icon {
            font-size: 2rem;
            color: var(--accent-blue);
            margin-bottom: 1.2rem;
        }
        .glass-card-dark h4 { font-size: 1.1rem; font-weight: 600; margin-bottom: 0.5rem; }
        .glass-card-dark p { font-size: 0.85rem; color: rgba(255, 255, 255, 0.7); line-height: 1.5; margin: 0; }

        /* Statistics Section */
        .stat-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 2.5rem 1.5rem;
            text-align: center;
            transition: all 0.4s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--accent-blue);
        }
        .stat-value {
            font-size: 2.8rem;
            font-weight: 800;
            background: linear-gradient(to right, #ffffff, #4facfe);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }
        .stat-label { font-size: 0.95rem; color: rgba(255, 255, 255, 0.7); font-weight: 500; }

        /* Technology Badges */
        .tech-badge {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s ease;
            color: white;
        }
        .tech-badge:hover {
            background: rgba(79, 172, 254, 0.1);
            border-color: var(--accent-blue);
            transform: translateY(-5px);
        }
        .tech-badge i { font-size: 2.5rem; color: var(--accent-blue); margin-bottom: 1rem; display: block; }
        .tech-badge span { font-size: 0.9rem; font-weight: 500; }

        /* Contact Section */
        .contact-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s ease;
        }
        .contact-card:hover { border-color: var(--accent-blue); transform: translateY(-5px); }
        .contact-card i { font-size: 2rem; color: var(--accent-blue); margin-bottom: 1rem; }
        .contact-card h5 { font-size: 1rem; font-weight: 600; margin-bottom: 0.5rem; }
        .contact-card p { font-size: 0.9rem; color: rgba(255, 255, 255, 0.7); margin: 0; word-break: break-all; }

        /* Footer */
        .footer {
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(10px);
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            padding: 3rem 0 1.5rem;
            position: relative;
            z-index: 1;
        }
        .footer a { color: rgba(255, 255, 255, 0.7); text-decoration: none; transition: color 0.3s; }
        .footer a:hover { color: var(--accent-blue); }
        .footer-links a { margin: 0 10px; font-size: 0.9rem; }
        .footer-bottom { border-top: 1px solid rgba(255, 255, 255, 0.05); padding-top: 1.5rem; margin-top: 2rem; text-align: center; font-size: 0.85rem; color: rgba(255, 255, 255, 0.5); }

        /* Responsive */
        @media (max-width: 991px) {
            .hero-title { font-size: 2.4rem; }
            .hero-illustration { margin-top: 3rem; }
            .section-title { font-size: 2rem; }
        }
        @media (max-width: 767px) {
            .hero-title { font-size: 2rem; }
            .hero-subtitle { font-size: 1rem; }
            .section-padding { padding: 60px 0; }
            .stat-value { font-size: 2.2rem; }
        }
    </style>
</head>
<body>

    <!-- Background Shapes -->
    <div class="floating-shape shape-1"></div>
    <div class="floating-shape shape-2"></div>
    <div class="floating-shape shape-3"></div>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-custom fixed-top">
        <div class="container">
            <a class="navbar-brand navbar-brand-custom" href="#">
                <i class="fas fa-university"></i>
                <span><c:out value="${systemShortName}" default="Campus Analytics" /></span>
            </a>
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" style="color: white;">
                <i class="fas fa-bars"></i>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link nav-link-custom active" href="#home">Home</a></li>
                    <li class="nav-item"><a class="nav-link nav-link-custom" href="#features">Features</a></li>
                    <li class="nav-item"><a class="nav-link nav-link-custom" href="#modules">Modules</a></li>
                    <li class="nav-item"><a class="nav-link nav-link-custom" href="#about">About System</a></li>
                    <li class="nav-item"><a class="nav-link nav-link-custom" href="#contact">Contact</a></li>
                    <li class="nav-item ms-lg-3 mt-2 mt-lg-0">
                        <a class="btn btn-login-nav" href="${pageContext.request.contextPath}/login">
                            <i class="fas fa-sign-in-alt me-2"></i>Login
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home" class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 mb-5 mb-lg-0 scroll-animate">
                    <h1 class="hero-title">Transforming Academic Monitoring Through Smart Digital Solutions</h1>
                    <p class="hero-subtitle">
                        Empowering educational institutions with a unified platform to manage attendance, track academic performance, streamline faculty operations, and generate insightful reports. Experience the next generation of university ERP systems.
                    </p>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="${pageContext.request.contextPath}/login" class="btn-hero-primary">
                            <i class="fas fa-sign-in-alt"></i> Login to Portal
                        </a>
                        <a href="#features" class="btn-hero-secondary">
                            <i class="fas fa-arrow-down"></i> Learn More
                        </a>
                    </div>
                </div>
                <div class="col-lg-6 text-center scroll-animate">
                    <div class="hero-illustration">
                        <!-- Professional Inline SVG Dashboard Illustration -->
                        <svg viewBox="0 0 600 450" xmlns="http://www.w3.org/2000/svg">
                            <!-- Monitor Frame -->
                            <rect x="50" y="40" width="500" height="320" rx="15" fill="#1e293b" stroke="#334155" stroke-width="4"/>
                            <rect x="70" y="60" width="460" height="280" rx="5" fill="#0f172a"/>
                            <!-- Stand -->
                            <path d="M250 360 L350 360 L380 400 L220 400 Z" fill="#334155"/>
                            <rect x="280" y="360" width="40" height="20" fill="#1e293b"/>
                            
                            <!-- Dashboard UI inside monitor -->
                            <!-- Sidebar -->
                            <rect x="70" y="60" width="110" height="280" fill="#1e3c72" opacity="0.9"/>
                            <rect x="85" y="80" width="80" height="12" rx="6" fill="#fff" opacity="0.6"/>
                            <rect x="85" y="115" width="70" height="8" rx="4" fill="#fff" opacity="0.3"/>
                            <rect x="85" y="135" width="70" height="8" rx="4" fill="#fff" opacity="0.3"/>
                            <rect x="85" y="155" width="70" height="8" rx="4" fill="#4facfe" opacity="0.9"/> <!-- Active -->
                            <rect x="85" y="175" width="70" height="8" rx="4" fill="#fff" opacity="0.3"/>
                            
                            <!-- Top Bar -->
                            <rect x="180" y="60" width="350" height="45" fill="#1e293b"/>
                            <circle cx="490" cy="82" r="14" fill="#4facfe"/>
                            <rect x="200" y="76" width="100" height="12" rx="6" fill="#fff" opacity="0.2"/>
                            
                            <!-- Content Area: Stat Cards -->
                            <rect x="200" y="125" width="100" height="65" rx="8" fill="#2a5298" opacity="0.6"/>
                            <rect x="210" y="140" width="40" height="8" rx="4" fill="#fff" opacity="0.5"/>
                            <rect x="210" y="160" width="60" height="12" rx="6" fill="#4facfe"/>
                            
                            <rect x="315" y="125" width="100" height="65" rx="8" fill="#2a5298" opacity="0.6"/>
                            <rect x="325" y="140" width="40" height="8" rx="4" fill="#fff" opacity="0.5"/>
                            <rect x="325" y="160" width="60" height="12" rx="6" fill="#10b981"/>
                            
                            <rect x="430" y="125" width="80" height="65" rx="8" fill="#2a5298" opacity="0.6"/>
                            <rect x="440" y="140" width="30" height="8" rx="4" fill="#fff" opacity="0.5"/>
                            <rect x="440" y="160" width="50" height="12" rx="6" fill="#f59e0b"/>
                            
                            <!-- Content Area: Bar Chart -->
                            <rect x="200" y="210" width="215" height="110" rx="8" fill="#1e293b" stroke="#334155" stroke-width="2"/>
                            <rect x="220" y="270" width="20" height="35" rx="3" fill="#4facfe"/>
                            <rect x="250" y="245" width="20" height="60" rx="3" fill="#4facfe"/>
                            <rect x="280" y="225" width="20" height="80" rx="3" fill="#4facfe"/>
                            <rect x="310" y="255" width="20" height="50" rx="3" fill="#4facfe"/>
                            <rect x="340" y="235" width="20" height="70" rx="3" fill="#4facfe"/>
                            <rect x="370" y="280" width="20" height="25" rx="3" fill="#4facfe"/>
                            
                            <!-- Content Area: Pie Chart -->
                            <rect x="430" y="210" width="80" height="110" rx="8" fill="#1e293b" stroke="#334155" stroke-width="2"/>
                            <circle cx="470" cy="265" r="30" fill="none" stroke="#2a5298" stroke-width="12" stroke-dasharray="120 200"/>
                            <circle cx="470" cy="265" r="30" fill="none" stroke="#4facfe" stroke-width="12" stroke-dasharray="60 200" stroke-dashoffset="-120"/>
                            <circle cx="470" cy="265" r="30" fill="none" stroke="#10b981" stroke-width="12" stroke-dasharray="20 200" stroke-dashoffset="-180"/>
                        </svg>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="section-padding">
        <div class="container">
            <h2 class="section-title scroll-animate">Comprehensive System Features</h2>
            <p class="section-subtitle scroll-animate">Equipped with enterprise-grade tools designed to streamline every aspect of academic administration and student monitoring.</p>
            
            <div class="row g-4">
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-light">
                        <div class="card-icon"><i class="fas fa-clipboard-check"></i></div>
                        <h4>Attendance Management</h4>
                        <p>Automated tracking of student attendance with real-time updates, proxy detection, and biometric integration capabilities.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-light">
                        <div class="card-icon"><i class="fas fa-user-graduate"></i></div>
                        <h4>Student Information</h4>
                        <p>Centralized repository for student profiles, academic history, enrollment details, and personal records.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-light">
                        <div class="card-icon"><i class="fas fa-chalkboard-user"></i></div>
                        <h4>Faculty Management</h4>
                        <p>Streamline faculty profiles, course allocations, workload distribution, and performance evaluations.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-light">
                        <div class="card-icon"><i class="fas fa-chart-line"></i></div>
                        <h4>Performance Tracking</h4>
                        <p>Monitor GPA, internal marks, and semester results with comprehensive progress reports and trend analysis.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-light">
                        <div class="card-icon"><i class="fas fa-chart-pie"></i></div>
                        <h4>Analytics Dashboard</h4>
                        <p>Visualize institutional data with interactive charts, graphs, and real-time metrics for data-driven insights.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-light">
                        <div class="card-icon"><i class="fas fa-file-export"></i></div>
                        <h4>Report Generation</h4>
                        <p>Generate automated PDF and Excel reports for attendance, grades, and administrative audits with a single click.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-light">
                        <div class="card-icon"><i class="fas fa-user-shield"></i></div>
                        <h4>Role-Based Access</h4>
                        <p>Granular permission management ensuring users only access data and modules relevant to their specific role.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-light">
                        <div class="card-icon"><i class="fas fa-lock"></i></div>
                        <h4>Secure Authentication</h4>
                        <p>Enterprise-grade login security with BCrypt hashing, CSRF protection, and robust session management.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- System Modules Section -->
    <section id="modules" class="section-padding" style="background: rgba(0,0,0,0.1);">
        <div class="container">
            <h2 class="section-title scroll-animate">Core System Modules</h2>
            <p class="section-subtitle scroll-animate">A modular architecture designed for scalability, allowing institutions to manage distinct operational areas seamlessly.</p>
            
            <div class="row g-4">
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-dark">
                        <div class="card-icon"><i class="fas fa-sign-in-alt"></i></div>
                        <h4>Authentication Module</h4>
                        <p>Secure login, session handling, and multi-factor verification.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-dark">
                        <div class="card-icon"><i class="fas fa-users"></i></div>
                        <h4>Student Management</h4>
                        <p>Admissions, profiles, and academic lifecycle tracking.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-dark">
                        <div class="card-icon"><i class="fas fa-id-badge"></i></div>
                        <h4>Faculty Management</h4>
                        <p>Staff directories, assignments, and workload analytics.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-dark">
                        <div class="card-icon"><i class="fas fa-book"></i></div>
                        <h4>Subject Management</h4>
                        <p>Course catalogs, credit structures, and syllabus tracking.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-dark">
                        <div class="card-icon"><i class="fas fa-calendar-check"></i></div>
                        <h4>Attendance Management</h4>
                        <p>Daily tracking, percentage calculations, and shortage alerts.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-dark">
                        <div class="card-icon"><i class="fas fa-graduation-cap"></i></div>
                        <h4>Academic Monitoring</h4>
                        <p>Internal marks, semester results, and CGPA calculations.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-dark">
                        <div class="card-icon"><i class="fas fa-chart-bar"></i></div>
                        <h4>Reports & Analytics</h4>
                        <p>Visual dashboards and exportable institutional reports.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 scroll-animate">
                    <div class="glass-card-dark">
                        <div class="card-icon"><i class="fas fa-cogs"></i></div>
                        <h4>Administration</h4>
                        <p>System configuration, user roles, and global settings.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Benefits Section -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title scroll-animate">Why Choose Our System?</h2>
            <p class="section-subtitle scroll-animate">Delivering measurable improvements to institutional efficiency and academic outcomes.</p>
            
            <div class="row g-4 justify-content-center">
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-robot card-icon mt-1" style="font-size: 1.5rem; min-width: 40px;"></i>
                        <div>
                            <h4>Reduced Manual Work</h4>
                            <p>Automate repetitive administrative tasks and eliminate paper-based record keeping.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-bolt card-icon mt-1" style="font-size: 1.5rem; min-width: 40px;"></i>
                        <div>
                            <h4>Real-Time Monitoring</h4>
                            <p>Track attendance and academic metrics as they happen with live dashboard updates.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-lightbulb card-icon mt-1" style="font-size: 1.5rem; min-width: 40px;"></i>
                        <div>
                            <h4>Improved Academic Insights</h4>
                            <p>Identify at-risk students early and analyze performance trends across departments.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-chess-king card-icon mt-1" style="font-size: 1.5rem; min-width: 40px;"></i>
                        <div>
                            <h4>Better Decision Making</h4>
                            <p>Empower leadership with data-driven insights for strategic academic planning.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-shield-alt card-icon mt-1" style="font-size: 1.5rem; min-width: 40px;"></i>
                        <div>
                            <h4>Secure Data Management</h4>
                            <p>Enterprise-grade encryption and secure protocols to protect sensitive student data.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-database card-icon mt-1" style="font-size: 1.5rem; min-width: 40px;"></i>
                        <div>
                            <h4>Centralized Information</h4>
                            <p>A single source of truth for all academic, administrative, and operational data.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
	<section class="section-padding" style="background: rgba(0,0,0,0.15);">
	    <div class="container">
	        <h2 class="section-title scroll-animate">Institutional Impact</h2>
	        <p class="section-subtitle scroll-animate">Real-time metrics reflecting the scale and efficiency of our deployed enterprise solutions.</p>
	        
	        <div class="row g-4">
	            <div class="col-6 col-lg-3 scroll-animate">
	                <div class="stat-card">
	                    <!-- ✅ Dynamic: Pulled from statsDAO.getTotalStudents() via HomeServlet -->
	                    <div class="stat-value"><c:out value="${studentCount}" default="0" /></div>
	                    <div class="stat-label">Active Students</div>
	                </div>
	            </div>
	            <div class="col-6 col-lg-3 scroll-animate">
	                <div class="stat-card">
	                    <!-- ✅ Dynamic: Pulled from statsDAO.getTotalFaculty() via HomeServlet -->
	                    <div class="stat-value"><c:out value="${facultyCount}" default="0" /></div>
	                    <div class="stat-label">Faculty Members</div>
	                </div>
	            </div>
	            <div class="col-6 col-lg-3 scroll-animate">
	                <div class="stat-card">
	                    <!-- ✅ Dynamic: Pulled from statsDAO.getTotalDepartments() via HomeServlet -->
	                    <div class="stat-value"><c:out value="${departmentCount}" default="0" /></div>
	                    <div class="stat-label">Departments</div>
	                </div>
	            </div>
	            <div class="col-6 col-lg-3 scroll-animate">
	                <div class="stat-card">
	                    <!-- ✅ Dynamic: Pulled from statsDAO.getTotalAttendanceRecords() via HomeServlet -->
	                    <div class="stat-value"><c:out value="${attendanceRecordCount}" default="0" /></div>
	                    <div class="stat-label">Attendance Records</div>
	                </div>
	            </div>
	        </div>
	    </div>
	</section>

    <!-- About & Architecture Section -->
    <section id="about" class="section-padding">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 mb-5 mb-lg-0 scroll-animate">
                    <h2 class="section-title text-start">Enterprise Architecture</h2>
                    <p class="text-start" style="color: rgba(255,255,255,0.8); font-size: 1.05rem; line-height: 1.8;">
                        Built on a robust <strong>Model-View-Controller (MVC)</strong> architecture, our system ensures a clean separation of concerns, making it highly scalable and maintainable. 
                    </p>
                    <p class="text-start" style="color: rgba(255,255,255,0.7); font-size: 1rem; line-height: 1.8;">
                        The backend leverages the power of <strong>Java Servlets</strong> for request processing and business logic, while <strong>JSP (JavaServer Pages)</strong> handles dynamic view rendering. Data persistence is managed through <strong>JDBC</strong> connecting to a highly optimized <strong>MySQL</strong> relational database, ensuring data integrity and rapid query execution.
                    </p>
                </div>
                <div class="col-lg-6 scroll-animate">
                    <div class="glass-card-dark p-4">
                        <h4 class="mb-4 text-center" style="color: var(--accent-blue);">System Flow</h4>
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-center gap-3 p-3" style="background: rgba(255,255,255,0.05); border-radius: 10px;">
                                <i class="fas fa-desktop fa-2x" style="color: #4facfe; min-width: 40px;"></i>
                                <div>
                                    <strong>View Layer (JSP)</strong>
                                    <p class="mb-0 small" style="color: rgba(255,255,255,0.6);">Dynamic UI rendering with JSTL & EL</p>
                                </div>
                            </div>
                            <div class="d-flex justify-content-center"><i class="fas fa-arrow-down" style="color: rgba(255,255,255,0.3);"></i></div>
                            <div class="d-flex align-items-center gap-3 p-3" style="background: rgba(255,255,255,0.05); border-radius: 10px;">
                                <i class="fas fa-server fa-2x" style="color: #10b981; min-width: 40px;"></i>
                                <div>
                                    <strong>Controller Layer (Servlets)</strong>
                                    <p class="mb-0 small" style="color: rgba(255,255,255,0.6);">Request routing & business logic execution</p>
                                </div>
                            </div>
                            <div class="d-flex justify-content-center"><i class="fas fa-arrow-down" style="color: rgba(255,255,255,0.3);"></i></div>
                            <div class="d-flex align-items-center gap-3 p-3" style="background: rgba(255,255,255,0.05); border-radius: 10px;">
                                <i class="fas fa-database fa-2x" style="color: #f59e0b; min-width: 40px;"></i>
                                <div>
                                    <strong>Data Layer (JDBC & MySQL)</strong>
                                    <p class="mb-0 small" style="color: rgba(255,255,255,0.6);">Secure, persistent relational data storage</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Technology Stack Section -->
    <section class="section-padding" style="background: rgba(0,0,0,0.1);">
        <div class="container">
            <h2 class="section-title scroll-animate">Technology Stack</h2>
            <p class="section-subtitle scroll-animate">Powered by industry-standard, enterprise-grade technologies ensuring reliability and performance.</p>
            
            <div class="row g-3 justify-content-center">
                <div class="col-6 col-md-4 col-lg-2 scroll-animate"><div class="tech-badge"><i class="fab fa-java"></i><span>Java</span></div></div>
                <div class="col-6 col-md-4 col-lg-2 scroll-animate"><div class="tech-badge"><i class="fas fa-code"></i><span>JSP</span></div></div>
                <div class="col-6 col-md-4 col-lg-2 scroll-animate"><div class="tech-badge"><i class="fas fa-server"></i><span>Servlets</span></div></div>
                <div class="col-6 col-md-4 col-lg-2 scroll-animate"><div class="tech-badge"><i class="fas fa-plug"></i><span>JDBC</span></div></div>
                <div class="col-6 col-md-4 col-lg-2 scroll-animate"><div class="tech-badge"><i class="fas fa-database"></i><span>MySQL</span></div></div>
                <div class="col-6 col-md-4 col-lg-2 scroll-animate"><div class="tech-badge"><i class="fab fa-bootstrap"></i><span>Bootstrap 5</span></div></div>
                <div class="col-6 col-md-4 col-lg-2 scroll-animate"><div class="tech-badge"><i class="fab fa-html5"></i><span>HTML5</span></div></div>
                <div class="col-6 col-md-4 col-lg-2 scroll-animate"><div class="tech-badge"><i class="fab fa-css3-alt"></i><span>CSS3</span></div></div>
                <div class="col-6 col-md-4 col-lg-2 scroll-animate"><div class="tech-badge"><i class="fab fa-js"></i><span>JavaScript</span></div></div>
            </div>
        </div>
    </section>

    <!-- Security Highlights Section -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title scroll-animate">Enterprise Security Standards</h2>
            <p class="section-subtitle scroll-animate">Your data is protected by multiple layers of advanced security protocols and architectural safeguards.</p>
            
            <div class="row g-4">
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-user-tag card-icon mt-1" style="font-size: 1.5rem; min-width: 40px; color: #10b981;"></i>
                        <div>
                            <h4>Role-Based Authentication</h4>
                            <p>Strict access control ensuring users only interact with authorized modules.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-clock card-icon mt-1" style="font-size: 1.5rem; min-width: 40px; color: #10b981;"></i>
                        <div>
                            <h4>Session Management</h4>
                            <p>Secure session handling with fixation prevention and automatic timeout protocols.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-key card-icon mt-1" style="font-size: 1.5rem; min-width: 40px; color: #10b981;"></i>
                        <div>
                            <h4>Password Encryption</h4>
                            <p>Industry-standard BCrypt hashing ensures passwords are never stored in plain text.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-shield-virus card-icon mt-1" style="font-size: 1.5rem; min-width: 40px; color: #10b981;"></i>
                        <div>
                            <h4>CSRF Protection</h4>
                            <p>Token-based validation prevents Cross-Site Request Forgery attacks on all forms.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-filter card-icon mt-1" style="font-size: 1.5rem; min-width: 40px; color: #10b981;"></i>
                        <div>
                            <h4>Input Validation</h4>
                            <p>Comprehensive sanitization and regex validation to block SQL injection and XSS.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 scroll-animate">
                    <div class="glass-card-dark d-flex align-items-start gap-3">
                        <i class="fas fa-lock card-icon mt-1" style="font-size: 1.5rem; min-width: 40px; color: #10b981;"></i>
                        <div>
                            <h4>Access Control Filters</h4>
                            <p>Servlet filters intercept and verify authorization before any protected resource is served.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="section-padding" style="background: rgba(0,0,0,0.15);">
        <div class="container">
            <h2 class="section-title scroll-animate">Contact Support</h2>
            <p class="section-subtitle scroll-animate">Our technical support team is available to assist you with any inquiries or system issues.</p>
            
            <div class="row g-4 justify-content-center">
                <div class="col-md-4 scroll-animate">
                    <div class="contact-card">
                        <i class="fas fa-university"></i>
                        <h5>Institution</h5>
                        <p><c:out value="${universityName}" default="University Name" /></p>
                    </div>
                </div>
                <div class="col-md-4 scroll-animate">
                    <div class="contact-card">
                        <i class="fas fa-envelope"></i>
                        <h5>Email Support</h5>
                        <p><c:out value="${supportEmail}" default="support@university.edu" /></p>
                    </div>
                </div>
                <div class="col-md-4 scroll-animate">
                    <div class="contact-card">
                        <i class="fas fa-phone-alt"></i>
                        <h5>Helpdesk Phone</h5>
                        <p><c:out value="${supportPhone}" default="+1 234 567 890" /></p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                    <a href="#" class="navbar-brand-custom text-decoration-none" style="font-size: 1.2rem;">
                        <i class="fas fa-university"></i>
                        <span><c:out value="${systemShortName}" default="Campus Analytics" /></span>
                    </a>
                </div>
                <div class="col-md-6 text-center text-md-end footer-links">
                    <a href="#">Privacy Policy</a>
                    <a href="#">Terms & Conditions</a>
                    <a href="mailto:${supportEmail}">Contact Support</a>
                </div>
            </div>
            <div class="footer-bottom">
                <p class="mb-0">
                    &copy; ${currentYear} <c:out value="${universityName}" default="University Name" />. All rights reserved. 
                    <span class="mx-2">|</span> 
                    System Version: <c:out value="${systemVersion}" default="1.0.0 Enterprise" />
                </p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom JS for Scroll Animations & Navbar -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Navbar scroll effect
            const navbar = document.querySelector('.navbar-custom');
            window.addEventListener('scroll', function() {
                if (window.scrollY > 50) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
            });

            // Scroll Animations using IntersectionObserver
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('animate-in');
                    }
                });
            }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });

            document.querySelectorAll('.scroll-animate').forEach(el => observer.observe(el));

            // Close mobile menu on link click
            const navLinks = document.querySelectorAll('.nav-link-custom');
            const navCollapse = document.getElementById('navbarNav');
            navLinks.forEach(link => {
                link.addEventListener('click', () => {
                    if (navCollapse.classList.contains('show')) {
                        new bootstrap.Collapse(navCollapse).hide();
                    }
                });
            });
        });
    </script>
</body>
</html>