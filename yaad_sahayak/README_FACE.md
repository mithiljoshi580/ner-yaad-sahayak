# Face Recognition Module

## Overview

The Face Recognition Module provides face enrollment, face verification,
family member recognition, liveness checking, and automatic family-member
identification.

## Setup

Required Flutter packages:

- camera
- google_mlkit_face_detection
- shared_preferences
- cloud_firestore
- firebase_auth

Run:

flutter pub get

## Face Enrollment

1. Open the Face Detection screen.
2. Allow camera permission.
3. Keep one face inside the camera frame.
4. The face is detected using Google ML Kit.
5. Select Save Face / Verify Face as required.
6. For family members, the face data is saved with the family member ID.

## Face Matching

The application captures face detection data and compares the saved
face data with the current face data.

The final confidence threshold is:

**0.78**

A confidence value of 0.78 or higher is considered a successful match.

## Threshold Logic

The matching process calculates a similarity confidence value.

If:

confidence >= 0.78

the face is considered matched.

If:

confidence < 0.78

the face is considered not matched.

## Liveness Check

Before verification, the application checks for basic face activity such
as blinking or smiling.

This helps prevent a simple static face image from being treated as a
normal live verification.

## Family Face Recognition

Family member face data is associated with a family member ID.

When verification succeeds, the application can identify the matching
family member and display the available family information.

## Voice Integration

After a family member is recognized, the associated voice note can be
automatically played when available.

## Security

- Face cache is cleared during logout.
- Face matching uses the final confidence threshold of 0.78.
- Camera permission is required for face detection.
- No debug `print()` statements are used in the final module.

## Testing

The following edge cases were tested:

- No face
- Multiple faces
- Low-light conditions
- Face with spectacles/cap
- Re-training the face multiple times
- Successful face verification
- Failed face verification

## Final Verification

Run:

flutter analyze

The final project should report:

No issues found!

## Release Build

Build the final APK using:

flutter build apk --release -t lib/main_mahi.dart

The generated release APK can then be used for final testing and
demonstration.