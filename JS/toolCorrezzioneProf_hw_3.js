var input = "AMOR RETINO PATRIE INTERO ROMA PATIRE RETINO DOMANI TIRONE MORA DOMINA";
var S = ["|",","];

function jobInputSplit ( input_str ) {
    //scrivo il codice di split
    return input_str.split(' ');
}
function keyVal(k,v){  return k+S[0]+v }

function jobMap ( V_In_Map ) {
    
    return V_In_Map.map(function(item){
        //scrivo il codice di map
        var stringaOrdinata = item.split('').sort().join('');
        var chiave = stringaOrdinata;
        var valore = 1;
        return keyVal(chiave, valore);
    });
}

function jobReduce ( K_In_Reduce_V_In_Reduce ) {
    
    return K_In_Reduce_V_In_Reduce.map(function (items){
        var K_In_Reduce = items.split(S[0])[0];
    var V_In_Reduce = items.split(S[0])[1].split(S[1]);
    //scrivo il codice di split
    var Reduce = V_In_Reduce.reduce(function (accumulator, item,) {
             return parseInt(accumulator) + parseInt(item);       
    },0);  
    var k_out = K_In_Reduce;
        var v_out = Reduce;
        return keyVal (k_out,v_out);
    });
}

function merge(v){
    new_v = []
    conc = ''
    for(var i=1; i<=v.length; i++){
        d = v[i-1].split(S[0])
        if(conc.length==0) { conc+= d[1]+S[1]+' '}
        if(i!=v.length){
             d1 = v[i].split(S[0])
             if(d[0] != d1[0]){
                   new_v.push(d[0]+S[0]+conc.substring(0,conc.length-2))
                   conc = ''
                }else{
                   conc+= d1[1]+S[1]+' '
             }
           }else{
             new_v.push(d[0]+S[0]+conc.substring(0,conc.length-2))
        }
     }
     return new_v
 }



var splitted = jobInputSplit(input);
console.log(splitted);
var mapped = jobMap(splitted);
console.log(mapped);
var merged = merge(mapped.sort());
console.log(merged);
var reduced = jobReduce(merged.sort());
console.log(reduced);