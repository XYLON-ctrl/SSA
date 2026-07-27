<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Dashboard" scope="request" />
<%@ include file="facultyHead.jsp" %>

<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        --warning-gradient: linear-gradient(135deg, #f59e0b 0%, #f97316 100%);
        --danger-gradient: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        --info-gradient: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        --shadow-soft: 0 8px 32px rgba(0, 0, 0, 0.08);
        --shadow-hover: 0 12px 48px rgba(0, 0, 0, 0.12);
        --radius-xl: 20px;
        --radius-lg: 16px;
        --radius-md: 12px;
    }

    .dashboard-container {
	    width: 100%;
	    max-width: 1800px;
	    margin: 0 auto;
	    padding: 2rem;
    }

    /* ===== ALERTS ===== */
    .custom-alert {
        border-radius: var(--radius-md);
        padding: 1rem 1.25rem;
        font-size: 0.9rem;
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        animation: slideDown 0.4s ease-out;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        transition: opacity 0.5s ease, transform 0.5s ease;
    }
    .custom-alert.fade-out { opacity: 0; transform: translateY(-10px); }
    .alert-error { background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%); color: #991b1b; border-left: 4px solid #ef4444; }
    .alert-success { background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%); color: #166534; border-left: 4px solid #10b981; }
    @keyframes slideDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }

    /* ===== HERO WELCOME ===== */
    .hero-welcome {
        background: var(--primary-gradient);
        border-radius: var(--radius-xl);
        padding: 2.5rem;
        margin-bottom: 2rem;
        color: white;
        position: relative;
        overflow: hidden;
        box-shadow: var(--shadow-soft);
    }

    .hero-welcome::before {
        content: '';
        position: absolute;
        top: -50%;
        right: -10%;
        width: 500px;
        height: 500px;
        background: rgba(255, 255, 255, 0.08);
        border-radius: 50%;
    }

    .hero-welcome::after {
        content: '';
        position: absolute;
        bottom: -40%;
        left: 30%;
        width: 300px;
        height: 300px;
        background: rgba(255, 255, 255, 0.05);
        border-radius: 50%;
    }

    .hero-content {
        position: relative;
        z-index: 1;
        display: flex;
        align-items: center;
        gap: 2rem;
        flex-wrap: wrap;
    }

    .hero-avatar {
        width: 90px;
        height: 90px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.2);
        backdrop-filter: blur(10px);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 2.25rem;
        border: 3px solid rgba(255, 255, 255, 0.3);
        flex-shrink: 0;
    }

    .hero-info { flex: 1; min-width: 250px; }

    .hero-greeting {
        font-size: 0.9rem;
        opacity: 0.85;
        margin-bottom: 0.25rem;
        font-weight: 500;
    }

    .hero-name {
        font-size: 2rem;
        font-weight: 700;
        margin: 0 0 0.5rem 0;
    }

    .hero-designation {
        font-size: 1rem;
        opacity: 0.9;
        margin-bottom: 1rem;
    }

    .hero-meta {
        display: flex;
        gap: 0.75rem;
        flex-wrap: wrap;
    }

    .hero-chip {
        background: rgba(255, 255, 255, 0.2);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.25);
        border-radius: 50px;
        padding: 0.5rem 1rem;
        font-size: 0.85rem;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
    }

    .hero-date {
        position: relative;
        z-index: 1;
        text-align: right;
        flex-shrink: 0;
    }

    .hero-date-day {
        font-size: 3rem;
        font-weight: 700;
        line-height: 1;
        margin-bottom: 0.25rem;
    }

    .hero-date-month {
        font-size: 1.1rem;
        font-weight: 600;
        opacity: 0.9;
    }

    .hero-date-weekday {
        font-size: 0.9rem;
        opacity: 0.75;
        margin-top: 0.25rem;
    }

    /* ===== KPI CARDS ===== */
    .kpi-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .kpi-card {
        background: white;
        border-radius: var(--radius-lg);
        padding: 1.75rem;
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }

    .kpi-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 4px;
    }

    .kpi-card.blue::before { background: var(--info-gradient); }
    .kpi-card.green::before { background: var(--success-gradient); }
    .kpi-card.orange::before { background: var(--warning-gradient); }
    .kpi-card.purple::before { background: var(--primary-gradient); }

    .kpi-card:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-hover);
    }

    .kpi-icon {
        width: 52px;
        height: 52px;
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.4rem;
        margin-bottom: 1rem;
    }

    .kpi-card.blue .kpi-icon { background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); color: #2563eb; }
    .kpi-card.green .kpi-icon { background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #059669; }
    .kpi-card.orange .kpi-icon { background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #d97706; }
    .kpi-card.purple .kpi-icon { background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%); color: #6366f1; }

    .kpi-label {
        font-size: 0.75rem;
        font-weight: 700;
        color: #6b7280;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 0.35rem;
    }

    .kpi-value {
        font-size: 2rem;
        font-weight: 700;
        color: #111827;
        line-height: 1;
    }

    .kpi-sublabel {
        font-size: 0.8rem;
        color: #9ca3af;
        margin-top: 0.35rem;
    }

    /* ===== MAIN GRID ===== */
    .main-grid {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 1.5rem;
        margin-bottom: 1.5rem;
    }

    /* ===== CARD STYLES ===== */
    .dash-card {
        background: white;
        border-radius: var(--radius-lg);
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        overflow: hidden;
        margin-bottom: 1.5rem;
    }

    .dash-card-header {
        padding: 1.25rem 1.5rem;
        border-bottom: 2px solid #f3f4f6;
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
    }

    .dash-card-title {
        font-size: 1rem;
        font-weight: 700;
        color: #111827;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.6rem;
    }

    .dash-card-title i { color: #667eea; }

    .dash-card-body { padding: 1.5rem; }

    .dash-card-link {
        font-size: 0.8rem;
        color: #667eea;
        text-decoration: none;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 0.3rem;
        transition: all 0.2s ease;
    }

    .dash-card-link:hover {
        color: #764ba2;
        gap: 0.5rem;
    }

    /* ===== TODAY'S SCHEDULE TABLE ===== */
    .schedule-table {
        width: 100%;
        border-collapse: collapse;
    }

    .schedule-table thead th {
        padding: 0.75rem 1.25rem;
        text-align: left;
        font-size: 0.7rem;
        font-weight: 700;
        color: #9ca3af;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        background: #f9fafb;
        border-bottom: 1px solid #e5e7eb;
    }

    .schedule-table tbody tr {
        transition: all 0.2s ease;
        border-bottom: 1px solid #f3f4f6;
    }

    .schedule-table tbody tr:hover {
        background: linear-gradient(135deg, #f0f9ff 0%, #faf5ff 100%);
    }

    .schedule-table tbody tr:last-child { border-bottom: none; }

    .schedule-table tbody td {
        padding: 1rem 1.25rem;
        font-size: 0.9rem;
        color: #111827;
    }

    .subject-name-cell {
        font-weight: 600;
        color: #111827;
    }

    .subject-section {
        font-size: 0.75rem;
        color: #6b7280;
        margin-top: 0.15rem;
    }

    .time-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #1e40af;
        padding: 0.4rem 0.85rem;
        border-radius: 50px;
        font-size: 0.8rem;
        font-weight: 600;
        border: 1px solid #bfdbfe;
    }

    .room-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        background: #f3f4f6;
        color: #374151;
        padding: 0.4rem 0.85rem;
        border-radius: 50px;
        font-size: 0.8rem;
        font-weight: 600;
    }

    /* ===== EMPTY STATE ===== */
    .empty-state {
        text-align: center;
        padding: 3rem 2rem;
    }

    .empty-icon {
        width: 80px;
        height: 80px;
        margin: 0 auto 1rem;
        background: linear-gradient(135deg, #f0f9ff 0%, #faf5ff 100%);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2rem;
        color: #667eea;
    }

    .empty-title {
        font-size: 1rem;
        font-weight: 700;
        color: #111827;
        margin: 0 0 0.25rem 0;
    }

    .empty-text {
        font-size: 0.85rem;
        color: #6b7280;
        margin: 0;
    }

    /* ===== TIMELINE ===== */
    .timeline {
        position: relative;
        padding-left: 1.75rem;
    }

    .timeline::before {
        content: '';
        position: absolute;
        left: 0.5rem;
        top: 0.5rem;
        bottom: 0.5rem;
        width: 2px;
        background: linear-gradient(to bottom, #667eea, #e5e7eb);
    }

    .timeline-item {
        position: relative;
        padding-bottom: 1.25rem;
    }

    .timeline-item:last-child { padding-bottom: 0; }

    .timeline-item::before {
        content: '';
        position: absolute;
        left: -1.5rem;
        top: 0.35rem;
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background: var(--primary-gradient);
        border: 2px solid white;
        box-shadow: 0 0 0 2px #667eea;
    }

    .timeline-date {
        font-size: 0.7rem;
        color: #9ca3af;
        margin-bottom: 0.2rem;
        font-weight: 500;
    }

    .timeline-text {
        font-size: 0.85rem;
        color: #111827;
        font-weight: 500;
        line-height: 1.4;
    }

    .timeline-action {
        display: inline-block;
        font-size: 0.7rem;
        font-weight: 700;
        color: #667eea;
        text-transform: uppercase;
        letter-spacing: 0.3px;
        margin-bottom: 0.15rem;
    }

    /* ===== LEAVE REQUEST ITEM ===== */
		.pending-approvals-container {
		    max-height: 320px;
		    overflow-y: auto;
		    padding-right: 0.5rem;
		}
		
		.pending-approvals-container::-webkit-scrollbar {
		    width: 6px;
		}
		
		.pending-approvals-container::-webkit-scrollbar-track {
		    background: #f1f5f9;
		    border-radius: 10px;
		}
		
		.pending-approvals-container::-webkit-scrollbar-thumb {
		    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		    border-radius: 10px;
		}
		
		.pending-approvals-container::-webkit-scrollbar-thumb:hover {
		    background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
		}

    .leave-item {
        padding: 1rem;
        border-radius: var(--radius-md);
        background: #f9fafb;
        margin-bottom: 0.75rem;
        border: 1px solid #e5e7eb;
        transition: all 0.2s ease;
    }

    .leave-item:hover {
        background: white;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    }

    .leave-item:last-child { margin-bottom: 0; }

    .leave-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 0.5rem;
    }

    .leave-student {
        display: flex;
        align-items: center;
        gap: 0.6rem;
    }

    .leave-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background: var(--primary-gradient);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 0.85rem;
        flex-shrink: 0;
    }

    .leave-name {
        font-weight: 600;
        color: #111827;
        font-size: 0.85rem;
        margin: 0;
    }

    .leave-meta {
        font-size: 0.7rem;
        color: #6b7280;
    }

    .leave-duration {
        display: inline-flex;
        align-items: center;
        gap: 0.3rem;
        background: white;
        padding: 0.2rem 0.6rem;
        border-radius: 50px;
        font-size: 0.7rem;
        font-weight: 600;
        color: #6b7280;
        border: 1px solid #e5e7eb;
    }

    .leave-reason {
        font-size: 0.8rem;
        color: #6b7280;
        margin: 0.5rem 0;
        font-style: italic;
    }

    .leave-actions {
        display: flex;
        gap: 0.5rem;
        margin-top: 0.75rem;
    }

    .leave-btn {
        flex: 1;
        padding: 0.45rem 0.75rem;
        border-radius: 50px;
        font-size: 0.75rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        border: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.3rem;
    }

    .leave-btn.approve {
        background: var(--success-gradient);
        color: white;
    }

    .leave-btn.reject {
        background: white;
        color: #ef4444;
        border: 1.5px solid #fecaca;
    }

    .leave-btn:hover { transform: translateY(-1px); }
    
    /* ===== WORKLOAD OVERVIEW GRID ===== */
	.workload-grid {
	    display: grid;
	    grid-template-columns: repeat(2, 1fr);
	    gap: 1rem;
	}
	
	.workload-square-card {
	    background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
	    border-radius: var(--radius-lg);
	    padding: 1.5rem;
	    border: 1px solid #e2e8f0;
	    transition: all 0.3s ease;
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    justify-content: center;
	    gap: 0.75rem;
	    min-height: 120px;
	}
	
	.workload-square-card:hover {
	    transform: translateY(-4px);
	    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
	    border-color: #667eea;
	}
	
	.workload-square-icon {
	    width: 48px;
	    height: 48px;
	    border-radius: var(--radius-md);
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    font-size: 1.4rem;
	}
	
	.workload-square-card.blue .workload-square-icon { 
	    background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); 
	    color: #2563eb; 
	}
	
	.workload-square-card.green .workload-square-icon { 
	    background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); 
	    color: #059669; 
	}
	
	.workload-square-card.orange .workload-square-icon { 
	    background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); 
	    color: #d97706; 
	}
	
	.workload-square-card.purple .workload-square-icon { 
	    background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%); 
	    color: #6366f1; 
	}
	
	.workload-square-value {
	    font-size: 1.75rem;
	    font-weight: 700;
	    color: #111827;
	    line-height: 1;
	}
	
	.workload-square-label {
	    font-size: 0.75rem;
	    color: #6b7280;
	    font-weight: 600;
	    text-align: center;
	}

    /* ===== SUBJECTS CHIPS ===== */
    .subjects-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 0.6rem;
    }

    .subject-chip {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        padding: 0.5rem 1rem;
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #1e40af;
        border-radius: 50px;
        font-size: 0.8rem;
        font-weight: 600;
        border: 1px solid #bfdbfe;
        transition: all 0.2s ease;
    }

    .subject-chip:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.15);
    }

    /* ===== QUICK ACTIONS ===== */
    .quick-actions {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 0.75rem;
    }

    .quick-action-btn {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 0.5rem;
        padding: 1.25rem 1rem;
        background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
        border: 1px solid #e5e7eb;
        border-radius: var(--radius-md);
        text-decoration: none;
        color: #374151;
        transition: all 0.3s ease;
        text-align: center;
    }

    .quick-action-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
        border-color: #667eea;
        color: #667eea;
    }

    .quick-action-icon {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #3b82f6;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1rem;
    }

    .quick-action-label {
        font-size: 0.8rem;
        font-weight: 600;
    }

    /* ===== RESPONSIVE ===== */
    @media (max-width: 1200px) {
        .main-grid { grid-template-columns: 1fr; }
        .kpi-grid { grid-template-columns: repeat(2, 1fr); }
    }

    @media (max-width: 768px) {
        .dashboard-container { padding: 1rem; }
        .hero-welcome { padding: 1.5rem; }
        .hero-content { flex-direction: column; text-align: center; }
        .hero-date { text-align: center; }
        .hero-meta { justify-content: center; }
        .kpi-grid { grid-template-columns: 1fr; }
        .quick-actions { grid-template-columns: 1fr; }
    }
