/**
 * @func
 * Met une majuscule au début de chaque mot séparé par un caractère non alphanumérique.
 * La regex récupére le caractère alphanumérique précédé par un caractère non alphanumérique.
 * @param {string} str La chaîne à modifier.
 * @return {string} La chaîne modifiée.
 */
const initCap = str => str.replace(/(?<=\W)\w/g, match => match.toUpperCase());

//@tests
const tests = [
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  'jean-michel'
];

for (t of tests) {
  console.log(initCap(t));
}
