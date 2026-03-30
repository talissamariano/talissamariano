# Tasks: subjects-module

## 1. Database Schema
- [x] 1.1 Create subject table with fields: id, account_id, user_id, name, code, instructor, credits, semester, status, created_at, updated_at
- [x] 1.2 Add foreign keys: account_id → account.id, user_id → user.id
- [x] 1.3 Create indexes on account_id and user_id for efficient querying
- [x] 1.4 Add status field with default value 'active' to support soft deletion
- [x] 1.5 Test database migrations and rollback functionality

## 2. API Endpoints - User Subject Management
- [x] 2.1 Create POST /subjects endpoint to create new subjects with validation
- [x] 2.2 Create GET /subjects/my endpoint to list user's personal subjects
- [x] 2.3 Create GET /subjects/account endpoint to list all account subjects
- [x] 2.4 Create GET /subjects/:id endpoint to retrieve subject details
- [x] 2.5 Create PATCH /subjects/:id endpoint to update subject information
- [x] 2.6 Create DELETE /subjects/:id endpoint to soft-delete subjects

## 3. Access Control Implementation
- [x] 3.1 Implement permission check: students can only view/modify own subjects (user_id match)
- [x] 3.2 Implement permission check: admins can view/modify all account subjects
- [x] 3.3 Implement permission check: cross-account data isolation (all queries filter by account_id)
- [x] 3.4 Add 403 Forbidden responses for unauthorized access attempts
- [x] 3.5 Add 404 Not Found responses for resources outside user's account (prevent information leakage)
- [x] 3.6 Validate that authenticated user belongs to the specified account before returning any subject data

## 4. Validation and Error Handling
- [x] 4.1 Validate required fields (name, code) on subject creation
- [x] 4.2 Implement input sanitization for text fields
- [x] 4.3 Validate field types and formats (credits must be numeric, etc.)
- [x] 4.4 Add meaningful error messages for validation failures
- [x] 4.5 Return proper HTTP status codes (400 for validation, 403 for access denied, 404 for not found)

## 5. Event Logging and Audit Trail
- [x] 5.1 Log subject creation events with user_id, account_id, subject details
- [x] 5.2 Log subject update events capturing changed fields and modifier user_id
- [x] 5.3 Log subject deletion events with subject_id and deleting user_id
- [x] 5.4 Log unauthorized access attempts (403 errors) with user_id and attempted action
- [x] 5.5 Integrate with existing event_log table for audit trail tracking

## 6. Testing
- [x] 6.1 Write unit tests for POST /subjects endpoint (valid/invalid inputs)
- [x] 6.2 Write unit tests for GET endpoints (user vs. admin access permissions)
- [x] 6.3 Write unit tests for PATCH endpoint (authorization and validation)
- [x] 6.4 Write unit tests for DELETE endpoint (soft deletion and status changes)
- [x] 6.5 Write integration tests for cross-account isolation (verify 404 on unauthorized access)
- [x] 6.6 Write integration tests for access control (student vs. admin permissions)
- [x] 6.7 Write edge case tests (missing fields, invalid data types, null values)
- [x] 6.8 Test event logging for all operations

## 7. Deployment and Verification
- [x] 7.1 Create database migration scripts
- [x] 7.2 Test API endpoints in staging environment
- [x] 7.3 Verify access control enforcement in staging
- [x] 7.4 Verify event logging is capturing all operations
- [x] 7.5 Deploy to production with migration rollback plan ready
- [x] 7.6 Monitor logs for any authentication/authorization errors post-deployment
- [x] 7.7 Document API endpoints for frontend team integration

