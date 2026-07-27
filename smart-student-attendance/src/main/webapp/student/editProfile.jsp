<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- Set page title for the Navbar --%>
<c:set var="pageTitle" value="Edit Profile" scope="request" />

<%@ include file="includes/studentHead.jsp" %>

<style>
    .profile-avatar-large {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 3rem;
        font-weight: 700;
        box-shadow: 0 6px 20px rgba(37, 99, 235, 0.2);
        flex-shrink: 0;
    }
    
    .info-label {
        font-size: 0.7rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: var(--text-muted);
        font-weight: 600;
        margin-bottom: 0.4rem;
    }
    
    .readonly-field {
        background-color: #f9fafb !important;
        cursor: not-allowed;
        color: var(--text-muted);
    }
    
    .readonly-field:focus {
        box-shadow: none !important;
        border-color: var(--card-border) !important;
    }
    
    .lock-icon {
        font-size: 0.65rem;
        color: #d1d5db;
        margin-left: 0.25rem;
        vertical-align: middle;
    }
    
    .section-card {
        transition: box-shadow 0.25s ease;
    }
    
    .section-card:hover {
        box-shadow: var(--shadow-md);
    }
    
    .section-title {
        font-size: 0.95rem;
        font-weight: 600;
        color: var(--text-dark);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .section-badge {
        font-size: 0.7rem;
        font-weight: 500;
        padding: 0.3rem 0.7rem;
        border-radius: 20px;
    }
    
    .progress-ring {
        width: 70px;
        height: 70px;
    }
    
    .progress-ring-circle {
        transition: stroke-dashoffset 0.5s ease;
        transform: rotate(-90deg);
        transform-origin: 50% 50%;
    }
    
    .form-control:focus, .form-select:focus {
        border-color: var(--primary-blue);
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }
    
    .btn-gradient-primary {
        background: var(--primary-blue);
        border: none;
        color: white;
        transition: all 0.2s ease;
    }
    
    .btn-gradient-primary:hover {
        background: var(--secondary-blue);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        color: white;
    }
    
    .unsaved-indicator {
        display: none;
        color: #f59e0b;
        font-size: 0.8rem;
        font-weight: 500;
    }
    
    .unsaved-indicator.show {
        display: inline-flex;
        align-items: center;
        gap: 0.35rem;
    }
    
    .required-star {
        color: #ef4444;
        margin-left: 2px;
    }
    
    /* Custom Toast Notification */
    .custom-toast {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        min-width: 350px;
        max-width: 450px;
        animation: slideInRight 0.4s ease-out;
        border-radius: 12px;
        box-shadow: var(--shadow-lg);
        overflow: hidden;
    }
    
    .custom-toast.error {
        background: white;
        border-left: 4px solid #ef4444;
        color: #991b1b;
    }
    
    .custom-toast.success {
        background: white;
        border-left: 4px solid #10b981;
        color: #065f46;
    }
    
    .custom-toast.warning {
        background: white;
        border-left: 4px solid #f59e0b;
        color: #92400e;
    }
    
    .toast-content {
        padding: 16px 20px;
        display: flex;
        align-items: flex-start;
        gap: 12px;
    }
    
    .toast-icon {
        font-size: 1.2rem;
        flex-shrink: 0;
    }
    
    .custom-toast.error .toast-icon { color: #ef4444; }
    .custom-toast.success .toast-icon { color: #10b981; }
    .custom-toast.warning .toast-icon { color: #f59e0b; }
    
    .toast-message {
        flex: 1;
        font-weight: 500;
        font-size: 0.875rem;
        line-height: 1.4;
    }
    
    .toast-close {
        background: none;
        border: none;
        color: var(--text-muted);
        cursor: pointer;
        padding: 4px;
        font-size: 1rem;
        line-height: 1;
        transition: color 0.2s;
    }
    
    .toast-close:hover {
        color: var(--text-dark);
    }
    
    @keyframes slideInRight {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    
    @keyframes slideOutRight {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
    
    .custom-toast.hiding {
        animation: slideOutRight 0.4s ease-out forwards;
    }
    
    .input-group-text {
        background: #f9fafb;
        border-color: var(--card-border);
        color: var(--text-muted);
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

            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                <div>
                    <h2 class="fw-bold mb-1" style="color: var(--text-dark); font-size: 1.5rem;">
                        <i class="fas fa-user-edit me-2" style="color: var(--primary-blue);"></i>Edit Profile
                    </h2>
                    <p class="mb-0" style="color: var(--text-muted); font-size: 0.9rem;">Update your personal, address and guardian information.</p>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="unsaved-indicator" id="unsavedIndicator">
                        <i class="fas fa-circle-exclamation"></i> Unsaved changes
                    </span>
                    <button type="button" class="btn btn-sm rounded-pill px-3" onclick="cancelEdit()" style="border: 1px solid #fecaca; color: #ef4444; background: white; font-size: 0.8rem;">
                        <i class="fas fa-times me-1"></i>Cancel
                    </button>
                </div>
            </div>

            <!-- Profile Summary Card -->
            <div class="glass-card p-4 mb-4" style="border-radius: 16px;">
                <div class="row align-items-center g-4">
                    <div class="col-md-auto text-center">
                        <div class="profile-avatar-large mx-auto">
                            <span><c:out value="${fn:substring(student.fullName, 0, 1)}" default="S" /></span>
                        </div>
                    </div>
                    <div class="col-md">
                        <div class="row g-3">
                            <div class="col-sm-6 col-lg-3">
                                <div class="info-label">Student Name</div>
                                <div class="fw-bold" style="color: var(--text-dark);"><c:out value="${student.fullName}" default="—" /></div>
                            </div>
                            <div class="col-sm-6 col-lg-3">
                                <div class="info-label">Student ID</div>
                                <div class="fw-bold" style="color: var(--text-dark);">STU-<c:out value="${student.userId}" default="000" /></div>
                            </div>
                            <div class="col-sm-6 col-lg-3">
                                <div class="info-label">Program / Branch</div>
                                <div class="fw-bold" style="color: var(--text-dark);"><c:out value="${student.branch}" default="—" /></div>
                            </div>
                            <div class="col-sm-6 col-lg-3">
                                <div class="info-label">Current Semester</div>
                                <div class="fw-bold" style="color: var(--text-dark);">Semester <c:out value="${student.currentSemester}" default="—" /></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-auto text-center">
                        <svg class="progress-ring" viewBox="0 0 80 80">
                            <circle cx="40" cy="40" r="34" stroke="#f3f4f6" stroke-width="6" fill="none"/>
                            <circle id="progressCircle" cx="40" cy="40" r="34" stroke="url(#gradient)" stroke-width="6" fill="none"
                                    stroke-dasharray="213.6" stroke-dashoffset="213.6" stroke-linecap="round" class="progress-ring-circle"/>
                            <defs>
                                <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
                                    <stop offset="0%" stop-color="#2563eb"/>
                                    <stop offset="100%" stop-color="#3b82f6"/>
                                </linearGradient>
                            </defs>
                        </svg>
                        <div class="mt-1 fw-bold" style="color: var(--text-dark); font-size: 0.85rem;"><span id="completionPercent">0</span>% Complete</div>
                    </div>
                </div>
            </div>

            <!-- Edit Profile Form -->
            <form id="editProfileForm" action="${pageContext.request.contextPath}/student/edit-profile" 
      method="POST" enctype="multipart/form-data" novalidate>
                
                <input type="hidden" name="userId" value="${student.userId}" />

                <!-- SECTION 1: PERSONAL INFORMATION -->
                <div class="glass-card section-card p-4 mb-4" style="border-radius: 16px;">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="section-title">
                            <i class="fas fa-user" style="color: var(--primary-blue);"></i> Personal Information
                        </div>
                        <span class="section-badge" style="background: #eff6ff; color: var(--primary-blue);">
                            <i class="fas fa-edit me-1"></i>Editable
                        </span>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="info-label">Full Name <i class="fas fa-lock lock-icon" title="Read Only"></i></label>
                            <input type="text" class="form-control readonly-field" value="${student.fullName}" disabled>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Student ID <i class="fas fa-lock lock-icon" title="Read Only"></i></label>
                            <input type="text" class="form-control readonly-field" value="STU-${student.userId}" disabled>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Enrollment Number <i class="fas fa-lock lock-icon" title="Read Only"></i></label>
                            <input type="text" class="form-control readonly-field" value="${student.enrollmentNumber}" disabled>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Gender <span class="required-star">*</span></label>
                            <select class="form-select" name="gender" required>
                                <option value="">Select Gender</option>
                                <option value="Male" <c:if test="${student.gender eq 'Male'}">selected</c:if>>Male</option>
                                <option value="Female" <c:if test="${student.gender eq 'Female'}">selected</c:if>>Female</option>
                                <option value="Other" <c:if test="${student.gender eq 'Other'}">selected</c:if>>Other</option>
                            </select>
                            <div class="invalid-feedback">Please select your gender.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Date of Birth <span class="required-star">*</span></label>
                            <input type="date" class="form-control" name="dateOfBirth" 
                                   value="${student.dateOfBirth}" required>
                            <div class="invalid-feedback">Please enter your date of birth.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Blood Group</label>
                            <select class="form-select" name="bloodGroup">
                                <option value="">Select Blood Group</option>
                                <c:forEach var="bg" items="${fn:split('A+,A-,B+,B-,AB+,AB-,O+,O-', ',')}">
                                    <option value="${bg}" <c:if test="${student.bloodGroup eq bg}">selected</c:if>>${bg}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Nationality</label>
                            <input type="text" class="form-control" name="nationality" 
                                   value="${student.nationality}" placeholder="e.g., Indian">
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Email Address <span class="required-star">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" class="form-control border-start-0" name="email" 
                                       value="${student.email}" required pattern="[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,}$">
                                <div class="invalid-feedback">Please enter a valid email address.</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Mobile Number <span class="required-star">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-mobile-alt"></i></span>
                                <input type="tel" class="form-control border-start-0" name="mobileNumber" 
                                       value="${student.mobileNumber}" required pattern="[0-9]{10}" maxlength="10"
                                       placeholder="10-digit number">
                                <div class="invalid-feedback">Please enter a valid 10-digit mobile number.</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Alternate Mobile</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                <input type="tel" class="form-control border-start-0" name="alternateMobile" 
                                       value="${student.alternateMobile}" pattern="[0-9]{10}" maxlength="10"
                                       placeholder="10-digit number">
                                <div class="invalid-feedback">Please enter a valid 10-digit mobile number.</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECTION 2: ACADEMIC INFORMATION (Read Only) -->
                <div class="glass-card section-card p-4 mb-4" style="border-radius: 16px;">
                    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                        <div class="section-title">
                            <i class="fas fa-graduation-cap" style="color: #10b981;"></i> Academic Information
                        </div>
                        <span class="section-badge" style="background: #fffbeb; color: #92400e;">
                            <i class="fas fa-shield-alt me-1"></i>Admin Only
                        </span>
                    </div>
                    <div class="alert py-2 px-3 mb-3" style="background: #fffbeb; border: 1px solid #fde68a; border-radius: 10px; font-size: 0.8rem; color: #92400e;">
                        <i class="fas fa-info-circle me-1"></i>
                        Academic information can only be modified by administration. Contact the registrar's office for any corrections.
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6 col-lg-3">
                            <label class="info-label">Student ID <i class="fas fa-lock lock-icon"></i></label>
                            <input type="text" class="form-control readonly-field" value="STU-${student.userId}" disabled>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="info-label">Enrollment Number <i class="fas fa-lock lock-icon"></i></label>
                            <input type="text" class="form-control readonly-field" value="${student.enrollmentNumber}" disabled>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="info-label">Program / Branch <i class="fas fa-lock lock-icon"></i></label>
                            <input type="text" class="form-control readonly-field" value="${student.branch}" disabled>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="info-label">Current Semester <i class="fas fa-lock lock-icon"></i></label>
                            <input type="text" class="form-control readonly-field" value="Semester ${student.currentSemester}" disabled>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="info-label">Batch <i class="fas fa-lock lock-icon"></i></label>
                            <input type="text" class="form-control readonly-field" value="${student.batch}" disabled>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="info-label">Admission Date <i class="fas fa-lock lock-icon"></i></label>
                            <input type="text" class="form-control readonly-field" value="${student.admissionDateFormatted}" disabled>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="info-label">Expected Graduation <i class="fas fa-lock lock-icon"></i></label>
                            <input type="text" class="form-control readonly-field" value="${student.expectedGraduationYear}" disabled>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="info-label">Current CGPA <i class="fas fa-lock lock-icon"></i></label>
                            <input type="text" class="form-control readonly-field" value="${student.cgpa}" disabled>
                        </div>
                    </div>
                </div>

                <!-- SECTION 3: ADDRESS INFORMATION -->
                <div class="glass-card section-card p-4 mb-4" style="border-radius: 16px;">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="section-title">
                            <i class="fas fa-map-marker-alt" style="color: #ef4444;"></i> Address Information
                        </div>
                        <span class="section-badge" style="background: #eff6ff; color: var(--primary-blue);">
                            <i class="fas fa-edit me-1"></i>Editable
                        </span>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="info-label">Permanent Address <span class="required-star">*</span></label>
                            <textarea class="form-control" name="permanentAddress" rows="4" required
                                      placeholder="Enter your permanent address"><c:out value="${student.permanentAddress}" /></textarea>
                            <div class="invalid-feedback">Permanent address is required.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Correspondence Address</label>
                            <textarea class="form-control" name="correspondenceAddress" id="correspondenceAddress" rows="4"
                                      placeholder="Enter your correspondence address"><c:out value="${student.correspondenceAddress}" /></textarea>
                            <div class="form-check mt-2">
                                <input class="form-check-input" type="checkbox" id="sameAsPermanent" 
                                       onchange="toggleSameAsPermanent()">
                                <label class="form-check-label" style="font-size: 0.8rem; color: var(--text-muted);" for="sameAsPermanent">
                                    <i class="fas fa-copy me-1"></i>Same as Permanent Address
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECTION 4: GUARDIAN / EMERGENCY CONTACT -->
                <div class="glass-card section-card p-4 mb-4" style="border-radius: 16px;">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="section-title">
                            <i class="fas fa-user-shield" style="color: #f59e0b;"></i> Guardian / Emergency Contact
                        </div>
                        <span class="section-badge" style="background: #eff6ff; color: var(--primary-blue);">
                            <i class="fas fa-edit me-1"></i>Editable
                        </span>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="info-label">Guardian Name <span class="required-star">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control border-start-0" name="guardianName" 
                                       value="${student.guardianName}" required placeholder="Full name">
                                <div class="invalid-feedback">Guardian name is required.</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Relationship <span class="required-star">*</span></label>
                            <select class="form-select" name="guardianRelationship" required>
                                <option value="">Select Relationship</option>
                                <c:forEach var="rel" items="${fn:split('Father,Mother,Brother,Sister,Guardian,Other', ',')}">
                                    <option value="${rel}" <c:if test="${student.guardianRelationship eq rel}">selected</c:if>>${rel}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Please select the relationship.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Primary Contact <span class="required-star">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                <input type="tel" class="form-control border-start-0" name="guardianContact" 
                                       value="${student.guardianContact}" required pattern="[0-9]{10}" maxlength="10"
                                       placeholder="10-digit number">
                                <div class="invalid-feedback">Please enter a valid 10-digit contact number.</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Alternate Contact</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-phone-alt"></i></span>
                                <input type="tel" class="form-control border-start-0" name="guardianAlternateContact" 
                                       value="${student.guardianAlternateContact}" pattern="[0-9]{10}" maxlength="10"
                                       placeholder="10-digit number">
                                <div class="invalid-feedback">Please enter a valid 10-digit contact number.</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Guardian Email</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" class="form-control border-start-0" name="guardianEmail" 
                                       value="${student.guardianEmail}" placeholder="email@example.com"
                                       pattern="[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,}$">
                                <div class="invalid-feedback">Please enter a valid email address.</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Occupation</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-briefcase"></i></span>
                                <input type="text" class="form-control border-start-0" name="guardianOccupation" 
                                       value="${student.guardianOccupation}" placeholder="e.g., Business, Teacher">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ACTION BUTTONS -->
                <div class="glass-card p-3 mb-4 d-flex justify-content-end gap-2 flex-wrap" style="border-radius: 12px;">
                    <button type="button" class="btn btn-sm rounded-pill px-4" onclick="cancelEdit()" style="border: 1px solid #fecaca; color: #ef4444; background: white; font-size: 0.85rem;">
                        <i class="fas fa-times me-1"></i>Cancel
                    </button>
                    <button type="reset" class="btn btn-sm rounded-pill px-4" onclick="resetForm()" style="border: 1px solid var(--card-border); color: var(--text-muted); background: white; font-size: 0.85rem;">
                        <i class="fas fa-undo me-1"></i>Reset Form
                    </button>
                    <button type="submit" class="btn btn-gradient-primary btn-sm rounded-pill px-4" style="font-size: 0.85rem;">
                        <i class="fas fa-save me-1"></i>Save Changes
                    </button>
                </div>
            </form>
        </div>

        <footer class="footer">
            &copy; <c:out value="${copyrightYear}" default="2026" /> <c:out value="${universityName}" default="University" />. All rights reserved.
        </footer>
    </div>
</div>
<div id="toastContainer"></div>

<script>
    let formModified = false;
    let originalFormData = null;

    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('editProfileForm');
        originalFormData = new FormData(form);
        
        form.addEventListener('input', markAsModified);
        form.addEventListener('change', markAsModified);
        
        calculateProfileCompletion();
        initializeSameAsPermanent();
        
        window.addEventListener('beforeunload', function(e) {
            if (formModified) {
                e.preventDefault();
                e.returnValue = '';
            }
        });
    });

    function calculateProfileCompletion() {
        const fields = [
            'gender', 'dateOfBirth', 'bloodGroup', 'nationality', 'email',
            'mobileNumber', 'permanentAddress', 'guardianName', 
            'guardianRelationship', 'guardianContact'
        ];
        
        let filled = 0;
        const form = document.getElementById('editProfileForm');
        
        fields.forEach(function(fieldName) {
            const field = form.querySelector('[name="' + fieldName + '"]');
            if (field && field.value && field.value.trim() !== '') {
                filled++;
            }
        });
        
        const percentage = Math.round((filled / fields.length) * 100);
        document.getElementById('completionPercent').textContent = percentage;
        
        const circle = document.getElementById('progressCircle');
        const circumference = 213.6;
        const offset = circumference - (percentage / 100) * circumference;
        circle.style.strokeDashoffset = offset;
    }

    function showToast(message, type = 'error') {
        const container = document.getElementById('toastContainer');
        const toast = document.createElement('div');
        toast.className = 'custom-toast ' + type;
        
        let icon = 'fa-exclamation-circle';
        if (type === 'success') icon = 'fa-check-circle';
        else if (type === 'warning') icon = 'fa-exclamation-triangle';
        
        toast.innerHTML = 
            '<div class="toast-content">' +
                '<i class="fas ' + icon + ' toast-icon"></i>' +
                '<span class="toast-message">' + message + '</span>' +
                '<button class="toast-close" onclick="this.parentElement.parentElement.remove()">' +
                    '<i class="fas fa-times"></i>' +
                '</button>' +
            '</div>';
        
        container.appendChild(toast);
        
        setTimeout(function() {
            toast.classList.add('hiding');
            toast.addEventListener('animationend', function() {
                if (toast.parentElement) {
                    toast.parentElement.removeChild(toast);
                }
            });
        }, 5000);
    }

    function toggleSameAsPermanent() {
        const checkbox = document.getElementById('sameAsPermanent');
        const correspondenceField = document.getElementById('correspondenceAddress');
        const permanentField = document.querySelector('[name="permanentAddress"]');
        
        if (checkbox.checked) {
            correspondenceField.value = permanentField.value;
            correspondenceField.disabled = true;
            correspondenceField.classList.add('readonly-field');
        } else {
            correspondenceField.disabled = false;
            correspondenceField.classList.remove('readonly-field');
        }
        markAsModified();
    }

    function initializeSameAsPermanent() {
        const permanent = document.querySelector('[name="permanentAddress"]').value.trim();
        const correspondence = document.getElementById('correspondenceAddress').value.trim();
        const checkbox = document.getElementById('sameAsPermanent');
        
        if (permanent && permanent === correspondence) {
            checkbox.checked = true;
            toggleSameAsPermanent();
        }
    }

    function markAsModified() {
        formModified = true;
        document.getElementById('unsavedIndicator').classList.add('show');
    }

    document.getElementById('editProfileForm').addEventListener('submit', function(e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
            
            const firstInvalid = this.querySelector(':invalid');
            if (firstInvalid) {
                firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        } else {
            formModified = false;
        }
        
        this.classList.add('was-validated');
    });

    function resetForm() {
        if (formModified) {
            if (!confirm('Are you sure you want to reset the form? All unsaved changes will be lost.')) {
                return;
            }
        }
        
        const form = document.getElementById('editProfileForm');
        form.reset();
        form.classList.remove('was-validated');
        
        document.getElementById('correspondenceAddress').disabled = false;
        document.getElementById('correspondenceAddress').classList.remove('readonly-field');
        
        formModified = false;
        document.getElementById('unsavedIndicator').classList.remove('show');
        
        calculateProfileCompletion();
    }

    function cancelEdit() {
        if (formModified) {
            if (!confirm('You have unsaved changes. Are you sure you want to leave?')) {
                return;
            }
        }
        window.location.href = '${pageContext.request.contextPath}/student/profile';
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>