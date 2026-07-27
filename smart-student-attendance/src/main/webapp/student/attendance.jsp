<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %> 

<%-- Set page title for the Navbar --%>
<c:set var="pageTitle" value="Attendance Overview" scope="request" />

<%@ include file="includes/studentHead.jsp" %>

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

            <!-- 1. Overall Attendance Summary Card -->
            <div class="glass-card mb-4 p-0 overflow-hidden" style="border-radius: 20px;">
                <div class="row g-0 align-items-center">
                    <div class="col-md-6 p-4 p-md-5">
                        <h5 class="text-muted text-uppercase fw-semibold mb-3" style="letter-spacing: 1px; font-size: 0.85rem;">Overall Attendance</h5>
                        
                        <div class="d-flex align-items-baseline gap-3 mb-3">
                            <h1 class="display-3 fw-bold text-dark mb-0">
                                <fmt:formatNumber value="${overallPercentage}" pattern="#0.00" />
                                <span class="fs-3 text-muted">%</span>
                            </h1>
                            
                            <!-- Dynamic Status Badge -->
                            <c:choose>
                                <c:when test="${overallPercentage >= 85}">
                                    <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill fs-6">Excellent</span>
                                </c:when>
                                <c:when test="${overallPercentage >= 75}">
                                    <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill fs-6">Good</span>
                                </c:when>
                                <c:when test="${overallPercentage >= 60}">
                                    <span class="badge bg-warning bg-opacity-10 text-warning px-3 py-2 rounded-pill fs-6">Warning</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill fs-6">Critical</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <p class="text-muted mb-4">
                            <c:choose>
                                <c:when test="${overallPercentage >= 75}">
                                    <i class="fas fa-check-circle text-success me-1"></i> You are meeting the minimum attendance requirement.
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-exclamation-triangle text-danger me-1"></i> You are below the minimum 75% attendance requirement.
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <!-- Visual Progress Bar -->
                        <div class="progress" style="height: 12px; border-radius: 6px; background: rgba(0,0,0,0.05);">
                            <c:choose>
                                <c:when test="${overallPercentage >= 85}">
                                    <div class="progress-bar bg-success" role="progressbar" style="width: ${overallPercentage}%"></div>
                                </c:when>
                                <c:when test="${overallPercentage >= 75}">
                                    <div class="progress-bar bg-primary" role="progressbar" style="width: ${overallPercentage}%"></div>
                                </c:when>
                                <c:when test="${overallPercentage >= 60}">
                                    <div class="progress-bar bg-warning" role="progressbar" style="width: ${overallPercentage}%"></div>
                                </c:when>
                                <c:otherwise>
                                    <div class="progress-bar bg-danger" role="progressbar" style="width: ${overallPercentage}%"></div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Right Side Visual/Info -->
                    <div class="col-md-6 bg-light bg-opacity-50 p-4 p-md-5 d-flex flex-column justify-content-center border-start border-light">
                        <h6 class="fw-bold text-dark mb-4"><i class="fas fa-info-circle text-primary me-2"></i>Attendance Guidelines</h6>
                        <ul class="list-unstyled mb-0">
                            <li class="mb-3 d-flex align-items-start gap-3">
                                <i class="fas fa-check-circle text-success mt-1"></i>
                                <span class="small text-muted"><strong class="text-dark">85% - 100%:</strong> Excellent standing. Eligible for all exams.</span>
                            </li>
                            <li class="mb-3 d-flex align-items-start gap-3">
                                <i class="fas fa-check-circle text-primary mt-1"></i>
                                <span class="small text-muted"><strong class="text-dark">75% - 84%:</strong> Good standing. Meets minimum requirements.</span>
                            </li>
                            <li class="mb-3 d-flex align-items-start gap-3">
                                <i class="fas fa-exclamation-circle text-warning mt-1"></i>
                                <span class="small text-muted"><strong class="text-dark">60% - 74%:</strong> Warning. Risk of detention if it drops further.</span>
                            </li>
                            <li class="d-flex align-items-start gap-3">
                                <i class="fas fa-times-circle text-danger mt-1"></i>
                                <span class="small text-muted"><strong class="text-dark">Below 60%:</strong> Critical. Detained from appearing in exams.</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- 2. Subject-Wise Attendance Breakdown -->
            <div class="glass-card" style="border-radius: 20px;">
                <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                    <h4 class="fw-bold text-dark mb-0"><i class="fas fa-list-alt text-primary me-2"></i>Subject-Wise Breakdown</h4>
                    <span class="badge bg-light text-primary border border-primary-subtle px-3 py-2 rounded-pill">
                        <c:out value="${fn:length(subjectAttendance)}" default="0" /> Subjects
                    </span>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th scope="col" class="border-0 rounded-start-3 py-3 px-4 text-muted small text-uppercase">#</th>
                                <th scope="col" class="border-0 py-3 text-muted small text-uppercase">Subject Name</th>
                                <th scope="col" class="border-0 py-3 text-muted small text-uppercase text-center">Classes</th>
                                <th scope="col" class="border-0 py-3 text-muted small text-uppercase text-center">Percentage</th>
                                <th scope="col" class="border-0 py-3 text-muted small text-uppercase text-center">Status</th>
                                <th scope="col" class="border-0 rounded-end-3 py-3 text-muted small text-uppercase text-center">Insight</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty subjectAttendance}">
                                    <c:forEach var="subject" items="${subjectAttendance}" varStatus="status">
                                        <tr>
                                            <td class="px-4 fw-semibold text-muted">
                                                <c:out value="${status.index + 1}" />
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark">
                                                    <c:out value="${subject.subjectName}" />
                                                </div>
                                                <!-- Link to detailed view -->
                                                <a href="${pageContext.request.contextPath}/student/attendance/details?subjectId=${subject.subjectId}" 
                                                   class="text-decoration-none small text-primary mt-1 d-inline-block">
                                                    View Details <i class="fas fa-arrow-right ms-1" style="font-size: 0.7rem;"></i>
                                                </a>
                                            </td>
                                            <td class="text-center">
                                                <span class="fw-bold text-dark"><c:out value="${subject.attendedClasses}" /></span>
                                                <span class="text-muted">/</span>
                                                <span class="text-muted"><c:out value="${subject.totalClasses}" /></span>
                                            </td>
                                            <td class="text-center">
                                                <div class="fw-bold text-dark">
                                                    <fmt:formatNumber value="${subject.percentage}" pattern="#0.0" />%
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${subject.status == 'Excellent'}">
                                                        <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill">Excellent</span>
                                                    </c:when>
                                                    <c:when test="${subject.status == 'Good'}">
                                                        <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill">Good</span>
                                                    </c:when>
                                                    <c:when test="${subject.status == 'Warning'}">
                                                        <span class="badge bg-warning bg-opacity-10 text-warning px-3 py-2 rounded-pill">Warning</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill">Critical</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${subject.classesNeeded > 0}">
                                                        <span class="text-danger small fw-semibold">
                                                            <i class="fas fa-arrow-up me-1"></i> Need ${subject.classesNeeded} more
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-success small fw-semibold">
                                                            <i class="fas fa-check me-1"></i> On Track
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="fas fa-clipboard-list fa-3x mb-3 opacity-25"></i>
                                            <p class="mb-0">No attendance records found for the current semester.</p>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
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