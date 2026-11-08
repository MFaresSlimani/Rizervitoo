# 🏠 REZERVITOO – Discover & List Properties in Algeria

Rezervitoo is a modern mobile app built for people in Algeria looking to **rent properties** or **list their own for rent**. Whether you're a tourist exploring different wilayas or a local looking for housing, DZ Rentals makes the process easy and intuitive.

---

## 📱 What You Can Do

- 🔍 **Browse properties** by wilaya (Medea, Algiers, Oran, and more!)
- 🏡 **View detailed listings** with photos, descriptions, prices, and distances to key landmarks
- 📝 **Create, edit, and manage your own listings** if you’re a property owner or agency
- 👤 **Set up your personal profile** with your name, phone number, and photo
- 🔐 **Secure login and easy account management**
- 🌍 **Explore the Travel Guide** to discover must-visit places in every wilaya
- 🚗 **Browse travel agencies and their offers** — or add your own to get noticed!
- 📅 **Reserve properties for rent** hassle-free
- 🔎 **Search and filter** by any criteria to find exactly what you want
- ❤️ **Manage your favorite properties** all in one place
- 🔔 **Get notifications** when your reservation is accepted or updated
- ✏️ **Edit or delete your properties** anytime you want
- 🌐 **Available in Arabic, English, and French**
- 🌙 **Supports both dark and light themes** for a comfortable experience
- 🚀 **And many more awesome features coming your way!**


---

## 🧭 Simple Navigation

- Two main tabs:
  - 🏘 **Properties** – Discover homes, apartments, and more.
  - 🏢 **Agencies** – Find and contact trusted rental agencies.

---

## 🇩🇿 Made for Algeria

- Localized experience with wilayas
- Designed with simplicity and familiarity for Algerian users

---

## 📦 Built With

- Flutter (Android), GetX for state, navigation and dependency injection
- Supabase: Auth, Postgres and Storage for property photos
- GetStorage for local settings
- Localization in Arabic (RTL), English and French; light and dark themes

### Project structure

```
lib/
  core/         services (auth, users, reservations), localization
  controllers/  GetX controllers per feature
  models/       data models
  screens/      home, properties, agency, guide, profile, settings
  widgets/      shared UI components
```

### Run

```bash
flutter pub get
flutter run
```

---

## 🚧 Status

Core browsing, listing, reservation and guide flows are implemented. Ongoing work: tests and store release.

---

## 🤝 Contact the Developer

Mohamed Fares SLIMANI  
[GitHub](https://github.com/MFaresSlimani) | [LinkedIn](https://www.linkedin.com/in/faresslimani01)

---

## License

MIT, see [LICENSE](LICENSE).
