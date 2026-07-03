# Pong contre un mur

Petit jeu : une raquette en bas de l'écran renvoie une balle qui rebondit sur
les murs (haut, gauche, droite). Tu déplaces la raquette avec les flèches
**←** et **→** du clavier. Si la balle passe sous la raquette, la partie est
perdue et le score est affiché.

Deux versions dans ce dépôt :

- `web/index.html` — version jouable dans n'importe quel navigateur, **sans
  Mac ni Xcode**. C'est la plus simple pour tester tout de suite.
- `Pong/` — la version native iOS (SwiftUI), qui nécessite un Mac + Xcode.

## Tester sans Mac (version web)

Ouvre `web/index.html` directement dans un navigateur (double-clic dessus, ou
glisse-le dans Chrome/Firefox/Edge). Clique sur "Jouer", puis utilise les
flèches ← / → de ton clavier — ça marche sur Windows, Linux ou Mac, aucune
installation nécessaire. Sur mobile/tablette, des boutons ← → apparaissent à
l'écran à la place du clavier.

## Lancer le projet iOS (nécessite un Mac)

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
