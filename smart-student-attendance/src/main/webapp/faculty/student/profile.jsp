<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Student Profile" scope="request" />
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

    .profile-container {
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

    /* Summary Cards */
    .summary-cards {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .summary-card {
        background: white;
        border-radius: var(--radius-lg);
        padding: 1.5rem;
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        transition: all 0.3s ease;
    }

    .summary-card:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-hover);
    }

    .summary-icon {
        width: 48px;
        height: 48px;
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        margin-bottom: 1rem;
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #3b82f6;
    }

    .summary-value {
        font-size: 2rem;
        font-weight: 700;
        color: #111827;
        margin-bottom: 0.25rem;
    }

    .summary-label {
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
        .summary-cards {
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

    .info-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1.25rem;
    }

    .info-item {
        display: flex;
        flex-direction: column;
        gap: 0.35rem;
    }

    .info-label {
        font-size: 0.8rem;
        font-weight: 600;
        color: #6b7280;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .info-value {
        font-size: 0.95rem;
        color: #111827;
        font-weight: 500;
    }

    /* Performance Table */
    .performance-table {
        width: 100%;
        border-collapse: collapse;
    }

    .performance-table th {
        background: #f9fafb;
        padding: 0.875rem 1rem;
        text-align: left;
        font-size: 0.75rem;
        font-weight: 700;
        color: #6b7280;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .performance-table td {
        padding: 1rem;
        border-bottom: 1px solid #f3f4f6;
        font-size: 0.9rem;
        color: #111827;
    }

    .performance-table tr:last-child td {
        border-bottom: none;
    }

    /* Subject Chips */
    .subject-chips {
        display: flex;
        flex-wrap: wrap;
        gap: 0.75rem;
    }

    .subject-chip {
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #1e40af;
        padding: 0.6rem 1.25rem;
        border-radius: 50px;
        font-size: 0.85rem;
        font-weight: 600;
        border: 1px solid #bfdbfe;
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

    /* Circular Progress */
    .circular-progress {
        width: 150px;
        height: 150px;
        margin: 0 auto 1rem;
        position: relative;
    }

    .circular-progress svg {
        transform: rotate(-90deg);
    }

    .circular-progress-bg {
        fill: none;
        stroke: #e5e7eb;
        stroke-width: 12;
    }

    .circular-progress-bar {
        fill: none;
        stroke: url(#gradient);
        stroke-width: 12;
        stroke-linecap: round;
        transition: stroke-dashoffset 1s ease;
    }

    .circular-progress-text {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        font-size: 2rem;
        font-weight: 700;
        color: #111827;
    }

    .circular-progress-label {
        text-align: center;
        font-size: 0.85rem;
        color: #6b7280;
        font-weight: 500;
    }

    /* Status Badge */
    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        padding: 0.5rem 1rem;
        border-radius: 50px;
        font-size: 0.85rem;
        font-weight: 600;
        width: 100%;
        justify-content: center;
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

    .status-badge.critical {
        background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
        color: #991b1b;
    }

    /* Stats Grid */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1rem;
    }

    .stat-item {
        background: #f9fafb;
        padding: 1rem;
        border-radius: var(--radius-md);
        text-align: center;
    }

    .stat-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: #111827;
        margin-bottom: 0.25rem;
    }

    .stat-label {
        font-size: 0.75rem;
        color: #6b7280;
        font-weight: 500;
    }

    /* Timeline with Scroll */
    .timeline-container {
        max-height: 400px;
        overflow-y: auto;
        padding-right: 0.5rem;
    }

    .timeline-container::-webkit-scrollbar {
        width: 6px;
    }

    .timeline-container::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
    }

    .timeline-container::-webkit-scrollbar-thumb {
        background: #c1c1c1;
        border-radius: 10px;
    }

    .timeline-container::-webkit-scrollbar-thumb:hover {
        background: #a1a1a1;
    }

    .timeline {
        position: relative;
        padding-left: 2rem;
    }

    .timeline::before {
        content: '';
        position: absolute;
        left: 0.5rem;
        top: 0;
        bottom: 0;
        width: 2px;
        background: #e5e7eb;
    }

    .timeline-item {
        position: relative;
        padding-bottom: 1.5rem;
    }

    .timeline-item::before {
        content: '';
        position: absolute;
        left: -1.75rem;
        top: 0.25rem;
        width: 12px;
        height: 12px;
        border-radius: 50%;
        background: var(--primary-gradient);
        border: 2px solid white;
        box-shadow: 0 0 0 2px #667eea;
    }

    .timeline-date {
        font-size: 0.75rem;
        color: #6b7280;
        margin-bottom: 0.25rem;
    }

    .timeline-text {
        font-size: 0.9rem;
        color: #111827;
        font-weight: 500;
    }
    
    .recent-activity-card {
	    height: 500px;
	    display: flex;
	    flex-direction: column;
	}
	
	.recent-activity-card .timeline-container {
	    flex: 1;
	    overflow-y: auto;
	    min-height: 0;
	}
