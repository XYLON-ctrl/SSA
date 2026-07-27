<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- Set page title for the Navbar --%>
<c:set var="pageTitle" value="Notifications" scope="request" />

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

            <!-- 1. Header & Actions -->
            <div class="glass-card mb-4 p-4" style="border-radius: 20px;">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <div>
                        <h2 class="page-title mb-1"><i class="fas fa-bell text-primary me-2"></i>Notifications</h2>
                        <p class="page-subtitle mb-0">Stay updated with your academic alerts and announcements.</p>
                    </div>
                    
                    <!-- Mark All as Read Form -->
                    <c:if test="${not empty notifications}">
                        <form action="${pageContext.request.contextPath}/student/notifications" method="POST" class="d-inline">
                            <input type="hidden" name="action" value="markAll">
                            <button type="submit" class="btn btn-primary rounded-pill px-4 py-2 shadow-sm">
                                <i class="fas fa-check-double me-2"></i> Mark All as Read
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <!-- 2. Notifications Feed -->
            <div class="glass-card p-0" style="border-radius: 20px; overflow: hidden;">
                <c:choose>
                    <c:when test="${not empty notifications}">
                        <div class="list-group list-group-flush">
                            <c:forEach var="notif" items="${notifications}" varStatus="status">
                                
                                <!-- Notification Item -->
                                <div class="list-group-item p-4 ${notif.isRead ? 'bg-transparent' : 'bg-light bg-opacity-50'}" style="transition: background 0.3s ease;">
                                    <div class="d-flex gap-3 align-items-start">
                                        
                                        <!-- Status Indicator -->
                                        <div class="mt-2">
                                            <c:choose>
                                                <c:when test="${!notif.isRead}">
                                                    <span class="badge bg-primary rounded-circle p-2" style="width: 10px; height: 10px;"></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-check-circle text-success opacity-50"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Content -->
                                        <div class="flex-grow-1">
                                            <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-1">
                                                <h6 class="fw-bold text-dark mb-0 ${notif.isRead ? 'opacity-75' : ''}">
                                                    <c:out value="${notif.title}" />
                                                </h6>
                                                <small class="text-muted" style="font-size: 0.75rem; white-space: nowrap;">
                                                    <i class="far fa-clock me-1"></i>
													<c:out value="${notif.createdAtFormatted}" />
                                                </small>
                                            </div>
                                            
                                            <p class="text-muted mb-3 small" style="line-height: 1.6;">
                                                <c:out value="${notif.message}" />
                                            </p>

                                            <!-- Action: Mark as Read (Only for unread) -->
                                            <c:if test="${!notif.isRead}">
                                                <form action="${pageContext.request.contextPath}/student/notifications" method="POST" class="d-inline">
                                                    <input type="hidden" name="action" value="markOne">
                                                    <input type="hidden" name="notificationId" value="${notif.notificationId}">
                                                    <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                                        <i class="fas fa-check me-1"></i> Mark as Read
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <!-- Separator (except for last item) -->
                                    <c:if test="${!status.last}">
                                        <hr class="my-3 opacity-25">
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <!-- Empty State -->
                        <div class="text-center py-5 px-4">
                            <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width: 100px; height: 100px;">
                                <i class="fas fa-bell-slash fa-3x text-muted opacity-50"></i>
                            </div>
                            <h4 class="fw-bold text-dark mb-2">No Notifications Yet</h4>
                            <p class="text-muted mb-0" style="max-width: 400px; margin: 0 auto;">
                                You're all caught up! Check back later for updates on your attendance, marks, and university announcements.
                            </p>
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