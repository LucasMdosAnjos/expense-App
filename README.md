
# Expense App

## Overview

This Expense Management App is designed to help users efficiently track and manage their expenses. Developed with Swift and SwiftUI, the app offers a clean and user-friendly interface for registering, logging in, and managing personal expenses.

## Architecture

The project follows the **Model-View-ViewModel (MVVM)** architecture combined with **Repository Pattern** for data access. This approach allows for a clear separation of concerns, easier testing, and more maintainable code. The MVVM architecture is implemented across all components of the application, ensuring a consistent and scalable structure.

### Data Management

Data access is managed through repositories, which abstract the details of data access whether it's from external sources or local storage using **Core Data**. This setup enables the application to seamlessly manage data operations, providing flexibility to switch or extend data sources without impacting the core business logic.

### Modules

The application is structured into the following key modules:

- **Register**: Allows new users to create an account. It includes `RegisterView`, `RegisterViewModel`, and a repository for user registration operations.

- **Login**: Handles user authentication. It is composed of `LoginView`, `LoginViewModel`, and a repository for handling login data transactions.

- **Welcome**: A welcoming screen displayed post-login, guiding users to the main features of the app. It includes `WelcomeView`.

- **Home**: The core interface where users can manage their expenses. This module is comprised of `HomeView`, `HomeViewModel`, and repositories for expense data management.

Each module is designed to be self-contained, with its own view, view model, and necessary repositories, adhering to the principles of MVVM and facilitating modular development and testing.

## Getting Started

To get started with the Expense Management App, clone the repository to your local machine and open the project in Xcode. Ensure you have the latest version of Xcode installed to take full advantage of SwiftUI features.

## Dependencies

- **Firebase**: Used for authentication and data storage in the cloud.
- **SwiftUI**: Utilized for building the user interface.
- **Core Data**: Employed for local data persistence.

## Contribution

Contributions to the Expense Management App are welcome. Please read the contribution guidelines before submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
