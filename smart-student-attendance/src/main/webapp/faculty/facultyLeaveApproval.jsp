<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Leave Approvals" scope="request" />
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

	.leaves-container {
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

    /* ===== HERO HEADER ===== */
    .hero-header {
        background: rgba(255,255,255,0.95);
        backdrop-filter: blur(20px);
        border: 1px solid rgba(255,255,255,0.3);
        border-radius: var(--radius-xl);
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: var(--shadow-soft);
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1.5rem;
    }
    .hero-title { font-size: 1.75rem; font-weight: 700; color: #111827; margin: 0 0 0.5rem 0; display: flex; align-items: center; gap: 0.75rem; }
    .hero-subtitle { color: #6b7280; margin: 0; font-size: 0.95rem; }
    .hero-stats { display: flex; gap: 0.75rem; flex-wrap: wrap; }
    .stat-chip {
        background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
        border: 1px solid #bae6fd;
        border-radius: 50px;
        padding: 0.6rem 1.1rem;
        display: flex; align-items: center; gap: 0.5rem;
        font-weight: 600; color: #0369a1; font-size: 0.85rem;
    }

    /* ===== FILTER TABS ===== */
    .filter-tabs {
        display: flex;
        gap: 0.5rem;
        margin-bottom: 1.5rem;
        flex-wrap: wrap;
        background: white;
        padding: 0.75rem;
        border-radius: var(--radius-lg);
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
    }

    .filter-tab {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.65rem 1.25rem;
        border-radius: 50px;
        font-size: 0.85rem;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.3s ease;
        border: 2px solid transparent;
        background: #f3f4f6;
        color: #6b7280;
    }

    .filter-tab:hover {
        background: #e5e7eb;
        color: #374151;
        transform: translateY(-1px);
    }

    .filter-tab.active {
        background: var(--primary-gradient);
        color: white;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }

    .filter-tab .count-badge {
        background: rgba(255,255,255,0.25);
        padding: 0.15rem 0.55rem;
        border-radius: 50px;
        font-size: 0.75rem;
        font-weight: 700;
    }

    .filter-tab:not(.active) .count-badge {
        background: #e5e7eb;
        color: #6b7280;
    }

    .filter-tab.pending-tab.active { background: var(--warning-gradient); }
    .filter-tab.approved-tab.active { background: var(--success-gradient); }
    .filter-tab.rejected-tab.active { background: var(--danger-gradient); }

    /* ===== LEAVE CARDS ===== */
    .leave-card {
        background: white;
        border-radius: var(--radius-lg);
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        margin-bottom: 1.25rem;
        overflow: hidden;
        transition: all 0.3s ease;
    }

    .leave-card:hover {
        box-shadow: var(--shadow-hover);
        transform: translateY(-2px);
    }

    .leave-card-header {
        padding: 1.25rem 1.5rem;
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 1rem;
        flex-wrap: wrap;
        border-bottom: 1px solid #f3f4f6;
    }

    .student-info-block {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .student-avatar {
        width: 48px; height: 48px;
        border-radius: 50%;
        background: var(--primary-gradient);
        display: flex; align-items: center; justify-content: center;
        color: white; font-weight: 700; font-size: 1.1rem;
        flex-shrink: 0;
    }

    .student-name { font-weight: 700; color: #111827; font-size: 1rem; margin: 0; }
    .student-meta { font-size: 0.8rem; color: #6b7280; margin-top: 0.15rem; }

    /* ===== STATUS BADGES ===== */
    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        padding: 0.45rem 1rem;
        border-radius: 50px;
        font-size: 0.8rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .status-pending { background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #92400e; }
    .status-approved { background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #065f46; }
    .status-rejected { background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%); color: #991b1b; }

    /* ===== LEAVE DETAILS ===== */
    .leave-card-body {
        padding: 1.25rem 1.5rem;
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.25rem;
    }

    .detail-block {}
    .detail-label {
        font-size: 0.7rem;
        font-weight: 700;
        color: #9ca3af;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 0.35rem;
        display: flex; align-items: center; gap: 0.35rem;
    }
    .detail-value { font-size: 0.9rem; color: #111827; font-weight: 500; }

    .duration-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.3rem;
        background: #f3f4f6;
        padding: 0.25rem 0.65rem;
        border-radius: 50px;
        font-size: 0.75rem;
        font-weight: 600;
        color: #374151;
        margin-left: 0.5rem;
    }

    .reason-block {
        grid-column: 1 / -1;
        background: #f9fafb;
        padding: 1rem 1.25rem;
        border-radius: var(--radius-md);
        border-left: 3px solid #667eea;
    }

    /* ===== REVIEW INFO ===== */
    .review-info {
        grid-column: 1 / -1;
        padding: 0.85rem 1.25rem;
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-size: 0.85rem;
    }
    .review-info.approved-bg { background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%); color: #166534; border: 1px solid #a7f3d0; }
    .review-info.rejected-bg { background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%); color: #991b1b; border: 1px solid #fecaca; }

    /* ===== ACTION BUTTONS ===== */
    .leave-card-actions {
        padding: 1rem 1.5rem;
        background: #f9fafb;
        display: flex;
        justify-content: flex-end;
        gap: 0.75rem;
        border-top: 1px solid #f3f4f6;
    }

    .btn-action {
        padding: 0.55rem 1.5rem;
        border-radius: 50px;
        font-size: 0.85rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        border: none;
    }

    .btn-approve {
        background: var(--success-gradient);
        color: white;
        box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
    }
    .btn-approve:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(16, 185, 129, 0.4); }

    .btn-reject {
        background: white;
        color: #ef4444;
        border: 2px solid #fecaca;
    }
    .btn-reject:hover { background: #fef2f2; border-color: #ef4444; }

    /* ===== EMPTY STATE ===== */
    .empty-state {
        text-align: center;
        padding: 4rem 2rem;
        background: white;
        border-radius: var(--radius-xl);
        border: 2px dashed #e5e7eb;
    }
    .empty-icon {
        width: 100px; height: 100px;
        margin: 0 auto 1.5rem;
        background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-size: 2.5rem;
    }
    .empty-title { font-size: 1.25rem; font-weight: 700; color: #111827; margin: 0 0 0.5rem 0; }
    .empty-text { color: #6b7280; margin-bottom: 1.5rem; }

    /* ===== RESPONSIVE ===== */
    @media (max-width: 768px) {
        .hero-header { flex-direction: column; text-align: center; }
        .hero-stats { justify-content: center; }
        .leave-card-body { grid-template-columns: 1fr; }
        .leave-card-actions { flex-direction: column; }
        .btn-action { width: 100%; justify-content: center; }
        .filter-tabs { justify-content: center; }
    }
</style>

<div class="app-wrapper">
    <%@ include file="facultySidebar.jsp" %>
    <div class="main-content">
        <%@ include file="facultyNavbar.jsp" %>

        <div class="leaves-container">

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

			<!-- Hero Header -->
			<div class="hero-header">
			    <div>
			        <h2 class="hero-title">
			            <i class="fas fa-file-signature" style="color: #667eea;"></i>
			            Leave Requests
			        </h2>
			        <p class="hero-subtitle">Review and manage leave requests from your class students.</p>
			    </div>
			    
			    <div class="hero-stats">
			        <div class="stat-chip">
			            <i class="fas fa-users"></i>
			            Your Section: 
			            
			            <!-- ✅ JSTL Logic to handle display -->
			            <c:choose>
			                <c:when test="${isClassAdvisor}">
			                    <strong>${sectionInfo.sectionName}</strong>
			                    <br>
			                    <small style="opacity: 0.8; font-size: 0.85em;">
			                        ${sectionInfo.department} • Sem ${sectionInfo.semester} • ${sectionInfo.batch}
			                    </small>
			                </c:when>
			                <c:otherwise>
			                    <strong>Not Assigned</strong>
			                </c:otherwise>
			            </c:choose>
			        </div>
			    </div>
			</div>

            <!-- Filter Tabs -->
            <div class="filter-tabs">
                <a href="${pageContext.request.contextPath}/faculty/leave-approval?status=ALL"
                   class="filter-tab ${currentFilter == 'ALL' ? 'active' : ''}">
                    <i class="fas fa-layer-group"></i> All
                    <span class="count-badge">${leaveCounts['ALL']}</span>
                </a>
                <a href="${pageContext.request.contextPath}/faculty/leave-approval?status=PENDING"
                   class="filter-tab pending-tab ${currentFilter == 'PENDING' ? 'active' : ''}">
                    <i class="fas fa-clock"></i> Pending
                    <span class="count-badge">${leaveCounts['PENDING']}</span>
                </a>
                <a href="${pageContext.request.contextPath}/faculty/leave-approval?status=APPROVED"
                   class="filter-tab approved-tab ${currentFilter == 'APPROVED' ? 'active' : ''}">
                    <i class="fas fa-check-circle"></i> Approved
                    <span class="count-badge">${leaveCounts['APPROVED']}</span>
                </a>
                <a href="${pageContext.request.contextPath}/faculty/leave-approval?status=REJECTED"
                   class="filter-tab rejected-tab ${currentFilter == 'REJECTED' ? 'active' : ''}">
                    <i class="fas fa-times-circle"></i> Rejected
                    <span class="count-badge">${leaveCounts['REJECTED']}</span>
                </a>
            </div>

            <!-- Leave Requests List -->
            <c:choose>
                <c:when test="${not empty allLeaves}">
                    <c:forEach var="leave" items="${allLeaves}">
                        <div class="leave-card">
                            <!-- Card Header -->
                            <div class="leave-card-header">
                                <div class="student-info-block">
                                    <div class="student-avatar">
                                        <c:out value="${fn:substring(leave.studentName, 0, 1)}" default="S" />
                                    </div>
                                    <div>
                                        <h4 class="student-name"><c:out value="${leave.studentName}" /></h4>
                                        <div class="student-meta">
                                            <c:out value="${leave.enrollmentNumber}" /> •
                                            <c:out value="${leave.branch}" /> •
                                            Sem <c:out value="${leave.currentSemester}" /> •
                                            <c:out value="${leave.sectionName}" />
                                        </div>
                                    </div>
                                </div>
                                <c:choose>
                                    <c:when test="${leave.status == 'PENDING'}">
                                        <span class="status-badge status-pending">
                                            <i class="fas fa-clock"></i> Pending
                                        </span>
                                    </c:when>
                                    <c:when test="${leave.status == 'APPROVED'}">
                                        <span class="status-badge status-approved">
                                            <i class="fas fa-check-circle"></i> Approved
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-rejected">
                                            <i class="fas fa-times-circle"></i> Rejected
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Card Body -->
                            <div class="leave-card-body">
                                <div class="detail-block">
                                    <div class="detail-label"><i class="fas fa-calendar"></i> Duration</div>
                                    <div class="detail-value">
                                        <c:out value="${leave.startDateFormatted}" /> — <c:out value="${leave.endDateFormatted}" />
                                        <span class="duration-badge">
                                            <i class="fas fa-calendar-day"></i>
                                            <c:out value="${leave.daysCount}" /> day<c:if test="${leave.daysCount > 1}">s</c:if>
                                        </span>
                                    </div>
                                </div>
                                <div class="detail-block">
                                    <div class="detail-label"><i class="fas fa-paper-plane"></i> Applied On</div>
                                    <div class="detail-value"><c:out value="${leave.appliedOnFormatted}" /></div>
                                </div>

                                <!-- Reason -->
                                <div class="reason-block">
                                    <div class="detail-label"><i class="fas fa-comment-dots"></i> Reason</div>
                                    <div class="detail-value"><c:out value="${leave.reason}" /></div>
                                </div>

                                <!-- Review Info (only for approved/rejected) -->
                                <c:if test="${leave.status != 'PENDING' && leave.reviewedAt != null}">
                                    <div class="review-info ${leave.status == 'APPROVED' ? 'approved-bg' : 'rejected-bg'}">
                                        <i class="fas ${leave.status == 'APPROVED' ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                                        <div>
                                            <strong>
                                                <c:out value="${leave.status == 'APPROVED' ? 'Approved' : 'Rejected'}" />
                                                by <c:out value="${leave.reviewerName}" default="Advisor" />
                                            </strong>
                                            on <c:out value="${leave.reviewedAtFormatted}" />
                                            <c:if test="${not empty leave.reviewRemarks}">
                                                — "<c:out value="${leave.reviewRemarks}" />"
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Actions (only for pending) -->
                            <c:if test="${leave.status == 'PENDING'}">
                                <div class="leave-card-actions">
                                    <form method="POST" action="${pageContext.request.contextPath}/faculty/leave-approval" style="display: inline;">
                                        <input type="hidden" name="leaveId" value="${leave.leaveId}">
                                        <input type="hidden" name="action" value="reject">
                                        <input type="hidden" name="status" value="${currentFilter}">
                                        <button type="submit" class="btn-action btn-reject"
                                                onclick="return confirm('Are you sure you want to reject this leave request?')">
                                            <i class="fas fa-times"></i> Reject
                                        </button>
                                    </form>
                                    <form method="POST" action="${pageContext.request.contextPath}/faculty/leave-approval" style="display: inline;">
                                        <input type="hidden" name="leaveId" value="${leave.leaveId}">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="status" value="${currentFilter}">
                                        <button type="submit" class="btn-action btn-approve">
                                            <i class="fas fa-check"></i> Approve
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <c:choose>
                                <c:when test="${currentFilter == 'PENDING'}">
                                    <i class="fas fa-check-double" style="color: #10b981;"></i>
                                </c:when>
                                <c:when test="${currentFilter == 'APPROVED'}">
                                    <i class="fas fa-inbox" style="color: #3b82f6;"></i>
                                </c:when>
                                <c:when test="${currentFilter == 'REJECTED'}">
                                    <i class="fas fa-inbox" style="color: #3b82f6;"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-folder-open" style="color: #6b7280;"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h3 class="empty-title">
                            <c:choose>
                                <c:when test="${currentFilter == 'PENDING'}">All Caught Up!</c:when>
                                <c:when test="${currentFilter == 'APPROVED'}">No Approved Requests</c:when>
                                <c:when test="${currentFilter == 'REJECTED'}">No Rejected Requests</c:when>
                                <c:otherwise>No Leave Requests</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="empty-text">
                            <c:choose>
                                <c:when test="${currentFilter == 'PENDING'}">No pending leave requests to review.</c:when>
                                <c:when test="${currentFilter == 'ALL'}">No leave requests have been submitted yet.</c:when>
                                <c:otherwise>No requests match this filter.</c:otherwise>
                            </c:choose>
                        </p>
                        <a href="${pageContext.request.contextPath}/faculty/leave-approval?status=ALL"
                           class="btn-action btn-approve" style="text-decoration: none;">
                            <i class="fas fa-layer-group"></i> View All Requests
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>

        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<script>
    // Auto-dismiss alerts after 3 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.custom-alert');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                alert.classList.add('fade-out');
                setTimeout(function() { alert.remove(); }, 500);
            }, 5000);
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>