</style>

<div class="app-wrapper">
    <%@ include file="facultySidebar.jsp" %>
    <div class="main-content">
        <%@ include file="facultyNavbar.jsp" %>

        <div class="dashboard-container">

            <!-- Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="custom-alert alert-error" id="serverAlert">
                    <i class="fas fa-exclamation-circle"></i> <c:out value="${errorMessage}" />
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="custom-alert alert-success" id="serverAlert">
                    <i class="fas fa-check-circle"></i> <c:out value="${successMessage}" />
                </div>
            </c:if>

            <!-- Hero Welcome -->
            <div class="hero-welcome">
                <div class="hero-content">
                    <div class="hero-avatar">
                        <c:out value="${fn:substring(profile.fullName, 0, 1)}" default="F" />
                    </div>
                    <div class="hero-info">
                        <div class="hero-greeting">
                            <i class="fas fa-hand-sparkles me-1"></i>
                            Welcome back
                        </div>
                        <h1 class="hero-name"><c:out value="${profile.fullName}" default="Faculty" /></h1>
                        <div class="hero-designation">
                            <c:out value="${profile.designation}" default="Professor" /> • 
                            <c:out value="${profile.department}" default="Department" />
                        </div>
                        <div class="hero-meta">
                            <span class="hero-chip">
                                <i class="fas fa-id-card"></i>
                                <c:out value="${profile.employeeId}" default="N/A" />
                            </span>
                            <span class="hero-chip">
                                <i class="fas fa-graduation-cap"></i>
                                <c:out value="${workload.subjectsAssigned}" default="0" /> Subjects
                            </span>
                            <span class="hero-chip">
                                <i class="fas fa-users"></i>
                                <c:out value="${totalStudents}" default="0" /> Students
                            </span>
                        </div>
                    </div>
                    <div class="hero-date">
					    <div class="hero-date-day">
					        <fmt:formatDate value="${todayDate}" pattern="dd" />
					    </div>
					    <div class="hero-date-month">
					        <fmt:formatDate value="${todayDate}" pattern="MMM yyyy" />
					    </div>
					    <div class="hero-date-weekday">
					        <fmt:formatDate value="${todayDate}" pattern="EEEE" />
					    </div>
					</div>
                </div>
            </div>

            <!-- KPI Cards -->
            <div class="kpi-grid">
                <div class="kpi-card blue">
                    <div class="kpi-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                    <div class="kpi-label">Classes Today</div>
                    <div class="kpi-value"><c:out value="${todayClasses}" default="0" /></div>
                    <div class="kpi-sublabel"><c:out value="${workload.classesPerWeek}" default="0" /> per week</div>
                </div>
                <div class="kpi-card green">
                    <div class="kpi-icon"><i class="fas fa-users"></i></div>
                    <div class="kpi-label">Total Students</div>
                    <div class="kpi-value"><c:out value="${totalStudents}" default="0" /></div>
                    <div class="kpi-sublabel">Across <c:out value="${workload.sectionsHandling}" default="0" /> sections</div>
                </div>
                <div class="kpi-card orange">
                    <div class="kpi-icon"><i class="fas fa-clock"></i></div>
                    <div class="kpi-label">Pending Leaves</div>
                    <div class="kpi-value"><c:out value="${pendingLeaves}" default="0" /></div>
                    <div class="kpi-sublabel">Awaiting review</div>
                </div>
                <div class="kpi-card purple">
                    <div class="kpi-icon"><i class="fas fa-clipboard-check"></i></div>
                    <div class="kpi-label">Attendance Sessions</div>
                    <div class="kpi-value"><c:out value="${workload.attendanceSessions}" default="0" /></div>
                    <div class="kpi-sublabel">Total marked</div>
                </div>
            </div>

            <!-- Main Grid: Schedule + Sidebar -->
            <div class="main-grid">
                <!-- LEFT COLUMN -->
                <div>
                    <!-- Today's Schedule -->
                    <div class="dash-card">
                        <div class="dash-card-header">
                            <h3 class="dash-card-title">
                                <i class="fas fa-calendar-day"></i>
                                Today's Schedule
                            </h3>
                            <a href="${pageContext.request.contextPath}/faculty/timetable" class="dash-card-link">
                                View Full Timetable <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                        <c:choose>
                            <c:when test="${not empty todayTimetable}">
                                <table class="schedule-table">
                                    <thead>
                                        <tr>
                                            <th>Subject</th>
                                            <th>Time</th>
                                            <th>Section</th>
                                            <th>Room</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="entry" items="${todayTimetable}">
                                            <tr>
                                                <td>
                                                    <div class="subject-name-cell"><c:out value="${entry.subjectName}" /></div>
                                                </td>
                                                <td>
                                                    <span class="time-badge">
                                                        <i class="far fa-clock"></i>
                                                        <c:set var="s" value="${fn:substring(entry.startTime, 0, 5)}" />
                                                        <c:set var="e" value="${fn:substring(entry.endTime, 0, 5)}" />
                                                        <c:out value="${s}" /> - <c:out value="${e}" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <span style="font-size: 0.85rem; color: #6b7280; font-weight: 500;">
                                                        <c:out value="${entry.sectionName}" default="N/A" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="room-badge">
                                                        <i class="fas fa-door-open"></i>
                                                        <c:out value="${entry.roomNumber}" default="—" />
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-icon"><i class="fas fa-coffee"></i></div>
                                    <h4 class="empty-title">No Classes Today</h4>
                                    <p class="empty-text">Enjoy your free day! You have a full schedule on other days.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Recent Activity -->
                    <div class="dash-card">
                        <div class="dash-card-header">
                            <h3 class="dash-card-title">
                                <i class="fas fa-history"></i>
                                Recent Activity
                            </h3>
                        </div>
                        <div class="dash-card-body">
                            <c:choose>
                                <c:when test="${not empty recentActivities}">
                                    <div class="timeline">
                                        <c:forEach var="activity" items="${recentActivities}" varStatus="status">
                                            <c:if test="${status.index < 6}">
                                                <div class="timeline-item">
                                                    <div class="timeline-date">
                                                        <fmt:formatDate value="${activity.timestamp}" pattern="dd MMM yyyy, hh:mm a" />
                                                    </div>
                                                    <div class="timeline-action"><c:out value="${activity.actionType}" /></div>
                                                    <div class="timeline-text"><c:out value="${activity.description}" /></div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="empty-icon"><i class="fas fa-history"></i></div>
                                        <h4 class="empty-title">No Recent Activity</h4>
                                        <p class="empty-text">Your recent actions will appear here.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Assigned Subjects -->
                    <div class="dash-card">
                        <div class="dash-card-header">
                            <h3 class="dash-card-title">
                                <i class="fas fa-book"></i>
                                Assigned Subjects
                            </h3>
                            <span style="font-size: 0.8rem; color: #6b7280; font-weight: 600;">
                                <c:out value="${fn:length(assignedSubjects)}" default="0" /> subjects
                            </span>
                        </div>
                        <div class="dash-card-body">
                            <c:choose>
                                <c:when test="${not empty assignedSubjects}">
                                    <div class="subjects-grid">
                                        <c:forEach var="subject" items="${assignedSubjects}">
                                            <span class="subject-chip">
                                                <i class="fas fa-book"></i>
                                                <c:out value="${subject.subjectName}" />
                                                <span style="opacity: 0.7; font-weight: 500;">(Sem <c:out value="${subject.semester}" />)</span>
                                            </span>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="empty-icon"><i class="fas fa-book"></i></div>
                                        <h4 class="empty-title">No Subjects Assigned</h4>
                                        <p class="empty-text">Contact the administration to get subjects assigned.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- RIGHT COLUMN -->
                <div>
                    <!-- Quick Actions -->
                    <div class="dash-card">
                        <div class="dash-card-header">
                            <h3 class="dash-card-title">
                                <i class="fas fa-bolt"></i>
                                Quick Actions
                            </h3>
                        </div>
                        <div class="dash-card-body">
                            <div class="quick-actions">
                                <a href="${pageContext.request.contextPath}/faculty/attendance" class="quick-action-btn">
                                    <div class="quick-action-icon"><i class="fas fa-clipboard-check"></i></div>
                                    <span class="quick-action-label">Mark Attendance</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/faculty/marks" class="quick-action-btn">
                                    <div class="quick-action-icon" style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #d97706;"><i class="fas fa-graduation-cap"></i></div>
                                    <span class="quick-action-label">Enter Marks</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/faculty/students" class="quick-action-btn">
                                    <div class="quick-action-icon" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #059669;"><i class="fas fa-users"></i></div>
                                    <span class="quick-action-label">My Students</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/faculty/leave-approval" class="quick-action-btn">
                                    <div class="quick-action-icon" style="background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%); color: #6366f1;"><i class="fas fa-file-signature"></i></div>
                                    <span class="quick-action-label">Leave Requests</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Pending Leave Approvals -->
					<div class="dash-card">
					    <div class="dash-card-header">
					        <h3 class="dash-card-title">
					            <i class="fas fa-file-signature"></i>
					            Pending Approvals
					        </h3>
					        <c:if test="${pendingLeaves > 0}">
					            <span style="background: var(--warning-gradient); color: white; padding: 0.2rem 0.6rem; border-radius: 50px; font-size: 0.75rem; font-weight: 700;">
					                <c:out value="${pendingLeaves}" />
					            </span>
					        </c:if>
					    </div>
					    <div class="dash-card-body" style="padding: 1rem;">
					        <c:choose>
					            <c:when test="${not empty pendingLeaveRequests}">
					                <c:forEach var="leave" items="${pendingLeaveRequests}" begin="0" end="0">
					                    <div class="leave-item">
					                        <div class="leave-header">
					                            <div class="leave-student">
					                                <div class="leave-avatar">
					                                    <c:out value="${fn:substring(leave.studentName, 0, 1)}" default="S" />
					                                </div>
					                                <div>
					                                    <p class="leave-name"><c:out value="${leave.studentName}" /></p>
					                                    <div class="leave-meta">
					                                        <c:out value="${leave.startDateFormatted}" /> - 
					                                        <c:out value="${leave.endDateFormatted}" />
					                                    </div>
					                                </div>
					                            </div>
					                        </div>
					                        <p class="leave-reason">"<c:out value="${leave.reason}" />"</p>
					                        <div class="leave-actions">
					                            <form method="POST" action="${pageContext.request.contextPath}/faculty/dashboard" style="flex: 1;">
					                                <input type="hidden" name="leaveId" value="${leave.leaveId}">
					                                <input type="hidden" name="leaveAction" value="reject">
					                                <button type="submit" class="leave-btn reject">
					                                    <i class="fas fa-times"></i> Reject
					                                </button>
					                            </form>
					                            <form method="POST" action="${pageContext.request.contextPath}/faculty/dashboard" style="flex: 1;">
					                                <input type="hidden" name="leaveId" value="${leave.leaveId}">
					                                <input type="hidden" name="leaveAction" value="approve">
					                                <button type="submit" class="leave-btn approve">
					                                    <i class="fas fa-check"></i> Approve
					                                </button>
					                            </form>
					                        </div>
					                    </div>
					                </c:forEach>
					                
					                <c:if test="${pendingLeaves > 1}">
					                    <a href="${pageContext.request.contextPath}/faculty/leave-approval" 
					                       class="dash-card-link" style="justify-content: center; margin-top: 0.75rem; display: flex;">
					                        View all <c:out value="${pendingLeaves}" /> requests <i class="fas fa-arrow-right"></i>
					                    </a>
					                </c:if>
					            </c:when>
					            <c:otherwise>
					                <div class="empty-state" style="padding: 2rem 1rem;">
					                    <div class="empty-icon" style="width: 60px; height: 60px; font-size: 1.5rem;">
					                        <i class="fas fa-check-double"></i>
					                    </div>
					                    <h4 class="empty-title">All Caught Up!</h4>
					                    <p class="empty-text">No pending leave requests.</p>
					                </div>
					            </c:otherwise>
					        </c:choose>
					    </div>
					</div>

				<!-- Workload Overview -->
				<div class="dash-card">
				    <div class="dash-card-header">
				        <h3 class="dash-card-title">
				            <i class="fas fa-chart-pie"></i>
				            Workload Overview
				        </h3>
				    </div>
				    <div class="dash-card-body">
				        <div class="quick-actions" style="margin: 0;">
				            <div class="quick-action-btn" style="cursor: default;">
				                <div class="quick-action-icon">
				                    <i class="fas fa-book"></i>
				                </div>
				                <div style="font-size: 1rem; font-weight: 700; color: #111827; margin: 0 0;">
				                    <c:out value="${workload.subjectsAssigned}" default="0" />
				                </div>
				                <span class="quick-action-label">Subjects</span>
				            </div>
				            
				            <div class="quick-action-btn" style="cursor: default;">
				                <div class="quick-action-icon" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #059669;">
				                    <i class="fas fa-users"></i>
				                </div>
				                <div style="font-size: 1rem; font-weight: 700; color: #111827; margin: 0 0;">
				                    <c:out value="${workload.sectionsHandling}" default="0" />
				                </div>
				                <span class="quick-action-label">Sections</span>
				            </div>
				            
				            <div class="quick-action-btn" style="cursor: default;">
				                <div class="quick-action-icon" style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #d97706;">
				                    <i class="fas fa-calendar"></i>
				                </div>
				                <div style="font-size: 1rem; font-weight: 700; color: #111827; margin: 0 0;">
				                    <c:out value="${workload.classesPerWeek}" default="0" />
				                </div>
				                <span class="quick-action-label">Classes/Week</span>
				            </div>
				            
				            <div class="quick-action-btn" style="cursor: default;">
				                <div class="quick-action-icon" style="background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%); color: #6366f1;">
				                    <i class="fas fa-clipboard-check"></i>
				                </div>
				                <div style="font-size: 1rem; font-weight: 700; color: #111827; margin: 0 0;">
				                    <c:out value="${workload.attendanceSessions}" default="0" />
				                </div>
				                <span class="quick-action-label">Sessions Marked</span>
				            </div>
				        </div>
				    </div>
				</div>
        	</div>
        </div>
        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
	</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto-dismiss alerts
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.custom-alert');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.classList.add('fade-out');
                setTimeout(() => alert.remove(), 500);
            }, 5000);
        });
    });
</script>
</body>
</html>