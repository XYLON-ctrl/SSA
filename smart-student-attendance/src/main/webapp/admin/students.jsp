<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Manage Students" scope="request" />
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
                    <div class="hero-icon"><i class="fas fa-user-graduate"></i></div>
                    <div class="hero-text">
                        <h1>Students</h1>
                        <p>Add, edit, and manage student accounts.</p>
                    </div>
                </div>
            </div>

            <!-- Students Table -->
            <div class="glass-card">
                <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-3">
                    <h3 class="fw-bold mb-0">
                        <i class="fas fa-list me-2" style="color: var(--primary-blue);"></i>All Students
                    </h3>
                    <form method="GET" action="${pageContext.request.contextPath}/admin/students" class="d-flex gap-2 flex-wrap align-items-center">
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
                        
                        <!-- ✅ Search Box -->
                        <div class="search-box" style="position: relative;">
                            <input type="text" id="searchInput" class="form-control-custom" 
                                   placeholder="Search by name or enrollment ID..." 
                                   style="width: 250px; padding-left: 40px;">
                            <i class="fas fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
                        </div>
                        
                        <button type="button" class="btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addStudentModal">
                            <i class="fas fa-plus"></i> Add Student
                        </button>
                    </form>
                </div>
            
                <c:choose>
                    <c:when test="${not empty students}">
                        <div class="table-responsive">
                            <table class="data-table" id="studentsTable">
                                <thead>
                                    <tr>
                                        <th style="width: 50px;">#</th>
                                        <th style="min-width: 180px;">Name</th>
                                        <th style="min-width: 130px;">Enrollment No</th>
                                        <th style="min-width: 220px;">Email</th>
                                        <th style="min-width: 180px;">Branch</th>
                                        <th style="min-width: 100px;">Semester</th>
                                        <th style="min-width: 120px;">Status</th>
                                        <th style="min-width: 180px;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="s" items="${students}" varStatus="status">
                                        <tr data-student-name="${s.fullName.toLowerCase()}" 
                                            data-student-enroll="${s.enrollmentNumber.toLowerCase()}">
                                            <td><c:out value="${status.index + 1}" /></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--success-gradient); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.9rem; flex-shrink: 0;">
                                                        <c:out value="${fn:substring(s.fullName, 0, 1)}" />
                                                    </div>
                                                    <span class="fw-semibold text-truncate" style="max-width: 150px;" title="<c:out value='${s.fullName}' />">
                                                        <c:out value="${s.fullName}" />
                                                    </span>
                                                </div>
                                            </td>
                                            <td class="text-truncate" style="max-width: 140px;" title="<c:out value='${s.enrollmentNumber}' />">
                                                <span class="badge-custom badge-info"><c:out value="${s.enrollmentNumber}" /></span>
                                            </td>
                                            <td class="text-truncate" style="max-width: 220px;" title="<c:out value='${s.email}' />">
                                                <c:out value="${s.email}" />
                                            </td>
                                            <td class="text-truncate" style="max-width: 180px;" title="<c:out value='${s.branch}' />">
                                                <c:out value="${s.branch}" />
                                            </td>
                                            <td><span class="badge-custom badge-success">Sem <c:out value="${s.currentSemester}" /></span></td>
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
													        onclick="editStudent(${s.studentId}, '${s.fullName}', '${s.email}', '${s.enrollmentNumber}', '${s.branch}', '${s.currentSemester}', '${s.sectionId}', '${s.departmentId}', '${s.batch}', '${s.cgpa}', ${s.active})"
													        style="white-space: nowrap;">
													    <i class="fas fa-edit"></i> Edit
													</button>
                                                    <!-- ✅ SweetAlert2 Delete Button -->
                                                    <button class="btn-action btn-delete" 
                                                            onclick="confirmDeleteStudent(${s.studentId}, '${s.fullName}')"
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
                            <div style="width: 80px; height: 80px; margin: 0 auto 1rem; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; color: #d97706;">
                                <i class="fas fa-user-graduate"></i>
                            </div>
                            <h4 class="fw-bold mb-2">No Students Found</h4>
                            <p class="text-muted mb-0">
                                <c:choose>
                                    <c:when test="${not empty deptFilter && deptFilter != 'all'}">
                                        No students found for the selected department.
                                    </c:when>
                                    <c:otherwise>
                                        Click "Add Student" to create your first student account.
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

