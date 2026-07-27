<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Manage Subjects" scope="request" />
<%@ include file="adminHead.jsp" %>

<!-- Add SweetAlert2 for modern dialogs -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div class="app-wrapper">
    <%@ include file="adminSidebar.jsp" %>
    <div class="main-content">
        <%@ include file="adminNavbar.jsp" %>

        <div class="content-area">
            
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

            <!-- Hero -->
            <div class="hero-section">
                <div class="hero-content">
                    <div class="hero-icon"><i class="fas fa-book"></i></div>
                    <div class="hero-text">
                        <h1>Subjects</h1>
                        <p>Add, edit, and manage academic subjects.</p>
                    </div>
                </div>
            </div>

            <!-- Subjects Table -->
            <div class="glass-card">
                <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-3">
                    <h3 class="fw-bold mb-0">
                        <i class="fas fa-list me-2" style="color: var(--primary-blue);"></i>All Subjects
                    </h3>
                    <form method="GET" action="${pageContext.request.contextPath}/admin/subjects" class="d-flex gap-2 flex-wrap align-items-center">
                        <!-- ✅ Department Filter -->
                        <select name="department" class="form-control-custom" style="width: 200px;" onchange="this.form.submit()">
                            <option value="all"
                                ${empty deptFilter || deptFilter eq 'all' ? 'selected' : ''}>
                                All Departments
                            </option>					
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.departmentId}"
                                    ${deptFilter eq dept.departmentId.toString() ? 'selected' : ''}>
                                    <c:out value="${dept.departmentName}" />
                                </option>
                            </c:forEach>						
                        </select>
                        
                        <!-- Search Box -->
                        <div class="search-box" style="position: relative;">
                            <input type="text" id="searchInput" class="form-control-custom" 
                                   placeholder="Search by code or name..." 
                                   style="width: 250px; padding-left: 40px;">
                            <i class="fas fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
                        </div>
                        
                        <button type="button" class="btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addSubjectModal">
                            <i class="fas fa-plus"></i> Add Subject
                        </button>
                    </form>
                </div>

                <c:choose>
                    <c:when test="${not empty subjects}">
                        <div class="table-responsive">
                            <table class="data-table" id="subjectsTable">
                                <thead>
                                    <tr>
                                        <th style="width: 50px;">#</th>
                                        <th style="min-width: 120px;">Subject Code</th>
                                        <th style="min-width: 300px;">Subject Name</th>
                                        <th style="min-width: 150px;">Department</th>
                                        <th style="min-width: 120px;">Credits</th>
                                        <th style="min-width: 120px;">Status</th>
                                        <th style="min-width: 180px;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="s" items="${subjects}" varStatus="status">
                                        <tr data-subject-code="${s.subjectCode.toLowerCase()}" 
                                            data-subject-name="${s.subjectName.toLowerCase()}">
                                            <td><c:out value="${status.index + 1}" /></td>
                                            <td><span class="badge-custom badge-info"><c:out value="${s.subjectCode}" /></span></td>
                                            <td class="text-truncate" style="max-width: 300px;" title="<c:out value='${s.subjectName}' />">
                                                <c:out value="${s.subjectName}" />
                                            </td>
                                            <td class="text-truncate" style="max-width: 150px;">
                                                <c:choose>
                                                    <c:when test="${s.departmentId > 0}">
                                                        <c:forEach var="dept" items="${departments}">
                                                            <c:if test="${dept.departmentId == s.departmentId}">
                                                                <c:out value="${dept.departmentName}" />
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><span class="badge-custom badge-success"><c:out value="${s.credits}" /> Credits</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${s.active}">
                                                        <span class="badge-custom badge-success">
                                                            <i class="fas fa-check-circle"></i> Active
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-custom badge-secondary" style="background: #e5e7eb; color: #6b7280;">
                                                            <i class="fas fa-times-circle"></i> Inactive
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <button class="btn-action btn-edit" 
                                                            onclick="editSubject(${s.subjectId}, '${s.subjectCode}', '${s.subjectName}', '${s.credits}', ${s.departmentId}, ${s.active})"
                                                            style="white-space: nowrap;">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </button>
                                                    <button class="btn-action btn-delete" 
                                                            onclick="confirmDeleteSubject(${s.subjectId}, '${s.subjectName}')"
                                                            style="white-space: nowrap;">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <div style="width: 80px; height: 80px; margin: 0 auto 1rem; background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; color: #6366f1;">
                                <i class="fas fa-book"></i>
                            </div>
                            <h4 class="fw-bold mb-2">No Subjects Found</h4>
                            <p class="text-muted mb-0">
                                <c:choose>
                                    <c:when test="${not empty deptFilter && deptFilter != 'all'}">
                                        No subjects found for the selected department.
                                    </c:when>
                                    <c:otherwise>
                                        Click "Add Subject" to create your first subject.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<!-- Add Subject Modal -->
