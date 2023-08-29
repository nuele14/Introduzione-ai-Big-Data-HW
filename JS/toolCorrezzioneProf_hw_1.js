var input = `'FATTURA,20180430,21.11
FATTURA,20180502,100
PREVENTIVO,20180503,99.1
OFFERTA,20180503,36.6
OFFERTA,20180503,1800
FATTURA,20180504,63.45
FATTURA,20180504,1800
OFFERTA,20180504,1969.08
FATTURA,20180504,71.93
OFFERTA,20180504,87.43
OFFERTA,20180504,87.43
FATTURA,20180504,93.94
PREVENTIVO,20180505,3172
FATTURA,20180505,292.8
PREVENTIVO,20180508,36.64
FATTURA,20180508,20.13
PREVENTIVO,20180509,35.17
OFFERTA,20180509,374.77
FATTURA,20180509,37
OFFERTA,20180509,1136.23
OFFERTA,20180509,221.48
FATTURA,20180509,170.25
FATTURA,20180510,28.82
OFFERTA,20180510,6244.11
FATTURA,20180511,79.35
FATTURA,20180511,16.23
FATTURA,20180512,42.25`;
var S = ["|",","];

function jobInputSplit ( input_str ) {
    //scrivo il codice di split
    return input_str.split('\n');
}

function keyVal(k,v){ 
    return k+S[0]+v
}

function jobMap ( V_In_Map ) {
    
    return V_In_Map.map(function(item){
        //scrivo il codice di map
        var tipoOrdine = item.split(",")[0]
        var data = item.split(",")[1]
        var costo = item.split(",")[2]

        var chiave;
        var valore;
        if(tipoOrdine === "FATTURA" || tipoOrdine === "RICEVUTA"){
            chiave = data.slice(0,6);
            valore = costo;
        }
        else
        {
            chiave = "NULL";
            valore = 0;
        }
        return keyVal(chiave, valore);
    });
}

function jobReduce ( K_In_Reduce_V_In_Reduce ) {
    
    return K_In_Reduce_V_In_Reduce.map(function (items){
        var K_In_Reduce = items.split(S[0])[0];
        var V_In_Reduce = items.split(S[0])[1].split(S[1]);
        //scrivo il codice di split
        var Reduce = V_In_Reduce.reduce(function (accumulator, item,) {
            if(K_In_Reduce !== "NULL"){
                return parseInt(accumulator) + parseInt(item);
            }
            return 0;
        },0);  
        var k_out = K_In_Reduce;
        var v_out = (Reduce/V_In_Reduce.length).toFixed(2)  ;
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