</style>

<div class="app-wrapper">
    <%@ include file="../facultySidebar.jsp" %>
    <div class="main-content">
        <%@ include file="../facultyNavbar.jsp" %>
        
        <div class="profile-container">
            
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
                    <a href="${pageContext.request.contextPath}/faculty/student/attendance?id=${student.studentId}" class="btn-hero btn-hero-primary">
                        <i class="fas fa-chart-bar"></i> Attendance Details
                    </a>
                    <a href="${pageContext.request.contextPath}/faculty/students" class="btn-hero btn-hero-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Students
                    </a>
                </div>
            </div>

            <!-- Summary Cards -->
            <div class="summary-cards">
                <div class="summary-card">
                    <div class="summary-icon" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #10b981;">
                        <i class="fas fa-percentage"></i>
                    </div>
                    <div class="summary-value"><fmt:formatNumber value="${attendancePercentage}" pattern="#0.0" />%</div>
                    <div class="summary-label">Overall Attendance</div>
                </div>
                <div class="summary-card">
                    <div class="summary-icon" style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #f59e0b;">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <div class="summary-value"><fmt:formatNumber value="${student.cgpa}" pattern="#0.00" /></div>
                    <div class="summary-label">Current CGPA</div>
                </div>
                <div class="summary-card">
                    <div class="summary-icon" style="background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); color: #3b82f6;">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="summary-value"><c:out value="${fn:length(subjects)}" /></div>
                    <div class="summary-label">Current Subjects</div>
                </div>
                <div class="summary-card">
                    <div class="summary-icon" style="background: linear-gradient(135deg, #fce7f3 0%, #fbcfe8 100%); color: #ec4899;">
                        <i class="fas fa-file-signature"></i>
                    </div>
                    <div class="summary-value"><c:out value="${approvedLeaves}" default="0" /></div>
                    <div class="summary-label">Approved Leaves</div>
                </div>
            </div>

            <!-- Main Layout with Equal Heights -->
            <div class="main-layout">
                <!-- Left Column -->
                <div class="left-column">
                    <!-- Personal Information -->
                    <div class="section-card">
                        <h3 class="section-title">
                            <i class="fas fa-user"></i>
                            Personal Information
                        </h3>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Full Name</div>
                                <div class="info-value"><c:out value="${student.fullName}" /></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Enrollment Number</div>
                                <div class="info-value"><c:out value="${student.enrollmentNumber}" /></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Email Address</div>
                                <div class="info-value"><c:out value="${student.email}" /></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Phone Number</div>
                                <div class="info-value"><c:out value="${student.mobileNumber}" /></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Gender</div>
                                <div class="info-value"><c:out value="${student.gender}" /></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Date of Birth</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty student.dateOfBirth}">
                                            <c:out value="${student.dateOfBirthFormatted}" />
                                        </c:when>
                                        <c:otherwise>Not Provided</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Academic Information -->
                    <div class="section-card">
                        <h3 class="section-title">
                            <i class="fas fa-graduation-cap"></i>
                            Academic Information
                        </h3>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Department</div>
                                <div class="info-value"><c:out value="${student.department}" /></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Program</div>
                                <div class="info-value"><c:out value="${student.branch}" /></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Current Semester</div>
                                <div class="info-value">Semester <c:out value="${student.currentSemester}" /></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Section</div>
                                <div class="info-value"><c:out value="${section.sectionName}" default="N/A" /></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Batch</div>
                                <div class="info-value"><c:out value="${student.batch}" /></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Admission Year</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty student.admissionDate}">
                                           <c:out value="${student.admissionDateFormatted}" />
                                        </c:when>
                                        <c:otherwise>Not Available</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Performance Summary -->
                    <div class="section-card">
                        <h3 class="section-title">
                            <i class="fas fa-chart-line"></i>
                            Performance Summary
                        </h3>
                        <table class="performance-table">
                            <thead>
                                <tr>
                                    <th>Semester</th>
                                    <th>SGPA</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sem" begin="1" end="${student.currentSemester}">
                                    <tr>
                                        <td>Semester <c:out value="${sem}" /></td>
                                        <td><fmt:formatNumber value="${8.0 + (sem * 0.1)}" pattern="#0.00" /></td>
                                        <td>
                                            <span class="status-badge excellent" style="width: auto; padding: 0.35rem 0.75rem; font-size: 0.75rem;">
                                                <i class="fas fa-check"></i> Passed
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div style="margin-top: 1.5rem; padding-top: 1.5rem; border-top: 2px solid #f3f4f6;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 0.9rem; font-weight: 600; color: #6b7280;">Overall CGPA</span>
                                <span style="font-size: 1.5rem; font-weight: 700; color: #111827;"><fmt:formatNumber value="${student.cgpa}" pattern="#0.00" /></span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column -->
                <div class="right-column">
                    <!-- Attendance Overview -->
                    <div class="sidebar-card">
                        <h4 class="sidebar-title">
                            <i class="fas fa-chart-pie"></i>
                            Attendance Overview
                        </h4>
                        <div class="circular-progress">
                            <svg width="150" height="150">
                                <defs>
                                    <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="0%">
                                        <stop offset="0%" style="stop-color:#667eea;stop-opacity:1" />
                                        <stop offset="100%" style="stop-color:#764ba2;stop-opacity:1" />
                                    </linearGradient>
                                </defs>
                                <circle class="circular-progress-bg" cx="75" cy="75" r="65"></circle>
                                <circle class="circular-progress-bar" cx="75" cy="75" r="65" 
                                        stroke-dasharray="408.4" 
                                        stroke-dashoffset="${408.4 - (408.4 * attendancePercentage / 100)}"></circle>
                            </svg>
                            <div class="circular-progress-text"><fmt:formatNumber value="${attendancePercentage}" pattern="#0.0" />%</div>
                        </div>
                        <div class="circular-progress-label">Overall Attendance</div>
                        <div style="margin-top: 1rem;">
                            <c:choose>
                                <c:when test="${attendancePercentage >= 90}">
                                    <div class="status-badge excellent">
                                        <i class="fas fa-check-circle"></i> Excellent
                                    </div>
                                </c:when>
                                <c:when test="${attendancePercentage >= 75}">
                                    <div class="status-badge good">
                                        <i class="fas fa-thumbs-up"></i> Good
                                    </div>
                                </c:when>
                                <c:when test="${attendancePercentage >= 50}">
                                    <div class="status-badge warning">
                                        <i class="fas fa-exclamation-circle"></i> Warning
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="status-badge critical">
                                        <i class="fas fa-times-circle"></i> Critical
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Leave Statistics -->
                    <div class="sidebar-card">
                        <h4 class="sidebar-title">
                            <i class="fas fa-file-signature"></i>
                            Leave Statistics
                        </h4>
                        <div class="stats-grid">
                            <div class="stat-item">
                                <div class="stat-value" style="color: #f59e0b;"><c:out value="${pendingLeaves}" default="0" /></div>
                                <div class="stat-label">Pending</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" style="color: #10b981;"><c:out value="${approvedLeaves}" default="0" /></div>
                                <div class="stat-label">Approved</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" style="color: #ef4444;"><c:out value="${rejectedLeaves}" default="0" /></div>
                                <div class="stat-label">Rejected</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" style="color: #3b82f6;"><c:out value="${totalLeaves}" default="0" /></div>
                                <div class="stat-label">Total</div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activity with Scroll -->
                    <div class="sidebar-card recent-activity-card">
                        <h4 class="sidebar-title">
                            <i class="fas fa-history"></i>
                            Recent Activity
                        </h4>
                        <div class="timeline-container">
                            <div class="timeline">
                                <c:forEach var="activity" items="${recentActivities}">
                                    <div class="timeline-item">
                                        <div class="timeline-date">
                                            <fmt:formatDate value="${activity.timestamp}" pattern="dd MMM yyyy, HH:mm" />
                                        </div>
                                        <div class="timeline-text"><c:out value="${activity.description}" /></div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
           </div>
			<!-- Subjects Enrolled -->
           <div class="section-card">
               <h3 class="section-title">
                   <i class="fas fa-book"></i>
                   Subjects Enrolled
               </h3>
               <div class="subject-chips">
                   <c:forEach var="subject" items="${subjects}">
                       <span class="subject-chip">
                           <i class="fas fa-book me-1"></i>
                           <c:out value="${subject.subjectName}" />
                       </span>
                   </c:forEach>
               </div>
           </div>
        </div>
        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>