<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Manage Faculty" scope="request" />
<%@ include file="adminHead.jsp" %>

<style>
	/* Table Cell Truncation */
	.data-table td {
	    max-width: 250px;
	    overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	}
	
	.data-table tbody tr {
	    height: auto;
	    min-height: 60px;
	}
	
	/* Button Spacing */
	.btn-action {
	    margin-right: 0.5rem;
	    white-space: nowrap;
	}
	
	.btn-action:last-child {
	    margin-right: 0;
	}
	
	/* Avatar */
	.avatar-circle {
	    width: 36px;
	    height: 36px;
	    border-radius: 50%;
	    background: var(--primary-gradient);
	    color: white;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    font-weight: 700;
	    font-size: 0.9rem;
	    flex-shrink: 0;
	}
</style>

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
                    <div class="hero-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                    <div class="hero-text">
                        <h1>Faculty Members</h1>
                        <p>Add, edit, and manage faculty accounts.</p>
                    </div>
                </div>
            </div>

			<!-- Faculty Table -->
			<div class="glass-card">
			    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-3">
			        <h3 class="fw-bold mb-0">
			            <i class="fas fa-list me-2" style="color: var(--primary-blue);"></i>All Faculty
			        </h3>
			        <form method="GET" action="${pageContext.request.contextPath}/admin/faculty" class="d-flex gap-2 flex-wrap align-items-center">
			            <!-- ✅ Department Filter -->
			            <select name="department" class="form-control-custom" style="width: 220px;" onchange="this.form.submit()">
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
			            
			            <!-- ✅ Search Box - NEW -->
			            <div class="search-box" style="position: relative;">
			                <input type="text" id="searchInput" class="form-control-custom" 
			                       placeholder="Search by name or emp ID..." 
			                       style="width: 220px; padding-left: 40px;">
			                <i class="fas fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
			            </div>
			            
			            <button type="button" class="btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addFacultyModal">
			                <i class="fas fa-plus"></i> Add Faculty
			            </button>
			        </form>
			    </div>
			
			    <c:choose>
			        <c:when test="${not empty facultyList}">
			            <div class="table-responsive">
			                <table class="data-table">
			                    <thead>
			                        <tr>
			                            <th style="width: 50px;">#</th>
			                            <th style="min-width: 150px;">NAME</th>
			                            <th style="min-width: 100px;">EMPLOYEE ID</th>
			                            <th style="min-width: 200px;">EMAIL</th>
			                            <th style="min-width: 200px;">DEPARTMENT</th>
			                            <th style="min-width: 120px;">STATUS</th>  <!-- ✅ CHANGED FROM DESIGNATION -->
			                            <th style="min-width: 180px;">ACTIONS</th>
			                        </tr>
			                    </thead>
			                    <tbody>
			                        <c:forEach var="f" items="${facultyList}" varStatus="status">
			                            <tr>
			                                <td>${status.index + 1}</td>
			                                <td>
			                                    <div class="d-flex align-items-center gap-2">
			                                        <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--primary-gradient); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.9rem; flex-shrink: 0;">
			                                            <c:out value="${fn:substring(f.fullName, 0, 1)}" />
			                                        </div>
			                                        <span class="fw-semibold text-truncate" style="max-width: 150px;" title="<c:out value='${f.fullName}' />">
			                                            <c:out value="${f.fullName}" />
			                                        </span>
			                                    </div>
			                                </td>
			                                <td><span class="badge-custom badge-info"><c:out value="${f.employeeId}" /></span></td>
			                                <td class="text-truncate" style="max-width: 200px;" title="<c:out value='${f.email}' />">
			                                    <c:out value="${f.email}" />
			                                </td>
			                                <td class="text-truncate" style="max-width: 200px;" title="<c:out value='${f.department}' />">
			                                    <c:out value="${f.department}" default="—" />
			                                </td>
			                                <td>  <!-- ✅ SHOW STATUS INSTEAD OF DESIGNATION -->
			                                    <c:choose>
			                                        <c:when test="${f.active}">
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
													        onclick="editFaculty(${f.facultyId}, '${f.fullName}', '${f.email}', '${f.phoneNumber}', '${f.departmentId}', '${f.designation}', '${f.employeeId}', '${f.qualification}', '${f.specialization}', '${f.experienceYears}', ${f.active})"
													        style="white-space: nowrap;">
													    <i class="fas fa-edit"></i> Edit
													</button>
			                                        <button class="btn-action btn-delete" 
			                                                onclick="confirmDelete(${f.facultyId}, '${f.fullName}')"
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
			                    <i class="fas fa-chalkboard-teacher"></i>
			                </div>
			                <h4 class="fw-bold mb-2">No Faculty Found</h4>
			                <p class="text-muted mb-0">Click "Add Faculty" to create your first faculty account.</p>
			            </div>
			        </c:otherwise>
			    </c:choose>
			</div>
        </div>
        
        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<!-- Add Faculty Modal -->
