<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<%-- Flash Message Handling --%>
<c:if test="${not empty sessionScope.successMessage and empty requestScope.successMessage}">
    <c:set var="successMessage" value="${sessionScope.successMessage}" scope="request" />
</c:if>
<c:if test="${not empty sessionScope.errorMessage and empty requestScope.errorMessage}">
    <c:set var="errorMessage" value="${sessionScope.errorMessage}" scope="request" />
</c:if>
<c:remove var="successMessage" scope="session" />
<c:remove var="errorMessage" scope="session" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle}" default="Faculty Dashboard" /> | Campus Analytics</title>
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
            --sidebar-hover: #f3f4f6;
            --sidebar-active: #eff6ff;
            --navbar-bg: #ffffff;
            --navbar-border: #e5e7eb;
            --content-bg: #f9fafb;
            --card-bg: #ffffff;
            --card-border: #e5e7eb;
            --text-dark: #111827;
            --text-muted: #6b7280;
            --success-color: #10b981;
            --error-color: #ef4444;
            --warning-color: #f59e0b;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { min-height: 100vh; background: var(--content-bg); display: flex; flex-direction: column; }
        .app-wrapper { display: flex; flex: 1; min-height: 100vh; }
        
        /* Sidebar */
        .sidebar { width: 260px; background: var(--sidebar-bg); border-right: 1px solid var(--sidebar-border); position: fixed; top: 0; left: 0; bottom: 0; z-index: 1000; display: flex; flex-direction: column; }
        .sidebar-brand { padding: 1.5rem; font-weight: 700; font-size: 1.1rem; border-bottom: 1px solid var(--sidebar-border); display: flex; align-items: center; gap: 10px; color: var(--text-dark); }
        .sidebar-brand i { color: var(--primary-blue); font-size: 1.4rem; }
        .sidebar-menu { list-style: none; padding: 1rem 0; flex: 1; overflow-y: auto; }
        .sidebar-menu li { margin: 0.25rem 0.75rem; }
        .sidebar-menu a { display: flex; align-items: center; gap: 12px; padding: 0.75rem 1rem; color: var(--sidebar-text); text-decoration: none; border-radius: 8px; font-size: 0.875rem; font-weight: 500; transition: all 0.2s; }
        .sidebar-menu a:hover { background: var(--sidebar-hover); }
        .sidebar-menu a.active { background: var(--sidebar-active); color: var(--primary-blue); font-weight: 600; }
        .sidebar-menu a i { width: 20px; text-align: center; }

        /* Main Content */
        .main-content { flex: 1; margin-left: 260px; display: flex; flex-direction: column; min-height: 100vh; }
        .top-navbar { background: var(--navbar-bg); border-bottom: 1px solid var(--navbar-border); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 900; }
        .content-area { padding: 2rem; flex: 1; }
        
        /* Cards & Utilities */
        .glass-card { background: var(--card-bg); border: 1px solid var(--card-border); border-radius: 16px; padding: 1.5rem; box-shadow: var(--shadow); margin-bottom: 1.5rem; }
        .page-title { color: var(--text-dark); font-weight: 700; font-size: 1.5rem; margin-bottom: 0.5rem; }
        .page-subtitle { color: var(--text-muted); font-size: 0.9rem; }
        .section-header { font-weight: 600; font-size: 1rem; color: var(--text-dark); margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem; }
        
        /* Alerts */
        .custom-alert { border-radius: 12px; padding: 1rem; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 10px; font-size: 0.9rem; animation: slideIn 0.3s ease; }
        .alert-error { background: #fef2f2; color: #991b1b; border-left: 4px solid var(--error-color); }
        .alert-success { background: #f0fdf4; color: #166534; border-left: 4px solid var(--success-color); }
        @keyframes slideIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        /* Profile Dropdown */
        .profile-dropdown { display: flex; align-items: center; gap: 10px; cursor: pointer; }
        .profile-avatar { width: 38px; height: 38px; border-radius: 50%; background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue)); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; }
        .dropdown-menu-custom { border-radius: 12px; box-shadow: var(--shadow-md); border: 1px solid var(--navbar-border); }
        
        .footer { text-align: center; padding: 1.5rem; color: var(--text-muted); font-size: 0.85rem; border-top: 1px solid var(--navbar-border); background: white; margin-top: auto; }
    </style>
</head>
<body>