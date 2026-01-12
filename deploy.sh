#!/bin/bash

echo "🚀 Employee Login System - Production Deployment Script"
echo "======================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_dependencies() {
    print_status "Checking dependencies..."

    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js first."
        exit 1
    fi

    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install npm first."
        exit 1
    fi

    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi

    print_status "All dependencies are installed."
}

# Create production builds
create_builds() {
    print_status "Creating production builds..."

    # Backend build (no build step needed for Node.js, but we can optimize)
    print_status "Preparing backend for production..."

    # Frontend build
    print_status "Building frontend..."
    cd client
    if npm run build; then
        print_status "Frontend build completed successfully."
    else
        print_error "Frontend build failed."
        exit 1
    fi
    cd ..
}

# Setup environment variables template
setup_env_template() {
    print_status "Creating environment variable templates..."

    cat > .env.production.example << EOL
# Production Environment Variables
# Copy this file to .env and fill in your actual values

# Backend (.env in server directory)
NODE_ENV=production
PORT=5000
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/employee_attendance_prod?retryWrites=true&w=majority
JWT_SECRET=your-super-secure-jwt-secret-for-production-change-this-immediately
CORS_ORIGIN=https://your-frontend-domain.vercel.app

# Frontend (environment variables in deployment platform)
REACT_APP_API_URL=https://your-backend-railway-url.up.railway.app/api
EOL

    print_status "Environment template created: .env.production.example"
}

# Initialize git repository if not already done
setup_git() {
    if [ ! -d ".git" ]; then
        print_status "Initializing Git repository..."
        git init
        git add .
        git commit -m "Initial commit: Employee Login System"
        print_warning "Please set up your GitHub repository and push the code."
        print_warning "Run: git remote add origin <your-repo-url>"
        print_warning "Run: git push -u origin main"
    else
        print_status "Git repository already initialized."
    fi
}

# Main deployment menu
show_menu() {
    echo ""
    echo "Select deployment option:"
    echo "1. Deploy Backend to Railway"
    echo "2. Deploy Frontend to Vercel"
    echo "3. Deploy Backend to Heroku"
    echo "4. Deploy Frontend to Netlify"
    echo "5. Setup MongoDB Atlas"
    echo "6. Create production builds only"
    echo "7. Show deployment guide"
    echo "8. Exit"
    echo ""
    read -p "Enter your choice (1-8): " choice

    case $choice in
        1)
            deploy_backend_railway
            ;;
        2)
            deploy_frontend_vercel
            ;;
        3)
            deploy_backend_heroku
            ;;
        4)
            deploy_frontend_netlify
            ;;
        5)
            setup_mongodb_atlas
            ;;
        6)
            create_builds
            ;;
        7)
            show_deployment_guide
            ;;
        8)
            exit 0
            ;;
        *)
            print_error "Invalid choice. Please select 1-8."
            show_menu
            ;;
    esac
}

deploy_backend_railway() {
    print_status "Deploying backend to Railway..."
    print_warning "Please ensure you have:"
    print_warning "1. Railway account (https://railway.app)"
    print_warning "2. GitHub repository connected"
    print_warning "3. MongoDB Atlas set up"
    echo ""
    print_status "Steps to deploy:"
    echo "1. Go to https://railway.app"
    echo "2. Click 'New Project' → 'Deploy from GitHub'"
    echo "3. Select your repository"
    echo "4. Set environment variables in Railway dashboard"
    echo "5. Railway will auto-deploy"
    echo ""
    read -p "Press Enter when ready to continue..."
}

deploy_frontend_vercel() {
    print_status "Deploying frontend to Vercel..."
    print_warning "Please ensure you have:"
    print_warning "1. Vercel account (https://vercel.com)"
    print_warning "2. Backend already deployed"
    echo ""
    print_status "Steps to deploy:"
    echo "1. Go to https://vercel.com"
    echo "2. Click 'New Project' → Import from Git"
    echo "3. Select your repository"
    echo "4. Configure: Root Directory = 'client'"
    echo "5. Set REACT_APP_API_URL environment variable"
    echo "6. Click 'Deploy'"
    echo ""
    read -p "Press Enter when ready to continue..."
}

deploy_backend_heroku() {
    print_status "Deploying backend to Heroku..."
    print_warning "Please ensure you have:"
    print_warning "1. Heroku CLI installed"
    print_warning "2. Heroku account"
    print_warning "3. MongoDB Atlas set up"
    echo ""
    print_status "Steps to deploy:"
    echo "1. Install Heroku CLI if not installed"
    echo "2. Run: heroku create your-app-name"
    echo "3. Run: heroku config:set NODE_ENV=production"
    echo "4. Run: heroku config:set MONGO_URI=your_mongodb_atlas_uri"
    echo "5. Run: heroku config:set JWT_SECRET=your_jwt_secret"
    echo "6. Run: heroku config:set CORS_ORIGIN=your_frontend_url"
    echo "7. Run: git push heroku main"
    echo ""
    read -p "Press Enter when ready to continue..."
}

deploy_frontend_netlify() {
    print_status "Deploying frontend to Netlify..."
    print_warning "Please ensure you have:"
    print_warning "1. Netlify account (https://netlify.com)"
    print_warning "2. Backend already deployed"
    echo ""
    print_status "Steps to deploy:"
    echo "1. Go to https://netlify.com"
    echo "2. Click 'New site from Git'"
    echo "3. Connect your GitHub repository"
    echo "4. Configure build settings:"
    echo "   - Base directory: client"
    echo "   - Build command: npm run build"
    echo "   - Publish directory: build"
    echo "5. Set environment variables: REACT_APP_API_URL"
    echo "6. Click 'Deploy site'"
    echo ""
    read -p "Press Enter when ready to continue..."
}

setup_mongodb_atlas() {
    print_status "Setting up MongoDB Atlas..."
    echo ""
    print_status "MongoDB Atlas Setup Guide:"
    echo "1. Go to https://cloud.mongodb.com"
    echo "2. Create a new project"
    echo "3. Build a new cluster (choose M0 - Free tier)"
    echo "4. Create database user:"
    echo "   - Username: Choose a username"
    echo "   - Password: Choose a strong password"
    echo "5. Configure network access:"
    echo "   - Add IP Address: 0.0.0.0/0 (for development)"
    echo "6. Connect your application:"
    echo "   - Choose 'Connect your application'"
    echo "   - Driver: Node.js"
    echo "   - Copy the connection string"
    echo "7. Replace in connection string:"
    echo "   - <password> with your database password"
    echo "   - <database> with 'employee_attendance_prod'"
    echo ""
    read -p "Press Enter when you have your connection string ready..."
    read -p "Enter your MongoDB Atlas connection string: " mongo_uri
    echo ""
    print_status "Your connection string: $mongo_uri"
    print_warning "Save this in your deployment platform's environment variables as MONGO_URI"
}

show_deployment_guide() {
    if [ -f "DEPLOYMENT-GUIDE.md" ]; then
        cat DEPLOYMENT-GUIDE.md
    else
        print_error "Deployment guide not found. Please run the script to generate it."
    fi
}

# Main execution
main() {
    echo "🚀 Employee Login System - Production Deployment Script"
    echo "======================================================="

    check_dependencies
    setup_env_template
    setup_git
    create_builds

    print_status "Setup completed! Ready for deployment."
    echo ""

    while true; do
        show_menu
    done
}

# Run main function
main