# weatherapp

A new Flutter project.

![Screenshot](/images/z6037964477812_2da76afcbf82cd6332ce1b5161eeec9a.jpg)
## Installation
- Clone the repository: git clone https://github.com/quantran88/weatherapp
- Run: flutter clean 
- Install dependencies: flutter pub get 
- Replace the API key in the WeatherRepository class with your own from https://www.weatherapi.com
- To run the project: flutter run -d chrome 
- Deploy hosting:
- Run: flutter buid web 
- Run: npm install -g firebase-tools
- Run: firebase experiments:enable webframeworks
- Run: firebase init hosting:
+ Answer yes when asked if you want to use a web framework.
+ If you're in an empty directory, you'll be asked to choose your web framework. Choose Flutter Web.
+ Choose your hosting source directory; this could be an existing flutter app.
+ Select a region to host your files.
+ Choose whether to set up automatic builds and deploys with GitHub.
- Deploy the app to Firebase Hosting:
+ Chạy lệnh firebase deploy --only hosting
## Feature
+ Search for weather information by city or country.
+ View daily weather forecasts.
+ Save search history.
+ Responsive UI with a modern design.
## Usage
+ Open the app in a web browser.
+ Enter the name of a city or country in the search bar.
+ Click the "Search" button to view current weather and forecasts.
## Project structure
weatherapp/
│
├── lib/
│   ├── main.dart                        # Main entry point of the application
│   ├──ui/screens/                       # Main UI screens   
│   ├──ui/provider/                      # Manages weather data retrieval and user location
│   └──data/weather_repository/          # API service handling
│
└── pubspec.yaml                         # Project configuration and dependencies