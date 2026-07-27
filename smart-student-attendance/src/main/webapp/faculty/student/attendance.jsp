<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Student Attendance Details" scope="request" />
<%@ include file="../facultyHead.jsp" %>

<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        --shadow-soft: 0 8px 32px rgba(0, 0, 0, 0.08);
        --shadow-hover: 0 12px 48px rgba(0, 0, 0, 0.12);
        --radius-xl: 20px;
        --radius-lg: 16px;
        --radius-md: 12px;
    }

    .attendance-container {
        width: 100%;
	    max-width: 1800px;
	    margin: 0 auto;
	    padding: 2rem;
    }

    /* Hero Banner */
    .student-hero {
        background: var(--glass-bg);
        backdrop-filter: blur(20px);
        border: 1px solid var(--glass-border);
        border-radius: var(--radius-xl);
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: var(--shadow-soft);
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 2rem;
    }

    .student-hero-left {
        display: flex;
        align-items: center;
        gap: 1.5rem;
    }

    .student-avatar-large {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background: var(--primary-gradient);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 2rem;
        flex-shrink: 0;
    }

    .student-hero-info h2 {
        font-size: 1.75rem;
        font-weight: 700;
        color: #111827;
        margin: 0 0 0.5rem 0;
    }

    .student-hero-info p {
        color: #6b7280;
        margin: 0 0 0.75rem 0;
        font-size: 0.95rem;
    }

    .student-chips {
        display: flex;
        gap: 0.75rem;
        flex-wrap: wrap;
    }

    .student-chip {
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #1e40af;
        padding: 0.5rem 1rem;
        border-radius: 50px;
        font-size: 0.85rem;
        font-weight: 600;
        border: 1px solid #bfdbfe;
    }

    .student-hero-right {
        display: flex;
        gap: 1rem;
    }

    .btn-hero {
        padding: 0.75rem 1.5rem;
        border-radius: var(--radius-md);
        border: none;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.9rem;
        text-decoration: none;
    }

    .btn-hero-primary {
        background: var(--primary-gradient);
        color: white;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }

    .btn-hero-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
    }

    .btn-hero-secondary {
        background: #f3f4f6;
        color: #6b7280;
    }

    .btn-hero-secondary:hover {
        background: #e5e7eb;
        color: #374151;
    }

    /* Analytics Cards */
    .analytics-cards {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .analytics-card {
        background: white;
        border-radius: var(--radius-lg);
        padding: 1.5rem;
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        transition: all 0.3s ease;
    }

    .analytics-card:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-hover);
    }

    .analytics-icon {
        width: 48px;
        height: 48px;
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        margin-bottom: 1rem;
    }

    .analytics-value {
        font-size: 2rem;
        font-weight: 700;
        color: #111827;
        margin-bottom: 0.25rem;
    }

    .analytics-label {
        font-size: 0.85rem;
        color: #6b7280;
        font-weight: 500;
    }

    /* Main Layout - Equal Height Columns */
    .main-layout {
        display: flex;
        gap: 2rem;
    }

    .main-layout .left-column {
        flex: 1;
        min-width: 0;
        display: flex;
        flex-direction: column;
    }

    .main-layout .right-column {
        width: 380px;
        flex-shrink: 0;
        display: flex;
        flex-direction: column;
    }

    @media (max-width: 1200px) {
        .main-layout {
            flex-direction: column;
        }
        .main-layout .right-column {
            width: 100%;
        }
        .analytics-cards {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    /* Section Cards */
    .section-card {
        background: white;
        border-radius: var(--radius-lg);
        padding: 1.75rem;
        margin-bottom: 1.5rem;
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
    }

    .section-title {
        font-size: 1.1rem;
        font-weight: 700;
        color: #111827;
        margin: 0 0 1.5rem 0;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .section-title i {
        color: #667eea;
    }

    /* Subject Attendance Table */
    .subject-table {
        width: 100%;
        border-collapse: collapse;
    }

    .subject-table th {
        background: #f9fafb;
        padding: 0.875rem 1rem;
        text-align: left;
        font-size: 0.75rem;
        font-weight: 700;
        color: #6b7280;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .subject-table td {
        padding: 1rem;
        border-bottom: 1px solid #f3f4f6;
        font-size: 0.9rem;
    }

    .subject-table tr:last-child td {
        border-bottom: none;
    }

    .subject-name {
        font-weight: 600;
        color: #111827;
        margin-bottom: 0.25rem;
    }

    .subject-code {
        font-size: 0.75rem;
        color: #6b7280;
    }

    .attendance-cell {
        min-width: 180px;
    }

    .attendance-percentage {
        font-weight: 700;
        color: #111827;
        font-size: 0.95rem;
        margin-bottom: 0.5rem;
    }

    .attendance-bar-bg {
        height: 8px;
        background: #e5e7eb;
        border-radius: 10px;
        overflow: hidden;
        margin-bottom: 0.5rem;
    }

    .attendance-bar-fill {
        height: 100%;
        background: var(--success-gradient);
        border-radius: 10px;
        transition: width 1s ease;
    }

    .attendance-bar-fill.warning {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    }

    .attendance-bar-fill.danger {
        background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
    }

    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        padding: 0.35rem 0.75rem;
        border-radius: 50px;
        font-size: 0.75rem;
        font-weight: 600;
    }

    .status-badge.excellent {
        background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
        color: #065f46;
    }

    .status-badge.good {
        background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
        color: #1e40af;
    }

    .status-badge.warning {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        color: #92400e;
    }

    /* Recent Records Table with Scroll */
    .records-container {
        max-height: 500px;
        overflow-y: auto;
        padding-right: 0.5rem;
    }

    .records-container::-webkit-scrollbar {
        width: 6px;
    }

    .records-container::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
    }

    .records-container::-webkit-scrollbar-thumb {
        background: #c1c1c1;
        border-radius: 10px;
    }

    .records-container::-webkit-scrollbar-thumb:hover {
        background: #a1a1a1;
    }

    .records-table {
        width: 100%;
        border-collapse: collapse;
    }

    .records-table th {
        background: #f9fafb;
        padding: 0.875rem 1rem;
        text-align: left;
        font-size: 0.75rem;
        font-weight: 700;
        color: #6b7280;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        position: sticky;
        top: 0;
        background: #f9fafb;
        z-index: 1;
    }

    .records-table td {
        padding: 1rem;
        border-bottom: 1px solid #f3f4f6;
        font-size: 0.9rem;
    }

    .records-table tr:last-child td {
        border-bottom: none;
    }

    .record-status {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        padding: 0.35rem 0.75rem;
        border-radius: 50px;
        font-size: 0.75rem;
        font-weight: 600;
    }

    .record-status.present {
        background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
        color: #065f46;
    }

    .record-status.absent {
        background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
        color: #991b1b;
    }

    .record-status.late {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        color: #92400e;
    }

    .record-status.medical {
        background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
        color: #1e40af;
    }

    /* Sidebar Cards */
    .sidebar-card {
        background: white;
        border-radius: var(--radius-lg);
        padding: 1.5rem;
        margin-bottom: 1.5rem;
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
    }

    .sidebar-title {
        font-size: 1rem;
        font-weight: 700;
        color: #111827;
        margin: 0 0 1.25rem 0;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .sidebar-title i {
        color: #667eea;
    }

    /* Distribution Items */
    .distribution-item {
        margin-bottom: 1.25rem;
    }

    .distribution-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 0.5rem;
    }

    .distribution-label {
        font-size: 0.85rem;
        font-weight: 600;
        color: #374151;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .distribution-count {
        font-size: 0.85rem;
        font-weight: 700;
        color: #6b7280;
    }

    .distribution-bar-bg {
        height: 6px;
        background: #e5e7eb;
        border-radius: 10px;
        overflow: hidden;
    }

    .distribution-bar-fill {
        height: 100%;
        border-radius: 10px;
        transition: width 1s ease;
    }

    /* Subject Ranking */
    .ranking-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0.875rem 0;
        border-bottom: 1px solid #f3f4f6;
    }

    .ranking-item:last-child {
        border-bottom: none;
    }

    .ranking-info {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .ranking-rank {
        width: 28px;
        height: 28px;
        border-radius: 50%;
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        color: #92400e;
        font-size: 0.8rem;
    }

    .ranking-name {
        font-weight: 600;
        color: #111827;
        font-size: 0.9rem;
    }

    .ranking-attendance {
        font-weight: 700;
        color: #10b981;
        font-size: 0.9rem;
    }

    /* Risk Indicator */
    .risk-card {
        padding: 1.5rem;
        border-radius: var(--radius-md);
        text-align: center;
        margin-bottom: 1.5rem;
    }

    .risk-card.safe {
        background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
    }

    .risk-card.warning {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
    }

    .risk-card.critical {
        background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
    }

    .risk-icon {
        font-size: 3rem;
        margin-bottom: 1rem;
    }

    .risk-title {
        font-size: 1.25rem;
        font-weight: 700;
        margin-bottom: 0.5rem;
    }

    .risk-desc {
        font-size: 0.9rem;
        opacity: 0.9;
    }

    /* Quick Stats */
    .quick-stats-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1rem;
    }

    .quick-stat {
        background: #f9fafb;
        padding: 1rem;
        border-radius: var(--radius-md);
        text-align: center;
    }

    .quick-stat-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: #111827;
        margin-bottom: 0.25rem;
    }

    .quick-stat-label {
        font-size: 0.75rem;
        color: #6b7280;
        font-weight: 500;
    }
