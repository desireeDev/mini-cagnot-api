
# 📱 Cagnot’ – Application Mobile

Cagnot’ est l’application mobile qui réinvente la fidélité physique : chaque paiement par carte bancaire devient automatiquement une opportunité de gagner des points et d’interagir avec ses enseignes préférées.

Notre mission : transformer la **carte bancaire en carte de fidélité universelle** 🎉

---

## ✨ Fonctionnalités principales

* 🔑 **Authentification sécurisée** (Signup & Login via API NestJS + JWT)
* 👤 **Gestion du profil client** (nom, email, cagnotte)
* 💳 **Suivi des paiements** et cumul automatique des points de fidélité
* 🏆 **Gamification intégrée** (points, récompenses, challenges)
* 📊 **Dashboard en temps réel** pour visualiser sa cagnotte
* 🌍 **Multi-enseignes & mutualisé** : vos points partout, sans friction
* 📱 **100% digital** : aucune carte physique, aucune action en caisse

---

## 🛠️ Stack technique

### Frontend mobile

* [Flutter](https://flutter.dev/) (Dart)
* Responsive UI avec `flutter_screenutil`
* Gestion du stockage local avec `shared_preferences`
* Architecture modulaire (écrans, services, modèles)

### Backend

* [NestJS](https://nestjs.com/) (TypeScript)
* Authentification JWT
* API RESTful pour clients, paiements et fidélité
* Base de données PostgreSQL

---

## 📂 Structure du projet (mobile)

```bash
lib/
├── models/            # Modèles (Customer, Payment, etc.)
├── screens/           # Interfaces (Login, Signup, Home, OnBoarding...)
├── services/          # Services API (connexion avec le backend NestJS)
├── widgets/           # Composants UI réutilisables
└── main.dart          # Point d’entrée de l’application
```

---

## 🚀 Installation & Lancement

### Pré-requis

* Flutter SDK installé ([guide officiel](https://docs.flutter.dev/get-started/install))
* Backend NestJS en cours d’exécution (`http://localhost:3000` par défaut)

### Étapes

```bash
# Cloner le repo
git clone https://github.com/ton-compte/cagnot-mobile.git

# Aller dans le dossier
cd cagnot-mobile

# Installer les dépendances
flutter pub get

# Lancer l’application
flutter run
```

---

## 🧪 Tests

```bash
flutter test
```

---




<img width="248" height="445" alt="LoginSignupScreen" src="https://github.com/user-attachments/assets/4f43a46a-74be-41f7-8f41-743c2722464e" />
<img width="251" height="443" alt="SignupScreen" src="https://github.com/user-attachments/assets/67dfc944-69eb-4d43-8bf5-4810b9611e31" />
<img width="251" height="445" alt="ConnexionScreen" src="https://github.com/user-attachments/assets/f69f768f-e7b7-42ed-bd75-429041ef3d14" />
<img width="247" height="400" alt="Points" src="https://github.com/user-attachments/assets/06e82c79-401c-4ee8-8b47-70d01079ca04" />
