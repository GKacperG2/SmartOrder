# SmartOrder AI

A Flutter mobile application that allows users to parse order details from text using an AI language model and calculate the total cost based on a product list from a remote API.

## Features

- Fetches and displays a list of products from `dummyjson.com`.
- Allows pasting an order text.
- Sends the text to an AI model (via OpenRouter) to extract order items (name and quantity).
- Matches the extracted items with the product list.
- Calculates the total cost for matched items.
- Displays the result in a table, clearly marking unmatched items.

## Architecture

The project follows the **Clean Architecture** principles, separating the code into three main layers:

- **Presentation**: UI (Flutter widgets) and State Management (BLoC).
- **Domain**: Business logic (Use Cases and Entities).
- **Data**: Data sources (Remote API) and Repositories.

## Configuration

The application requires an API key for the AI service (OpenRouter).

### How to add the API Key

1.  The API key is loaded from the `lib/core/config/app_config.dart` file.
2.  The key is provided via a compile-time variable `OPENROUTER_API_KEY`.

To run the app with your key, use the following command:

```bash
flutter run --dart-define=OPENROUTER_API_KEY=YOUR_API_KEY
```

Replace `YOUR_API_KEY` with your actual key from OpenRouter. If the key is not provided, the app will show an error message when trying to analyze an order.

## How to Run

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd smartorder_ai
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app with your API key:**
    ```bash
    flutter run --dart-define=OPENROUTER_API_KEY=YOUR_API_KEY
    ```

## Bonus Features

- (Optional) Export order results to JSON.
- (Optional) Simple product search on the products list.
