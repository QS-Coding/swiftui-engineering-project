# Mobile Acebook SwiftUI

Front-end application for Mobile Acebook project - by:
Karina, Maz, Robert, Sam and Will

## This Repo

This repo contains the project for a Swift-UI frontend application consuming an Express backend that lives [here](https://github.com/QS-Coding/Mobile-Acebook)

## Installation
 1. Clone the front-end and [back-end](https://github.com/QS-Coding/Mobile-Acebook) repos to your local machine
 2. Navigate to /api in the backend and run `npm install`
 3. Install MongoDB (ONLY IF YOU HAVEN'T ALREADY - skip this step if so, to avoid running into issues)
   ```
   brew tap mongodb/brew
   brew install mongodb-community@6.0
   ```
   *Note:* If you see a message that says `If you need to have
   mongodb-community@5.0 first in your PATH, run:`, follow the instruction.
   Restart your terminal after this.
   
 4. Start MongoDB
   ```
   brew services start mongodb-community@6.0
   ```
 5. Create .env file in /api and add `MONGODB_URL` and `JWT_SECRET` environment variables
 6. Start backend server with command `npm run dev`
 7. Open frontend folder with XCode
 8. Build Swift app using XCode's top menu -> Product -> Build
 9. Run Swift app using XCode's top menu -> Product -> Run
 10. Simulator window will appear with app running

## Usage
1. App allows user to Signup / Login
2. User navigated to Feed upon successful Login
3. User can create new posts (with an optional image) by clicking "Create Post" on navbar
4. User navigated to Feed upon successful Post creation
5. User can click on a post in Feed and is navigated to Full Post View.
6. User can read and add comments to post in Full Post View.
7. User can refresh Feed by clicking "Refresh" on navbar
8. User can logout by clicking "Logout" on navbar and confirming on alert/popup.