<!-- Add Student Modal -->
<div class="modal fade modal-custom" id="addStudentModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add New Student</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/admin/students">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Full Name *</label>
                            <input type="text" name="fullName" class="form-control-custom" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Email *</label>
                            <input type="email" name="email" class="form-control-custom" required>
                        </div>
                        <!-- ✅ Enrollment ID - Visible but Read-Only (Auto-generated) -->
                        <div class="col-md-4">
                            <label class="form-label-custom">
                                Enrollment Number 
                                <span class="badge-custom badge-info" style="font-size: 0.7rem; padding: 2px 8px;">Auto-generated</span>
                            </label>
                            <input type="text" name="enrollmentNumber" class="form-control-custom" 
                                   value="${nextEnrollmentId}" 
                                   readonly 
                                   style="background: #f3f4f6; cursor: not-allowed; color: #6b7280;">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Branch *</label>
                            <input type="text" name="branch" class="form-control-custom" required placeholder="e.g., Computer Science">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Batch *</label>
                            <input type="text" name="batch" class="form-control-custom" required placeholder="e.g., 2024-2028">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-custom">Current Semester *</label>
                            <select name="currentSemester" class="form-control-custom" required>
                                <c:forEach var="i" begin="1" end="8">
                                    <option value="${i}">Semester ${i}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-custom">Department</label>
                            <select name="departmentId" class="form-control-custom">
                                <option value="">Select Department</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}"><c:out value="${dept.departmentName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-custom">Section</label>
                            <select name="sectionId" class="form-control-custom">
                                <option value="">Select Section</option>
                                <c:forEach var="sec" items="${sections}">
                                    <option value="${sec.sectionId}"><c:out value="${sec.sectionName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-custom">CGPA</label>
                            <input type="number" name="cgpa" class="form-control-custom" step="0.01" min="0" max="10" value="0.00">
                        </div>
                        <!-- ✅ Password - VISIBLE (type="text") -->
                        <div class="col-md-12">
                            <label class="form-label-custom">
                                Password * (min 6 chars)
                                <span class="badge-custom badge-warning" style="font-size: 0.7rem; padding: 2px 8px;">Visible</span>
                            </label>
                            <input type="text" name="password" class="form-control-custom" 
                                   required minlength="6" 
                                   placeholder="Enter password (visible for verification)">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-primary-custom"><i class="fas fa-save"></i> Save Student</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Student Modal -->
<div class="modal fade modal-custom" id="editStudentModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Student</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/admin/students">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="studentId" id="editStudentId">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Full Name *</label>
                            <input type="text" name="fullName" id="editStudentName" class="form-control-custom" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Email *</label>
                            <input type="email" name="email" id="editStudentEmail" class="form-control-custom" required>
                        </div>
                        <!-- ✅ Enrollment ID - Visible but Read-Only (Fixed) -->
                        <div class="col-md-4">
                            <label class="form-label-custom">
                                Enrollment Number 
                                <span class="badge-custom badge-warning" style="font-size: 0.7rem; padding: 2px 8px;">Fixed</span>
                            </label>
                            <input type="text" name="enrollmentNumber" id="editStudentEnroll" 
                                   class="form-control-custom" 
                                   readonly 
                                   style="background: #f3f4f6; cursor: not-allowed; color: #6b7280;">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Branch *</label>
                            <input type="text" name="branch" id="editStudentBranch" class="form-control-custom" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Batch *</label>
                            <input type="text" name="batch" id="editStudentBatch" class="form-control-custom" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-custom">Current Semester *</label>
                            <select name="currentSemester" id="editStudentSemester" class="form-control-custom" required>
                                <c:forEach var="i" begin="1" end="8">
                                    <option value="${i}">Semester ${i}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-custom">Department</label>
                            <select name="departmentId" id="editStudentDept" class="form-control-custom">
                                <option value="">Select Department</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}"><c:out value="${dept.departmentName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-custom">Section</label>
                            <select name="sectionId" id="editStudentSection" class="form-control-custom">
                                <option value="">Select Section</option>
                                <c:forEach var="sec" items="${sections}">
                                    <option value="${sec.sectionId}"><c:out value="${sec.sectionName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-custom">CGPA</label>
                            <input type="number" name="cgpa" id="editStudentCgpa" class="form-control-custom" step="0.01" min="0" max="10">
                        </div>
                        
                        <!-- ✅ Active/Inactive Toggle -->
                        <div class="col-md-12 mt-3">
                            <div class="p-3 rounded" style="background: #f8fafc; border: 1px solid #e2e8f0;">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" 
                                           id="editStudentActive" 
                                           name="isActive" 
                                           value="1"
                                           style="width: 3rem; height: 1.5rem; cursor: pointer;">
                                    <label class="form-check-label ms-2" for="editStudentActive" 
                                           style="font-weight: 600; cursor: pointer; color: #1f2937;">
                                        Student is active
                                    </label>
                                </div>
                                <small class="text-muted ms-5">Inactive students cannot login and won't appear in dropdowns</small>
                            </div>
                        </div>
                        
                        <!-- ✅ Optional Password Update Field -->
                        <div class="col-md-12 mt-3">
                            <div class="p-3 rounded" style="background: #f8fafc; border: 1px solid #e2e8f0;">
                                <label class="form-label-custom mb-2">
                                    <i class="fas fa-key me-1" style="color: #6366f1;"></i>
                                    Update Password 
                                    <span class="badge-custom badge-info" style="font-size: 0.7rem; padding: 2px 8px;">Optional</span>
                                </label>
                                <input type="text" name="newPassword" id="editStudentNewPassword" 
                                       class="form-control-custom" 
                                       placeholder="(leave empty to keep current password)"
                                       minlength="6"
                                       style="background: #fff; cursor: text;">
                                <small class="text-muted">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Leave blank to keep the existing password. Enter a new password (min 6 chars) to reset it.
                                </small>
                            </div>
                        </div>
                        
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-primary-custom"><i class="fas fa-save"></i> Update Student</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ✅ Edit Student Function
    function editStudent(id, name, email, enroll, branch, semester, sectionId, deptId, batch, cgpa, isActive) {
	    document.getElementById('editStudentId').value = id;
	    document.getElementById('editStudentName').value = name;
	    document.getElementById('editStudentEmail').value = email;
	    document.getElementById('editStudentEnroll').value = enroll;
	    document.getElementById('editStudentBranch').value = branch;
	    document.getElementById('editStudentSemester').value = semester;
	    document.getElementById('editStudentSection').value = sectionId || '';
	    document.getElementById('editStudentDept').value = deptId || '';
	    document.getElementById('editStudentBatch').value = batch || '';
	    document.getElementById('editStudentCgpa').value = cgpa || '0.00';
	    
	    // ✅ Set active status from database
	    const activeCheckbox = document.getElementById('editStudentActive');
	    if (activeCheckbox) {
	        activeCheckbox.checked = isActive === true || isActive === 'true' || isActive === 1;
	    }
	    
	    // ✅ Clear the new password field when opening edit modal
	    const newPasswordField = document.getElementById('editStudentNewPassword');
	    if (newPasswordField) {
	        newPasswordField.value = '';
	    }
	    
	    // Show the modal
	    const modalElement = document.getElementById('editStudentModal');
	    const modal = new bootstrap.Modal(modalElement);
	    modal.show();
	}

    // ✅ Professional Delete Confirmation with SweetAlert2
    function confirmDeleteStudent(id, name) {
        Swal.fire({
            title: '<i class="fas fa-exclamation-triangle" style="color: #f59e0b; font-size: 3rem;"></i>',
            html: '<h3 class="mb-2">Delete Student?</h3>' +
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
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });
                
                // Create and submit delete form
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/students';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'studentId';
                idInput.value = id;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        });
    }

    // ✅ Search Functionality - Filter by name or enrollment ID
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('input', function(e) {
                const searchTerm = e.target.value.toLowerCase();
                const rows = document.querySelectorAll('#studentsTable tbody tr');
                
                rows.forEach(row => {
                    const studentName = row.getAttribute('data-student-name');
                    const studentEnroll = row.getAttribute('data-student-enroll');
                    
                    if (studentName && studentName.includes(searchTerm) || 
                        studentEnroll && studentEnroll.includes(searchTerm)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        }
        
        // Auto-dismiss alerts
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