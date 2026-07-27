<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- Set page title for the Navbar --%>
<c:set var="pageTitle" value="My Profile" scope="request" />

<%@ include file="includes/studentHead.jsp" %>

<style>
    .profile-avatar-custom {
        width: 80px; height: 80px; border-radius: 50%;
        background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
        display: flex; align-items: center; justify-content: center;
        color: white; font-size: 2rem; font-weight: 700;
        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2); flex-shrink: 0;
    }
    .info-label { 
        font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; 
        color: var(--text-muted); font-weight: 600; margin-bottom: 0.25rem; 
    }
    .info-value { 
        font-size: 0.9rem; color: var(--text-dark); font-weight: 500; margin-bottom: 1rem; 
    }
    .readonly-lock { 
        font-size: 0.65rem; color: #d1d5db; margin-left: 0.25rem; vertical-align: middle; 
    }
    .verification-chip { 
        display: flex; align-items: center; gap: 0.5rem; padding: 0.5rem 0.85rem; 
        background: #f0fdf4; border: 1px solid #dcfce7; border-radius: 8px; 
        font-size: 0.8rem; font-weight: 500; color: #166534; 
    }
    .verification-chip i { color: #10b981; }
    .timeline-item-custom { 
        position: relative; padding-left: 1.5rem; padding-bottom: 1.25rem; 
        border-left: 2px solid #e5e7eb; margin-left: 0.5rem; 
    }
    .timeline-item-custom:last-child { border-left: 2px solid transparent; padding-bottom: 0; }
    .timeline-dot-custom { 
        position: absolute; left: -6px; top: 0; width: 10px; height: 10px; 
        border-radius: 50%; background: var(--primary-blue); border: 2px solid white; 
    }
    .section-title {
        font-size: 0.95rem;
        font-weight: 600;
        color: var(--text-dark);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    .section-title i {
        font-size: 0.9rem;
    }
    .edit-btn {
        font-size: 0.75rem;
        font-weight: 500;
        color: var(--primary-blue);
        border: 1px solid #dbeafe;
        background: #eff6ff;
        border-radius: 20px;
        padding: 0.3rem 0.8rem;
        transition: all 0.2s ease;
    }
    .edit-btn:hover {
        background: var(--primary-blue);
        color: white;
        border-color: var(--primary-blue);
    }
    .completion-bar {
        height: 6px;
        border-radius: 3px;
        background: #f3f4f6;
    }
    /* Custom scrollbar for activities and subjects */
    .scrollable-container {
        max-height: 400px;
        overflow-y: auto;
        padding-right: 5px;
    }
    .scrollable-container::-webkit-scrollbar {
        width: 6px;
    }
    .scrollable-container::-webkit-scrollbar-track {
        background: #f1f5f9;
        border-radius: 3px;
    }
    .scrollable-container::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 3px;
    }
    .scrollable-container::-webkit-scrollbar-thumb:hover {
        background: #94a3b8;
    }
</style>

<div class="app-wrapper">
    <%@ include file="includes/studentSidebar.jsp" %>

    <div class="main-content">
        <%@ include file="includes/studentNavbar.jsp" %>

        <div class="content-area">
            
            <!-- Server Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="custom-alert alert-error"><i class="fas fa-exclamation-circle"></i> <c:out value="${errorMessage}" /></div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="custom-alert alert-success"><i class="fas fa-check-circle"></i> <c:out value="${successMessage}" /></div>
            </c:if>

            <!-- SECTION 1: Compact Professional Header & Profile Completion -->
            <div class="row g-3 mb-3">
                <div class="col-lg-8">
                    <div class="glass-card p-4 h-100 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3" style="border-radius: 16px;">
                        <div class="d-flex align-items-center gap-3">
                            <div class="profile-avatar-custom">
                                <c:out value="${fn:substring(student.fullName, 0, 1)}" default="S" />
                            </div>
                            <div>
                                <h4 class="fw-bold mb-1" style="color: var(--text-dark); font-size: 1.2rem;"><c:out value="${student.fullName}" default="Student Name" /></h4>
                                <p class="mb-2" style="color: var(--text-muted); font-size: 0.8rem;">
                                    <i class="fas fa-id-card me-1"></i> <c:out value="${student.enrollmentNumber}" default="ENR-0000" /> 
                                    <span class="mx-2">|</span> 
                                    <i class="fas fa-graduation-cap me-1"></i> <c:out value="${student.branch}" default="Program" />
                                </p>
                                <span class="badge" style="background: #ecfdf5; color: #10b981; font-size: 0.7rem; font-weight: 500; padding: 0.3rem 0.7rem; border-radius: 20px;">
                                    <i class="fas fa-check-circle me-1"></i>Active Student
                                </span>
                            </div>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="${pageContext.request.contextPath}/student/edit-profile" class="btn btn-sm rounded-pill px-3" style="background: var(--primary-blue); color: white; font-size: 0.8rem;">
                                <i class="fas fa-edit me-1"></i>Edit Profile
                            </a>
                            <a href="${pageContext.request.contextPath}/auth/change-password" class="btn btn-sm rounded-pill px-3" style="border: 1px solid var(--card-border); color: var(--text-muted); font-size: 0.8rem; background: white;">
                                <i class="fas fa-key me-1"></i>Change Password
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="glass-card p-4 h-100" style="border-radius: 16px;">
                        <h6 class="fw-bold mb-3" style="color: var(--text-dark); font-size: 0.9rem;"><i class="fas fa-tasks me-2" style="color: var(--primary-blue);"></i>Profile Completion</h6>
                        <div class="d-flex justify-content-between mb-2">
                            <span style="font-size: 0.8rem; color: var(--text-muted);">${profileCompletion}% Complete</span>
                            <span style="font-size: 0.8rem; font-weight: 600; color: var(--primary-blue);">${100 - profileCompletion}% Remaining</span>
                        </div>
                        <div class="completion-bar mb-3">
                            <div class="progress-bar" style="width: ${profileCompletion}%; background: var(--primary-blue); border-radius: 3px; height: 100%;"></div>
                        </div>
                        <div style="font-size: 0.75rem; font-weight: 600; color: var(--text-muted); margin-bottom: 0.5rem;">Missing information:</div>
                        <ul class="list-unstyled mb-0" style="font-size: 0.8rem;">
                            <c:choose>
                                <c:when test="${not empty missingFields}">
                                    <c:forEach var="missing" items="${missingFields}" varStatus="status">
                                        <li class="${status.last ? 'mb-0' : 'mb-1'}" style="color: var(--text-muted);">
                                            <i class="fas fa-exclamation-circle me-2" style="color: #f59e0b; font-size: 0.7rem;"></i><c:out value="${missing}" />
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li class="mb-0" style="color: var(--text-muted);"><i class="fas fa-check-circle me-2" style="color: #10b981; font-size: 0.7rem;"></i>All information is complete!</li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- SECTION 2: Personal & Academic Information -->
            <div class="row g-3 mb-3">
                <!-- Personal Information -->
                <div class="col-lg-6">
                    <div class="glass-card p-4 h-100" style="border-radius: 16px;">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="section-title"><i class="fas fa-user" style="color: var(--primary-blue);"></i> Personal Information</div>
                            <a href="${pageContext.request.contextPath}/student/edit-profile?section=personal" class="edit-btn text-decoration-none">
                                <i class="fas fa-edit me-1"></i> Edit
                            </a>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="info-label">Full Name</div>
                                <div class="info-value"><c:out value="${student.fullName}" default="Not Available" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Gender</div>
                                <div class="info-value"><c:out value="${student.gender}" default="Not Provided" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Date of Birth</div>
                                <div class="info-value"><c:out value="${student.dateOfBirthFormatted}" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Blood Group</div>
                                <div class="info-value"><c:out value="${student.bloodGroup}" default="Not Provided" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Nationality</div>
                                <div class="info-value"><c:out value="${student.nationality}" default="Not Provided" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Email Address</div>
                                <div class="info-value"><c:out value="${student.email}" default="Not Available" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Mobile Number</div>
                                <div class="info-value"><c:out value="${student.mobileNumber}" default="Not Provided" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Alternate Mobile</div>
                                <div class="info-value"><c:out value="${student.alternateMobile}" default="Not Provided" /></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Academic Information -->
                <div class="col-lg-6">
                    <div class="glass-card p-4 h-100" style="border-radius: 16px;">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="section-title"><i class="fas fa-graduation-cap" style="color: #10b981;"></i> Academic Information</div>
                            <span class="badge" style="background: #f3f4f6; color: var(--text-muted); font-size: 0.7rem; font-weight: 500; padding: 0.3rem 0.7rem; border-radius: 20px;">
                                <i class="fas fa-lock me-1"></i>Read Only
                            </span>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="info-label">Student ID <i class="fas fa-lock readonly-lock" title="Read Only"></i></div>
                                <div class="info-value">STU-<c:out value="${student.userId}" default="000" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Enrollment Number <i class="fas fa-lock readonly-lock" title="Read Only"></i></div>
                                <div class="info-value"><c:out value="${student.enrollmentNumber}" default="Not Available" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Program / Branch <i class="fas fa-lock readonly-lock" title="Read Only"></i></div>
                                <div class="info-value"><c:out value="${student.branch}" default="Not Available" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Current Semester <i class="fas fa-lock readonly-lock" title="Read Only"></i></div>
                                <div class="info-value"><c:out value="${student.currentSemester}" default="Not Available" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Batch <i class="fas fa-lock readonly-lock" title="Read Only"></i></div>
                                <div class="info-value"><c:out value="${student.batch}" default="Not Available" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Admission Date <i class="fas fa-lock readonly-lock" title="Read Only"></i></div>
                                <div class="info-value"><c:out value="${student.admissionDateFormatted}" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Expected Graduation <i class="fas fa-lock readonly-lock" title="Read Only"></i></div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty student.expectedGraduationYear}"><c:out value="${student.expectedGraduationYear}" /></c:when>
                                        <c:otherwise>Not Available</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Current CGPA <i class="fas fa-lock readonly-lock" title="Read Only"></i></div>
                                <div class="info-value"><c:out value="${student.cgpa}" default="0.0" /></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SECTION 3: Address & Guardian -->
            <div class="row g-3 mb-3">
                <!-- Address Information -->
                <div class="col-lg-6">
                    <div class="glass-card p-4 h-100" style="border-radius: 16px;">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="section-title"><i class="fas fa-map-marker-alt" style="color: #ef4444;"></i> Address Information</div>
                            <a href="${pageContext.request.contextPath}/student/edit-profile?section=address" class="edit-btn text-decoration-none">
                                <i class="fas fa-edit me-1"></i> Edit
                            </a>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="info-label">Permanent Address</div>
                                <div class="info-value" style="margin-bottom: 0;">
                                    <c:choose>
                                        <c:when test="${not empty student.permanentAddress}"><c:out value="${student.permanentAddress}" /></c:when>
                                        <c:otherwise>Not Provided</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Correspondence Address</div>
                                <div class="info-value" style="margin-bottom: 0;">
                                    <c:choose>
                                        <c:when test="${not empty student.correspondenceAddress}"><c:out value="${student.correspondenceAddress}" /></c:when>
                                        <c:when test="${not empty student.permanentAddress}">Same as Permanent Address</c:when>
                                        <c:otherwise>Not Provided</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Guardian / Emergency Contact -->
                <div class="col-lg-6">
                    <div class="glass-card p-4 h-100" style="border-radius: 16px;">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="section-title"><i class="fas fa-user-shield" style="color: #f59e0b;"></i> Guardian / Emergency Contact</div>
                            <a href="${pageContext.request.contextPath}/student/edit-profile?section=guardian" class="edit-btn text-decoration-none">
                                <i class="fas fa-edit me-1"></i> Edit
                            </a>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="info-label">Guardian Name</div>
                                <div class="info-value"><c:out value="${student.guardianName}" default="Not Provided" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Relationship</div>
                                <div class="info-value"><c:out value="${student.guardianRelationship}" default="Not Provided" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Primary Contact</div>
                                <div class="info-value"><c:out value="${student.guardianContact}" default="Not Provided" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Alternate Contact</div>
                                <div class="info-value"><c:out value="${student.guardianAlternateContact}" default="Not Provided" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Email</div>
                                <div class="info-value"><c:out value="${student.guardianEmail}" default="Not Provided" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Occupation</div>
                                <div class="info-value"><c:out value="${student.guardianOccupation}" default="Not Provided" /></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SECTION 4: Security & Verification -->
            <div class="row g-3 mb-3">
                <!-- Account Security -->
                <div class="col-lg-6">
                    <div class="glass-card p-4 h-100" style="border-radius: 16px;">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="section-title"><i class="fas fa-shield-alt" style="color: #06b6d4;"></i> Account Security</div>
                            <a href="${pageContext.request.contextPath}/auth/change-password" class="edit-btn text-decoration-none" style="color: var(--text-muted); border-color: var(--card-border); background: white;">
                                <i class="fas fa-key me-1"></i>Change Password
                            </a>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="info-label">Last Login</div>
                                <div class="info-value"><c:out value="${lastLoginTimeFormatted}" /></div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">Account Status</div>
                                <div class="info-value">
                                    <span class="badge" style="background: #ecfdf5; color: #10b981; font-size: 0.7rem; font-weight: 500; padding: 0.3rem 0.6rem; border-radius: 20px;">
                                        <i class="fas fa-check me-1"></i>Active
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Verification Status -->
                <div class="col-lg-6">
                    <div class="glass-card p-4 h-100" style="border-radius: 16px;">
                        <h6 class="fw-bold mb-3" style="color: var(--text-dark); font-size: 0.9rem;"><i class="fas fa-certificate me-2" style="color: #10b981;"></i>Verification Status</h6>
                        <div class="row g-2">
                            <div class="col-md-6">
                                <div class="verification-chip"><i class="fas fa-check-circle"></i><span>Student Record Verified</span></div>
                            </div>
                            <div class="col-md-6">
                                <div class="verification-chip"><i class="fas fa-check-circle"></i><span>Email Verified</span></div>
                            </div>
                            <div class="col-md-6">
                                <div class="verification-chip"><i class="fas fa-check-circle"></i><span>Enrollment Verified</span></div>
                            </div>
                            <div class="col-md-6">
                                <div class="verification-chip"><i class="fas fa-check-circle"></i><span>Academic Registration Active</span></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SECTION 5: Activities & Subjects -->
            <div class="row g-3 mb-3">
                <!-- Recent Profile Activities -->
                <div class="col-lg-5">
                    <div class="glass-card p-4 h-100" style="border-radius: 16px;">
                        <h6 class="fw-bold mb-3" style="color: var(--text-dark); font-size: 0.9rem;"><i class="fas fa-history me-2" style="color: var(--primary-blue);"></i>Recent Profile Activities</h6>
                        <div class="scrollable-container">
                            <c:choose>
                                <c:when test="${not empty recentActivities}">
                                    <c:forEach var="activity" items="${recentActivities}">
                                        <div class="timeline-item-custom">
                                            <div class="timeline-dot-custom"></div>
                                            <div style="font-size: 0.85rem; font-weight: 600; color: var(--text-dark);"><c:out value="${activity.action}" /></div>
                                            <div style="font-size: 0.75rem; color: var(--text-muted);"><c:out value="${activity.timestampFormatted}" /></div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-3">
                                        <i class="fas fa-history mb-2" style="font-size: 1.5rem; color: #d1d5db;"></i>
                                        <p style="color: var(--text-muted); font-size: 0.85rem;" class="mb-0">No recent activities found.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Enrolled Subjects -->
                <div class="col-lg-7">
                    <div class="glass-card p-4 h-100" style="border-radius: 16px;">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="fw-bold mb-0" style="color: var(--text-dark); font-size: 0.9rem;"><i class="fas fa-book me-2" style="color: #06b6d4;"></i>Enrolled Subjects</h6>
                            <span class="badge" style="background: var(--primary-blue); color: white; font-size: 0.7rem; font-weight: 500; padding: 0.3rem 0.7rem; border-radius: 20px;">
                                <c:out value="${fn:length(subjects)}" default="0" /> Subjects
                            </span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty subjects}">
                                <div class="scrollable-container">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead>
                                            <tr style="background: #f9fafb;">
                                                <th scope="col" class="border-0 py-2 px-3" style="color: var(--text-muted); font-size: 0.7rem; text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px;">#</th>
                                                <th scope="col" class="border-0 py-2" style="color: var(--text-muted); font-size: 0.7rem; text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px;">Subject Code</th>
                                                <th scope="col" class="border-0 py-2" style="color: var(--text-muted); font-size: 0.7rem; text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px;">Subject Name</th>
                                                <th scope="col" class="border-0 py-2 text-center" style="color: var(--text-muted); font-size: 0.7rem; text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px;">Credits</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="subject" items="${subjects}" varStatus="status">
                                                <tr style="border-bottom: 1px solid #f3f4f6;">
                                                    <td class="px-3 fw-semibold" style="color: var(--text-muted); font-size: 0.8rem;"><c:out value="${status.index + 1}" /></td>
                                                    <td><span class="badge" style="background: #eff6ff; color: var(--primary-blue); font-size: 0.7rem; font-weight: 500; padding: 0.3rem 0.6rem; border-radius: 6px;"><c:out value="${subject.subjectCode}" /></span></td>
                                                    <td style="font-weight: 500; color: var(--text-dark); font-size: 0.85rem;"><c:out value="${subject.subjectName}" /></td>
                                                    <td class="text-center" style="font-weight: 600; color: var(--text-muted); font-size: 0.85rem;"><c:out value="${subject.credits}" /></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4">
                                    <i class="fas fa-book mb-2" style="font-size: 1.5rem; color: #d1d5db;"></i>
                                    <p style="color: var(--text-muted); font-size: 0.85rem;" class="mb-0">No enrolled subjects found for the current semester.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>

        <footer class="footer">
            &copy; <c:out value="${copyrightYear}" default="2026" /> <c:out value="${universityName}" default="University" />. All rights reserved.
        </footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>