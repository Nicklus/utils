// inspiré par https://dev.to/samanthaming/how-to-check-if-object-is-empty-in-javascript-2m9

/**
@func
Vérifie qu'un objet est vide
@param {{}} o l'objet à vérifier
@return {boolean}
*/
const isEmptyObject = o => o && Object.keys(value).length === 0 && value.constructor === Object;

//@tests
const aTrue = [{}, new Object()];
const aFalse = [{ name: 'john' }, new String(), new Number(), new Boolean(), new Array(), new RegExp(), new Function(), new Date(), 100, true, []];

for (obj of aTrue) {
  console.log(isEmptyObject(obj);
}

for (obj of aFalse) {
  console.log(isEmptyObject(obj);
}