<div class="modal fade modal-custom" id="addFacultyModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add New Faculty</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/admin/faculty">
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
                        <!-- ✅ Employee ID - Visible but Read-Only (Auto-generated) -->
                        <div class="col-md-4">
                            <label class="form-label-custom">
                                Employee ID 
                                <span class="badge-custom badge-info" style="font-size: 0.7rem; padding: 2px 8px;">Auto-generated</span>
                            </label>
                            <input type="text" name="employeeId" class="form-control-custom" 
                                   value="${nextEmployeeId}" 
                                   readonly 
                                   style="background: #f3f4f6; cursor: not-allowed; color: #6b7280;">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Phone Number</label>
                            <input type="text" name="phoneNumber" class="form-control-custom">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Department</label>
                            <select name="departmentId" class="form-control-custom">
                                <option value="">Select Department</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}"><c:out value="${dept.departmentName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Designation</label>
                            <input type="text" name="designation" class="form-control-custom" placeholder="e.g., Professor">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Qualification</label>
                            <input type="text" name="qualification" class="form-control-custom" placeholder="e.g., Ph.D.">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Experience (Years)</label>
                            <input type="number" name="experienceYears" class="form-control-custom" min="0" value="0">
                        </div>
                        <!-- ✅ Password - VISIBLE (type="text") -->
                        <div class="col-md-6">
                            <label class="form-label-custom">
                                Password * (min 6 chars)
                                <span class="badge-custom badge-warning" style="font-size: 0.7rem; padding: 2px 8px;">Visible</span>
                            </label>
                            <input type="text" name="password" class="form-control-custom" 
                                   required minlength="6" 
                                   placeholder="Enter password (visible for verification)">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Specialization</label>
                            <input type="text" name="specialization" class="form-control-custom" placeholder="e.g., Artificial Intelligence">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-primary-custom"><i class="fas fa-save"></i> Save Faculty</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Faculty Modal -->
<div class="modal fade modal-custom" id="editFacultyModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Faculty</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/admin/faculty">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="facultyId" id="editFacultyId">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Full Name *</label>
                            <input type="text" name="fullName" id="editFacultyName" class="form-control-custom" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Email *</label>
                            <input type="email" name="email" id="editFacultyEmail" class="form-control-custom" required>
                        </div>
                        <!-- ✅ Employee ID - Visible but Read-Only (Fixed) -->
                        <div class="col-md-4">
                            <label class="form-label-custom">
                                Employee ID 
                                <span class="badge-custom badge-warning" style="font-size: 0.7rem; padding: 2px 8px;">Fixed</span>
                            </label>
                            <input type="text" name="employeeId" id="editFacultyEmpId" class="form-control-custom" 
                                   readonly 
                                   style="background: #f3f4f6; cursor: not-allowed; color: #6b7280;">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Phone Number</label>
                            <input type="text" name="phoneNumber" id="editFacultyPhone" class="form-control-custom">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Department</label>
                            <select name="departmentId" id="editFacultyDept" class="form-control-custom">
                                <option value="">Select Department</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}"><c:out value="${dept.departmentName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Designation</label>
                            <input type="text" name="designation" id="editFacultyDesig" class="form-control-custom">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Qualification</label>
                            <input type="text" name="qualification" id="editFacultyQual" class="form-control-custom">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Experience (Years)</label>
                            <input type="number" name="experienceYears" id="editFacultyExp" class="form-control-custom" min="0">
                        </div>
                        <div class="col-md-12">
                            <label class="form-label-custom">Specialization</label>
                            <input type="text" name="specialization" id="editFacultySpec" class="form-control-custom">
                        </div>
                        
                        <!-- ✅ Active/Inactive Toggle - LIKE SECTION MODAL -->
                        <div class="col-md-12 mt-3">
                            <div class="p-3 rounded" style="background: #f8fafc; border: 1px solid #e2e8f0;">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" 
                                           id="editFacultyActive" 
                                           name="isActive" 
                                           value="1"
                                           style="width: 3rem; height: 1.5rem; cursor: pointer;">
                                    <label class="form-check-label ms-2" for="editFacultyActive" 
                                           style="font-weight: 600; cursor: pointer; color: #1f2937;">
                                        Faculty is active
                                    </label>
                                </div>
                                <small class="text-muted ms-5">Inactive faculty cannot login and won't appear in dropdowns</small>
                            </div>
                        </div>
                        
                        <!-- ✅ Optional Password Update Field (VISIBLE) -->
                        <div class="col-md-12 mt-3">
                            <div class="p-3 rounded" style="background: #f8fafc; border: 1px solid #e2e8f0;">
                                <label class="form-label-custom mb-2">
                                    <i class="fas fa-key me-1" style="color: #6366f1;"></i>
                                    Update Password 
                                    <span class="badge-custom badge-info" style="font-size: 0.7rem; padding: 2px 8px;">Optional</span>
                                    <span class="badge-custom badge-warning" style="font-size: 0.7rem; padding: 2px 8px;">Visible</span>
                                </label>
                                <input type="text" name="newPassword" id="editFacultyNewPassword" 
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
                    <button type="submit" class="btn-primary-custom"><i class="fas fa-save"></i> Update Faculty</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
	function editFaculty(id, name, email, phone, deptId, designation, empId, qualification, specialization, experience, isActive) {
	    document.getElementById('editFacultyId').value = id;
	    document.getElementById('editFacultyName').value = name;
	    document.getElementById('editFacultyEmail').value = email;
	    document.getElementById('editFacultyPhone').value = phone || '';
	    document.getElementById('editFacultyDept').value = deptId || '';
	    document.getElementById('editFacultyDesig').value = designation || '';
	    document.getElementById('editFacultyEmpId').value = empId || '';
	    document.getElementById('editFacultyQual').value = qualification || '';
	    document.getElementById('editFacultySpec').value = specialization || '';
	    document.getElementById('editFacultyExp').value = experience || '0';
	    
	    // ✅ Set active status from database
	    const activeCheckbox = document.getElementById('editFacultyActive');
	    activeCheckbox.checked = isActive === true || isActive === 'true' || isActive === 1;
	    
	    // ✅ Clear the new password field when opening edit modal
	    const newPasswordField = document.getElementById('editFacultyNewPassword');
	    if (newPasswordField) {
	        newPasswordField.value = '';
	    }
	    
	    new bootstrap.Modal(document.getElementById('editFacultyModal')).show();
	}
    
 // ✅ Professional Delete Confirmation with SweetAlert2
	function confirmDelete(id, name) {
	    Swal.fire({
	        title: '<i class="fas fa-exclamation-triangle" style="color: #f59e0b; font-size: 3rem;"></i>',
	        html: '<h3 class="mb-2">Delete Faculty Member?</h3>' +
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
	            // Show loading
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
	            form.action = '${pageContext.request.contextPath}/admin/faculty';
	            
	            const actionInput = document.createElement('input');
	            actionInput.type = 'hidden';
	            actionInput.name = 'action';
	            actionInput.value = 'delete';
	            
	            const idInput = document.createElement('input');
	            idInput.type = 'hidden';
	            idInput.name = 'facultyId';
	            idInput.value = id;
	            
	            form.appendChild(actionInput);
	            form.appendChild(idInput);
	            document.body.appendChild(form);
	            form.submit();
	        }
	    });
	}
 
	// ✅ Search Functionality - NEW
	document.getElementById('searchInput').addEventListener('input', function(e) {
	    const searchTerm = e.target.value.toLowerCase();
	    const rows = document.querySelectorAll('.data-table tbody tr');
	    
	    rows.forEach(row => {
	        const name = row.cells[1].textContent.toLowerCase();
	        const empId = row.cells[2].textContent.toLowerCase();
	        
	        if (name.includes(searchTerm) || empId.includes(searchTerm)) {
	            row.style.display = '';
	        } else {
	            row.style.display = 'none';
	        }
	    });
	});

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