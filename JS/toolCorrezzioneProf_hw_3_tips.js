//Calcolo mese con valore di vendita più alto per ogni anno
//tips 1
var S = ["|", ","];
function jobInputSplit(input_str) {
// input_str => document.getElementById('input_text_area').value;
return input_str.split("\n")
}
function jobMap(V_In_Map) {
return V_In_Map.map(function(item) {
var nuovaStringa = item.replace(/«|»/g, '').split("-")
const data = nuovaStringa[0].trim()
const mese = data.slice(4, 6)
const somma = nuovaStringa[1]
K_Out_Map = data.slice(0, 4)
V_Out_Map = mese + " --->" + somma
console.log(K_Out_Map)
console.log(V_Out_Map)
return keyVal(K_Out_Map, V_Out_Map)
}); }
function jobReduce(K_In_Reduce_V_In_Reduce) {
return K_In_Reduce_V_In_Reduce.map(function(items) {
var K_In_Reduce = items.split(S[0])[0];
var V_In_Reduce = items.split(S[0])[1].split(S[1]);
var Reduce = V_In_Reduce.reduce(function(accumulator, item) {
if (parseFloat(accumulator.split(" --->")[1]) < parseFloat(item.split(" --->")[1])) {
return item } else {
return accumulator }
});
K_Out_Reduce = K_In_Reduce
V_Out_Reduce = Reduce
return keyVal(K_Out_Reduce, V_Out_Reduce)
}); }


//Tips2
var S = ["|",","];
// => WRITE YOUR CODE HERE <=

function jobInputSplit(input_str){
// input_str => document.getElementById('input_text_area').value;
return input_str.split('\n')
}

function jobMap(V_In_Map){
 return V_In_Map.map(function(item){
 var somma_mesi = item.split(" - ");

 var key = somma_mesi[0].substring(2,6);
 var value = somma_mesi[1].slice(0, -2);

 return keyVal(key, somma_mesi[0].substring(2,8)+value);
 });
 }

 function jobReduce(K_In_Reduce_V_In_Reduce){
 return K_In_Reduce_V_In_Reduce.map(function (items){
 var K_In_Reduce = items.split(S[0])[0];
 var V_In_Reduce = items.split(S[0])[1].split(S[1]);

 let n = 7;
 var Reduce = V_In_Reduce.reduce (function (max, item){
 return parseFloat(1*max.substring(n)) > parseFloat(1*item.substring(n)) ? max : item;
 });

 return keyVal( K_In_Reduce, Reduce.substring(0,7));
 });
 }