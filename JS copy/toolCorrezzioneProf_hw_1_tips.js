//CALCOLO MEDIA
//suggest 1
var S = ["|", ","];
function jobInputSplit(input_str) {
return input_str.split("\n") }
function jobMap(V_In_Map) {
return V_In_Map.map(function(item) {
var tipoOrdine = item.split(",")[0]
var data = item.split(",")[1]
var costo = item.split(",")[2]
if (tipoOrdine === "FATTURA" || tipoOrdine === "RICEVUTA") {
K_Out_Map = data.slice(0, 6)
V_Out_Map = costo } else {
K_Out_Map = "Non calcolare"
V_Out_Map = 0 }
return keyVal(K_Out_Map, V_Out_Map) });
}
function jobReduce(K_In_Reduce_V_In_Reduce) {
return K_In_Reduce_V_In_Reduce.map(function(items) {
var K_In_Reduce = items.split(S[0])[0];
var V_In_Reduce = items.split(S[0])[1].split(S[1]);
let i = 1
var Reduce = V_In_Reduce.reduce(function(accumulator, item) {
if (K_In_Reduce !== "Non calcolare") { i++
return parseFloat(accumulator) + parseFloat(item) } else {
return parseFloat(accumulator) + parseFloat(item) }
});
K_Out_Reduce = K_In_Reduce
V_Out_Reduce = Reduce / i
return keyVal(K_Out_Reduce, V_Out_Reduce)
}); }

//suggest 2
var S = ["|",","];
// => WRITE YOUR CODE HERE <=

function jobInputSplit(input_str){
//input_str=>document.getElementById('input_text_area').value;
return input_str.split('\n').filter(function (lines){
return lines.split(',')[0] === 'FATTURA' ||
lines.split(',')[0]==='RICEVUTA';
})
} 10.
 function jobMap(V_In_Map){
 return V_In_Map.map(function(item){
 var ordini = item.split(",");
 var key = ordini[1].substring(0,6);
 var value = ordini[2];
 return keyVal(key, value);
 });
 }

 function jobReduce(K_In_Reduce_V_In_Reduce){
 return K_In_Reduce_V_In_Reduce.map(function (items){
 var K_In_Reduce = items.split(S[0])[0];
 var V_In_Reduce = items.split(S[0])[1].split(S[1]);

 var Reduce = V_In_Reduce.reduce(function(accumulator, item) {
 return parseFloat(accumulator) + parseFloat(item); });

 var media = parseFloat(Reduce/V_In_Reduce.length); 29.
 return keyVal(K_In_Reduce, media.toFixed(5));
 });
}