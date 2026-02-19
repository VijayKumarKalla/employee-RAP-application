# RAP Employee Management Application (ABAP RAP - Managed Scenario)

## 📌 Overview
This project is a complete end-to-end SAP RAP (RESTful ABAP Programming Model) application developed in the ABAP Cloud (BTP Trial Environment).

The application demonstrates a full enterprise-grade RAP architecture including:
- Managed Scenario
- Draft Handling
- Actions (Approve / Reject)
- Determinations
- Validations
- Instance Authorization
- Fiori Elements UI (List Report + Object Page)
- Value Help (Search Helps)
- Static Branding (Company Logo)

---

## 🏗️ Architecture
### RAP Model Used:
- Managed RAP
- OData V4
- Draft Enabled Application

### Layers Implemented:
- Database Tables (Persistence)
- Interface CDS Views (ZI_*)
- Projection CDS Views (ZC_*)
- Behavior Definition (BDEF)
- Behavior Implementation (Handler Class)
- Service Definition & Binding
- Metadata Extension (UI Annotations)

---

## 🗂️ Data Model
### Main Tables:
- `ZVK_EMP` – Employee Master Data
- `ZEMP_DEPT` – Department Data
- `ZDT_EMPTB` – Draft Table (for Draft Handling)

### Key Fields:
- Employee ID (UUID - Managed Numbering)
- Employee Name
- Age
- Department
- Salary
- Status (NEW / APPROVED / REJECTED)
- Created & Last Changed Timestamps

---

## 🚀 Features Implemented

### 1️⃣ Draft Functionality
- Create Employee with Draft
- Edit / Resume / Activate / Discard Draft
- Automatic Draft Handling via RAP Framework

### 2️⃣ Business Actions
- Approve Employee
- Reject Employee
- Dynamic Action Enable/Disable based on Status
- Backend-secured Action Authorization

### 3️⃣ Determinations
- Auto-set initial Status = `NEW` during creation

### 4️⃣ Validations
- Age Validation (Minimum Age Check)
- Salary Validation (Salary > 0)
- Error Messaging using RAP Message Framework

### 5️⃣ Instance Authorization
- Disable Edit after Approval
- Restrict Approve/Reject based on Status
- Optional User-based Authorization Logic

### 6️⃣ Value Helps (Search Helps)
- Department Dropdown (CDS Value Help)
- Status Value Help (Code List based)

### 7️⃣ UI Enhancements
- Fiori Elements List Report & Object Page
- Static Company Logo Integration
- Clean Header Configuration
- Field Grouping & Facets

---

## 🎨 UI Configuration
### Fiori Elements Pages:
- List Report (Employee Overview)
- Object Page (Detailed Employee View)

### UI Annotations Used:
- `@UI.headerInfo`
- `@UI.lineItem`
- `@UI.identification`
- `@UI.facet`
- `@Consumption.valueHelpDefinition`
- `@Semantics.imageUrl`

---

## 🔐 Behavior Definition Highlights
```abap
managed implementation in class zbp_i_vk_emp_root unique;
strict ( 2 );
n
