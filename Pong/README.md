# Pong contre un mur

Petit jeu iOS en SwiftUI : une raquette en bas de l'écran renvoie une balle qui
rebondit sur les murs (haut, gauche, droite). Tu déplaces la raquette avec les
flèches **←** et **→** du clavier. Si la balle passe sous la raquette, la
partie est perdue et le score est affiché.

## Lancer le projet

1. Ouvre `Pong.xcodeproj` avec Xcode (15 ou plus récent).
2. Choisis un simulateur iPhone ou iPad comme destination.
3. Lance avec ⌘R.
4. Clique une fois dans la fenêtre du simulateur pour lui donner le focus,
   puis utilise les flèches ← / → de ton clavier Mac pour bouger la raquette
   (le simulateur relaie directement les événements clavier).

Sur un vrai iPhone/iPad, il faut connecter un clavier externe (Bluetooth ou
Smart Keyboard) pour utiliser les flèches.

## Structure

- `Pong/PongApp.swift` — point d'entrée de l'application.
- `Pong/ContentView.swift` — vue racine.
- `Pong/GameView.swift` — logique du jeu (physique de la balle, contrôle
  clavier, dessin via `Canvas`, score et meilleur score sauvegardés avec
  `@AppStorage`).

Cible : iOS 17.0+, Swift 5.