</style>

<div class="app-wrapper">
    <%@ include file="../facultySidebar.jsp" %>
    <div class="main-content">
        <%@ include file="../facultyNavbar.jsp" %>
        
        <div class="attendance-container">
            
            <!-- Student Hero Banner -->
            <div class="student-hero">
                <div class="student-hero-left">
                    <div class="student-avatar-large">
                        <c:out value="${fn:substring(student.fullName, 0, 1)}" default="S" />
                    </div>
                    <div class="student-hero-info">
                        <h2><c:out value="${student.fullName}" /></h2>
                        <p><c:out value="${student.branch}" /> • Semester <c:out value="${student.currentSemester}" /></p>
                        <div class="student-chips">
                            <span class="student-chip"><i class="fas fa-id-card me-1"></i><c:out value="${student.enrollmentNumber}" /></span>
                            <span class="student-chip" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #065f46; border-color: #6ee7b7;">
                                <i class="fas fa-check-circle me-1"></i>Active
                            </span>
                        </div>
                    </div>
                </div>
                <div class="student-hero-right">
                    <a href="${pageContext.request.contextPath}/faculty/student/profile?id=${student.studentId}" class="btn-hero btn-hero-secondary">
                        <i class="fas fa-user"></i> View Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/faculty/students" class="btn-hero btn-hero-primary">
                        <i class="fas fa-arrow-left"></i> Back to Students
                    </a>
                </div>
            </div>

            <!-- Analytics Cards -->
            <div class="analytics-cards">
                <div class="analytics-card">
                    <div class="analytics-icon" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #10b981;">
                        <i class="fas fa-percentage"></i>
                    </div>
                    <div class="analytics-value"><fmt:formatNumber value="${overallAttendance}" pattern="#0.0" />%</div>
                    <div class="analytics-label">Overall Attendance</div>
                </div>
                <div class="analytics-card">
                    <div class="analytics-icon" style="background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); color: #3b82f6;">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="analytics-value"><c:out value="${totalClasses}" /></div>
                    <div class="analytics-label">Classes Conducted</div>
                </div>
                <div class="analytics-card">
                    <div class="analytics-icon" style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #f59e0b;">
                        <i class="fas fa-calendar-day"></i>
                    </div>
                    <div class="analytics-value"><c:out value="${attendedClasses}" /></div>
                    <div class="analytics-label">Classes Attended</div>
                </div>
                <div class="analytics-card">
                    <div class="analytics-icon" style="background: linear-gradient(135deg, #fce7f3 0%, #fbcfe8 100%); color: #ec4899;">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="analytics-value">+<fmt:formatNumber value="${attendanceTrend}" pattern="#0.0" />%</div>
                    <div class="analytics-label">Attendance Trend (This Month)</div>
                </div>
            </div>

            <!-- Main Layout with Equal Heights -->
            <div class="main-layout">
                <!-- Left Column -->
                <div class="left-column">
                    <!-- Subject-wise Attendance -->
                    <div class="section-card">
                        <h3 class="section-title">
                            <i class="fas fa-book"></i>
                            Subject-wise Attendance
                        </h3>
                        <table class="subject-table">
                            <thead>
                                <tr>
                                    <th>Subject</th>
                                    <th style="text-align: center;">Conducted</th>
                                    <th style="text-align: center;">Attended</th>
                                    <th>Attendance</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="subject" items="${subjectAttendance}">
                                    <tr>
                                        <td>
                                            <div class="subject-name"><c:out value="${subject.subjectName}" /></div>
                                            <div class="subject-code"><c:out value="${subject.subjectCode}" /></div>
                                        </td>
                                        <td style="text-align: center; font-weight: 600;"><c:out value="${subject.conducted}" /></td>
                                        <td style="text-align: center; font-weight: 600;"><c:out value="${subject.attended}" /></td>
                                        <td>
                                            <div class="attendance-cell">
                                                <div class="attendance-percentage"><fmt:formatNumber value="${subject.percentage}" pattern="#0.0" />%</div>
                                                <div class="attendance-bar-bg">
                                                    <div class="attendance-bar-fill 
                                                        <c:choose>
                                                            <c:when test="${subject.percentage >= 75}"></c:when>
                                                            <c:when test="${subject.percentage >= 50}">warning</c:when>
                                                            <c:otherwise>danger</c:otherwise>
                                                        </c:choose>" 
                                                        style="width: ${subject.percentage}%;"></div>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${subject.percentage >= 90}">
                                                        <span class="status-badge excellent">
                                                            <i class="fas fa-check-circle"></i> Excellent
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${subject.percentage >= 75}">
                                                        <span class="status-badge good">
                                                            <i class="fas fa-thumbs-up"></i> Good
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${subject.percentage >= 50}">
                                                        <span class="status-badge warning">
                                                            <i class="fas fa-exclamation-circle"></i> Warning
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge" style="background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%); color: #991b1b;">
                                                            <i class="fas fa-times-circle"></i> Critical
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Recent Attendance Records with Scroll -->
                    <div class="section-card" style="flex: 1; display: flex; flex-direction: column;">
                        <h3 class="section-title">
                            <i class="fas fa-history"></i>
                            Recent Attendance Records
                        </h3>
                        <div class="records-container">
                            <table class="records-table">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Subject</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="record" items="${recentRecords}">
                                        <tr>
                                            <td><c:out value="${record.dateFormatted}" /></td>
                                            <td><c:out value="${record.subjectName}" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${record.status == 'PRESENT'}">
                                                        <span class="record-status present">
                                                            <i class="fas fa-check"></i> Present
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${record.status == 'ABSENT'}">
                                                        <span class="record-status absent">
                                                            <i class="fas fa-times"></i> Absent
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${record.status == 'LATE'}">
                                                        <span class="record-status late">
                                                            <i class="fas fa-clock"></i> Late
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="record-status medical">
                                                            <i class="fas fa-file-medical"></i> Medical Leave
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Right Column -->
                <div class="right-column">
                    <!-- Attendance Distribution -->
                    <div class="sidebar-card">
                        <h4 class="sidebar-title">
                            <i class="fas fa-chart-pie"></i>
                            Attendance Distribution
                        </h4>
                        <div class="distribution-item">
                            <div class="distribution-header">
                                <span class="distribution-label">
                                    <i class="fas fa-check-circle" style="color: #10b981;"></i>
                                    Present Days
                                </span>
                                <span class="distribution-count"><c:out value="${presentDays}" /></span>
                            </div>
                            <div class="distribution-bar-bg">
                                <div class="distribution-bar-fill" style="width: ${presentDays * 100 / totalClasses}%; background: var(--success-gradient);"></div>
                            </div>
                        </div>
                        <div class="distribution-item">
                            <div class="distribution-header">
                                <span class="distribution-label">
                                    <i class="fas fa-times-circle" style="color: #ef4444;"></i>
                                    Absent Days
                                </span>
                                <span class="distribution-count"><c:out value="${absentDays}" /></span>
                            </div>
                            <div class="distribution-bar-bg">
                                <div class="distribution-bar-fill" style="width: ${absentDays * 100 / totalClasses}%; background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);"></div>
                            </div>
                        </div>
                        <div class="distribution-item">
                            <div class="distribution-header">
                                <span class="distribution-label">
                                    <i class="fas fa-file-medical" style="color: #3b82f6;"></i>
                                    Medical Leaves
                                </span>
                                <span class="distribution-count"><c:out value="${medicalLeaves}" /></span>
                            </div>
                            <div class="distribution-bar-bg">
                                <div class="distribution-bar-fill" style="width: ${medicalLeaves * 100 / totalClasses}%; background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);"></div>
                            </div>
                        </div>
                        <div class="distribution-item">
                            <div class="distribution-header">
                                <span class="distribution-label">
                                    <i class="fas fa-clock" style="color: #f59e0b;"></i>
                                    Late Entries
                                </span>
                                <span class="distribution-count"><c:out value="${lateEntries}" /></span>
                            </div>
                            <div class="distribution-bar-bg">
                                <div class="distribution-bar-fill" style="width: ${lateEntries * 100 / totalClasses}%; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Subject Ranking -->
                    <div class="sidebar-card">
                        <h4 class="sidebar-title">
                            <i class="fas fa-trophy"></i>
                            Top Attendance Subjects
                        </h4>
                        <c:forEach var="subject" items="${topSubjects}" begin="0" end="4">
                            <div class="ranking-item">
                                <div class="ranking-info">
                                    <div class="ranking-rank"><c:out value="${subject.rank}" /></div>
                                    <div class="ranking-name"><c:out value="${subject.subjectName}" /></div>
                                </div>
                                <div class="ranking-attendance"><fmt:formatNumber value="${subject.percentage}" pattern="#0.0" />%</div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Risk Indicator -->
                    <div class="risk-card ${riskLevel}">
                        <div class="risk-icon">
                            <c:choose>
                                <c:when test="${riskLevel == 'safe'}">
                                    <i class="fas fa-shield-alt" style="color: #065f46;"></i>
                                </c:when>
                                <c:when test="${riskLevel == 'warning'}">
                                    <i class="fas fa-exclamation-triangle" style="color: #92400e;"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-times-circle" style="color: #991b1b;"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="risk-title">
                            <c:choose>
                                <c:when test="${riskLevel == 'safe'}">
                                    Safe Zone
                                </c:when>
                                <c:when test="${riskLevel == 'warning'}">
                                    Needs Attention
                                </c:when>
                                <c:otherwise>
                                    Critical Attendance
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="risk-desc">
                            <c:choose>
                                <c:when test="${riskLevel == 'safe'}">
                                    Student is maintaining excellent attendance.
                                </c:when>
                                <c:when test="${riskLevel == 'warning'}">
                                    Attendance is below optimal. Needs improvement.
                                </c:when>
                                <c:otherwise>
                                    Immediate attention required. Risk of detention.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Quick Stats -->
                    <div class="sidebar-card">
                        <h4 class="sidebar-title">
                            <i class="fas fa-bolt"></i>
                            Quick Stats
                        </h4>
                        <div class="quick-stats-grid">
                            <div class="quick-stat">
                                <div class="quick-stat-value" style="color: #10b981;"><c:out value="${longestStreak}" /></div>
                                <div class="quick-stat-label">Longest Present Streak</div>
                            </div>
                            <div class="quick-stat">
                                <div class="quick-stat-value" style="color: #3b82f6;"><c:out value="${currentStreak}" /></div>
                                <div class="quick-stat-label">Current Streak</div>
                            </div>
                            <div class="quick-stat">
                                <div class="quick-stat-value" style="color: #f59e0b;"><c:out value="${bestSubject}" /></div>
                                <div class="quick-stat-label">Best Subject</div>
                            </div>
                            <div class="quick-stat">
                                <div class="quick-stat-value" style="color: #ef4444;"><c:out value="${lowestSubject}" /></div>
                                <div class="quick-stat-label">Lowest Subject</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        
        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>