# Yaad Sahayak - UI Documentation

## Project Overview

Yaad Sahayak is a Flutter-based application designed to help users preserve family memories, information, and meaningful moments.

The application provides an interactive and user-friendly interface for managing family members and exploring memories through an intuitive navigation flow.

---

# Application UI Flow

The main application flow is:

Welcome Screen
↓
Home/Dashboard Screen
↓
Family List
↓
Add Family Member
↓
Family Details
↓
Quiz
↓
Quiz Result

---

# Screens

## 1. Welcome Screen

The Welcome Screen is the first screen displayed to the user.

### Features

- Application branding
- Attractive gradient-based UI
- Application tagline
- Feature cards
- Start Exploring button
- Navigation to the main application

---

## 2. Dashboard

The Dashboard acts as the main navigation hub of the application.

### Features

- Quick access to application features
- Family management navigation
- Memory-related navigation
- Interactive cards
- Responsive layout

---

## 3. Family List Screen

The Family List Screen displays all added family members.

### Features

- Display family member cards
- Profile photo
- Member name
- Relationship information
- Add Family Member button
- Empty state when no family members are available
- Loading shimmer effect
- Responsive layout

### Empty State

When no family members are available, the application displays:

- Family illustration icon
- "No Family Members Yet" message
- Description for the user
- Add Family Member button

---

## 4. Add Family Member Screen

This screen allows users to add or edit family member information.

### Features

- Add family member name
- Select relationship
- Add profile image
- Add information about the family member
- Form validation
- Edit existing family member details
- Responsive user interface

---

## 5. Family Detail Screen

The Family Detail Screen displays complete information about a selected family member.

### Features

- Profile photo
- Hero animation from Family List to Detail Screen
- Member name
- Relationship information
- About section
- Memories section
- Empty memories state
- Edit member option
- Delete member option
- Voice note button

### Hero Animation

The profile image uses Flutter's Hero widget to create a smooth transition between:

Family List Screen → Family Detail Screen

---

## 6. Memories Section

The Memories section is available inside the Family Detail Screen.

### Features

- Display saved family memories
- Grid layout for memory images
- Empty state when no memories are available

### Empty State

The application displays:

- Memory icon
- "No Memories Yet" message
- Helpful description

---

## 7. Quiz Screen

The Quiz Screen allows users to interact with memory-based questions.

### Features

- Interactive questions
- Answer selection
- Navigation between quiz questions
- User-friendly interface

---

## 8. Quiz Result Screen

The Quiz Result Screen displays the user's performance after completing a quiz.

### Features

- Display quiz score
- Result feedback
- Clear and interactive design
- Navigation options

---

# UI Design

The application uses a modern dark theme.

### Main Colors

- Background: Dark Navy
- Cards: Dark Blue
- Primary Color: Deep Blue
- Accent Color: Blue
- Text: White and Light Gray

### Design Elements

- Rounded cards
- Gradient backgrounds
- Smooth animations
- Responsive layouts
- Empty states
- Loading shimmer effects
- Hero animations

---

# Navigation Flow

```text
Welcome Screen
      ↓
Home / Dashboard
      ↓
Family List
      ↓
Add Family Member
      ↓
Family Details
      ↓
Edit / Delete Member