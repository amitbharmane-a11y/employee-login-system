@echo off
echo ===========================================
echo  🗄️ EMPLOYEE LOGIN SYSTEM - MONGODB ATLAS SETUP
echo ===========================================
echo.
echo This script will guide you through setting up
echo MongoDB Atlas for your deployment.
echo.
echo Press any key to continue...
pause >nul

echo.
echo STEP 1: Create MongoDB Atlas Account
echo ====================================
echo.
echo 1. Go to: https://cloud.mongodb.com
echo 2. Click 'Try Free' or 'Sign Up'
echo 3. Create your account with email/password
echo 4. Verify your email
echo.
echo Press any key when you've created your account...
pause >nul

echo.
echo STEP 2: Create a New Project
echo ============================
echo.
echo 1. Click 'Create a New Project'
echo 2. Project Name: employee-attendance-system
echo 3. Click 'Next'
echo 4. Add members (optional) - you can skip
echo 5. Click 'Create Project'
echo.
echo Press any key when project is created...
pause >nul

echo.
echo STEP 3: Build Your Database Cluster
echo ===================================
echo.
echo 1. Click 'Build a Database'
echo 2. Choose 'M0 Cluster' (FREE tier)
echo 3. Provider & Region: Any (default is fine)
echo 4. Cluster Name: Cluster0 (default)
echo 5. Click 'Create Cluster'
echo.
echo NOTE: This takes 1-3 minutes to provision.
echo.
echo Press any key when cluster is created...
pause >nul

echo.
echo STEP 4: Create Database User
echo ============================
echo.
echo 1. In your cluster, click 'Database Access'
echo 2. Click 'Add New Database User'
echo 3. Authentication Method: Password
echo 4. Username: employeeadmin
echo 5. Password: Create a strong password
echo    (Save this password - you'll need it!)
echo 6. Built-in Role: Read and write any database
echo 7. Click 'Add User'
echo.
set /p db_password="Enter the database password you just created: "

echo.
echo STEP 5: Configure Network Access
echo ================================
echo.
echo 1. Click 'Network Access' in the left sidebar
echo 2. Click 'Add IP Address'
echo 3. Click 'Allow Access from Anywhere'
echo 4. IP Address: 0.0.0.0/0
echo 5. Click 'Confirm'
echo.
echo Press any key when network access is configured...
pause >nul

echo.
echo STEP 6: Get Connection String
echo =============================
echo.
echo 1. Click 'Clusters' in the left sidebar
echo 2. Click 'Connect' button on your cluster
echo 3. Choose 'Connect your application'
echo 4. Driver: Node.js
echo 5. Version: 4.0 or later
echo 6. Copy the connection string
echo.
echo Your connection string will look like:
echo mongodb+srv://employeeadmin:PASSWORD@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
echo.
echo Press any key to continue...
pause >nul

echo.
echo STEP 7: Modify Connection String
echo ================================
echo.
echo Replace in the connection string:
echo 1. Replace 'PASSWORD' with your actual password
echo 2. Add database name at the end
echo.
echo FROM:
echo mongodb+srv://employeeadmin:PASSWORD@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
echo.
echo TO:
echo mongodb+srv://employeeadmin:%db_password%@cluster0.xxxxx.mongodb.net/employee_attendance_prod?retryWrites=true&w=majority
echo.
echo Press any key to finish...
pause >nul

echo.
echo ===========================================
echo  ✅ MONGODB ATLAS SETUP COMPLETE!
echo ===========================================
echo.
echo Your MongoDB Atlas database is ready!
echo.
echo Connection String (save this):
echo mongodb+srv://employeeadmin:%db_password%@cluster0.xxxxx.mongodb.net/employee_attendance_prod?retryWrites=true&w=majority
echo.
echo You'll need this for Render deployment.
echo.
echo Next step: Run './deploy-render.bat' to deploy to Render
echo.
pause