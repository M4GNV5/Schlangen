# Schlangen

My snakes for the Schlangenprogrammiernacht, a slither.io inspired game for the GPN written by the Bytewerk (Hackerspace Ingolstadt). You can find the game's source code at [git.bingo-ev.de](https://git.bingo-ev.de/GPN18Programmierspiel)

## Snakes
- [directionpartition_peaceful](directionpartition_peaceful.lua) My main snake during the Beta, it checks how much food is in 16 directions and picks the best one
- [avoid_and_eat](avoid_and_eat.lua) Eats the closest food which is in the opposite direction of the closest enemy
- [kamikaze](kamikaze.lua) Much hated snake which tries to kill others (and itself) by headbutting other snakes. Also known as `kamikaze_trooper_XX` (Beta) and `trooperXX` (GPN)