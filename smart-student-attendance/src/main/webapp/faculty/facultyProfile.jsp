<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="pageTitle" value="My Profile" scope="request" />
<%@ include file="facultyHead.jsp" %>

<style>
    :root {
        --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --gradient-success: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        --shadow-soft: 0 10px 40px rgba(0, 0, 0, 0.08);
        --radius-lg: 20px;
        --radius-md: 16px;
    }

    .profile-hero {
        background: var(--gradient-primary);
        border-radius: var(--radius-lg);
        padding: 2.5rem;
        margin-bottom: 2rem;
        color: white;
        position: relative;
        overflow: hidden;
        box-shadow: var(--shadow-soft);
    }

    .profile-hero::before {
        content: '';
        position: absolute;
        top: -50%;
        right: -10%;
        width: 400px;
        height: 400px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 50%;
    }

    .profile-avatar-large {
        width: 110px;
        height: 110px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.2);
        backdrop-filter: blur(10px);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 2.75rem;
        border: 4px solid rgba(255, 255, 255, 0.3);
        position: relative;
        z-index: 1;
        flex-shrink: 0;
    }

    .profile-name {
        font-size: 1.75rem;
        font-weight: 700;
        margin-bottom: 0.25rem;
    }

    .profile-designation {
        font-size: 1rem;
        color: rgba(255, 255, 255, 0.85);
        margin-bottom: 0.75rem;
    }

    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.4rem 0.9rem;
        border-radius: 50px;
        font-size: 0.8rem;
        font-weight: 600;
        background: rgba(255, 255, 255, 0.2);
        backdrop-filter: blur(10px);
    }

    .profile-badges {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
        margin-top: 0.75rem;
    }

    .profile-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        padding: 0.4rem 0.9rem;
        background: rgba(255, 255, 255, 0.95);
        color: #667eea;
        border-radius: 50px;
        font-size: 0.8rem;
        font-weight: 600;
    }

    .profile-badge.advisor {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        color: #92400e;
    }

    .profile-actions {
        position: absolute;
        bottom: 1.5rem;
        right: 2rem;
        display: flex;
        gap: 0.6rem;
        z-index: 1;
    }

    .btn-action-small {
        padding: 0.5rem 1.1rem;
        border-radius: 50px;
        font-size: 0.8rem;
        font-weight: 600;
        background: rgba(255, 255, 255, 0.95);
        color: #667eea;
        border: none;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
    }

    .btn-action-small:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .info-card {
        background: white;
        border-radius: var(--radius-md);
        padding: 1.5rem;
        border: 1px solid #e5e7eb;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        margin-bottom: 1.5rem;
        height: 100%;
    }

    .card-header-custom {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 1.25rem;
        padding-bottom: 0.875rem;
        border-bottom: 2px solid #f3f4f6;
    }

    .card-title {
        font-size: 1rem;
        font-weight: 700;
        color: #111827;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.6rem;
    }

    .btn-edit-section {
        padding: 0.4rem 0.9rem;
        border-radius: 50px;
        font-size: 0.75rem;
        font-weight: 600;
        background: var(--gradient-success);
        color: white;
        border: none;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        text-decoration: none;
    }

    .btn-edit-section:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(17, 153, 142, 0.3);
        color: white;
    }

    .info-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.7rem 0;
        border-bottom: 1px solid #f9fafb;
    }

    .info-row:last-child { border-bottom: none; }

    .info-label {
        font-size: 0.85rem;
        color: #6b7280;
        font-weight: 500;
    }

    .info-value {
        font-size: 0.875rem;
        color: #111827;
        font-weight: 600;
        text-align: right;
        max-width: 60%;
        word-break: break-word;
    }

    .subject-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.5rem 0.9rem;
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #2563eb;
        border-radius: 50px;
        font-size: 0.8rem;
        font-weight: 600;
        margin: 0.2rem;
        border: 1px solid #bfdbfe;
        transition: all 0.2s ease;
    }

    .subject-badge:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(37, 99, 235, 0.15);
    }

    .scrollable-container {
        max-height: 280px;
        overflow-y: auto;
        padding-right: 0.5rem;
    }

    .scrollable-container::-webkit-scrollbar { width: 6px; }
    .scrollable-container::-webkit-scrollbar-track { background: #f3f4f6; border-radius: 3px; }
    .scrollable-container::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }
    .scrollable-container::-webkit-scrollbar-thumb:hover { background: #94a3b8; }

    .timeline-item {
        display: flex;
        gap: 0.875rem;
        padding: 0.75rem 0;
        border-left: 2px solid #e5e7eb;
        padding-left: 1.25rem;
        position: relative;
        margin-left: 0.5rem;
    }

    .timeline-item::before {
        content: '';
        position: absolute;
        left: -6px;
        top: 1rem;
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background: #667eea;
        border: 2px solid white;
    }

    .timeline-time {
        font-size: 0.7rem;
        color: #6b7280;
        margin-bottom: 0.2rem;
    }

    .timeline-text {
        font-size: 0.825rem;
        color: #111827;
        font-weight: 500;
        line-height: 1.4;
    }

    .empty-state {
        text-align: center;
        padding: 2rem 1rem;
        color: #9ca3af;
    }

    .empty-state i {
        font-size: 2rem;
        margin-bottom: 0.5rem;
        opacity: 0.5;
    }

    @media (max-width: 991px) {
        .profile-actions {
            position: static;
            margin-top: 1rem;
            justify-content: center;
        }
        .profile-hero { text-align: center; }
        .profile-avatar-large { margin: 0 auto 1rem; }
    }
</style>

<div class="app-wrapper">
    <%@ include file="facultySidebar.jsp" %>
    <div class="main-content">
        <%@ include file="facultyNavbar.jsp" %>
        <div class="content-area">
            
            <c:if test="${not empty errorMessage}">
                <div class="custom-alert alert-error"><i class="fas fa-exclamation-circle"></i> <c:out value="${errorMessage}" /></div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="custom-alert alert-success"><i class="fas fa-check-circle"></i> <c:out value="${successMessage}" /></div>
            </c:if>

            <!-- Profile Hero Section -->
            <div class="profile-hero">
                <div class="d-flex align-items-center gap-4 flex-wrap">
                    <div class="profile-avatar-large">
                        <c:out value="${fn:substring(profile.fullName, 0, 1)}" default="F" />
                    </div>
                    <div class="flex-grow-1">
                        <h2 class="profile-name"><c:out value="${profile.fullName}" default="Not Available" /></h2>
                        <p class="profile-designation">
                            <c:out value="${profile.designation}" default="Not Available" />
                            <c:if test="${not empty profile.department}">
                                &nbsp;•&nbsp;<c:out value="${profile.department}" />
                            </c:if>
                        </p>
                        <span class="status-badge">
                            <i class="fas fa-check-circle"></i> Active Faculty
                        </span>
                        <div class="profile-badges">
                            <span class="profile-badge">
                                <i class="fas fa-id-card"></i><c:out value="${profile.employeeId}" default="N/A" />
                            </span>
                            <span class="profile-badge">
                                <i class="fas fa-building"></i><c:out value="${profile.department}" default="N/A" />
                            </span>
                            <c:if test="${profile.classAdvisor}">
                                <span class="profile-badge advisor">
                                    <i class="fas fa-award"></i>Class Advisor
                                </span>
                            </c:if>
                        </div>
                    </div>
                </div>
                <div class="profile-actions">
                    <a href="${pageContext.request.contextPath}/faculty/profile/edit" class="btn-action-small">
                        <i class="fas fa-edit"></i>Edit Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/auth/change-password" class="btn-action-small">
					    <i class="fas fa-lock"></i>Change Password
					</a>
                </div>
            </div>

            <!-- ROW 1: Personal Information + Assigned Subjects -->
            <div class="row g-4 mb-4">
                <div class="col-lg-7">
                    <div class="info-card">
                        <div class="card-header-custom">
                            <h3 class="card-title">
                                <i class="fas fa-user text-primary"></i>Personal Information
                            </h3>
                            <a href="${pageContext.request.contextPath}/faculty/profile/edit#personal" class="btn-edit-section">
                                <i class="fas fa-edit"></i>Edit
                            </a>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Full Name</span>
                            <span class="info-value"><c:out value="${profile.fullName}" default="Not Available" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Email Address</span>
                            <span class="info-value"><c:out value="${profile.email}" default="Not Available" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Phone Number</span>
                            <span class="info-value"><c:out value="${profile.phoneNumber}" default="Not Available" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Office Location</span>
                            <span class="info-value"><c:out value="${profile.officeLocation}" default="Not Available" /></span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div class="info-card">
                        <div class="card-header-custom">
                            <h3 class="card-title">
                                <i class="fas fa-book-open text-primary"></i>Assigned Subjects
                            </h3>
                        </div>
                        <c:choose>
                            <c:when test="${not empty assignedSubjects}">
                                <div class="scrollable-container">
                                    <c:forEach var="subject" items="${assignedSubjects}">
                                        <span class="subject-badge">
                                            <i class="fas fa-book"></i>
                                            <c:out value="${subject.subjectName}" />
                                            <small style="opacity: 0.7;">(Sem <c:out value="${subject.semester}" />)</small>
                                        </span>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-book"></i>
                                    <p class="mb-0">No subjects assigned</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- ROW 2: Professional Information + Workload Summary -->
            <div class="row g-4 mb-4">
                <div class="col-lg-7">
                    <div class="info-card">
                        <div class="card-header-custom">
                            <h3 class="card-title">
                                <i class="fas fa-briefcase text-primary"></i>Professional Information
                            </h3>
                            <a href="${pageContext.request.contextPath}/faculty/profile/edit#professional" class="btn-edit-section">
                                <i class="fas fa-edit"></i>Edit
                            </a>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Employee ID</span>
                            <span class="info-value"><c:out value="${profile.employeeId}" default="Not Available" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Department</span>
                            <span class="info-value"><c:out value="${profile.department}" default="Not Available" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Designation</span>
                            <span class="info-value"><c:out value="${profile.designation}" default="Not Available" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Qualification</span>
                            <span class="info-value"><c:out value="${profile.qualification}" default="Not Available" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Specialization</span>
                            <span class="info-value"><c:out value="${profile.specialization}" default="Not Available" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Joining Date</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty joiningDateFormatted}">
									    <c:out value="${joiningDateFormatted}" />
									</c:when>
                                    <c:otherwise>Not Available</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div class="info-card">
                        <div class="card-header-custom">
                            <h3 class="card-title">
                                <i class="fas fa-history text-primary"></i>Recent Activity
                            </h3>
                        </div>
                        <c:choose>
                            <c:when test="${not empty recentActivities}">
                                <div class="scrollable-container">
                                    <c:forEach var="activity" items="${recentActivities}">
                                        <div class="timeline-item">
                                            <div>
                                                <div class="timeline-time">
                                                    <fmt:formatDate value="${activity.timestamp}" pattern="dd MMM yyyy, hh:mm a" />
                                                </div>
                                                <div class="timeline-text">
                                                    <strong><c:out value="${activity.actionType}" />:</strong>
                                                    <c:out value="${activity.description}" />
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-history"></i>
                                    <p class="mb-0">No recent activities</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- ROW 3: Academic Information + Recent Activity -->
            <div class="row g-4 mb-4">
                <div class="col-lg-7">
                    <div class="info-card">
                        <div class="card-header-custom">
                            <h3 class="card-title">
                                <i class="fas fa-graduation-cap text-primary"></i>Academic Information
                            </h3>
                            <a href="${pageContext.request.contextPath}/faculty/profile/edit#academic" class="btn-edit-section">
                                <i class="fas fa-edit"></i>Edit
                            </a>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Research Area</span>
                            <span class="info-value"><c:out value="${profile.researchArea}" default="Not Available" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Publications</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${profile.publicationsCount > 0}">
                                        <c:out value="${profile.publicationsCount}" /> Research Papers
                                    </c:when>
                                    <c:otherwise>Not Available</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Certifications</span>
                            <span class="info-value"><c:out value="${profile.certifications}" default="Not Available" /></span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div class="info-card">
                        <div class="card-header-custom">
                            <h3 class="card-title">
                                <i class="fas fa-chart-pie text-primary"></i>Workload Summary
                            </h3>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Subjects Assigned</span>
                            <span class="info-value"><c:out value="${workload.subjectsAssigned}" default="0" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Classes Per Week</span>
                            <span class="info-value"><c:out value="${workload.classesPerWeek}" default="0" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Sections Handling</span>
                            <span class="info-value"><c:out value="${workload.sectionsHandling}" default="0" /></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Attendance Sessions</span>
                            <span class="info-value"><c:out value="${workload.attendanceSessions}" default="0" /></span>
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