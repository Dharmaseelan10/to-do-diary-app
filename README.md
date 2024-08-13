# Diary App

Diary App is a Flutter-based application that allows users to record their thoughts and experiences. The app provides functionalities to add, view, and delete diary entries, including support for attaching images to entries.

## Table of Contents

- [Project Description](#project-description)
- [Features](#features)
- [Screenshots](#screenshots)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Technologies Used](#technologies-used)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Project Description

The Diary App is a simple yet powerful application for keeping track of daily activities and thoughts. Users can add text entries along with optional images, view their entries in a list, and delete unwanted entries.

## Features

- Add diary entries with text and optional images
- View a list of all diary entries
- Delete unwanted diary entries
- Simple and intuitive user interface


## Setup Instructions

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed
- [Node.js](https://nodejs.org/) installed (if using Node.js as the backend)
- [PHP](https://www.php.net/downloads) installed (if using PHP as the backend)
- [MySQL](https://www.mysql.com/) database set up

### Running the Project

You can choose between two backend implementations: **PHP** or **Node.js**. The instructions below guide you through running the project depending on the backend you're using.

#### Option 1: Using PHP Backend

1. **Backend Setup:**
   - Ensure your PHP server (e.g., Apache) is running and configured correctly.
   - Update the database connection details in `backend.php`:

    ```php
    define('DB_HOST', 'your_database_host');
    define('DB_USER', 'your_database_user');
    define('DB_PASSWORD', 'your_database_password');
    define('DB_NAME', 'your_database_name');
    ```

   - Place the PHP files on your web server (e.g., in `htdocs` if using XAMPP) and ensure the server is running.

2. **Frontend Setup and Run:**
   - Navigate to the frontend directory:

    ```sh
    cd diary_app
    ```

   - Install Flutter dependencies:

    ```sh
    flutter pub get
    ```

   - Start the Flutter application:

    ```sh
    flutter run 

#### Option 2: Using Node.js Backend

1. **Backend Setup:**
   - Open a terminal and navigate to the backend directory:

    ```sh
    cd diary_app_backend
    ```

   - Install backend dependencies:

    ```sh
    npm install
    ```

   - Create a `.env` file with the following content and replace placeholders with actual values:

    ```env
    DB_HOST=your_database_host
    DB_USER=your_database_user
    DB_PASSWORD=your_database_password
    DB_NAME=your_database_name
    ```

   - Start the Node.js backend server:

    ```sh
    npm start
    ```

2. **Frontend Setup and Run:**
   - Open a new terminal.
   - Navigate to the frontend directory:

    ```sh
    cd diary_app
    ```

   - Install Flutter dependencies:

    ```sh
    flutter pub get
    ```

   - Start the Flutter application:

    ```sh
    flutter run -d chrome
    ```

## Usage

(To be filled in based on specific instructions or usage examples)

## API Endpoints

(To be filled in with details on API endpoints for backend communication)

## Technologies Used

- Flutter
- Node.js / PHP
- MySQL

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For any questions or inquiries, please contact at [dseelan563@gmail.com].