<div class="modal fade modal-custom" id="addSubjectModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add New Subject</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/admin/subjects">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Subject Code *</label>
                            <input type="text" name="subjectCode" class="form-control-custom" required placeholder="e.g., CS101">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Subject Name *</label>
                            <input type="text" name="subjectName" class="form-control-custom" required placeholder="e.g., Data Structures">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Department</label>
                            <select name="departmentId" class="form-control-custom">
                                <option value="">Select Department</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}"><c:out value="${dept.departmentName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Credits *</label>
                            <select name="credits" class="form-control-custom" required>
                                <c:forEach var="i" begin="1" end="6">
                                    <option value="${i}">${i} Credits</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-primary-custom"><i class="fas fa-save"></i> Save Subject</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Subject Modal -->
<div class="modal fade modal-custom" id="editSubjectModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Subject</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/admin/subjects">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="subjectId" id="editSubjectId">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Subject Code *</label>
                            <input type="text" name="subjectCode" id="editSubjectCode" class="form-control-custom" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Subject Name *</label>
                            <input type="text" name="subjectName" id="editSubjectName" class="form-control-custom" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Department</label>
                            <select name="departmentId" id="editSubjectDept" class="form-control-custom">
                                <option value="">Select Department</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}"><c:out value="${dept.departmentName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Credits *</label>
                            <select name="credits" id="editSubjectCredits" class="form-control-custom" required>
                                <c:forEach var="i" begin="1" end="6">
                                    <option value="${i}">${i} Credits</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <!-- ✅ Active/Inactive Toggle -->
                        <div class="col-md-12 mt-3">
                            <div class="p-3 rounded" style="background: #f8fafc; border: 1px solid #e2e8f0;">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" 
                                           id="editSubjectActive" 
                                           name="isActive" 
                                           value="1"
                                           style="width: 3rem; height: 1.5rem; cursor: pointer;">
                                    <label class="form-check-label ms-2" for="editSubjectActive" 
                                           style="font-weight: 600; cursor: pointer; color: #1f2937;">
                                        Subject is active
                                    </label>
                                </div>
                                <small class="text-muted ms-5">Inactive subjects won't appear in dropdowns</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-primary-custom"><i class="fas fa-save"></i> Update Subject</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editSubject(id, code, name, credits, deptId, isActive) {
        document.getElementById('editSubjectId').value = id;
        document.getElementById('editSubjectCode').value = code;
        document.getElementById('editSubjectName').value = name;
        document.getElementById('editSubjectCredits').value = credits;
        document.getElementById('editSubjectDept').value = deptId || '';
        
        // ✅ Set active status
        const activeCheckbox = document.getElementById('editSubjectActive');
        activeCheckbox.checked = isActive === true || isActive === 'true' || isActive === 1;
        
        new bootstrap.Modal(document.getElementById('editSubjectModal')).show();
    }

    function confirmDeleteSubject(id, name) {
        Swal.fire({
            title: '<i class="fas fa-exclamation-triangle" style="color: #f59e0b; font-size: 3rem;"></i>',
            html: '<h3 class="mb-2">Delete Subject?</h3>' +
                  '<p class="text-muted mb-3">Are you sure you want to delete <strong style="color: #1f2937;">' + name + '</strong>?</p>' +
                  '<div class="alert alert-danger" style="background: #fef2f2; border: 1px solid #fecaca; border-radius: 8px; padding: 12px;">' +
                  '<i class="fas fa-info-circle" style="color: #ef4444;"></i> ' +
                  '<span style="color: #991b1b; font-weight: 500;">This action cannot be undone!</span>' +
                  '</div>',
            showCancelButton: true,
            confirmButtonText: '<i class="fas fa-trash-alt"></i> Yes, Delete',
            cancelButtonText: '<i class="fas fa-times"></i> Cancel',
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#6b7280',
            reverseButtons: true,
            focusConfirm: false
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: 'Deleting...',
                    allowOutsideClick: false,
                    didOpen: () => { Swal.showLoading(); }
                });
                
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/subjects';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'subjectId';
                idInput.value = id;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        });
    }

    // Search Functionality
    document.getElementById('searchInput').addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#subjectsTable tbody tr');
        
        rows.forEach(row => {
            const subjectCode = row.getAttribute('data-subject-code');
            const subjectName = row.getAttribute('data-subject-name');
            
            if (subjectCode.includes(searchTerm) || subjectName.includes(searchTerm)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    });

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