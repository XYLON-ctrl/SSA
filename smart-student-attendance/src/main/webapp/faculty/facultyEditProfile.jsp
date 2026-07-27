<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Edit Profile" scope="request" />
<%@ include file="facultyHead.jsp" %>

<style>
    :root {
        --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --gradient-success: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        --shadow-soft: 0 10px 40px rgba(0, 0, 0, 0.08);
        --shadow-hover: 0 20px 60px rgba(0, 0, 0, 0.12);
        --radius-lg: 20px;
        --radius-md: 16px;
        --radius-sm: 12px;
    }

    .edit-container {
        max-width: 1600px;
        margin: 0 auto;
        padding: 1.5rem;
    }

    /* Page Header */
    .page-header {
        background: white;
        border-radius: var(--radius-lg);
        padding: 1.5rem 2rem;
        margin-bottom: 1.5rem;
        border: 1px solid #e5e7eb;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }

    .breadcrumb-custom {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-bottom: 0.75rem;
        font-size: 0.85rem;
    }

    .breadcrumb-custom a {
        color: #667eea;
        text-decoration: none;
        font-weight: 500;
    }

    .breadcrumb-custom a:hover { text-decoration: underline; }
    .breadcrumb-custom .separator { color: #9ca3af; }
    .breadcrumb-custom .current { color: #6b7280; }

    .page-title-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }

    .page-title-section h1 {
        font-size: 1.75rem;
        font-weight: 700;
        color: #111827;
        margin: 0 0 0.25rem 0;
    }

    .page-title-section p {
        color: #6b7280;
        font-size: 0.9rem;
        margin: 0;
    }

    .header-actions {
        display: flex;
        gap: 0.75rem;
        flex-wrap: wrap;
    }

    .btn-header {
        padding: 0.6rem 1.25rem;
        border-radius: 50px;
        font-size: 0.875rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        border: none;
        text-decoration: none;
    }

    .btn-save {
        background: var(--gradient-primary);
        color: white;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }

    .btn-save:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.5);
        color: white;
    }

    .btn-cancel {
        background: white;
        color: #6b7280;
        border: 2px solid #e5e7eb;
    }

    .btn-cancel:hover {
        border-color: #667eea;
        color: #667eea;
    }

    .btn-back {
        background: #f3f4f6;
        color: #374151;
    }

    .btn-back:hover {
        background: #e5e7eb;
        color: #111827;
    }

    /* Profile Summary Card */
    .profile-summary {
        background: var(--gradient-primary);
        border-radius: var(--radius-lg);
        padding: 1.75rem 2rem;
        margin-bottom: 1.5rem;
        color: white;
        position: relative;
        overflow: hidden;
        box-shadow: var(--shadow-soft);
    }

    .profile-summary::before {
        content: '';
        position: absolute;
        top: -50%;
        right: -10%;
        width: 400px;
        height: 400px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 50%;
    }

    .summary-content {
        display: flex;
        align-items: center;
        gap: 1.5rem;
        position: relative;
        z-index: 1;
        flex-wrap: wrap;
    }

    .summary-avatar {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.2);
        backdrop-filter: blur(10px);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 2rem;
        border: 3px solid rgba(255, 255, 255, 0.3);
        flex-shrink: 0;
    }

    .summary-info { flex: 1; min-width: 200px; }

    .summary-name {
        font-size: 1.5rem;
        font-weight: 700;
        margin: 0 0 0.25rem 0;
    }

    .summary-meta {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
        margin-top: 0.5rem;
    }

    .summary-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        padding: 0.35rem 0.85rem;
        background: rgba(255, 255, 255, 0.95);
        color: #667eea;
        border-radius: 50px;
        font-size: 0.8rem;
        font-weight: 600;
    }

    /* Main Layout */
    .edit-layout {
        display: grid;
        grid-template-columns: 1fr 380px;
        gap: 1.5rem;
    }

    @media (max-width: 1200px) {
        .edit-layout { grid-template-columns: 1fr; }
    }

    /* Section Cards */
    .section-card {
        background: white;
        border-radius: var(--radius-lg);
        padding: 1.5rem;
        margin-bottom: 1.5rem;
        border: 1px solid #e5e7eb;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }

    .section-header {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin-bottom: 1.25rem;
        padding-bottom: 0.875rem;
        border-bottom: 2px solid #f3f4f6;
    }

    .section-icon {
        width: 40px;
        height: 40px;
        border-radius: var(--radius-sm);
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #667eea;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.1rem;
        flex-shrink: 0;
    }

    .section-title {
        font-size: 1.1rem;
        font-weight: 700;
        color: #111827;
        margin: 0;
    }

    .section-subtitle {
        font-size: 0.8rem;
        color: #6b7280;
        margin: 0.15rem 0 0 0;
    }

    /* Form Styling */
    .form-floating-custom {
        position: relative;
        margin-bottom: 1rem;
    }

    .form-floating-custom label {
        font-size: 0.85rem;
        font-weight: 600;
        color: #374151;
        margin-bottom: 0.5rem;
        display: flex;
        align-items: center;
        gap: 0.35rem;
    }

    .form-floating-custom label .required {
        color: #ef4444;
        font-weight: 700;
    }

    .form-control-edit {
        width: 100%;
        padding: 0.75rem 1rem;
        border: 2px solid #e5e7eb;
        border-radius: var(--radius-sm);
        font-size: 0.9rem;
        transition: all 0.3s ease;
        background: white;
        color: #111827;
    }

    .form-control-edit:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
    }

    .form-control-edit:disabled,
    .form-control-edit.readonly {
        background: #f9fafb;
        color: #6b7280;
        cursor: not-allowed;
        border-color: #e5e7eb;
    }

    .form-control-edit::placeholder { color: #9ca3af; }

    textarea.form-control-edit {
        min-height: 80px;
        resize: vertical;
        font-family: inherit;
        line-height: 1.5;
    }

    .char-counter {
        text-align: right;
        font-size: 0.75rem;
        color: #9ca3af;
        margin-top: 0.35rem;
        font-weight: 500;
    }

    .char-counter.warning { color: #f59e0b; }
    .char-counter.danger { color: #ef4444; }

    .input-icon-wrapper {
        position: relative;
    }

    .input-icon-wrapper i {
        position: absolute;
        left: 1rem;
        top: 50%;
        transform: translateY(-50%);
        color: #9ca3af;
        font-size: 0.9rem;
    }

    .input-icon-wrapper .form-control-edit {
        padding-left: 2.75rem;
    }

    /* Readonly Notice */
    .readonly-notice {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        border: 1px solid #fcd34d;
        border-radius: var(--radius-sm);
        padding: 0.875rem 1rem;
        margin-bottom: 1.25rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-size: 0.85rem;
        color: #92400e;
    }

    .readonly-notice i {
        color: #d97706;
        font-size: 1.1rem;
        flex-shrink: 0;
    }

    /* Sidebar Cards */
    .sidebar-card {
        background: white;
        border-radius: var(--radius-lg);
        padding: 1.5rem;
        margin-bottom: 1.5rem;
        border: 1px solid #e5e7eb;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }

    .sidebar-header {
        display: flex;
        align-items: center;
        gap: 0.6rem;
        margin-bottom: 1.25rem;
        padding-bottom: 0.875rem;
        border-bottom: 2px solid #f3f4f6;
    }

    .sidebar-title {
        font-size: 1rem;
        font-weight: 700;
        color: #111827;
        margin: 0;
    }

    /* Stat Mini Cards */
    .stat-mini-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 0.75rem;
    }

    .stat-mini {
        background: linear-gradient(135deg, #f9fafb 0%, #f3f4f6 100%);
        border-radius: var(--radius-sm);
        padding: 1rem;
        text-align: center;
        transition: all 0.3s ease;
        border: 1px solid #e5e7eb;
    }

    .stat-mini:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }

    .stat-mini-icon {
        width: 36px;
        height: 36px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 0.5rem;
        font-size: 1rem;
    }

    .stat-mini-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: #111827;
        line-height: 1;
        margin-bottom: 0.25rem;
    }

    .stat-mini-label {
        font-size: 0.7rem;
        color: #6b7280;
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.3px;
    }

    /* Subject Chips */
    .subject-chips {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
    }

    .subject-chip {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        padding: 0.45rem 0.85rem;
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #2563eb;
        border-radius: 50px;
        font-size: 0.78rem;
        font-weight: 600;
        border: 1px solid #bfdbfe;
        transition: all 0.2s ease;
    }

    .subject-chip:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(37, 99, 235, 0.15);
    }

    /* Profile Completeness */
    .completeness-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 0.75rem;
    }

    .completeness-percentage {
        font-size: 1.5rem;
        font-weight: 700;
        color: #667eea;
    }

    .completeness-label {
        font-size: 0.8rem;
        color: #6b7280;
    }

    .progress-custom {
        height: 10px;
        background: #f3f4f6;
        border-radius: 10px;
        overflow: hidden;
        margin-bottom: 1rem;
    }

    .progress-bar-custom {
        height: 100%;
        background: var(--gradient-primary);
        border-radius: 10px;
        transition: width 1s ease;
    }

    .missing-fields {
        margin-top: 1rem;
    }

    .missing-fields-title {
        font-size: 0.8rem;
        font-weight: 600;
        color: #374151;
        margin-bottom: 0.5rem;
    }

    .missing-field-item {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.4rem 0;
        font-size: 0.8rem;
        color: #6b7280;
    }

    .missing-field-item i {
        color: #f59e0b;
        font-size: 0.75rem;
    }

    /* Administrative Info Card */
    .admin-info-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.75rem 0;
        border-bottom: 1px solid #f3f4f6;
    }

    .admin-info-item:last-child {
        border-bottom: none;
    }

    .admin-info-label {
        font-size: 0.85rem;
        color: #6b7280;
        font-weight: 500;
    }

    .admin-info-value {
        font-size: 0.875rem;
        color: #111827;
        font-weight: 600;
        text-align: right;
    }

    /* Sticky Save Bar */
    .save-bar {
        position: sticky;
        bottom: 1rem;
        background: white;
        border-radius: var(--radius-lg);
        padding: 1rem 1.5rem;
        margin-top: 1.5rem;
        border: 1px solid #e5e7eb;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        display: flex;
        justify-content: space-between;
        align-items: center;
        z-index: 100;
    }

    .save-bar-info {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-size: 0.875rem;
        color: #6b7280;
    }

    .save-bar-info.unsaved { color: #f59e0b; font-weight: 600; }

    .save-bar-actions {
        display: flex;
        gap: 0.75rem;
    }

    /* Loading State */
    .btn-save.loading {
        pointer-events: none;
        opacity: 0.8;
    }

    .btn-save.loading i {
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }

    /* Alerts */
    .custom-alert {
        border-radius: var(--radius-md);
        border-left: 4px solid;
        padding: 1rem 1.25rem;
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-size: 0.9rem;
        animation: slideDown 0.3s ease;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }

    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .alert-error {
        background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
        border-color: #ef4444;
        color: #991b1b;
    }

    .alert-success {
        background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
        border-color: #10b981;
        color: #166534;
    }
    
    .readonly-field {
	    background-color: #f3f4f6 !important;
	    color: #6b7280;
	    cursor: not-allowed;
	    border: 1px solid #d1d5db;
	}
	
	.readonly-field:focus {
	    background-color: #f3f4f6 !important;
	    border-color: #d1d5db;
	    box-shadow: none;
	    outline: none;
	    cursor: not-allowed;
	}
	
	.readonly-field:hover {
	    background-color: #f3f4f6 !important;
	    cursor: not-allowed;
	}
	
	.readonly-field::selection {
	    background: transparent;
	}

    /* Responsive */
    @media (max-width: 768px) {
        .edit-container { padding: 1rem; }
        .page-header { padding: 1.25rem; }
        .page-title-section h1 { font-size: 1.4rem; }
        .summary-content { flex-direction: column; text-align: center; }
        .summary-meta { justify-content: center; }
        .section-card { padding: 1.25rem; }
        .stat-mini-grid { grid-template-columns: 1fr; }
    }
</style>

<div class="app-wrapper">
    <%@ include file="facultySidebar.jsp" %>
    <div class="main-content">
        <%@ include file="facultyNavbar.jsp" %>
        <div class="edit-container">
            
            <!-- Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="custom-alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <c:out value="${errorMessage}" />
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="custom-alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <c:out value="${successMessage}" />
                </div>
            </c:if>

            <!-- Page Header -->
            <div class="page-header">
                <div class="breadcrumb-custom">
                    <a href="${pageContext.request.contextPath}/faculty/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                    <span class="separator">/</span>
                    <a href="${pageContext.request.contextPath}/faculty/profile">Profile</a>
                    <span class="separator">/</span>
                    <span class="current">Edit Profile</span>
                </div>
                <div class="page-title-section">
                    <div>
                        <h1><i class="fas fa-user-edit" style="color: #667eea; margin-right: 0.5rem;"></i>Edit Profile</h1>
                        <p>Manage and update your personal and professional information.</p>
                    </div>
                    <div class="header-actions">
                        <a href="${pageContext.request.contextPath}/faculty/profile" class="btn-header btn-back">
                            <i class="fas fa-arrow-left"></i>Back to Profile
                        </a>
                        <button type="button" class="btn-header btn-cancel" onclick="cancelEdit()">
                            <i class="fas fa-times"></i>Cancel
                        </button>
                        <button type="submit" form="editProfileForm" class="btn-header btn-save" id="saveBtn">
                            <i class="fas fa-save"></i>Save Changes
                        </button>
                    </div>
                </div>
            </div>

            <!-- Profile Summary Card -->
            <div class="profile-summary">
                <div class="summary-content">
                    <div class="summary-avatar">
                        <c:out value="${fn:substring(profile.fullName, 0, 1)}" default="F" />
                    </div>
                    <div class="summary-info">
                        <h3 class="summary-name"><c:out value="${profile.fullName}" default="Faculty Name" /></h3>
                        <div style="font-size: 0.9rem; opacity: 0.9;">
                            <c:out value="${profile.designation}" default="Designation" /> • 
                            <c:out value="${profile.department}" default="Department" />
                        </div>
                        <div class="summary-meta">
                            <span class="summary-badge">
                                <i class="fas fa-id-card"></i><c:out value="${profile.employeeId}" default="N/A" />
                            </span>
                            <span class="summary-badge" style="background: rgba(255,255,255,0.2); color: white;">
                                <i class="fas fa-check-circle"></i>Active
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Layout -->
            <form id="editProfileForm" action="${pageContext.request.contextPath}/faculty/profile/edit" method="POST">
                <div class="edit-layout">
                    
                    <!-- Left Column: Editable Form -->
                    <div>
                        
                        <!-- Read-only Notice -->
                        <div class="readonly-notice">
                            <i class="fas fa-shield-alt"></i>
                            <div>
                                <strong>Administrative Fields:</strong> Employee ID, Department, Designation, Faculty Type, Joining Date, and Status are managed by the university administration and cannot be modified.
                            </div>
                        </div>

                        <!-- Row 1: Personal & Professional Information (Side by Side) -->
                        <div class="row g-3 mb-3">
                            <!-- Personal Information -->
                            <div class="col-lg-6">
                                <div class="section-card">
                                    <div class="section-header">
                                        <div class="section-icon"><i class="fas fa-user"></i></div>
                                        <div>
                                            <h3 class="section-title">Personal Information</h3>
                                            <p class="section-subtitle">Your basic contact details</p>
                                        </div>
                                    </div>
                                    <div class="form-floating-custom">
									    <label>Full Name <span class="required">*</span></label>
									    <div class="input-icon-wrapper">
									        <i class="fas fa-user"></i>
									        <input type="text"
									               name="fullName"
									               class="form-control-edit readonly-field"
									               value="<c:out value='${profile.fullName}' />"
									               readonly>
									    </div>
									</div>									
									<div class="form-floating-custom">
									    <label>Email Address <span class="required">*</span></label>
									    <div class="input-icon-wrapper">
									        <i class="fas fa-envelope"></i>
									        <input type="email"
									               name="email"
									               class="form-control-edit readonly-field"
									               value="<c:out value='${profile.email}' />"
									               readonly>
									    </div>
									</div>
                                    <div class="form-floating-custom">
                                        <label>Phone Number <span class="required">*</span></label>
                                        <div class="input-icon-wrapper">
                                            <i class="fas fa-phone"></i>
                                            <input type="tel" name="phoneNumber" class="form-control-edit" 
                                                   value="<c:out value='${profile.phoneNumber}' />" 
                                                   placeholder="+91 XXXXX XXXXX" required>
                                        </div>
                                    </div>
                                    <div class="form-floating-custom">
                                        <label>Alternate Phone Number</label>
                                        <div class="input-icon-wrapper">
                                            <i class="fas fa-phone-alt"></i>
                                            <input type="tel" name="alternatePhone" class="form-control-edit" 
                                                   value="<c:out value='${profile.alternatePhone}' />" 
                                                   placeholder="+91 XXXXX XXXXX">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Professional Information -->
                            <div class="col-lg-6">
                                <div class="section-card">
                                    <div class="section-header">
                                        <div class="section-icon"><i class="fas fa-briefcase"></i></div>
                                        <div>
                                            <h3 class="section-title">Professional Information</h3>
                                            <p class="section-subtitle">Your academic and professional details</p>
                                        </div>
                                    </div>
                                    <div class="row g-2">
                                        <div class="col-12">
                                            <div class="form-floating-custom">
                                                <label>Qualification</label>
                                                <div class="input-icon-wrapper">
                                                    <i class="fas fa-graduation-cap"></i>
                                                    <input type="text" name="qualification" class="form-control-edit" 
                                                           value="<c:out value='${profile.qualification}' />" 
                                                           placeholder="e.g., Ph.D., M.Tech">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <div class="form-floating-custom">
                                                <label>Specialization</label>
                                                <div class="input-icon-wrapper">
                                                    <i class="fas fa-award"></i>
                                                    <input type="text" name="specialization" class="form-control-edit" 
                                                           value="<c:out value='${profile.specialization}' />" 
                                                           placeholder="e.g., Data Science">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="form-floating-custom">
                                                <label>Experience (Years)</label>
                                                <div class="input-icon-wrapper">
                                                    <i class="fas fa-clock"></i>
                                                    <input type="number" name="experienceYears" class="form-control-edit" 
                                                           value="<c:out value='${profile.experienceYears}' default='0' />" 
                                                           min="0" max="50" placeholder="Years">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="form-floating-custom">
                                                <label>Office Location</label>
                                                <div class="input-icon-wrapper">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                    <input type="text" name="officeLocation" class="form-control-edit" 
                                                           value="<c:out value='${profile.officeLocation}' />" 
                                                           placeholder="Room 301, CS Block">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Row 2: Academic & Research Information (Full Width) -->
                        <div class="section-card mb-3">
                            <div class="section-header">
                                <div class="section-icon"><i class="fas fa-flask"></i></div>
                                <div>
                                    <h3 class="section-title">Academic & Research Information</h3>
                                    <p class="section-subtitle">Your research interests and publications</p>
                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-floating-custom">
                                        <label>Research Area</label>
                                        <textarea name="researchArea" class="form-control-edit" 
                                                  maxlength="500" oninput="updateCounter(this, 'counter1', 500)"
                                                  placeholder="Describe your primary research area..."><c:out value='${profile.researchArea}' /></textarea>
                                        <div class="char-counter" id="counter1">
                                            <c:out value="${fn:length(profile.researchArea)}" default="0" />/500 characters
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-floating-custom">
                                        <label>Research Interests</label>
                                        <textarea name="researchInterests" class="form-control-edit" 
                                                  maxlength="500" oninput="updateCounter(this, 'counter2', 500)"
                                                  placeholder="List your research interests..."><c:out value='${profile.researchInterests}' /></textarea>
                                        <div class="char-counter" id="counter2">
                                            <c:out value="${fn:length(profile.researchInterests)}" default="0" />/500 characters
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-floating-custom">
                                        <label>Publications Count</label>
                                        <div class="input-icon-wrapper">
                                            <i class="fas fa-book"></i>
                                            <input type="number" name="publicationsCount" class="form-control-edit" 
                                                   value="<c:out value='${profile.publicationsCount}' default='0' />" 
                                                   min="0" placeholder="Number">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-8">
                                    <div class="form-floating-custom">
                                        <label>Certifications</label>
                                        <textarea name="certifications" class="form-control-edit" 
                                                  maxlength="500" oninput="updateCounter(this, 'counter3', 500)"
                                                  placeholder="List your professional certifications..."><c:out value='${profile.certifications}' /></textarea>
                                        <div class="char-counter" id="counter3">
                                            <c:out value="${fn:length(profile.certifications)}" default="0" />/500 characters
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Row 3: Online Presence & Contact Information (Side by Side) -->
                        <div class="row g-3 mb-3">
                            <!-- Online Presence -->
                            <div class="col-lg-6">
                                <div class="section-card">
                                    <div class="section-header">
                                        <div class="section-icon"><i class="fas fa-globe"></i></div>
                                        <div>
                                            <h3 class="section-title">Online Presence</h3>
                                            <p class="section-subtitle">Your academic and professional profiles</p>
                                        </div>
                                    </div>
                                    <div class="form-floating-custom">
                                        <label>Google Scholar Profile</label>
                                        <div class="input-icon-wrapper">
                                            <i class="fab fa-google"></i>
                                            <input type="url" name="googleScholar" class="form-control-edit" 
                                                   value="<c:out value='${profile.googleScholar}' />" 
                                                   placeholder="https://scholar.google.com/...">
                                        </div>
                                    </div>
                                    <div class="form-floating-custom">
                                        <label>LinkedIn Profile</label>
                                        <div class="input-icon-wrapper">
                                            <i class="fab fa-linkedin"></i>
                                            <input type="url" name="linkedinProfile" class="form-control-edit" 
                                                   value="<c:out value='${profile.linkedinProfile}' />" 
                                                   placeholder="https://linkedin.com/in/...">
                                        </div>
                                    </div>
                                    <div class="form-floating-custom">
                                        <label>ORCID ID</label>
                                        <div class="input-icon-wrapper">
                                            <i class="fas fa-fingerprint"></i>
                                            <input type="text" name="orcidId" class="form-control-edit" 
                                                   value="<c:out value='${profile.orcidId}' />" 
                                                   placeholder="0000-0000-0000-0000">
                                        </div>
                                    </div>
                                    <div class="form-floating-custom">
                                        <label>Personal Academic Website</label>
                                        <div class="input-icon-wrapper">
                                            <i class="fas fa-globe"></i>
                                            <input type="url" name="academicWebsite" class="form-control-edit" 
                                                   value="<c:out value='${profile.academicWebsite}' />" 
                                                   placeholder="https://yoursite.edu">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Contact Information -->
                            <div class="col-lg-6">
                                <div class="section-card">
                                    <div class="section-header">
                                        <div class="section-icon"><i class="fas fa-map-marked-alt"></i></div>
                                        <div>
                                            <h3 class="section-title">Contact Information</h3>
                                            <p class="section-subtitle">Your residential address details</p>
                                        </div>
                                    </div>
                                    <div class="form-floating-custom">
                                        <label>Address</label>
                                        <textarea name="address" class="form-control-edit" 
                                                  maxlength="250" oninput="updateCounter(this, 'counter4', 250)"
                                                  placeholder="House No., Street, Locality..." style="min-height: 70px;"><c:out value='${profile.address}' /></textarea>
                                        <div class="char-counter" id="counter4">
                                            <c:out value="${fn:length(profile.address)}" default="0" />/250 characters
                                        </div>
                                    </div>
                                    <div class="row g-2">
                                        <div class="col-4">
                                            <div class="form-floating-custom">
                                                <label>City</label>
                                                <div class="input-icon-wrapper">
                                                    <i class="fas fa-city"></i>
                                                    <input type="text" name="city" class="form-control-edit" 
                                                           value="<c:out value='${profile.city}' />" 
                                                           placeholder="City">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-4">
                                            <div class="form-floating-custom">
                                                <label>State</label>
                                                <div class="input-icon-wrapper">
                                                    <i class="fas fa-map"></i>
                                                    <input type="text" name="state" class="form-control-edit" 
                                                           value="<c:out value='${profile.state}' />" 
                                                           placeholder="State">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-4">
                                            <div class="form-floating-custom">
                                                <label>Postal Code</label>
                                                <div class="input-icon-wrapper">
                                                    <i class="fas fa-mail-bulk"></i>
                                                    <input type="text" name="postalCode" class="form-control-edit" 
                                                           value="<c:out value='${profile.postalCode}' />" 
                                                           placeholder="Code">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Sticky Save Bar -->
                        <div class="save-bar" id="saveBar" style="display: none;">
                            <div class="save-bar-info unsaved" id="saveBarInfo">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>You have unsaved changes</span>
                            </div>
                            <div class="save-bar-actions">
                                <button type="button" class="btn-header btn-cancel" onclick="cancelEdit()">
                                    <i class="fas fa-times"></i>Discard
                                </button>
                                <button type="submit" class="btn-header btn-save" id="saveBtnBottom">
                                    <i class="fas fa-save"></i>Save Changes
                                </button>
                            </div>
                        </div>

                    </div>

                    <!-- Right Sidebar (Sticky) -->
                    <div style="position: sticky; top: 1.5rem; align-self: start;">
                        
                        <!-- Administrative Information (Read Only) -->
                        <div class="sidebar-card">
                            <div class="sidebar-header">
                                <i class="fas fa-shield-alt" style="color: #667eea;"></i>
                                <h4 class="sidebar-title">Administrative Information</h4>
                            </div>
                            <div class="admin-info-item">
                                <span class="admin-info-label">Employee ID</span>
                                <span class="admin-info-value"><c:out value="${profile.employeeId}" default="N/A" /></span>
                            </div>
                            <div class="admin-info-item">
                                <span class="admin-info-label">Department</span>
                                <span class="admin-info-value"><c:out value="${profile.department}" default="N/A" /></span>
                            </div>
                            <div class="admin-info-item">
                                <span class="admin-info-label">Designation</span>
                                <span class="admin-info-value"><c:out value="${profile.designation}" default="N/A" /></span>
                            </div>
                            <div class="admin-info-item">
                                <span class="admin-info-label">Faculty Type</span>
                                <span class="admin-info-value">Permanent</span>
                            </div>
                            <div class="admin-info-item">
                                <span class="admin-info-label">Joining Date</span>
                                <span class="admin-info-value">
                                    <c:choose>
                                        <c:when test="${not empty profile.joiningDate}">
                                            <c:out value="${profile.joiningDateFormatted}" />
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="admin-info-item">
                                <span class="admin-info-label">Status</span>
                                <span class="admin-info-value" style="color: #10b981;">Active</span>
                            </div>
                            <div style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid #f3f4f6; font-size: 0.75rem; color: #9ca3af; text-align: center;">
                                <i class="fas fa-lock"></i> Managed by administration
                            </div>
                        </div>

                        <!-- Academic Summary -->
                        <div class="sidebar-card">
                            <div class="sidebar-header">
                                <i class="fas fa-chart-line" style="color: #667eea;"></i>
                                <h4 class="sidebar-title">Academic Summary</h4>
                            </div>
                            <div class="stat-mini-grid">
                                <div class="stat-mini">
                                    <div class="stat-mini-icon" style="background: #dbeafe; color: #2563eb;">
                                        <i class="fas fa-book"></i>
                                    </div>
                                    <div class="stat-mini-value"><c:out value="${workload.subjectsAssigned}" default="0" /></div>
                                    <div class="stat-mini-label">Subjects</div>
                                </div>
                                <div class="stat-mini">
                                    <div class="stat-mini-icon" style="background: #d1fae5; color: #10b981;">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <div class="stat-mini-value"><c:out value="${workload.sectionsHandling}" default="0" /></div>
                                    <div class="stat-mini-label">Sections</div>
                                </div>
                                <div class="stat-mini">
                                    <div class="stat-mini-icon" style="background: #fef3c7; color: #f59e0b;">
                                        <i class="fas fa-chalkboard"></i>
                                    </div>
                                    <div class="stat-mini-value"><c:out value="${workload.classesPerWeek}" default="0" /></div>
                                    <div class="stat-mini-label">Classes/Week</div>
                                </div>
                                <div class="stat-mini">
                                    <div class="stat-mini-icon" style="background: #fce7f3; color: #ec4899;">
                                        <i class="fas fa-clipboard-check"></i>
                                    </div>
                                    <div class="stat-mini-value"><c:out value="${workload.attendanceSessions}" default="0" /></div>
                                    <div class="stat-mini-label">Sessions</div>
                                </div>
                            </div>
                        </div>

                        <!-- Assigned Subjects -->
                        <div class="sidebar-card">
                            <div class="sidebar-header">
                                <i class="fas fa-book-open" style="color: #667eea;"></i>
                                <h4 class="sidebar-title">Assigned Subjects</h4>
                            </div>
                            <c:choose>
                                <c:when test="${not empty assignedSubjects}">
                                    <div class="subject-chips">
                                        <c:forEach var="subject" items="${assignedSubjects}">
                                            <span class="subject-chip">
                                                <i class="fas fa-book"></i>
                                                <c:out value="${subject.subjectName}" />
                                            </span>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="text-align: center; padding: 1.5rem; color: #9ca3af;">
                                        <i class="fas fa-book" style="font-size: 2rem; opacity: 0.5; margin-bottom: 0.5rem;"></i>
                                        <p style="font-size: 0.85rem; margin: 0;">No subjects assigned</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid #f3f4f6; font-size: 0.75rem; color: #9ca3af; text-align: center;">
                                <i class="fas fa-lock"></i> Managed by administration
                            </div>
                        </div>

                        <!-- Profile Completeness -->
                        <div class="sidebar-card">
                            <div class="sidebar-header">
                                <i class="fas fa-tasks" style="color: #667eea;"></i>
                                <h4 class="sidebar-title">Profile Completeness</h4>
                            </div>
                            <div class="completeness-header">
                                <div>
                                    <div class="completeness-percentage">
                                        <c:out value="${completeness.percentage}" default="0" />%
                                    </div>
                                    <div class="completeness-label">Profile Complete</div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-size: 1.25rem; font-weight: 700; color: #111827;">
                                        <c:out value="${completeness.filledFields}" default="0" />/<c:out value="${completeness.totalFields}" default="15" />
                                    </div>
                                    <div class="completeness-label">Fields Filled</div>
                                </div>
                            </div>
                            <div class="progress-custom">
                                <div class="progress-bar-custom" style="width: ${completeness.percentage}%;"></div>
                            </div>
                            
                            <c:if test="${not empty completeness.missingFields}">
                                <div class="missing-fields">
                                    <div class="missing-fields-title">
                                        <i class="fas fa-exclamation-triangle" style="color: #f59e0b;"></i>
                                        Missing Information:
                                    </div>
                                    <c:forEach var="field" items="${completeness.missingFields}">
                                        <div class="missing-field-item">
                                            <i class="fas fa-circle"></i>
                                            <span><c:out value="${field}" /></span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </form>

        </div>
        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<script>
    // Character counter for textareas
    function updateCounter(textarea, counterId, maxLength) {
        const count = textarea.value.length;
        const counter = document.getElementById(counterId);
        counter.textContent = count + '/' + maxLength + ' characters';
        
        counter.classList.remove('warning', 'danger');
        if (count > maxLength * 0.9) {
            counter.classList.add('danger');
        } else if (count > maxLength * 0.75) {
            counter.classList.add('warning');
        }
    }

    // Unsaved changes detection
    let formChanged = false;
    const form = document.getElementById('editProfileForm');
    const saveBar = document.getElementById('saveBar');

    form.addEventListener('input', function(e) {
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
            formChanged = true;
            saveBar.style.display = 'flex';
        }
    });

    // Save button loading state
    form.addEventListener('submit', function(e) {
        const saveBtn = document.getElementById('saveBtn');
        const saveBtnBottom = document.getElementById('saveBtnBottom');
        
        saveBtn.classList.add('loading');
        saveBtn.innerHTML = '<i class="fas fa-spinner"></i>Saving...';
        saveBtnBottom.classList.add('loading');
        saveBtnBottom.innerHTML = '<i class="fas fa-spinner"></i>Saving...';
        
        formChanged = false;
    });

    // Warn before leaving with unsaved changes
    window.addEventListener('beforeunload', function(e) {
        if (formChanged) {
            e.preventDefault();
            e.returnValue = '';
            return '';
        }
    });

    // Cancel edit
    function cancelEdit() {
        if (formChanged) {
            if (confirm('You have unsaved changes. Are you sure you want to discard them?')) {
                window.location.href = '${pageContext.request.contextPath}/faculty/profile';
            }
        } else {
            window.location.href = '${pageContext.request.contextPath}/faculty/profile';
        }
    }

    // Auto-hide success messages after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.custom-alert');
        alerts.forEach(alert => {
            if (alert.classList.contains('alert-success')) {
                setTimeout(() => {
                    alert.style.transition = 'opacity 0.5s';
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 500);
                }, 5000);
            }
        });
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>