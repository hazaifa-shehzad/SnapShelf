import { initializeApp } from "firebase/app";
import {
  getFirestore,
  doc,
  setDoc,
  serverTimestamp,
} from "firebase/firestore";
import fs from "fs";
import path from "path";
import { randomUUID } from "crypto";

const googleServicesPath = path.join(
  process.cwd(),
  "android",
  "app",
  "google-services.json",
);

if (!fs.existsSync(googleServicesPath)) {
  console.error(
    "google-services.json not found. Make sure this file exists: android/app/google-services.json",
  );
  process.exit(1);
}

const googleServices = JSON.parse(fs.readFileSync(googleServicesPath, "utf8"));

const projectInfo = googleServices.project_info;
const client = googleServices.client[0];

const firebaseConfig = {
  apiKey: client.api_key[0].current_key,
  authDomain: `${projectInfo.project_id}.firebaseapp.com`,
  projectId: projectInfo.project_id,
  storageBucket: projectInfo.storage_bucket,
  messagingSenderId: projectInfo.project_number,
  appId: client.client_info.mobilesdk_app_id,
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

const makeId = (prefix) => `${prefix}_${randomUUID()}`;

const userId = makeId("user");

const albumHazzzzzId = makeId("album");
const albumHazaId = makeId("album");
const albumFamilyId = makeId("album");

async function seedUsers() {
  await setDoc(doc(db, "users", userId), {
    id: userId,
    fullName: "Raja Hazaifa Shehzad",
    name: "Raja Hazaifa Shehzad",
    displayName: "Raja Hazaifa Shehzad",
    email: "rajahazaifashehzad@gmail.com",
    avatarText: "R",
    profileImageUrl: "",
    passwordPlaceholder: "********",
    isActive: true,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });

  console.log("users collection created");
}

async function seedAlbum(id, title, description, color) {
  await setDoc(doc(db, "albums", id), {
    id,
    userId,
    title,
    description,
    coverLocalPath: "",
    coverPhotoId: "",
    color,
    photoCount: 0,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });
}

async function seedAlbums() {
  await seedAlbum(
    albumHazzzzzId,
    "hazzzzz",
    "Personal device photos",
    "pink",
  );
  await seedAlbum(albumHazaId, "haza", "Saved memories", "purple");
  await seedAlbum(albumFamilyId, "Family", "Family photos and memories", "blue");

  console.log("albums collection created");
}

async function seedAppContent() {
  await setDoc(doc(db, "app_content", "privacy_policy"), {
    id: "privacy_policy",
    title: "Privacy Policy",
    sections: [
      {
        heading: "Introduction",
        body: "Your privacy is important. This policy explains what information SnapShelf may use when you create an account, save images locally, create albums, update profile settings, or delete your account.",
      },
      {
        heading: "Information we collect",
        body: "The app stores actual image files in the app documents directory on your mobile device. Firestore stores authentication-related profile details, album names, photo metadata, local file paths, counts, and tracking fields for organization.",
      },
      {
        heading: "How we protect data",
        body: "Images are stored locally on the mobile device. Firestore access should be protected with authenticated security rules because it stores metadata for your local photo library.",
      },
    ],
    updatedAt: serverTimestamp(),
  });

  await setDoc(doc(db, "app_content", "terms_conditions"), {
    id: "terms_conditions",
    title: "Terms and Conditions",
    sections: [
      {
        heading: "Introduction",
        body: "Welcome to SnapShelf. These terms explain how you may use the app to save photos locally on your device, create albums, manage your profile, and control your account.",
      },
      {
        heading: "Account usage",
        body: "The app is designed for personal photo organization and safe image viewing. Firestore stores metadata used for album tracking, photo lists, and account data, while the image files remain on your device.",
      },
      {
        heading: "Service availability",
        body: "Some features depend on Firebase Auth and Firestore availability. Local image files remain tied to the device and app data where they were saved.",
      },
    ],
    updatedAt: serverTimestamp(),
  });

  console.log("app_content collection created");
}

async function seedFirestore() {
  try {
    console.log("Starting SnapShelf Firestore seed...");
    console.log(`Firebase Project: ${firebaseConfig.projectId}`);

    await seedUsers();
    await seedAlbums();
    await seedAppContent();

    console.log("");
    console.log("Firestore seed completed successfully!");
    console.log("");
    console.log("Created collections:");
    console.log("users");
    console.log("albums");
    console.log("app_content");
    console.log("");
    console.log("Demo IDs:");
    console.log("User:", userId);
    console.log("Album hazzzzz:", albumHazzzzzId);
    console.log("Album haza:", albumHazaId);
    console.log("Album Family:", albumFamilyId);

    process.exit(0);
  } catch (error) {
    console.error("Seed failed:");
    console.error(error);
    process.exit(1);
  }
}

seedFirestore();
