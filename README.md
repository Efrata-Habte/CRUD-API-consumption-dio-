# Atlas Explorer

**Atlas Explorer** is a Flutter application designed for exploring and registering countries globally. Powered by the **Dio HTTP Client** and structured with **BLoC State Management**, this app represents a state-of-the-art implementation of clean architecture, complete with a beautiful 

---

## CRUD Operations & Live Application Screenshots

Here is a visual showcase of the core **CRUD** (Create, Read, Update, Delete) operations running in the Flutter Web environment:

### 1. Create Operation (C)
Allows users to discover and register new countries into the Atlas. It features an integrated **Live Preview Card** at the top that updates dynamically with every keystroke, and a solid Midnight Slate publish button at the bottom.

#### Form View (Top & Live Card Preview)
<p align="center">
  <img src="screenshots/create_form_top.png" width="480" alt="Create Form Top" />
</p>

#### Form View (Bottom & Section Inputs)
<p align="center">
  <img src="screenshots/create_form_bottom.png" width="480" alt="Create Form Bottom" />
</p>

---

### 2. Read Operation (R)
Loads and lists all registered countries using optimistic caching, custom paginated blocks, and search filters.

#### Main Dashboard & Analytics Explored List
Includes a rich analytics header showing live counts of **Countries**, **Capitals**, and **Currencies** registered.
<p align="center">
  <img src="screenshots/dashboard.png" width="480" alt="Dashboard Explored List" />
</p>

#### Filtering & Search Operations
Allows finding registered countries instantly using the capsule search panel with active filter states (e.g., search for "Ethiopia").
<p align="center">
  <img src="screenshots/search.png" width="480" alt="Search Filter" />
</p>

---

### 3. Update Operation (U)
Allows modifying registered country records. Opening a country pre-fills all fields in the single-scroll wizard.

#### Edit Country Form (Anguilla Pre-filled - Top)
<p align="center">
  <img src="screenshots/update_form.png" width="480" alt="Update Form Top" />
</p>

#### Edit Country Form (Scrolled to bottom - Finance & Currencies)
<p align="center">
  <img src="screenshots/update_form_bottom.png" width="480" alt="Update Form Bottom" />
</p>

---

### 4. Delete Operation (D)
Allows removing a country record instantly. It triggers a custom **Slide-Up Bottom Sheet** drawer that gives warning the user.

#### Warning 
<p align="center">
  <img src="screenshots/delete_confirm.png" width="480" alt="Delete Confirmation Drawer" />
</p>

#### Successful Deletion Feedback Toast
<p align="center">
  <img src="screenshots/delete_success.png" width="480" alt="Delete Success Feedback Toast" />
</p>

---

##  Quick Start & Installation

### Prerequisites
Make sure you have [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.

### Setup Instructions
1. **Clone the repository:**
   ```bash
   git clone https://github.com/Efrata-Habte/CRUD-API-consumption-dio-.git
   ```

2. **Navigate to the Flutter project directory:**
   ```bash
   cd CRUD-API-consumption-dio-/crud_api_consumption_dio
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

---

## Tech Stack & Libraries
- **Language**: [Dart / Flutter](https://flutter.dev/)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) & [bloc](https://pub.dev/packages/bloc)
- **Networking**: [dio](https://pub.dev/packages/dio) (HTTP client with custom interceptors and exception wrappers)
- **Typography & Icons**: Material Icons & custom HSL/RGB colors
