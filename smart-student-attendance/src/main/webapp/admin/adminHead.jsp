<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle}" default="Admin Panel" /> | Campus Analytics</title>
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-blue: #3b82f6;
            --accent-blue: #60a5fa;
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            --warning-gradient: linear-gradient(135deg, #f59e0b 0%, #f97316 100%);
            --danger-gradient: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            --info-gradient: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            --text-dark: #1f2937;
            --text-muted: #6b7280;
            --card-border: #e5e7eb;
            --bg-light: #f9fafb;
            --shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
            --shadow-md: 0 8px 32px rgba(0, 0, 0, 0.1);
            --radius-lg: 16px;
            --radius-md: 12px;
            --radius-sm: 8px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f3f4f6; color: var(--text-dark); }

        /* App Layout */
        .app-wrapper { display: flex; min-height: 100vh; }
        
        /* Sidebar */
        .sidebar {
            width: 260px;
            background: white;
            border-right: 1px solid var(--card-border);
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 100;
        }
        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--card-border);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        .sidebar-logo {
            width: 40px; height: 40px;
            background: var(--primary-gradient);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: white; font-size: 1.25rem;
        }
        .sidebar-title { font-size: 1.1rem; font-weight: 700; color: var(--text-dark); }
        .sidebar-nav { padding: 1rem 0; }
        .nav-item { margin: 0.25rem 1rem; }
        .nav-link {
            display: flex; align-items: center; gap: 0.75rem;
            padding: 0.75rem 1rem;
            color: var(--text-muted);
            text-decoration: none;
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        .nav-link:hover { background: var(--bg-light); color: var(--text-dark); }
        .nav-link.active {
            background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
            color: var(--primary-blue);
            font-weight: 600;
        }
        .nav-link i { width: 20px; text-align: center; font-size: 1rem; }
        .nav-divider { height: 1px; background: var(--card-border); margin: 1rem; }
        .nav-link.logout { color: #ef4444; }
        .nav-link.logout:hover { background: #fef2f2; }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 260px;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Navbar */
        .navbar-custom {
            background: white;
            border-bottom: 1px solid var(--card-border);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 50;
        }
        .navbar-title { font-size: 1.25rem; font-weight: 700; color: var(--text-dark); }
        .navbar-right { display: flex; align-items: center; gap: 1.5rem; }
        .user-profile {
            display: flex; align-items: center; gap: 0.75rem;
            cursor: pointer;
        }
        .user-avatar {
            width: 40px; height: 40px;
            border-radius: 50%;
            background: var(--primary-gradient);
            display: flex; align-items: center; justify-content: center;
            color: white; font-weight: 700;
        }
        .user-name { font-weight: 600; font-size: 0.9rem; }
        .user-role { font-size: 0.75rem; color: var(--text-muted); }

        /* Content Area */
        .content-area { padding: 2rem; flex: 1; }

        /* Footer */
        .footer {
            background: white;
            border-top: 1px solid var(--card-border);
            padding: 1rem 2rem;
            text-align: center;
            color: var(--text-muted);
            font-size: 0.85rem;
        }

        /* ===== ADMIN-SPECIFIC COMPONENTS ===== */
        
        /* Hero Section */
        .hero-section {
            background: var(--primary-gradient);
            border-radius: var(--radius-lg);
            padding: 2rem 2.5rem;
            margin-bottom: 1.5rem;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-md);
        }
        .hero-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -5%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }
        .hero-content { position: relative; z-index: 1; display: flex; align-items: center; gap: 1.5rem; }
        .hero-icon {
            width: 60px; height: 60px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            backdrop-filter: blur(10px);
            font-size: 1.75rem;
        }
        .hero-text h1 { font-size: 2rem; font-weight: 700; margin-bottom: 0.25rem; }
        .hero-text p { font-size: 0.95rem; opacity: 0.95; margin: 0; }

        /* Glass Cards */
        .glass-card {
            background: white;
            border-radius: var(--radius-lg);
            border: 1px solid var(--card-border);
            box-shadow: var(--shadow);
            padding: 1.75rem;
            margin-bottom: 1.5rem;
        }

        /* KPI Cards */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .kpi-card {
            background: white;
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            border: 1px solid var(--card-border);
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .kpi-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 4px;
        }
        .kpi-card.blue::before { background: var(--info-gradient); }
        .kpi-card.green::before { background: var(--success-gradient); }
        .kpi-card.orange::before { background: var(--warning-gradient); }
        .kpi-card.purple::before { background: var(--primary-gradient); }
        .kpi-card.red::before { background: var(--danger-gradient); }
        .kpi-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-md); }
        .kpi-icon {
            width: 48px; height: 48px;
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.25rem;
            margin-bottom: 1rem;
        }
        .kpi-card.blue .kpi-icon { background: #dbeafe; color: #2563eb; }
        .kpi-card.green .kpi-icon { background: #d1fae5; color: #059669; }
        .kpi-card.orange .kpi-icon { background: #fef3c7; color: #d97706; }
        .kpi-card.purple .kpi-icon { background: #e0e7ff; color: #6366f1; }
        .kpi-card.red .kpi-icon { background: #fee2e2; color: #dc2626; }
        .kpi-label {
            font-size: 0.75rem; font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase; letter-spacing: 0.5px;
            margin-bottom: 0.5rem;
        }
        .kpi-value { font-size: 2rem; font-weight: 700; color: var(--text-dark); }
        .kpi-sublabel { font-size: 0.8rem; color: var(--text-muted); margin-top: 0.25rem; }

        /* Data Table */
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th {
            padding: 0.875rem 1rem;
            text-align: left;
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: var(--bg-light);
            border-bottom: 2px solid var(--card-border);
        }
        .data-table tbody tr { border-bottom: 1px solid var(--card-border); transition: background 0.2s ease; }
        .data-table tbody tr:hover { background: var(--bg-light); }
        .data-table tbody tr:last-child { border-bottom: none; }
        .data-table tbody td { padding: 1rem; font-size: 0.9rem; color: var(--text-dark); vertical-align: middle; }

        /* Action Buttons */
        .btn-action {
            padding: 0.4rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            text-decoration: none;
        }
        .btn-edit { background: #dbeafe; color: #1e40af; }
        .btn-edit:hover { background: #1e40af; color: white; }
        .btn-delete { background: #fee2e2; color: #991b1b; }
        .btn-delete:hover { background: #991b1b; color: white; }
        .btn-view { background: #d1fae5; color: #065f46; }
        .btn-view:hover { background: #065f46; color: white; }

        /* Primary Button */
        .btn-primary-custom {
            background: var(--primary-gradient);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
            color: white;
        }

        /* Alerts */
        .custom-alert {
            border-radius: var(--radius-md);
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: slideDown 0.4s ease-out;
            box-shadow: var(--shadow);
            transition: opacity 0.5s ease;
        }
        .custom-alert.fade-out { opacity: 0; }
        .alert-error { background: #fef2f2; color: #991b1b; border-left: 4px solid #ef4444; }
        .alert-success { background: #f0fdf4; color: #166534; border-left: 4px solid #10b981; }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }

        /* Modal */
        .modal-custom .modal-content {
            border-radius: var(--radius-lg);
            border: none;
            box-shadow: var(--shadow-md);
        }
        .modal-custom .modal-header {
            background: var(--bg-light);
            border-bottom: 2px solid var(--card-border);
            padding: 1.25rem 1.5rem;
        }
        .modal-custom .modal-title { font-weight: 700; color: var(--text-dark); }
        .modal-custom .modal-body { padding: 1.5rem; }
        .modal-custom .modal-footer {
            border-top: 2px solid var(--card-border);
            padding: 1rem 1.5rem;
        }

        /* Form Controls */
        .form-label-custom {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.4rem;
        }
        .form-control-custom {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid var(--card-border);
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            transition: all 0.2s ease;
        }
        .form-control-custom:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        /* Badge */
        .badge-custom {
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .badge-success { background: #d1fae5; color: #065f46; }
        .badge-warning { background: #fef3c7; color: #92400e; }
        .badge-danger { background: #fee2e2; color: #991b1b; }
        .badge-info { background: #dbeafe; color: #1e40af; }

        /* Responsive */
        @media (max-width: 992px) {
            .sidebar { transform: translateX(-100%); transition: transform 0.3s ease; }
            .sidebar.show { transform: translateX(0); }
            .main-content { margin-left: 0; }
            .kpi-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 576px) {
            .kpi-grid { grid-template-columns: 1fr; }
            .content-area { padding: 1rem; }
        }
    </style>
</head>
<body>