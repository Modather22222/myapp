# Project Blueprint

## Overview

This document outlines the structure and implementation of a Flutter application that allows users to ask questions and receive answers from the DeepSeek API. The app is designed to be secure, visually appealing, and user-friendly, with a focus on providing a seamless and intuitive chat experience.

## Features

*   **AI-Powered Chat:** Users can ask questions and receive answers from the DeepSeek API.
*   **Conversation History:** The app saves and displays the user's conversation history, allowing them to revisit past conversations.
*   **Secure API Key:** The API key is stored securely using environment variables.
*   **Modern UI:** The app features a modern design with a custom theme and fonts, inspired by the DeepSeek app.
*   **Loading Indicator:** A visual cue to indicate that the application is fetching a response.
*   **Error Handling:** Graceful handling of network errors and other issues.
*   **File and Image Attachments:** Users can attach images and files to their messages.

## Implemented Changes

1.  **Added `flutter_dotenv`:** To manage environment variables and keep the API key secure.
2.  **Created `.env` file:** To store the API key.
3.  **Updated `.gitignore`:** To prevent the `.env` file from being committed to version control.
4.  **Updated `main.dart`:** To load the environment variables at startup.
5.  **Updated `api_service.dart`:** To use the API key from the environment variables.
6.  **Added `google_fonts`:** To use custom fonts in the app.
7.  **Created `app_theme.dart`:** To define a modern theme for the app.
8.  **Updated `main.dart`:** To apply the new theme.
9.  **Updated `home_screen.dart`:** To align the UI with the new theme.
10. **Architectural Refactoring:** Implemented the `provider` package for state management, separating business logic from the UI. This involved creating a `ChatProvider` to handle all chat-related logic and state, significantly simplifying the `HomeScreen` widget.
11. **Code Cleanup:** Ran `flutter analyze` and fixed all reported issues, including replacing deprecated `withOpacity` methods.
12. **Preview Fix:** Resolved a preview connection issue by triggering a hot restart.
13. **UI Transformation:** Overhauled the `HomeScreen` to mirror the modern UI of the DeepSeek app. This included creating a sticky, redesigned input bar at the bottom and adding a welcoming "empty state" screen.
14. **Conversation History:** Added a new feature to save and display the user's conversation history. This included creating a `Conversation` class, updating the `ChatProvider` to manage multiple conversations, and adding a `Drawer` to the `HomeScreen` to display the conversation history.
15. **UX Enhancements:**
    *   Prevented the creation of multiple empty "New Conversation" entries by adding a check to the `ChatProvider`.
    *   Added a `SnackBar` to the `HomeScreen` to inform the user that they are already in a new chat if they try to create a new one.
    *   Updated the `ConversationHistoryDrawer` to hide any conversations that do not have messages yet.
16. **File Structure Refactoring:** Reorganized the project into a more scalable and maintainable structure.
    *   `lib/core`: Contains the `api_service.dart` file.
    *   `lib/data`: Contains the `models` and `providers` directories.
    *   `lib/presentation`: Contains the `screens` and `widgets` directories.
    *   Updated all necessary imports to reflect the new file structure.
    *   Extracted widgets from `home_screen.dart` into their own files:
        *   `lib/presentation/widgets/conversation_history_drawer.dart`
        *   `lib/presentation/widgets/chat_bubble.dart`
        *   `lib/presentation/widgets/empty_state.dart`
        *   `lib/presentation/widgets/chat_input_bar.dart`
