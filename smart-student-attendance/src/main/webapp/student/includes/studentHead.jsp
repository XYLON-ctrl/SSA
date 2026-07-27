<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<%-- 
  Flash Message Pattern
--%>
<c:if test="${not empty sessionScope.successMessage and empty requestScope.successMessage}">
    <c:set var="successMessage" value="${sessionScope.successMessage}" scope="request" />
</c:if>
<c:if test="${not empty sessionScope.errorMessage and empty requestScope.errorMessage}">
    <c:set var="errorMessage" value="${sessionScope.errorMessage}" scope="request" />
</c:if>
<c:if test="${not empty sessionScope.warningMessage and empty requestScope.warningMessage}">
    <c:set var="warningMessage" value="${sessionScope.warningMessage}" scope="request" />
</c:if>

<c:remove var="successMessage" scope="session" />
<c:remove var="errorMessage" scope="session" />
<c:remove var="warningMessage" scope="session" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle}" default="Student Dashboard" /> | Campus Analytics</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #2563eb;
            --secondary-blue: #1e40af;
            --accent-blue: #3b82f6;
            --sidebar-bg: #ffffff;
            --sidebar-border: #e5e7eb;
            --sidebar-text: #374151;
            --sidebar-text-muted: #6b7280;
            --sidebar-hover: #f3f4f6;
            --sidebar-active: #eff6ff;
            --navbar-bg: #ffffff;
            --navbar-border: #e5e7eb;
            --navbar-text: #111827;
            --content-bg: #f9fafb;
            --card-bg: #ffffff;
            --card-border: #e5e7eb;
            --text-dark: #111827;
            --text-muted: #6b7280;
            --text-light: #9ca3af;
            --success-color: #10b981;
            --error-color: #ef4444;
            --warning-color: #f59e0b;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        html, body { height: 100%; margin: 0; overflow-x: hidden; }

        body {
            min-height: 100vh;
            background: var(--content-bg);
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .app-wrapper {
            display: flex;
            flex: 1;
            position: relative;
            z-index: 1;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            background: var(--sidebar-bg);
            border-right: 1px solid var(--sidebar-border);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0; left: 0; bottom: 0;
            z-index: 1000;
            transition: transform 0.3s ease;
            box-shadow: var(--shadow-sm);
        }

        .sidebar-brand {
            padding: 1.5rem;
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--text-dark);
            font-weight: 700;
            font-size: 1.1rem;
            border-bottom: 1px solid var(--sidebar-border);
        }
        .sidebar-brand i { color: var(--primary-blue); font-size: 1.4rem; }

        .sidebar-menu {
            list-style: none;
            padding: 1rem 0;
            margin: 0;
            flex: 1;
            overflow-y: auto;
        }

        .sidebar-menu li { margin: 0.25rem 0.75rem; }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0.75rem 1rem;
            color: var(--sidebar-text);
            text-decoration: none;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .sidebar-menu a:hover { background: var(--sidebar-hover); color: var(--text-dark); }
        .sidebar-menu a.active { background: var(--sidebar-active); color: var(--primary-blue); font-weight: 600; }
        .sidebar-menu a i { width: 20px; text-align: center; font-size: 1rem; }

        .badge-notification {
            background: var(--error-color);
            color: white;
            font-size: 0.7rem;
            padding: 2px 6px;
            border-radius: 10px;
            margin-left: auto;
            font-weight: 600;
        }

        .main-content {
            flex: 1;
            margin-left: 260px;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background: var(--content-bg);
        }

        .top-navbar {
            background: var(--navbar-bg);
            border-bottom: 1px solid var(--navbar-border);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 900;
            box-shadow: var(--shadow-sm);
        }

        .navbar-left { display: flex; align-items: center; gap: 1rem; }
        .menu-toggle { display: none; color: var(--text-dark); font-size: 1.2rem; cursor: pointer; background: none; border: none; }
        .navbar-right { display: flex; align-items: center; gap: 1.5rem; }

        .nav-icon-btn {
            position: relative;
            color: var(--text-muted);
            font-size: 1.2rem;
            cursor: pointer;
            transition: color 0.2s;
            background: none;
            border: none;
            padding: 0.5rem;
        }
        .nav-icon-btn:hover { color: var(--primary-blue); }

        .profile-dropdown { display: flex; align-items: center; gap: 10px; cursor: pointer; }
        .profile-avatar {
            width: 38px; height: 38px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            display: flex; align-items: center; justify-content: center;
            color: white; font-weight: 600; font-size: 0.9rem;
        }
        .profile-info { color: var(--text-dark); line-height: 1.2; }
        .profile-name { font-size: 0.875rem; font-weight: 600; }
        .profile-role { font-size: 0.75rem; color: var(--text-muted); }

        .dropdown-menu-custom {
            background: white;
            border: 1px solid var(--navbar-border);
            border-radius: 12px;
            padding: 0.5rem;
            margin-top: 10px;
            min-width: 200px;
            box-shadow: var(--shadow-lg);
        }
        .dropdown-item-custom {
            color: var(--sidebar-text);
            padding: 0.6rem 1rem;
            border-radius: 8px;
            font-size: 0.875rem;
            transition: all 0.2s;
        }
        .dropdown-item-custom:hover { background: var(--sidebar-hover); color: var(--text-dark); }
        .dropdown-divider-custom { border-color: var(--navbar-border); margin: 0.5rem 0; }

        .content-area { padding: 2rem; flex: 1; }
        
        .glass-card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }

        .glass-card-dark {
            background: var(--sidebar-bg);
            border: 1px solid var(--sidebar-border);
            border-radius: 16px;
            padding: 1.5rem;
            color: var(--text-dark);
            box-shadow: var(--shadow);
        }

        .page-header { margin-bottom: 2rem; }
        .page-title { color: var(--text-dark); font-weight: 700; font-size: 1.75rem; margin-bottom: 0.5rem; }
        .page-subtitle { color: var(--text-muted); font-size: 0.95rem; }

        .custom-alert { 
            border-radius: 12px; 
            border: none; 
            padding: 1rem 1.2rem; 
            font-size: 0.9rem; 
            margin-bottom: 1.5rem; 
            display: flex; 
            align-items: center; 
            gap: 12px;
            box-shadow: var(--shadow-md);
            animation: slideIn 0.3s ease-out;
            transition: all 0.3s ease;
        }
        
        .custom-alert.hiding { animation: slideOut 0.3s ease-out forwards; }
        
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes slideOut {
            from { opacity: 1; transform: translateY(0); }
            to { opacity: 0; transform: translateY(-20px); }
        }
        
        .alert-error { background-color: #fef2f2; color: #991b1b; border-left: 4px solid var(--error-color); }
        .alert-success { background-color: #f0fdf4; color: #166534; border-left: 4px solid var(--success-color); }
        .alert-warning { background-color: #fffbeb; color: #92400e; border-left: 4px solid var(--warning-color); }

        .footer {
            text-align: center; padding: 1.5rem 2rem;
            color: var(--text-muted); font-size: 0.85rem;
            border-top: 1px solid var(--navbar-border);
            background: white;
        }
        .footer a { color: var(--text-muted); text-decoration: none; margin: 0 8px; }
        .footer a:hover { color: var(--primary-blue); }

        @media (max-width: 991px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.show { transform: translateX(0); box-shadow: var(--shadow-lg); }
            .main-content { margin-left: 0; }
            .menu-toggle { display: block; }
            .profile-info { display: none; }
            .content-area { padding: 1.5rem; }
        }

        @media (max-width: 576px) {
            .glass-card { padding: 1.5rem; border-radius: 12px; }
            .top-navbar { padding: 1rem; }
        }
    </style>
</head>
<body>