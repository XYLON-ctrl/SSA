<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- Set page title for the Navbar --%>
<c:set var="pageTitle" value="Leave History" scope="request" />

<%@ include file="includes/studentHead.jsp" %>

<style>
    .filter-btn {
        transition: all 0.3s ease;
        border: 2px solid transparent;
        font-weight: 600;
        border-radius: 50px !important;
        padding: 0.6rem 1.5rem;
        position: relative;
    }
    
    .filter-btn.active {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-color: transparent;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        transform: translateY(-2px);
    }
    
    .filter-btn.active .badge-count {
        background: rgba(255, 255, 255, 0.3);
        color: white;
    }
    
    .filter-btn:not(.active):hover {
        background: #f8fafc;
        border-color: #667eea;
        color: #667eea;
        transform: translateY(-1px);
    }
    
    .badge-count {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-width: 24px;
        height: 24px;
        padding: 0 6px;
        border-radius: 12px;
        font-size: 0.75rem;
        font-weight: 700;
        margin-left: 6px;
        background: #e2e8f0;
        color: #4a5568;
        transition: all 0.3s ease;
    }
    
    .table-responsive {
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }
    
    .table-responsive::-webkit-scrollbar {
        height: 6px;
    }
    
    .table-responsive::-webkit-scrollbar-track {
        background: #f1f5f9;
    }
    
    .table-responsive::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 3px;
    }
    
    .table-responsive::-webkit-scrollbar-thumb:hover {
        background: #94a3b8;
    }
    
    .table-row {
        transition: all 0.2s ease;
    }
    
    .table-row:hover {
        background: #f8fafc;
        transform: scale(1.01);
    }
    
    /* Fix table width to prevent horizontal scroll */
    .table {
        min-width: 100%;
        table-layout: fixed;
    }
    
    .table th:nth-child(1), .table td:nth-child(1) { width: 5%; }
    .table th:nth-child(2), .table td:nth-child(2) { width: 20%; }
    .table th:nth-child(3), .table td:nth-child(3) { width: 8%; }
    .table th:nth-child(4), .table td:nth-child(4) { width: 30%; }
    .table th:nth-child(5), .table td:nth-child(5) { width: 15%; }
    .table th:nth-child(6), .table td:nth-child(6) { width: 22%; }
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

            <!-- 1. Header & Filter Tabs -->
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                <div>
                    <h2 class="page-title mb-1"><i class="fas fa-history text-primary me-2"></i>Leave History</h2>
                    <p class="page-subtitle mb-0">Track the status of your past and current leave requests.</p>
                </div>
                
                <!-- Status Filter Tabs -->
				<div class="d-flex gap-2 flex-wrap">
				    <a href="${pageContext.request.contextPath}/student/leave/history?status=ALL" 
				       class="btn filter-btn ${currentFilter == 'ALL' ? 'active' : 'btn-light border'} text-decoration-none">
				        All Requests
				        <span class="badge-count">${totalCount}</span>
				    </a>
				    
				    <a href="${pageContext.request.contextPath}/student/leave/history?status=PENDING" 
				       class="btn filter-btn ${currentFilter == 'PENDING' ? 'active' : 'btn-light border'} text-decoration-none">
				        Pending
				        <span class="badge-count">${pendingCount}</span>
				    </a>
				    
				    <a href="${pageContext.request.contextPath}/student/leave/history?status=APPROVED" 
				       class="btn filter-btn ${currentFilter == 'APPROVED' ? 'active' : 'btn-light border'} text-decoration-none">
				        Approved
				        <span class="badge-count">${approvedCount}</span>
				    </a>
				    
				    <a href="${pageContext.request.contextPath}/student/leave/history?status=REJECTED" 
				       class="btn filter-btn ${currentFilter == 'REJECTED' ? 'active' : 'btn-light border'} text-decoration-none">
				        Rejected
				        <span class="badge-count">${rejectedCount}</span>
				    </a>
				</div>
            </div>

            <!-- 2. Leave History Table -->
			<div class="glass-card p-0" style="border-radius: 20px; overflow: hidden;">
			    <c:choose>
			        <c:when test="${not empty leaveHistory}">
			            <div class="table-responsive">
			                <table class="table table-hover align-middle mb-0">
			                    <thead class="bg-light">
			                        <tr>
			                            <th scope="col" class="border-0 py-3 px-4 text-muted small text-uppercase">#</th>
			                            <th scope="col" class="border-0 py-3 text-muted small text-uppercase">Duration</th>
			                            <th scope="col" class="border-0 py-3 text-muted small text-uppercase text-center">Days</th>
			                            <th scope="col" class="border-0 py-3 text-muted small text-uppercase">Reason</th>
			                            <th scope="col" class="border-0 py-3 text-muted small text-uppercase text-center">Status</th>
			                            <th scope="col" class="border-0 py-3 text-muted small text-uppercase text-center">Applied On</th>
			                        </tr>
			                    </thead>
			                    <tbody>
			                        <c:forEach var="leave" items="${leaveHistory}" varStatus="status">
			                            <tr class="table-row">
			                                <td class="px-4 fw-semibold text-muted">
			                                    <c:out value="${status.index + 1}" />
			                                </td>
			                                <td>
			                                    <div class="fw-semibold text-dark">
			                                        <c:out value="${leave.startDateFormatted}" />
			                                    </div>
			                                    <div class="small text-muted">
			                                        to <c:out value="${leave.endDateFormatted}" />
			                                    </div>
			                                </td>
			                                <td class="text-center">
			                                    <span class="badge bg-light text-dark border rounded-pill px-3 py-2">
			                                        <c:out value="${leave.daysCount}" default="-" />
			                                    </span>
			                                </td>
			                                <td>
			                                    <div class="text-truncate text-dark" style="max-width: 250px;" title="<c:out value='${leave.reason}' />">
			                                        <c:out value="${leave.reason}" />
			                                    </div>
			                                </td>
			                                <td class="text-center">
			                                    <c:choose>
			                                        <c:when test="${leave.status == 'PENDING'}">
			                                            <span class="badge bg-warning bg-opacity-10 text-warning px-3 py-2 rounded-pill border border-warning-subtle">
			                                                <i class="fas fa-clock me-1"></i> Pending
			                                            </span>
			                                        </c:when>
			                                        <c:when test="${leave.status == 'APPROVED'}">
			                                            <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill border border-success-subtle">
			                                                <i class="fas fa-check-circle me-1"></i> Approved
			                                            </span>
			                                        </c:when>
			                                        <c:when test="${leave.status == 'REJECTED'}">
			                                            <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill border border-danger-subtle">
			                                                <i class="fas fa-times-circle me-1"></i> Rejected
			                                            </span>
			                                        </c:when>
			                                        <c:otherwise>
			                                            <span class="badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill">
			                                                <c:out value="${leave.status}" />
			                                            </span>
			                                        </c:otherwise>
			                                    </c:choose>
			                                </td>
			                                <td class="text-center">
			                                    <div class="small text-muted">
			                                        <c:out value="${leave.appliedOnFormatted}" />
			                                    </div>
			                                    <div class="small text-muted opacity-75">
			                                        <c:out value="${leave.appliedOnTimeFormatted}" />
			                                    </div>
			                                </td>
			                            </tr>
			                        </c:forEach>
			                    </tbody>
			                </table>
			            </div>
			        </c:when>
			        
			        <c:otherwise>
			            <!-- Empty State -->
			            <div class="text-center py-5 px-4">
			                <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width: 100px; height: 100px;">
			                    <i class="fas fa-folder-open fa-3x text-muted opacity-50"></i>
			                </div>
			                <h4 class="fw-bold text-dark mb-2">No Leave Requests Found</h4>
			                <p class="text-muted mb-4" style="max-width: 400px; margin: 0 auto;">
			                    <c:choose>
			                        <c:when test="${currentFilter == 'ALL'}">
			                            You haven't submitted any leave requests yet.
			                        </c:when>
			                        <c:otherwise>
			                            No <c:out value="${currentFilter}" /> leave requests found.
			                        </c:otherwise>
			                    </c:choose>
			                </p>
			                <a href="${pageContext.request.contextPath}/student/leave/request" class="btn btn-primary rounded-pill px-4 shadow-sm">
			                    <i class="fas fa-plus me-2"></i> Apply for Leave
			                </a>
			            </div>
			        </c:otherwise>
			    </c:choose>
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