#!/bin/bash

# -----------------------
# --- Linux functions ---
# -----------------------


# Function to install Git on Linux
install_git_linux() {
    echo "Git is not installed. Installing Git..."
    sudo apt-get update
    sudo apt-get install git -y
    echo "Git installed successfully."
}

# Function to install Node.js and npm on Linux
install_node_linux() {
    echo "Node.js and npm are not installed. Installing Node.js and npm..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "Node.js and npm installed successfully."
}

# Function to install Angular CLI on Linux
install_angular_linux() {
    echo "Angular CLI is not installed. Installing Angular CLI..."
    sudo npm install -g @angular/cli
    echo "Angular CLI installed successfully."
}

# ---------------------------------
# --- Windows install functions ---
# ---------------------------------

# Function to install Git on Windows
install_git_windows() {
    echo "Git is not installed. Installing Git..."
    choco install git -y
    echo "Git installed successfully."
}

# Function to install Node.js and npm on Windows
install_node_windows() {
    echo "Node.js and npm are not installed. Installing Node.js and npm..."
    choco install nodejs-lts -y
    echo "Node.js and npm installed successfully."
}

# Function to install Angular CLI on Windows
install_angular_windows() {
    echo "Angular CLI is not installed. Installing Angular CLI..."
    npm install -g @angular/cli
    echo "Angular CLI installed successfully."
}

# ----------------------------------
# --- Check the operating system ---
# ----------------------------------

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux OS
    # Check if Git is installed
    if ! command -v git &> /dev/null; then
        install_git_linux
    else
        echo "Git is already installed."
    fi

    # Check if Node.js and npm are installed
    if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
        install_node_linux
    else
        echo "Node.js and npm are already installed."
    fi

    # Check if Angular CLI is installed
    if ! command -v ng &> /dev/null; then
        install_angular_linux
    else
        echo "Angular CLI is already installed."
    fi

elif [[ "$OSTYPE" == "msys"* ]]; then
    # Windows OS
    # Check if Git is installed
    if ! command -v git &> /dev/null; then
        install_git_windows
    else
        echo "Git is already installed."
    fi

    # Check if Node.js and npm are installed
    if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
        install_node_windows
    else
        echo "Node.js and npm are already installed."
    fi

    # Check if Angular CLI is installed
    if ! command -v ng &> /dev/null; then
        install_angular_windows
    else
        echo "Angular CLI is already installed."
    fi

else
    echo "Unsupported operating system."
    exit 1
fi

echo "Minimum requirements installed."
echo "Creating new project..."

# Create new project -> Read project name...
echo "What is the nickname of the project?"
read $projectName

# Function to install the Angular project dependencies
install_dependencies() {
    echo "Installing project dependencies..."
    npm install
    echo "Project dependencies installed successfully."
}

# Function to configure linting and code formatting
configure_linting_and_formatting() {
    echo "Configuring linting and code formatting..."

    # Install ESLint and Prettier
    npm install eslint prettier --save-dev

    # Create ESLint configuration file
    npx eslint --init

    # Install ESLint plugins and extensions
    npm install eslint-plugin-import eslint-plugin-prettier eslint-config-prettier --save-dev

    # Install lint-staged and husky for pre-commit hooks
    npm install lint-staged husky --save-dev

    # Configure lint-staged
    npx husky install
    npx husky add .husky/pre-commit "npx lint-staged"

    echo "Linting and code formatting configured successfully."
}

# Function to configure the test environment
configure_test_environment() {
    echo "Configuring the test environment..."

    # Install Jest and required dependencies
    npm install jest @types/jest jest-preset-angular ts-jest --save-dev

    # Create setup file for Jest
    echo "import 'jest-preset-angular';" > src/setup-jest.ts

    # Update tsconfig.spec.json for Jest
    jq '.compilerOptions.types += ["jest", "node"]' tsconfig.spec.json > tmpfile && mv tmpfile tsconfig.spec.json

    # Update test.ts file for Jest
    echo "import 'zone.js/dist/zone-testing';" > src/test.ts
    echo "import { getTestBed } from '@angular/core/testing';" >> src/test.ts
    echo "import { BrowserDynamicTestingModule, platformBrowserDynamicTesting } from '@angular/platform-browser-dynamic/testing';" >> src/test.ts
    echo "getTestBed().initTestEnvironment(BrowserDynamicTestingModule, platformBrowserDynamicTesting());" >> src/test.ts
    echo "const context = require.context('./', true, /\.spec\.ts$/);" >> src/test.ts
    echo "context.keys().map(context);" >> src/test.ts

    echo "Test environment configured successfully."
}

# Create new Angular project
echo "Creating new Angular project..."
ng new $projectName --defaults
cd $projectName

# Configure linting and code formatting
configure_linting_and_formatting

# Configure the test environment
configure_test_environment

echo "Angular project setup completed successfully."
